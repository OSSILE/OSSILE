// Copyright (c) 2018 Kevin Adler
// 
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/*
This module is the processing program for STRTCPSVR/ENDTCPSRVR

Features:
 - instance configuration specified via ini file
 - start/end support
 - *ALL support
 - *AUTOSTART support
 
Sample ini:
[strtcpsvr]
autostart = 1 ; whether to start/end with INSTANCE(*AUTOSTART). values: 0 or 1

[sbmjob]
; user to run SBMJOB under
user = qtmhhttp

[gunicorn]
; How to start the application server. values: <module name>:<app variable name>
; REQUIRED
app = sample:app

; Path to where gunicorn & python are located
bin_dir = /QOpenSys/QIBM/ProdData/OPS/Python3.4/bin

; Path to where virtual environment is located.
; NOTE: When venv set, bin_dir is ignored
venv = /home/user/project/.venv

; Number of worker jobs to run. values: 1+ (default 1)
; Equivalent to --workers option
; http://docs.gunicorn.org/en/latest/settings.html#workers
workers = 2

; Path to where your module is located, if not in the default Python Path
; Equivalent to --pythonpath option
; http://docs.gunicorn.org/en/latest/settings.html#pythonpath
app_path = /home/kadler/bottle-example

; Path where to run the server from
; Equivalent to --chdir option
; http://docs.gunicorn.org/en/latest/settings.html#chdir
run_path = /home/kadler/bottle-example

; Which host and port to bind to (default 127.0.0.1:5000)
; Equivalent to --bind option
; http://docs.gunicorn.org/en/latest/settings.html#bind
bind = 127.0.0.1:5000

; Path to the error log file (default is stderr)
; Equivalent to --error-logfile option
; http://docs.gunicorn.org/en/latest/settings.html#errorlog
error_log = /QOpenSys/var/log/bottle.log

; Redirect stdout & stderr to error log (default is false)
; Equivalent to --capture-output option
; http://docs.gunicorn.org/en/latest/settings.html#capture-output
; Supports "true" or "false"
capture_output = true



Register it like so:
 ADDTCPSVR SVRSPCVAL(*GUNICORN) PGM(OSSILE/GUNICORNTCP)
 SVRNAME('GUNICORN') SVRTYPE('GUNICORN') TEXT('Python gunicorn servers')
*/

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <signal.h>
#include <errno.h>
#include <sys/types.h>
#include <dirent.h>

#include <qp0ztrc.h>

#include "ini.h"

#ifndef __OS400_TGTVRM__
#error What sort of ILE are you running?
#endif

#ifndef INIPATH
#define INIPATH "/QOpenSys/etc/gunicorn-tcpsvr/"
#endif

#define START "*START    "
#define END   "*END      "

#define QSH_CMD_STR "QSYS/QSH CMD('"
#define QSH_CMD_END "')"

// Make sure to add additional command options when adding new sbmjob ini options
#define MAX_SBMJOB "QSYS/SBMJOB ALWMLTTHD(*YES) USER(1234567890) CMD()"
#define MAX_SBMJOB_LEN sizeof(MAX_SBMJOB)

enum {
    RC_OK,
    RC_FAILED,
    RC_ALREADY_RUNNING
} rc_map;

typedef _Packed struct {
    char action[10];
    char reserved[20];
    short rc;
    char instance[32];
    unsigned int startup_offset;
    unsigned int startup_len;
} parm_t;

size_t unpad_length(const char* padded, size_t length)
{
    for(; padded[length-1] == ' '; --length); // empty body
    
    return length;
}

typedef struct {
    char* user;
    char* app;
    char* app_path;
    char* run_path;
    char* bin_dir;
    char* bind;
    char* venv;
    char* error_log;
    int capture_output;
    int workers;
    int autostart;
} gunicorn_opts_t;

void free_opts(gunicorn_opts_t* opts)
{
    free(opts->user);
    free(opts->app);
    free(opts->app_path);
    free(opts->run_path);
    free(opts->bin_dir);
    free(opts->bind);
    free(opts->venv);
    free(opts->error_log);
}

