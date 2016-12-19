#include <except.h>                         // exception header
#include <recio.h>                          // Record I/O
#include <stdio.h>                          // standard I/O
#include <stdlib.h>                         // standard I/O
#include <string.h>                         // memory and string
#include <sys/stat.h>                       // File Stat
#include <sys/types.h>                      // Types
#include <fcntl.h>                          // File control
#include <errno.h>                          // Error Number
#include <pwd.h>                            // user structs
#include <dirent.h>                         // Directory entry
#include <qwccvtdt.h>                       // convert Date
#include <ledate.h>                         // CEE date functions
#include <time.h>                           // Convert time structures
#include <qtqiconv.h>                       // ccsid conversion
#include <Qp0lstdi.h>                       // Object information
#include <qlg.h>                            // Qlg structs
#include <qusec.h>                          // Error Code Structs
#pragma comment(copyright,"Copyright @ Shield Advanced Solutions Ltd 1997-2011")

typedef _Packed struct  CtlBlkAreaName_x{
                        unsigned int fd;
                        unsigned long long size;
                        unsigned long long dir_size;
                        unsigned long objects;
                        unsigned long dir_objects;
                        unsigned long dirs;
                        } CtlBlkAreaName_t;

typedef union pName_Type {
                        char pName_Char[2048];
                        char *pName_Ptr;
                        };

typedef _Packed struct  pName_Struct_x {
                        Qlg_Path_Name_T qlgStruct;
                        union pName_Type Path;
                        } pName_Struct_t;

typedef _Packed struct IFS_Path_x {
                        Qlg_Path_Name_T Path_Dets;
                        char Path_Name[5002];
                        } IFS_Path_t;

typedef _Packed struct  Attr_Req_x {
                        Qp0l_AttrTypes_List_t attr_struct;
                        unsigned int Attr_Types[10];
                        } Attr_Req_t;

typedef _Packed struct  Objtypes_List_x {
                        uint Number_Of_Objtypes;
                        char Objtype[2][11];
                        } Objtypes_List_t;


typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[1024];
                        } EC_t;

#define _ERR_REC sizeof(struct EC_x);
#define PATH_TYPE_POINTER    0x00000001
#define _1KB 1024
#define _8K _1KB * 8
#define _32K _1KB * 32
#define _64K _1KB * 64
#define _1MB _1KB * _1KB
#define _1GB ((long)_1MB * _1KB)
#define _1TB ((double)_1GB * _1KB)
#define _4MB _1MB * 4
#define _8MB _1MB * 8
#define _16MB 16773120
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)


/**
  * (function) crt_file()
  * create and open the log file
  * @parms
  *     Data Queue
  * returns 1
  */

int crt_file(char *file) {
int fd = 0;                                 // file desc
char new_file[36];                          // new file buffer
char msg_dta[5002];                         // msg buf
char *token;                                // ptr

if(access(file,F_OK) == -1) {
   if(creat(file,S_IRWXO) == -1) {  // cant create it path error
      strcpy(new_file,file);
      token = strtok(new_file,"/");
      do {
         if(strchr(token,'.') != NULL) { // file def
            break;
            }
         if((chdir(token) == -1) && (errno == ENOENT)) {
            if(mkdir(token,S_IRWXO)  == -1) {
               printf("Failed to Make Directory %s",token);
               break;
               }
            if(chdir(token) == -1) {
               printf("Failed to Change Directory %s",token);
               break;
               }
            }
         }while(token = strtok(NULL,"/"));
      }
   chdir("/");
   if(creat(file,S_IRWXO) == -1) { // cant create it path error ?
      printf("Failed to create file %s",file);
      }
   }
fd = open(file,O_WRONLY|O_TRUNC);
return fd;
}

/**
  * (function)convert_size
  * create the size for dispaly to user
  * @parms
  *     1 size in bytes to be converted
  * returns 1 if successful
  */