int handler(void* user, const char* section, const char* name, const char* value)
{
    gunicorn_opts_t* opts = (gunicorn_opts_t*) user;

    if(strcmp(section, "strtcpsvr") == 0)
    {
        if(strcmp(name, "autostart") == 0)
        {
            opts->autostart = atoi(value);
            if(opts->autostart != 0 && opts->autostart != 1)
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
    else if(strcmp(section, "sbmjob") == 0)
    {
        if(strcmp(name, "user") == 0)
        {
            if(strlen(value) > 10)
            {
                Qp0zLprintf("INVALID USER VALUE\n");
            }
            
            opts->user = strdup(value);
        }
        else
        {
            return 0;
        }
    }
    else if(strcmp(section, "gunicorn") == 0)
    {
        if(strcmp(name, "workers") == 0)
        {
            opts->workers = atoi(value);
            if(opts->workers <= 0)
            {
                Qp0zLprintf("INVALID WORKERS VALUE\n");
                return 0;
            }
        }
        else if(strcmp(name, "app") == 0)
        {
            opts->app = strdup(value);
        }
        else if(strcmp(name, "app_path") == 0)
        {
            opts->app_path = strdup(value);
        }
        else if(strcmp(name, "run_path") == 0)
        {
            opts->run_path = strdup(value);
        }
        else if(strcmp(name, "bind") == 0)
        {
            opts->bind = strdup(value);
        }
        else if(strcmp(name, "bin_dir") == 0)
        {
            opts->bin_dir = strdup(value);
        }
        else if(strcmp(name, "venv") == 0)
        {
            opts->venv = strdup(value);
        }
        else if(strcmp(name, "error_log") == 0)
        {
            opts->error_log = strdup(value);
        }
        else if(strcmp(name, "capture_output") == 0)
        {
            opts->capture_output = strcmp(value, "true") == 0;
        }
        else
        {
            return 0;
        }
    }
    
    return 1;
}

pid_t read_pid(const char* pidfile_path)
{
    FILE* fp = fopen(pidfile_path, "r");
    if(!fp)
    {
        return (pid_t) -1;
    }
    
    unsigned long pid = 0;
    
    fscanf(fp, "%lu", &pid);
    fclose(fp);
    
    return (pid_t) pid;
}


int handle_instance(const char* action, const char* instance, int multiple, int autostart_only);


int main(int argc, char *argv[])
{
    int rc;
    char instance[33];
    
    parm_t* parm = (parm_t*) argv[1];
    char* startup_values = &argv[1][parm->startup_offset];
    
    size_t instance_len = unpad_length(parm->instance, sizeof(parm->instance));
    parm->startup_len = unpad_length(startup_values, parm->startup_len);
    
//     Qp0zLprintf("%.10s %.*s %u %.*s\n", parm->action, instance_len, parm->instance, parm->startup_len, parm->startup_len, startup_values);
    
    if(parm->startup_len != sizeof("*NONE")-1 && memcmp(startup_values, "*NONE", parm->startup_len) != 0)
    {
        Qp0zLprintf("Overriding instance startup values is not supported\n");
        parm->rc = RC_FAILED;
        return 1;
    }
    
    int single = 1;
    int autostart = 0;

#define ISINSTANCE(name) (instance_len == sizeof(name)-1 && memcmp(parm->instance, name, instance_len) == 0)
    if(ISINSTANCE("*DFT"))
    {
        parm->rc = RC_FAILED;
        return 1;
    }
    else if(ISINSTANCE("*ALL"))
    {
        single = 0;
    }
    else if(ISINSTANCE("*AUTOSTART"))
    {
        single = 0;
        autostart = 1;
    }
    else if(parm->instance[0] == '*' || parm->instance[0] == '.')
    {
        Qp0zLprintf("Invalid instance value: %.*s\n", instance_len, parm->instance);
        parm->rc = RC_FAILED;
        return 1;
    }
    
    if(single)
    {
        memcpy(instance, parm->instance, instance_len);
        instance[instance_len] = 0;
        
        parm->rc = handle_instance(parm->action, instance, 0, 0);
        return parm->rc;
    }
    
    DIR* d = opendir(INIPATH);
    if(!d)
    {
        Qp0zLprintf("Couldn't open ini path\n");
        parm->rc = RC_FAILED;
        return 1;
    }
    
    int failure = 0;
    
    struct dirent* entry;
    while((entry = readdir(d)))
    {
        size_t name_len = strlen(entry->d_name);
        if(entry->d_name[0] == '.') continue;
        
        if(name_len > 32+4 || name_len <= 4 || strcmp(&entry->d_name[name_len-4], ".ini") != 0) continue;
        
        memcpy(instance, entry->d_name, name_len-4);
        instance[name_len-4] = 0;
        
//         Qp0zLprintf("%s\n", instance);
        rc = handle_instance(parm->action, instance, 1, autostart);
        if(!failure && rc == RC_FAILED) failure = 1;
    }
    
    if(failure)
    {
        parm->rc = RC_FAILED;
        return 1;
    }
    else
    {
        return 0;
    }
}
    
int handle_instance(const char* action, const char* instance, int multiple, int autostart_only)
{
    char ini_path[sizeof(INIPATH)+32+sizeof(".ini")];
    sprintf(ini_path, "%s%s.ini", INIPATH, instance);
    int rc;
    
    FILE* fp = fopen(ini_path, "r, o_ccsid=37");
    if(!fp)
    {
        Qp0zLprintf("%*s config not found: %s\n", instance, ini_path);
        rc = RC_FAILED;
        return 1;
    }
    
    gunicorn_opts_t opts;
    memset(&opts, 0, sizeof(opts));
    
    if (setvbuf(fp, NULL, _IONBF, 0) != 0) {
        fclose(fp);
        rc = RC_FAILED;
        return 1;
    }
    
    rc = ini_parse_file(fp, handler, &opts);
    fclose(fp);
    fp = NULL;
    
    if(rc < 0)
    {
        Qp0zLprintf("PARSING FAILED\n");
        rc = RC_FAILED;
        goto end;
    }
    
    if(!opts.app)
    {
        Qp0zLprintf("No \"app\" key specified in section \"gunicorn\"\n");
        rc = RC_FAILED;
        goto end;
    }
    
    if(!opts.autostart && autostart_only)
    {
        return RC_OK;
    }
    
    
    char pid_file[100];
    sprintf(pid_file, "/QOpenSys/var/tmp/%s.pid", instance);
    pid_t pid = read_pid(pid_file);
        
    if (memcmp(action, START, 10) == 0)
    {
        if(pid != (pid_t)-1)
        {
            rc = kill(pid, 0);
            if(rc < 0)
            {
                switch(errno)
                {
                    case ESRCH: // Not running
                    break;
                    
                    case EPERM:
                        Qp0zLprintf("INSUFFICIENT AUTHORITY\n");
                        rc = RC_FAILED;
                        goto end;
                        break;
                        
                    default:
                        Qp0zLprintf("UNKNOWN ERROR\n");
                        rc = RC_FAILED;
                        goto end;
                        break;
                }
            }
            else
            {
                rc = RC_ALREADY_RUNNING;
                goto end;
            }
        }
        
        // TODO: Add bounds checking?
        char command[MAX_SBMJOB_LEN + sizeof(QSH_CMD_STR) + 5000 + sizeof(QSH_CMD_END)];
        int len = 0;
        int offset = 0;

#define APPEND_COMMAND_STRING(...) \
        { \
            len = sprintf(&command[offset], __VA_ARGS__); \
            if(len < 0) \
            { \
                Qp0zLprintf("UNKNOWN ERROR: %d\n", errno); \
                rc = RC_FAILED; \
                goto end; \
            } \
            offset += len; \
        }

        APPEND_COMMAND_STRING("QSYS/SBMJOB ALWMLTTHD(*YES)");
        
        if(opts.user) APPEND_COMMAND_STRING(" USER(%s)", opts.user);

        // set the FLASK_ENV to production
        APPEND_COMMAND_STRING(" CMD(" QSH_CMD_STR "export FLASK_ENV=production;");

        if(opts.venv) 
        {
            // activate the venv first
            APPEND_COMMAND_STRING(" source %s/bin/activate; exec gunicorn", opts.venv);
        } 
        else 
        {
            const char* path = opts.bin_dir ? opts.bin_dir : "/QOpenSys/pkgs/bin";
            APPEND_COMMAND_STRING(" exec %s/gunicorn", path);
        }

        APPEND_COMMAND_STRING(" -D -p %s", pid_file);

        if(opts.workers) APPEND_COMMAND_STRING(" -w %d", opts.workers);
        if(opts.app_path) APPEND_COMMAND_STRING(" --pythonpath %s", opts.app_path);
        if(opts.run_path) APPEND_COMMAND_STRING(" --chdir %s", opts.run_path);
        if(opts.bind) APPEND_COMMAND_STRING(" --bind %s", opts.bind);
        if(opts.error_log) APPEND_COMMAND_STRING(" --error-logfile %s", opts.error_log);
        if(opts.capture_output) APPEND_COMMAND_STRING(" --capture-output");
        
        APPEND_COMMAND_STRING(" %s" QSH_CMD_END ")", opts.app);
        
        Qp0zLprintf("%s\n", command);
        rc = system(command);
        rc = rc == 0 ? RC_OK : RC_FAILED;
    }
    else if (memcmp(action, END, 10) == 0)
    {
        if(pid == (pid_t)-1)
        {
            if(multiple)
            {
                rc = RC_OK;
            }
            else
            {
                Qp0zLprintf("gunicorn server %s not running\n", instance);
                rc = RC_FAILED;
            }
            goto end;
        }
        
        rc = kill((pid_t) pid, SIGINT);
        if(rc != 0)
        {
            Qp0zLprintf("Failed to end server\n", instance);
            rc = RC_FAILED;
            goto end;
        }
    }
    else
    {
        // other operations ignored no-op
        Qp0zLprintf("Unknown operation: %.10s\n", action);
        rc = RC_FAILED;
        goto end;
    }
    
end:
    if(fp) fclose(fp);
    free_opts(&opts);
    return rc;
}