int convert_size(char *size) {
double nSize,Total,Mult;                    // counters
char *Type;                                 // type ptr
char *endptr;                               // end ptr

nSize = strtod(size,&endptr);
if(nSize > (999.5 * _1GB)) {
   Type = "TB";
   Mult = _1TB;
   }
else if(nSize > (999.5 * _1MB)) {
   Type = "GB";
   Mult = _1GB;
   }
else if(nSize > (999.5 * _1KB)) {
   Type = "MB";
   Mult = _1MB;
   }
else if(nSize > 999.5) {
   Type = "kB";
   Mult = _1KB;
   }
else  {
   Type = "B";
   Mult = 1;
   }
Total = nSize/((double)Mult);
if(Total < 0.0)
   Total = 0.0;
memset(size,' ',sizeof(size));
sprintf(size,"%3.1f%s",Total,Type);
return 1;
}

/**
  * (function) Get_Obj_Size
  * Get the object size for STMF
  * @parms
  *
  * returns 1 if the directory was set OK
  */

void Get_Obj_Size(uint *Sel_sts,
                 uint *Err_val,
                 uint *Ret_val,
                 Qlg_Path_Name_T *Obj_name,
                 void  *Func_ctl_blk) {
int i = 0;                                  // counter
int len = 0;                                // counter
int ret = 0;                                // return value
size_t insz;                                // path len
size_t outsz = 2048;                        // converted outbuf size
char outbuf[2048];                          // output buffer
char conv_size[48];                         // converted size buf
char *outbuf_ptr;                           // ptr to output buffer
iconv_t cd;                                 // convert struct
size_t ret_iconv;                           // returned value
char msg_dta[1024];                         // message buffer
char *path_ptr;                             // ptr to path string
struct stat info;                           // stat struct
CtlBlkAreaName_t *t_ptr;                    // Control block ptr
pName_Struct_t *pName;                      // Path name struct
QtqCode_T toCode   =    {37,0,0,0,0,0};     // CCSID to struct
QtqCode_T fromCode = {0,0,0,0,0,0};         // CCSID from struct

// setup the control block ptr
t_ptr = (CtlBlkAreaName_t *)Func_ctl_blk;
if(*Sel_sts == QP0L_SELECT_OK) {
   if(Obj_name != NULL) {
      fromCode.CCSID = Obj_name->CCSID;
      pName = (pName_Struct_t *)Obj_name;
      if(Obj_name->Path_Type & PATH_TYPE_POINTER) {
         path_ptr = pName->Path.pName_Ptr;
         }
      else {
         path_ptr = (char *)pName->Path.pName_Char;
         }
      // convert to US CCSID
      insz = pName->qlgStruct.Path_Length;
      outbuf_ptr = (char *)outbuf;
      memset(outbuf_ptr, 0x00, insz);
      cd = QtqIconvOpen(&toCode,&fromCode);
      if(cd.return_value == -1) {
         *Ret_val = errno;
         return;
         }
      ret_iconv = (iconv(cd,(char **)&(path_ptr),&insz,(char **)&(outbuf_ptr),&outsz));
      if(ret_iconv != 0) {
         ret_iconv= iconv_close(cd);
         printf("failed to iconv()\n");
         *Ret_val = errno;
         return;
         }
      ret_iconv = iconv_close(cd);
      // get the attributes and create the CRC
      if(stat(outbuf,&info) != 0) {
         printf("failed to stat\n",outbuf);
         return;
         }
      t_ptr->size += info.st_size;
      if(S_ISDIR(info.st_mode))  {
         sprintf(conv_size,"%.0f",(double)t_ptr->dir_size);
         convert_size(conv_size);
         sprintf(msg_dta,"Directory = %s objects = %lu size = %s\r\n",outbuf,t_ptr->dir_objects,conv_size);
         write(t_ptr->fd,msg_dta,strlen(msg_dta));
         t_ptr->dirs++;
         t_ptr->dir_objects = 0;
         t_ptr->dir_size = 0;
         }
      else {
         t_ptr->dir_size += info.st_size;
         t_ptr->objects++;
         t_ptr->dir_objects++;
         }
      }
   }
*Ret_val = 0;
}


/* Function main()
 * Purpose main program entry point
 * @parms
 *      int argc (number of parms)
 *      char **parms (character strings)
 * exit 0
 */

int main(int argc, char **argv) {
unsigned long long size = 0;                // counter
unsigned long objects = 0;                  // number objects
int rc = 0;                                 // return code
int path_len = 0;                           // path length
int junkl;                                  // Int holder
char msg_dta[1024];                         // msg data
char conv_size[48];                         // converted size buf
char dir_entered[5002];                     // directory
char file[30];                              // file name
double secs;                                // Secs holder
unsigned char junk2[23];                    // Junk char string
char Time_Stamp[18];                        // Time Stamp holder
char Date[16];                              // date holder
char *cwd_ptr;                              // starting directory
time_t t1,t2;                               // time structs
IFS_Path_t Path;                            // path name struct
Objtypes_List_t MyObj_types;                // obj types struct
Qp0l_User_Function_t User_function;         // user function struct
CtlBlkAreaName_t CtlBlkAreaName;            // control block
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = _ERR_REC;
// set up the controll block content
CtlBlkAreaName.size = 0;
CtlBlkAreaName.dir_size = 0;
CtlBlkAreaName.objects = 0;
CtlBlkAreaName.dir_objects = 0;
CtlBlkAreaName.dirs = 0;
// create the file name
CEELOCT(&junkl, &secs,junk2,NULL);
CEEDATM(&secs,"YYYYMMDDHHMISS999",Time_Stamp,NULL);
QWCCVTDT ("*YYMD     ", Time_Stamp, "*YYMD     ", Date, &Error_Code);
// open the IFS File
sprintf(file,"/home/rtvdirsz/log/%s.dta",Date);
CtlBlkAreaName.fd = crt_file(file);
path_len = *(int *)argv[1];
cwd_ptr = argv[1];
cwd_ptr += sizeof(int);
memcpy(dir_entered,cwd_ptr,path_len);
memset(&dir_entered[path_len],'\0',1);
sprintf(msg_dta,"Directory Entered = %s\r\n",dir_entered);
write(CtlBlkAreaName.fd,msg_dta,strlen(msg_dta));
// set up the function call
memset((void *)&User_function, 0x00, sizeof(Qp0l_User_Function_t));
User_function.Function_Type = QP0L_USER_FUNCTION_PTR;
User_function.Mltthdacn[0] = QP0L_MLTTHDACN_NOMSG;
User_function.Procedure = &Get_Obj_Size;
// set up the path name struct
memset((void*)&Path, 0x00, sizeof(Path));
Path.Path_Dets.CCSID = 0;
Path.Path_Dets.Path_Type = 0;
Path.Path_Dets.Path_Length = path_len;
memcpy(Path.Path_Dets.Path_Name_Delimiter,"/ ",2);
memcpy(Path.Path_Name,cwd_ptr,path_len);
// set up the object types
MyObj_types.Number_Of_Objtypes = 2;
memcpy(&MyObj_types.Objtype[0],"*STMF      ",11);
memcpy(&MyObj_types.Objtype[1],"*DIR       ",11);
// create a time stamp
t1 = time(NULL);
if(rc = Qp0lProcessSubtree((Qlg_Path_Name_T *)&Path,
                            QP0L_SUBTREE_YES,
                            (Qp0l_Objtypes_List_t *)&MyObj_types,
                            QP0L_LOCAL_REMOTE_OBJ,
                            (Qp0l_IN_EXclusion_List_t *)NULL,
                            QP0L_PASS_WITH_ERRORID,
                            &User_function,
                            &CtlBlkAreaName) == 0) {
   t2 = time(NULL);
   sprintf(msg_dta,"Successfully collected data\r\n");
   write(CtlBlkAreaName.fd,msg_dta,strlen(msg_dta));
   }
else {
   t2 = time(NULL);
   sprintf(msg_dta,"ERROR on Qp0lProcessSubtree(): %s",strerror(errno));
   write(CtlBlkAreaName.fd,msg_dta,strlen(msg_dta));
   exit(-1);
   }
sprintf(conv_size,"%.0f",(double)CtlBlkAreaName.size);
convert_size(conv_size);
sprintf(msg_dta,"Size = %s Objects = %u Directories = %u\r\n",conv_size,CtlBlkAreaName.objects,CtlBlkAreaName.dirs);
write(CtlBlkAreaName.fd,msg_dta,strlen(msg_dta));
sprintf(msg_dta,"Took %d seconds to run\r\n",t2 - t1);
write(CtlBlkAreaName.fd,msg_dta,strlen(msg_dta));
close(CtlBlkAreaName.fd);
exit(0);
}
