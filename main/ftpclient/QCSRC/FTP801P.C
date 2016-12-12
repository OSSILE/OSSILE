/* This file is part of FTP Client for IBM i.                                    */
/*                                                                               */
/* Copyright (c) 2016 Chris Hird                                                 */
/* All rights reserved.                                                          */
/*                                                                               */
/* Redistribution and use in source and binary forms, with or without            */
/* modification, are permitted provided that the following conditions            */
/* are met:                                                                      */
/* 1. Redistributions of source code must retain the above copyright             */
/*    notice, this list of conditions and the following disclaimer.              */
/* 2. Redistributions in binary form must reproduce the above copyright          */
/*    notice, this list of conditions and the following disclaimer in the        */
/*    documentation and/or other materials provided with the distribution.       */
/*                                                                               */
/* FTP Client for IBM i is free software: you can redistribute it and/or modify  */
/* it under the terms of the GNU General Public License as published by          */
/* the Free Software Foundation, either version 3 of the License, or             */
/* any later version.                                                            */
/*                                                                               */
/* Disclaimer :                                                                  */
/* FTP Client for IBM i is distributed in the hope that it will be useful,       */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of                */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                 */
/* GNU General Public License for more details.                                  */
/*                                                                               */
/* You should have received a copy of the GNU General Public License             */
/* along with FTP Client for IBM i. If not, see <http://www.gnu.org/licenses/>.  */
 
#include <fcntl.h>                          /* file control */
#include <sys/stat.h>                       /* File Stat */
#include <pwd.h>                            /* user structs */
#include <Qp0lstdi.h>                       /* rename object */
#include <errno.h>                          /* error */
#include <xxcvt.h>                          /* conversion */
#include <dirent.h>                         /* Directory entry */
#include "uimopt.h"
#include "common.h"
#pragma comment(copyright,_CPYRGHT)
 
#define PNLGRP          "FTP801PG  *LIBL     "
#define ILEPGMLIB       "FTP801P   *LIBL     "
 
typedef _Packed struct  Sit_Rec_x{
                        char rrn[6];
                        SITREC Sit_Dets;
                        }Sit_Rec_t;
 
typedef _Packed struct  cwd_rec_x{
                        char rmtdir[SHORT_PATH];
                        char lcldir[SHORT_PATH];
                        }cwd_rec_t;
 
typedef _Packed struct  rename_rec_x{
                        char oldname[MAX_NAME];
                        char newname[MAX_NAME];
                        }rename_rec_t;
 
typedef _Packed struct  path_rec_x{
                        char path[SHORT_PATH];
                        char lpath[MAX_PATH];
                        }path_rec_t;
 
typedef _Packed struct  newpath_rec_x{
                        char lclpath[MAX_PATH];
                        char rmtpath[MAX_PATH];
                        }newpath_rec_t;
 
typedef _Packed struct  dftcnn_x{
                        decimal(5,0) port;
                        decimal(3,0) retry;
                        decimal(3,0) delay;
                        }dftcnn_t;
 
typedef _Packed struct  sitdet_x{
                        char lcluser[10];
                        char sitelbl[25];
                        char hostadr[55];
                        char userid[25];
                        char pwd[PWD_LEN];
                        char rmtdir[SHORT_PATH];
                        char lcldir[SHORT_PATH];
                        char transtyp;
                        }sitdet_t;
 
extern void UIMExit(Qui_ALC_t *);
extern void AppWrkLclCwd(void);
int Load_Cwd(char *, char *);
int Build_Rmt_Dir(char *);
int init_panel(char *);
int Not_Connected(char *);
int Set_Dir(char *, char *);
int check_qsys(char *,int);
 
int main(int argc,char *argv[])  {
_RFILE    *fp;                              // file Ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
CFGREC   CfgRec;                            // File struct
int ret = 0;                                // ret val
extern int keepalive;                       // Keepalive setting
char msg_dta[255];                          // message buffer
char **tmp_ptr;
Qui_ALC_t *call_lopt;
EC_t Error_Code = {0};
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
if(argc == 1) {
   if((fp =_Ropen("FTPCFG","rr")) == NULL) {
      snd_msg("F000001","FTPCFG     *LIBL     ",20);
      exit(-1);
      }
   fdbk = _Rreadf(fp,&CfgRec,_REC,__DFT);
   if(fdbk->num_bytes == EOF) {
      snd_msg("F000002","FTPCFG" ,6);
      exit(-1);
      }
   keepalive = CfgRec.KEEPALIVE;
   _Rclose(fp);
   AppWrkLclCwd();
   }
else {
   tmp_ptr = argv;
   call_lopt = (Qui_ALC_t *) tmp_ptr[1];
   UIMExit(call_lopt);
   }
exit(0);
}
 
/**
  * (Function) AppWrkLclCwd
  * Work with Local Working Directory
  * @parms NONE
  * returns NULL
  */
 
void AppWrkLclCwd()  {
int ret = 0;                                // return val
int Function_Requested,
*Func_Req = &Function_Requested;            // func requested
char applHandle[8];                         // application handle
char varBuffer[130];                        // variable buffer
char connected = 'N';                       // connected flag
char command[50];                           // cmd buf
char User_Task = 'O';                       // task flag
int Wait = -1;                              // wait time
int  C_Stack = 0;                           // stack flag
char *Msg_Queue = "QUIDSPP";                // msg q
char *Ref_Key = "    ";                     // ref key
char Cursor = 'D';                          // cursor
char L_Ent[4] = "NONE";                     // list entry
char Err_LE[4] = "NONE";                    // err le
EC_t Error_Code = {0};                      // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
/* open the application */
QUIOPNDA(applHandle,
         PNLGRP,
         APPSCOPE_CALLER,
         EXITPARM_STR,
         HELPFULL_NO,
         &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return;
   }
/* send epgm info */
memset(varBuffer,' ',EXITPROG_BUFLEN);
memcpy(varBuffer,ILEPGMLIB,20);
QUIPUTV(applHandle,
        varBuffer,
        EXITPROG_BUFLEN,
        "EXITPGM   ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   QUICLOA(applHandle,
           CLOSEOPT_NORMAL,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   return;
   }
/* set connection info */
QUIPUTV(applHandle,
        &connected,
        sizeof(connected),
        "CONNFLAG  ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   QUICLOA(applHandle,
           CLOSEOPT_NORMAL,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   return;
   }
/* create mesage queue  for log messages */
strcpy(command,"CRTMSGQ MSGQ(QTEMP/FTPCLOGQ)");
ret = Issue_Cmd(command);
/* put up initial panel */
init_panel(applHandle);
QUIDSPP(applHandle,
        Func_Req,
        "SITEL     ",
        REDISPLAY_NO,
        &Error_Code,
        User_Task,
        C_Stack,
        Msg_Queue,
        Ref_Key,
        Cursor,
        L_Ent,
        Err_LE,
        Wait);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   QUICLOA(applHandle,
           CLOSEOPT_NORMAL,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   return;
   }
/* remove the temp message queue */
strcpy(command,"DLTMSGQ MSGQ(QTEMP/FTPCLOGQ)");
ret = Issue_Cmd(command);
/* close down and leave */
QUICLOA(applHandle,
        CLOSEOPT_NORMAL,
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return;
   }
return;
}
 
/**
  * (Function) UIMExit
  * processes exit requests
  * @parm
  *     Exit request structure
  * returns NULL
  */
 
void UIMExit(Qui_ALC_t *uimExitStr)  {
void ProcessListOption(Qui_ALC_t *);
void ProcessListExit(Qui_ALX_t *);
void ProcessFuncKeyAct(Qui_FKC_t *);
 
Qui_FKC_t *funcKeyAction;
Qui_MIC_t *menuOptAction;
Qui_ALC_t *listOptAction;
Qui_GPX_t *generalExit;
Qui_ALX_t *listOptExit;
Qui_ILX_t *incompleteListExit;
Qui_AFX_t *applFormatExit;
Qui_AFX_t *cursorPromptExit;
int CallType;
 
CallType = uimExitStr->CallType;
switch(CallType)  {
   case 1: {
     funcKeyAction = (Qui_FKC_t *) uimExitStr;
     ProcessFuncKeyAct(funcKeyAction);
     break;
     }
   case 2: {
     menuOptAction = (Qui_MIC_t *) uimExitStr;
     break;
     }
   case 3: {
     listOptAction = (Qui_ALC_t *) uimExitStr;
     ProcessListOption(listOptAction);
     break;
     }
   case 4: {
     generalExit = (Qui_GPX_t *) uimExitStr;
     break;
     }
   case 5: {
     listOptExit = (Qui_ALX_t *) uimExitStr;
     ProcessListExit(listOptExit);
     break;
     }
   case 6: {
     incompleteListExit = (Qui_ILX_t *) uimExitStr;
     break;
     }
   case 7: {
     applFormatExit = (Qui_AFX_t *) uimExitStr;
     break;
     }
   case 8: {
     cursorPromptExit = (Qui_AFX_t *) uimExitStr;
     break;
     }
  }
return;
}
 
/**
  * (Function) ProcessListOption
  * Process list options
  * @parms
  *     ListOption struct
  * returns NULL
  */
 
void ProcessListOption(Qui_ALC_t *listOptAction) {
_RFILE    *fp;                              // file Ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
SITREC   Sitrec;                            // File struct
SITREC   Sitrec1;                           // File struct
extern int hCntrlSocket;                    // control socket
int len = 0;                                // counter
int i = 0;                                  // counter
int ret = 0;                                // return val
int optzero = 0;                            // Option set
int path_len = 0;                           // path size
int offset = 0;                             // offset counter
int rrn = 0;                                // file rrn
int functionRequested,                      // Function requested by user
*funcReq = &functionRequested;              // Pointer to function requested
int Server_Port = 0;                        // Remote Server port
int retry = 0;                              // retry num
int delay = 0;                              // delay num
char quit = '1';                            // CANCEL
char connected;                             // connected flag
char ExtOpt = 'N';                          // Ext opt
char type;                                  // view type lcl/rmt
char newpath[MAX_PATH];                     // path string
char key [16];                              // cipher key
char rkeys[176];                            // keys
char cipher[16];                            // cipher text
char plain [16];                            // plain text
char msg_dta[MAX_MSG];                      // message data
char tmp[PWD_LEN];                          // tmp buf
char command[BUF_SIZE];                     // command string
char temp_file[BUF_SIZE];                   // temp file
char cwd[BUF_SIZE];                         // directory
char cwd_1[BUF_SIZE];                       // directory
char Sel_Crit[20];                          // selection criteria
char SelHdl[4];                             // slection handle
char Le_Hndl[4];                            // list entry handle
char server[51];                            // server address
char Pnluser[10];                           // panel user
char oldname[BUF_SIZE];                     // buffer
char newname[BUF_SIZE];                     // buffer
char *ptr;                                  // pointer char
rename_rec_t namerec;                       // name struct
path_rec_t pathrec;                         // path struct
Sit_Rec_t Site_Rec;                         // UIM Struct
sitdet_t buf;                               // site struct
dftcnn_t buf1;                              // conn struct
Qui_ALC_t listOpt;                          // UIM Structure for List Option
struct dsp_buf{                             // temp struct
       char name[SHORT_NAME];
       char lname[MAX_NAME];
       char type[10];
       }dsp_buf;
struct stat info;                           // IFS stat struct
EC_t Error_Code = {0};                      // Error Code struct
 
listOpt = *listOptAction;
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
/* Connect to the remote system.  */
if((listOpt.ListOption == 1) &&
   (memcmp(listOpt.ListName,"SITELST   ",10) == 0)) {
   QUIGETV(listOpt.ApplHandle,
           &Pnluser,
           sizeof(Pnluser),
           "PNLUSR    ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* site info */
   QUIGETV(listOpt.ApplHandle,
           &buf,
           sizeof(buf),
           "BUF       ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* ip info */
   QUIGETV(listOpt.ApplHandle,
           &buf1,
           sizeof(buf1),
           "BUF1      ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /*Copy the port number and server address  */
   Server_Port = buf1.port;
   retry = buf1.retry;
   delay = buf1.delay;
   memset(server,'\0',51);
   for(i = 0; i < 50; i++) {
      server[i] = (buf.hostadr[i] == ' ' ) ? '\0' : buf.hostadr[i];
      if(server[i] == '\0')
         break;
      }
   /* connect to the server */
   if(Crt_Cntrl_Conn(server, Server_Port, buf.sitelbl, buf.pwd,buf.userid, Pnluser, retry, delay) == 1) {
      connected = 'Y';
      QUIPUTV(listOpt.ApplHandle,
              &connected,
              sizeof(connected),
              "CONNFLAG  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      QUIGETV(listOpt.ApplHandle,
              &Site_Rec,
              sizeof(Site_Rec),
              "SITEINFO  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      // get the remote features and write to the log.
      get_feat();
      /* load the path info */
      memset(&pathrec,' ',sizeof(pathrec));
      strcpy(pathrec.path,Site_Rec.Sit_Dets.LCLDIR);
      strcpy(pathrec.lpath,Site_Rec.Sit_Dets.LCLDIR);
      QUIPUTV(listOpt.ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "PATHREC   ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      memset(&pathrec,' ',sizeof(pathrec));
      strcpy(pathrec.path,Site_Rec.Sit_Dets.RMTDIR);
      strcpy(pathrec.lpath,Site_Rec.Sit_Dets.RMTDIR);
      QUIPUTV(listOpt.ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "RPATHREC  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      /* just add the single entry back */
      QUIDLTL(listOpt.ApplHandle,
              "SITELST   ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      /* set the option variable to 0 */
      QUIPUTV(listOpt.ApplHandle,
              &optzero,
              sizeof(int),
              "OPTCLR2   ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      QUIADDLE(listOpt.ApplHandle,
               &Site_Rec,
               sizeof(Site_Rec),
               "SITEINFO  ",
               "SITELST   ",
               "NEXT",
               "    ",
               &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      /* display the remote directory */
      type = '1';
      QUIPUTV(listOpt.ApplHandle,
              &type,
              sizeof(type),
              "VIEWTYPE  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         End_Cntrl_Conn(buf.sitelbl);
         return;
         }
      //sprintf(msg_dta,"Connect to remote system and get path");
      //snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      Get_Rmt_Cwd(listOpt.ApplHandle,pathrec.lpath);
      QUIDSPP(listOpt.ApplHandle,
              funcReq,
              "CWD       ",
              REDISPLAY_NO,
              &Error_Code);
      if((Error_Code.EC.Bytes_Available)&&
         (memcmp(&Error_Code.EC.Exception_Id,"CPD6A48",7) != 0)) {
         snd_error_msg(Error_Code);
         return;
         }
      }
   return;
   }
 
/* list option - Get/Put File.     */
 
if((listOpt.ListOption == 1) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* both need control socket */
   if(Check_Cntrl_Socket() != 1) {
      Not_Connected(listOpt.ApplHandle);
      QUIPUTV(listOpt.ApplHandle,
              &quit,
              sizeof(quit),
              "CANCEL    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIDLTL(listOpt.ApplHandle,
              "CWDLST    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIPUTV(listOpt.ApplHandle,
              &optzero,
              sizeof(int),
              "OPTCLR    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      return;
      }
   /* if *LOCAL check security */
   if(type == '0') {
      if(memcmp(dsp_buf.type,"*STMF",5) == 0)
         Put_File(dsp_buf.lname);
      if(memcmp(dsp_buf.type,"*DIR",4) == 0)
         Build_Rmt_Dir(dsp_buf.lname);
      }
   /* if remote */
   else {
      if(memcmp(dsp_buf.type,"*STMF",5) == 0) {
         ptr = strstr(dsp_buf.lname,".SAV");
         if(ptr != NULL)
            Get_Save_File(dsp_buf.lname);
         else
            Get_File(dsp_buf.lname);
         }
      else if(memcmp(dsp_buf.type,"*DIR",4) == 0)
         Get_Rmt_Dir(dsp_buf.lname);
      }
   return;
   }
 
/* Edit the file from the list of objects   */
 
if((listOpt.ListOption == 2) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   if(getcwd(cwd,sizeof(cwd)) == NULL) {
      perror("getcwd() error");
      return;
      }
   if((memcmp(dsp_buf.name,"..",2) == 0) ||
      (memcmp(dsp_buf.type,"*DIR",4) == 0)) {
      snd_log_msg("CWD0002"," ",0);
      snd_status_msg("CWD0002"," ",0);
      return;
      }
   strcpy(command,"EDTF STMF('");
   strcat(command,cwd);
   strcat(command,"/");
   strcat(command,dsp_buf.lname);
   strcat(command,"')");
   system(command);
   return;
   }
 
/* Edit the connection information  */
 
if((listOpt.ListOption == 2) &&
   (memcmp(listOpt.ListName,"SITELST   ",10) == 0)) {
   /* set the password to blanks */
   memset(tmp,' ',PWD_LEN);
   QUIPUTV(listOpt.ApplHandle,
           &tmp,
           sizeof(tmp),
           "PWDREC    ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIDSPP(listOpt.ApplHandle,
           funcReq,
           "SITEDET   ",
           REDISPLAY_NO,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   if(*funcReq == 500) {
      QUIGETV(listOpt.ApplHandle,
              &Site_Rec,
              sizeof(Site_Rec),
              "SITEINFO  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIGETV(listOpt.ApplHandle,
              &Pnluser,
              sizeof(Pnluser),
              "PNLUSR    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      memcpy(&Sitrec.LCLUSER,Site_Rec.Sit_Dets.LCLUSER,_SIT_REC);
      memcpy(&Sitrec.LCLUSER,Pnluser,10);
      if((fp =_Ropen("FTPSITE","rr+")) == NULL) {
         snd_msg("F000001","FTPSITE   ",10);
         return;
         }
      rrn = QXXZTOI(Site_Rec.rrn,5,0);
      fdbk = _Rreadd(fp,&Sitrec1,_SIT_REC,__DFT,rrn);
      if(fdbk->num_bytes != _SIT_REC) {
         memcpy(msg_dta,"FTPSITE   ",10);
         memcpy(&msg_dta[10],&Site_Rec.rrn,sizeof(Site_Rec.rrn));
         snd_msg("F000010",msg_dta,15);
         return;
         }
      if(memcmp(Sitrec.PWD,tmp,PWD_LEN) != 0) {
         Get_Key(key,Pnluser);
         AES ("EK", key, rkeys, plain, cipher);
         for(i = PWD_LEN / 16, offset = 0; i > 0; i --,offset += 16) {
            memcpy(plain,&Sitrec.PWD[offset],16);
            AES ("E ", key, rkeys, plain, cipher);
            memcpy(&tmp[offset],cipher,16);
            memset(plain,' ',16);
            memset(cipher,' ',16);
            }
         if((PWD_LEN % 16) > 0)  {
            memset(plain,' ',16);
            memset(cipher,' ',16);
            memcpy(plain,&Sitrec.PWD[offset],PWD_LEN % 16);
            AES ("E ", key, rkeys, plain, cipher);
            memcpy(&tmp[offset],cipher,PWD_LEN % 16);
            }
         memcpy(Site_Rec.Sit_Dets.PWD,tmp,PWD_LEN);
         memcpy(Sitrec.PWD,tmp,PWD_LEN);
         }
      else  {
         memcpy(Sitrec.PWD,Sitrec1.PWD,PWD_LEN);
         memcpy(Site_Rec.Sit_Dets.PWD,Sitrec1.PWD,PWD_LEN);
         }
      for(i = MAX_SITE-1; i >= 0; i--) {
         if(Sitrec.SITELBL[i] != ' ') {
            memset(&Sitrec.SITELBL[i+1],'\0',1);
            memset(&Site_Rec.Sit_Dets.SITELBL[i+1],'\0',1);
            break;
            }
         }
      for(i = SHORT_PATH-1; i >= 0; i--) {
         if(Sitrec.LCLDIR[i] != ' ') {
            memset(&Sitrec.LCLDIR[i+1],'\0',1);
            memset(&Site_Rec.Sit_Dets.LCLDIR[i+1],'\0',1);
            break;
            }
         }
      for(i = SHORT_PATH-1; i >= 0; i--) {
         if(Sitrec.RMTDIR[i] != ' ') {
            memset(&Sitrec.RMTDIR[i+1],'\0',1);
            memset(&Site_Rec.Sit_Dets.RMTDIR[i+1],'\0',1);
            break;
            }
         }
      fdbk = _Rupdate(fp,&Sitrec,_SIT_REC);
      _Rclose(fp);
      QUIUPDLE(listOpt.ApplHandle,
               &Site_Rec,
               sizeof(Site_Rec),
               "SITEINFO  ",
               "SITELST   ",
               "SAME",
               Le_Hndl,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      }
   return;
   }
 
/* disconnect from the remote site  */
 
if((listOpt.ListOption == 3) &&
   (memcmp(listOpt.ListName,"SITELST   ",10) == 0)) {
   QUIGETV(listOpt.ApplHandle,
           &buf,
           sizeof(buf),
           "BUF       ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   End_Cntrl_Conn(buf.sitelbl);
   QUIDLTL(listOpt.ApplHandle,
           "SITELST   ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   connected = 'N';
   QUIPUTV(listOpt.ApplHandle,
           &connected,
           sizeof(connected),
           "CONNFLAG  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIPUTV(listOpt.ApplHandle,
           &optzero,
           sizeof(int),
           "OPTCLR2   ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   init_panel(listOpt.ApplHandle);
   return;
   }
 
/* Change directory  or display contents */
 
if((listOpt.ListOption == 5) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* if local */
   if(type == '0') {
      if((memcmp(dsp_buf.type, "*DIR",4) != 0) &&
         (memcmp(dsp_buf.type, "*LIB",4) != 0) &&
         (memcmp(dsp_buf.type, "*DDIR",5) != 0) &&
         (memcmp(dsp_buf.type, "*FLR",4) != 0)) {
         memset(cwd,'\0',sizeof(cwd));
         if(getcwd(cwd,sizeof(cwd)) == NULL) {
            snd_msg("CWD0003"," ",0);
            return;
            }
         strcpy(command,"DSPF STMF('");
         strcat(command,cwd);
         strcat(command,"/");
         strcat(command,dsp_buf.lname);
         strcat(command,"')");
         system(command);
         printf("%s\n",command);
         return;
         }
      memset(cwd,'\0',sizeof(cwd));
      if(getcwd(cwd_1,sizeof(cwd_1)) == NULL) {
         snd_msg("CWD0003"," ",0);
         return;
         }
      if(memcmp(dsp_buf.name,"..",2) == 0) {
         ptr = strrchr(cwd_1,'/');
         memset(ptr,'\0',1);
         if(strlen(cwd_1) == 0)
            strcat(cwd_1,"/");
         strcpy(cwd,cwd_1);
         }
      else {
         if(strlen(cwd_1) > 1)
            strcat(cwd_1,"/");
         strcat(cwd_1,dsp_buf.lname);
         strcpy(cwd,cwd_1);
         }
      if(stat(cwd,&info) != 0) {
         snd_msg("CWD0006"," ",0);
         return;
         }
      if((memcmp(info.st_objtype, "*DIR",4) == 0) ||
         (memcmp(info.st_objtype, "*LIB",4) == 0) ||
         (memcmp(info.st_objtype, "*DDIR",5) == 0) ||
         (memcmp(info.st_objtype, "*FLR",4) == 0)) {
         QUIPUTV(listOpt.ApplHandle,
                 &optzero,
                 sizeof(int),
                 "OPTCLR    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         if(chdir(cwd) != 0) {
            sprintf(msg_dta,"Cannot Change Directory %s %s",cwd,strerror(errno));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
            return;
            }
         QUIDLTL(listOpt.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if((Error_Code.EC.Bytes_Available) &&
            (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
            snd_error_msg(Error_Code);
            return;
            }
         Load_Cwd(listOpt.ApplHandle, cwd);
         }
      else  {
         snd_msg("CWD0007"," ",0);
         snd_log_msg("CWD0007"," ",0);
         }
      return;
      }
   else {
      if(Check_Cntrl_Socket() != 1) {
         Not_Connected(listOpt.ApplHandle);
         QUIPUTV(listOpt.ApplHandle,
                 &quit,
                 sizeof(quit),
                 "CANCEL    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIDLTL(listOpt.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         return;
         }
      if((memcmp(dsp_buf.type, "*DIR",4) != 0) &&
         (memcmp(dsp_buf.type, "*LIB",4) != 0) &&
         (memcmp(dsp_buf.type, "*DDIR",5) != 0) &&
         (memcmp(dsp_buf.type, "*FLR",4) != 0)) {
         /* create the /tmp file */
         Get_File_to_Tmp(dsp_buf.lname);
         strcpy(command,"DSPF STMF('");
         strcat(command,"/tmp/");
         strcat(command,dsp_buf.lname);
         strcat(command,"')");
         system(command);
         strcpy(command,"RMVLNK OBJLNK('/tmp/");
         strcat(command,dsp_buf.lname);
         strcat(command,"')");
         ret = Issue_Cmd(command);
         return;
         }
      if(memcmp(dsp_buf.type,"*DIR",4) != 0) {
         snd_log_msg("CWD0007"," ",0);
         snd_msg("CWD0007"," ",0);
         return;
         }
      QUIPUTV(listOpt.ApplHandle,
              &optzero,
              sizeof(int),
              "OPTCLR    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIGETV(listOpt.ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "RPATHREC  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      memset(newpath,'\0',sizeof(newpath));
      if(memcmp(&dsp_buf.lname,"..",2) == 0) {
         ptr = strrchr(pathrec.lpath,'/');
         memset(ptr,'\0',1);
         if(strlen(pathrec.lpath) == 0)
            strcat(pathrec.lpath,"/");
         strcpy(newpath,pathrec.lpath);
         }
      else {
         strcpy(newpath,pathrec.lpath);
         if(strlen(newpath) > 1)
            strcat(newpath,"/");
         strcat(newpath,dsp_buf.lname);
         }
      memset(&pathrec,' ',sizeof(pathrec));
      path_len = strlen(newpath);
      if(path_len >= MAX_PATH) {
         snd_msg("CWD0008"," ",0);
         snd_log_msg("CWD0008"," ",0);
         return;
         }
      if(path_len >= SHORT_PATH) {
         memcpy(pathrec.path,newpath,SHORT_PATH);
         memset(&pathrec.path[SHORT_PATH-1],'~',1);
         }
      else
         strcpy(pathrec.path,newpath);
      strcpy(pathrec.lpath,newpath);
      if(Get_Rmt_Cwd(listOpt.ApplHandle,newpath) == 1) {
         QUIPUTV(listOpt.ApplHandle,
                 &pathrec,
                 sizeof(pathrec),
                 "RPATHREC  ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         }
      return;
      }
   return;
   }
 
/* Delete a site definition   */
 
if((listOpt.ListOption == 4) &&
   (memcmp(listOpt.ListName,"SITELST   ",10) == 0)) {
   if((fp =_Ropen("FTPSITE","rr+")) == NULL) {
      snd_msg("F000001","FTPSITE   ",10);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &Site_Rec,
           sizeof(Site_Rec),
           "SITEINFO  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   rrn = QXXZTOI(Site_Rec.rrn,5,0);
   fdbk = _Rlocate(fp,NULL,rrn,__RRN_EQ);
   fdbk = _Rdelete(fp);
   _Rclose(fp);
   QUIRMVLE(listOpt.ApplHandle,
           listOpt.ListName,
           EXTEND_NO,
           Le_Hndl,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   return;
   }
 
/* Delete an object from the directory list  */
 
if((listOpt.ListOption == 4) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* if local */
   if(type == '0') {
      if(getcwd(cwd,sizeof(cwd)) == NULL) {
         snd_msg("CWD0003"," ",0);
         return;
         }
      if(memcmp(dsp_buf.type,"*DIR",4) == 0) {
         if(memcmp(dsp_buf.name,"..",2) == 0) {
            snd_msg("CWD0004"," ",0);
            snd_log_msg("CWD0004"," ",0);
            return;
            }
         if(rmdir(dsp_buf.lname) != 0) {
            sprintf(msg_dta,"rmdir() error %s",strerror(errno));
            snd_msg("GEN0001",msg_dta,strlen(msg_dta));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            return;
            }
         else  {
            sprintf(msg_dta," Directory %s removed",dsp_buf.lname);
            snd_msg("GEN0001",msg_dta,strlen(msg_dta));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            QUIRMVLE(listOpt.ApplHandle,
                    listOpt.ListName,
                    EXTEND_NO,
                    Le_Hndl,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         }
      else if(memcmp(dsp_buf.type,"*STMF",5) == 0) {
         if(unlink(dsp_buf.lname) == 0) {
            sprintf(msg_dta,"File : %s Deleted",dsp_buf.lname);
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            QUIRMVLE(listOpt.ApplHandle,
                    listOpt.ListName,
                    EXTEND_NO,
                    Le_Hndl,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         else   {
            sprintf(msg_dta,"File : %s Not Deleted : %s",dsp_buf.lname,
                    strerror(errno));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            return;
            }
         }
      else {
         snd_msg("CWD0005"," ",0);
         snd_log_msg("CWD0005"," ",0);
         }
      return;
      }
   else {
      if(Check_Cntrl_Socket() != 1) {
         Not_Connected(listOpt.ApplHandle);
         QUIPUTV(listOpt.ApplHandle,
                 &quit,
                 sizeof(quit),
                 "CANCEL    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIDLTL(listOpt.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         return;
         }
      if(memcmp(dsp_buf.type,"*DIR",4) == 0) {
         if(Rmv_Rmt_Dir(dsp_buf.lname) != 1)
            return;
         else  {
            QUIRMVLE(listOpt.ApplHandle,
                    listOpt.ListName,
                    EXTEND_NO,
                    Le_Hndl,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         }
      else if(memcmp(dsp_buf.type,"*STMF",5) == 0) {
         if(Del_Rmt_File(dsp_buf.lname) != 1)
            return;
         else {
            QUIRMVLE(listOpt.ApplHandle,
                    listOpt.ListName,
                    EXTEND_NO,
                    Le_Hndl,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         }
      else  {
         sprintf(msg_dta,"Delete not supported for type : %s",
                 dsp_buf.type);
         snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
         }
      return;
      }
   return;
   }
 
/* Display detail  */
 
if((listOpt.ListOption == 8) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* if local */
   if(type == '0') {
      Get_Lcl_Det(listOpt.ApplHandle,dsp_buf.lname);
      QUIDSPP(listOpt.ApplHandle,
              funcReq,
              "OBJDET    ",
              REDISPLAY_NO,
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      return;
      }
   else {
      if(Check_Cntrl_Socket() != 1) {
         Not_Connected(listOpt.ApplHandle);
         QUIPUTV(listOpt.ApplHandle,
                 &quit,
                 sizeof(quit),
                 "CANCEL    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIDLTL(listOpt.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         return;
         }
      if(memcmp(dsp_buf.type,"*STMF",5) != 0) {
         if(Get_Dir_Det(listOpt.ApplHandle,dsp_buf.lname) == 1) {
            QUIDSPP(listOpt.ApplHandle,
                    funcReq,
                    "OBJDET    ",
                    REDISPLAY_NO,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         }
      else  {
         if(Get_Rmt_Det(listOpt.ApplHandle,dsp_buf.lname) == 1) {
            QUIDSPP(listOpt.ApplHandle,
                    funcReq,
                    "OBJDET    ",
                    REDISPLAY_NO,
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            }
         }
      }
   return;
   }
 
 
/* Rename Object Local */
 
if((listOpt.ListOption == 7) &&
   (memcmp(listOpt.ListName,"CWDLST    ",10) == 0)) {
   QUIGETLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            "Y",
            Sel_Crit,
            SelHdl,
            &ExtOpt,
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(listOpt.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* if local */
   if(type == '0') {
      QUIDSPP(listOpt.ApplHandle,
              funcReq,
              "RENAMEF   ",
              REDISPLAY_NO,
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      if(*funcReq == 500) {
         QUIGETV(listOpt.ApplHandle,
                 &namerec,
                 sizeof(namerec),
                 "NEWNAME   ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            exit(-1);
            }
         for(i = MAX_NAME-1; i >= 0; i--) {
            if(namerec.newname[i] != ' ') {
               namerec.newname[i+1] = '\0';
               break;
               }
            }
         if(Qp0lRenameKeep(namerec.oldname,namerec.newname) != 0) {
            sprintf(msg_dta,"Rename failed : %s",strerror(errno));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            return;
            }
         len = strlen(namerec.newname);
         memset(dsp_buf.name,' ',SHORT_NAME+MAX_NAME);
         if(len > SHORT_NAME) {
            memcpy(dsp_buf.name,namerec.newname,SHORT_NAME);
            memset(&dsp_buf.name[SHORT_NAME-1],'~',1);
            }
         else
            memcpy(dsp_buf.name,namerec.newname,len);
         memcpy(dsp_buf.lname,namerec.newname,len);
         }
      }
   /* remote */
   else {
      QUIDSPP(listOpt.ApplHandle,
              funcReq,
              "RENAMEF   ",
              REDISPLAY_NO,
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      if(*funcReq == 500) {
         QUIGETV(listOpt.ApplHandle,
                 &pathrec,
                 sizeof(pathrec),
                 "RPATHREC  ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIGETV(listOpt.ApplHandle,
                 &namerec,
                 sizeof(namerec),
                 "NEWNAME   ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         for(i = MAX_NAME-1; i >= 0; i--) {
            if(namerec.newname[i] != ' ') {
               namerec.newname[i+1] = '\0';
               break;
               }
            }
         memset(newname,'\0',BUF_SIZE);
         memset(oldname,'\0',BUF_SIZE);
         strcpy(oldname,pathrec.lpath);
         strcat(oldname,"/");
         strcat(oldname,namerec.oldname);
         strcpy(newname,pathrec.lpath);
         strcat(newname,"/");
         strcat(newname,namerec.newname);
         if(Ren_Rmt_Obj(oldname,newname) == 1) {
            len = strlen(namerec.newname);
            memset(dsp_buf.name,' ',SHORT_NAME+MAX_NAME);
            if(len > SHORT_NAME) {
               memcpy(dsp_buf.name,namerec.newname,SHORT_NAME);
               memset(&dsp_buf.name[SHORT_NAME-1],'~',1);
               }
            else
               memcpy(dsp_buf.name,namerec.newname,len);
            memcpy(dsp_buf.lname,namerec.newname,len);
            }
         }
      }
   /* update the list */
   QUIUPDLE(listOpt.ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "SAME",
            Le_Hndl,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   return;
   }
return;
}
 
/**
  * (Function) ProcessListExit
  * run when a list exits with a delete
  * @parms
  *     ListExit struct
  * returns NULL
  */
 
void ProcessListExit(Qui_ALX_t *listOptExit) {
Qui_ALX_t listExit;                         // exit struct
char ListEntryHandle[4];                    // entry handle
EC_t Error_Code;                            // error code struct
listExit = *listOptExit;
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
if((listExit.Result == 0) && (listExit.ListOption == 4)) {
   QUIRMVLE(listExit.ApplHandle,listExit.ListName,EXTEND_NO,
            ListEntryHandle,&Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   return;
   }
return;
}
 
/**
  * (Function) ProcessFuncKeyAct
  * Process Function Key action
  * @parms
  *     FunctionKeyRequest Struct
  * returns NULL
  */
 
void ProcessFuncKeyAct(Qui_FKC_t *funcKeyAct) {
extern int hCntrlSocket;                    // control socket
int optzero = 0;                            // Option set
int len = 0;                                // counter
int i = 0;                                  // counter
int functionRequested,                      // Function requested by user
*funcReq = &functionRequested;              // Pointer to function requested
char quit = '1';                            // CANCEL
char type;                                  // view type lcl/rmt
extern char tMode;                          // transfer mode
char msg_dta[MAX_MSG];                      // message data
char newpath[MAX_PATH];                     // path string
char dir[SHORT_NAME];                       // dir name
path_rec_t pathrec;                         // path struct
Qui_FKC_t FKeyAct;
EC_t Error_Code = {0};
 
FKeyAct = *funcKeyAct;
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
/* FKey 2 Set Directory  */
if(FKeyAct.FunctionKey == 2) {
   Set_Dir(FKeyAct.ApplHandle,FKeyAct.PanelName);
   return;
   }
 
/* FKey 5 Refresh the local directory list   */
 
if((FKeyAct.FunctionKey == 5) && (memcmp(FKeyAct.PanelName,"CWD       ",10) == 0)) {
   /* ensure the opt flag is clear */
   QUIPUTV(FKeyAct.ApplHandle,
           &optzero,
           sizeof(int),
           "OPTCLR    ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIDLTL(FKeyAct.ApplHandle,
           "CWDLST    ",
           &Error_Code);
   if((Error_Code.EC.Bytes_Available) && (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
      snd_error_msg(Error_Code);
      return;
      }
   /* check local or remote */
   QUIGETV(FKeyAct.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* local */
   if(type == '0') {
      QUIGETV(FKeyAct.ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "PATHREC   ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      Load_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
      return;
      }
   /* remote */
   else {
      if(Check_Cntrl_Socket() != 1) {
         Not_Connected(FKeyAct.ApplHandle);
         QUIPUTV(FKeyAct.ApplHandle,
                 &quit,
                 sizeof(quit),
                 "CANCEL    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIDLTL(FKeyAct.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if((Error_Code.EC.Bytes_Available) && (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
            snd_error_msg(Error_Code);
            return;
            }
         return;
         }
      QUIGETV(FKeyAct.ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "RPATHREC  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      Get_Rmt_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
      return;
      }
   return;
   }
 
/* FKey 6 Add a new site  */
 
if((FKeyAct.FunctionKey == 6) &&
   (memcmp(FKeyAct.PanelName,"SITEL     ",10) == 0)) {
   Add_Site(FKeyAct.ApplHandle);
   return;
   }
 
/* FKey 6 Add a new Directory  */
 
if((FKeyAct.FunctionKey == 6) && (memcmp(FKeyAct.PanelName,"CWD       ",10) == 0)) {
   /* clear the panle buffer */
   memset(dir,' ',sizeof(dir));
   QUIPUTV(FKeyAct.ApplHandle,
           &dir,
           sizeof(dir),
           "NEWDIR    ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* check local or remote */
   QUIGETV(FKeyAct.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   /* local */
   if(type == '0') {
      QUIDSPP(FKeyAct.ApplHandle,
              funcReq,
              "ADDDIRW   ",
              REDISPLAY_NO,
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      if(*funcReq == 500) {
         QUIGETV(FKeyAct.ApplHandle,
                 &dir,
                 sizeof(dir),
                 "NEWDIR    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         for(i = SHORT_NAME-1; i >= 0; i--) {
            if(dir[i] != ' ') {
               dir[i+1] = '\0';
               break;
               }
            }
         if(mkdir(dir,S_IRWXU| S_IRGRP| S_IXGRP) != 0) {
            sprintf(msg_dta,"mkdir() failed %s",strerror(errno));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            return;
            }
         else {
            QUIGETV(FKeyAct.ApplHandle,
                    &pathrec,
                    sizeof(pathrec),
                    "PATHREC   ",
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            QUIDLTL(FKeyAct.ApplHandle,
                    "CWDLST    ",
                    &Error_Code);
            if((Error_Code.EC.Bytes_Available) &&
               (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
               snd_error_msg(Error_Code);
               return;
               }
            Load_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
            sprintf(msg_dta," Directory %s created",dir);
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            }
         }
      return;
      }
   /* remote */
   else {
      if(Check_Cntrl_Socket() != 1) {
         Not_Connected(FKeyAct.ApplHandle);
         QUIPUTV(FKeyAct.ApplHandle,
                 &quit,
                 sizeof(quit),
                 "CANCEL    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         QUIDLTL(FKeyAct.ApplHandle,
                 "CWDLST    ",
                 &Error_Code);
         if((Error_Code.EC.Bytes_Available) &&
            (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
            snd_error_msg(Error_Code);
            return;
            }
         return;
         }
      QUIDSPP(FKeyAct.ApplHandle,
              funcReq,
              "ADDDIRW   ",
              REDISPLAY_NO,
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      if(*funcReq == 500) {
         QUIGETV(FKeyAct.ApplHandle,
                 &dir,
                 sizeof(dir),
                 "NEWDIR    ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return;
            }
         for(i = SHORT_NAME-1; i >= 0; i--) {
            if(dir[i] != ' ') {
               dir[i+1] = '\0';
               break;
               }
            }
         if(Add_Rmt_Dir(dir)) {
            sprintf(msg_dta," Directory %s created",dir);
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            QUIGETV(FKeyAct.ApplHandle,
                    &pathrec,
                    sizeof(pathrec),
                    "RPATHREC  ",
                    &Error_Code);
            if(Error_Code.EC.Bytes_Available) {
               snd_error_msg(Error_Code);
               return;
               }
            QUIDLTL(FKeyAct.ApplHandle,
                    "CWDLST    ",
                    &Error_Code);
            if((Error_Code.EC.Bytes_Available) &&
               (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
               snd_error_msg(Error_Code);
               return;
               }
            sprintf(msg_dta,"Remote dir %s",pathrec.lpath);
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            Get_Rmt_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
            }
         }
      return;
      }
   return;
   }
 
/* FKey 7 Display local directory  */
 
if(FKeyAct.FunctionKey == 7) {
   /* put the view type variable to the remote system */
   type = '0';
   QUIPUTV(FKeyAct.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(FKeyAct.ApplHandle,
           &pathrec,
           sizeof(pathrec),
           "PATHREC   ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIDLTL(FKeyAct.ApplHandle,
           "CWDLST    ",
           &Error_Code);
   if((Error_Code.EC.Bytes_Available) &&
      (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
      snd_error_msg(Error_Code);
      return;
      }
   Load_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
   if(memcmp(FKeyAct.PanelName,"SITEL     ",10) == 0) {
      QUIDSPP(FKeyAct.ApplHandle,
              funcReq,
              "CWD       ",
              REDISPLAY_NO,
              &Error_Code);
      if((Error_Code.EC.Bytes_Available)&&
         (memcmp(&Error_Code.EC.Exception_Id,"CPD6A48",7) != 0)) {
         snd_error_msg(Error_Code);
         return;
         }
      }
   return;
   }
 
/* FKey 8 Display remote directory */
 
if(FKeyAct.FunctionKey == 8) {
   if(Check_Cntrl_Socket() != 1) {
      Not_Connected(FKeyAct.ApplHandle);
      QUIPUTV(FKeyAct.ApplHandle,
              &quit,
              sizeof(quit),
              "CANCEL    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIDLTL(FKeyAct.ApplHandle,
              "CWDLST    ",
              &Error_Code);
      if((Error_Code.EC.Bytes_Available) &&
         (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
         snd_error_msg(Error_Code);
         return;
         }
      return;
      }
   type = '1';
   QUIPUTV(FKeyAct.ApplHandle,
           &type,
           sizeof(type),
           "VIEWTYPE  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIDLTL(FKeyAct.ApplHandle,
           "CWDLST    ",
           &Error_Code);
   if((Error_Code.EC.Bytes_Available) &&
      (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
      snd_error_msg(Error_Code);
      return;
      }
   QUIGETV(FKeyAct.ApplHandle,
           &pathrec,
           sizeof(pathrec),
           "RPATHREC  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   Get_Rmt_Cwd(FKeyAct.ApplHandle,pathrec.lpath);
   if(memcmp(FKeyAct.PanelName,"SITEL     ",10) == 0) {
      QUIDSPP(FKeyAct.ApplHandle,
              funcReq,
              "CWD       ",
              REDISPLAY_NO,
              &Error_Code);
      if((Error_Code.EC.Bytes_Available)&&
         (memcmp(&Error_Code.EC.Exception_Id,"CPD6A48",7) != 0)) {
         snd_error_msg(Error_Code);
         return;
         }
      }
   return;
   }
 
/* FKey 14 Change Transfer type  */
 
if(FKeyAct.FunctionKey == 14) {
   if(Check_Cntrl_Socket() != 1) {
      Not_Connected(FKeyAct.ApplHandle);
      QUIPUTV(FKeyAct.ApplHandle,
              &quit,
              sizeof(quit),
              "CANCEL    ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      QUIDLTL(FKeyAct.ApplHandle,
              "CWDLST    ",
              &Error_Code);
      if((Error_Code.EC.Bytes_Available) &&
         (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
         snd_error_msg(Error_Code);
         return;
         }
      return;
      }
   QUIDSPP(FKeyAct.ApplHandle,
           funcReq,
           "CHGTTYP   ",
           REDISPLAY_NO,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return;
      }
   if(*funcReq == 500) {
      QUIGETV(FKeyAct.ApplHandle,
              &tMode,
              sizeof(tMode),
              "MODE      ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return;
         }
      sprintf(msg_dta," mode = %c",tMode);
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      }
   return;
   }
return;
}
 
/**
  * (Function) Add_Site
  * Add  new site connection
  * @parms
  *     Application Handle
  * return 1
  */
 
int Add_Site(char *ApplHandle) {
_RFILE    *fp;                              // file Ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
SITREC   Sitrec;                            // File struct
Sit_Rec_t Site_Rec;                         // site struct
int functionRequested,
*funcReq = &functionRequested;              // function requested
int i = 0;                                  // counter
int path_len = 0;                           // counter
int offset = 0;                             // marker
char Pnluser[10];                           // user
char path[SHORT_PATH];                      // path
char tmp[PWD_LEN];                          // tmp buffer
char key [16];                              // cipher key
char rkeys[176];                            // ret keys
char cipher[16];                            // cipher text
char plain [16];                            // plain text
char msg_dta[MAX_MSG];                      // msg Data
sitdet_t buf;                               // site struct
dftcnn_t buf1;                              // conn struct
EC_t Error_Code = {0};                      // err struct
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
memset(&buf,' ',sizeof(buf));
memset(&buf.transtyp,'A',1);
buf1.port = 21;
buf1.retry = 2;
buf1.delay = 1;
QUIPUTV(ApplHandle,
        &buf,
        sizeof(buf),
        "BUF       ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
QUIPUTV(ApplHandle,
        &buf1,
        sizeof(buf1),
        "BUF1      ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
QUIDSPP(ApplHandle,
        funcReq,
        "SITEDET   ",
        REDISPLAY_NO,
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
if(*funcReq == 500) {
   QUIGETV(ApplHandle,
           &Pnluser,
           sizeof(Pnluser),
           "PNLUSR    ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return -1;
      }
   QUIGETV(ApplHandle,
           &Site_Rec,
           sizeof(Site_Rec),
           "SITEINFO  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return -1;
      }
   Get_Key(key,Pnluser);
   memcpy(&Sitrec.LCLUSER,Pnluser,10);
   AES ("EK", key, rkeys, plain, cipher);
   for(i = PWD_LEN / 16, offset = 0; i > 0; i --,offset += 16) {
      memcpy(plain,&Site_Rec.Sit_Dets.PWD[offset],16);
      AES ("E ", key, rkeys, plain, cipher);
      memcpy(&tmp[offset],cipher,16);
      memset(plain,' ',16);
      memset(cipher,' ',16);
      }
   if((PWD_LEN % 16) > 0) {
      memset(plain,' ',16);
      memset(cipher,' ',16);
      memcpy(plain,&Site_Rec.Sit_Dets.PWD[offset],PWD_LEN % 16);
      AES ("E ", key, rkeys, plain, cipher);
      memcpy(&tmp[offset],cipher,PWD_LEN % 16);
      }
   memcpy(Site_Rec.Sit_Dets.PWD,tmp,PWD_LEN);
   memcpy(&Sitrec.SITELBL,Site_Rec.Sit_Dets.SITELBL,_SIT_REC-10);
   for(i = MAX_SITE-1; i >= 0; i--) {
      if(Sitrec.SITELBL[i] != ' ') {
         memset(&Sitrec.SITELBL[i+1],'\0',1);
         break;
         }
      }
   for(i = SHORT_PATH-1; i >= 0; i--) {
      if(Sitrec.LCLDIR[i] != ' ') {
         memset(&Sitrec.LCLDIR[i+1],'\0',1);
         break;
         }
      }
   path_len = strlen(Sitrec.LCLDIR);
   if(memcmp(Sitrec.LCLDIR,"/qsys.lib",9) == 0) {
      for(i = 0; i > path_len; i++)
         toupper(Sitrec.LCLDIR[i]);
      }
   for(i = SHORT_PATH-1; i >= 0; i--) {
      if(Sitrec.RMTDIR[i] != ' ') {
         memset(&Sitrec.RMTDIR[i+1],'\0',1);
         break;
         }
      }
   path_len = strlen(Sitrec.RMTDIR);
   if(memcmp(Sitrec.RMTDIR,"/qsys.lib",9) == 0) {
      for(i = 0; i > path_len; i++)
         toupper(Sitrec.RMTDIR[i]);
      }
   if((fp =_Ropen("FTPSITE","rr+")) == NULL) {
      snd_msg("F000001","FTPSITE   ",10);
      return -1;
      }
   fdbk = _Rwrite(fp,&Sitrec,_SIT_REC);
   if(fdbk->num_bytes != _SIT_REC) {
      snd_msg("F000009 ","FTPSITE   ",10);
      _Rclose(fp);
      return -1;
      }
   QXXITOZ(Site_Rec.rrn,5,0,fdbk->rrn);
   memcpy(Site_Rec.Sit_Dets.SITELBL,Sitrec.SITELBL,_SIT_REC-10);
   QUIADDLE(ApplHandle,
            &Site_Rec,
            sizeof(Site_Rec),
            "SITEINFO  ",
            "SITELST   ",
            "NEXT",
            "    ",
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      _Rclose(fp);
      return -1;
      }
   _Rclose(fp);
   }
return 1;
}
 
/**
  * (Function) init_panel
  * Set up initial panel
  * @parms
  *     Application Handle
  * returns 1
  */
 
int init_panel(char *ApplHandle) {
_RFILE    *fp;                              // file Ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
SITREC   Sitrec;                            // File struct
Sit_Rec_t Site_Rec;
int functionRequested,
*Func_Req = &functionRequested;
char Pnluser[10];
char User_Task = 'O';
int  Counter = 0;
char MsgQ[10] = "*CALLER   ";
char Ref_Key[4] = "FRST";
char Cursor_Pos = 'D';
char Last_Le[4];
char Error_Le[4];
char msg_dta[MAX_MSG];
int Wait_Time = -1;
EC_t Error_Code = {0};
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
QUIGETV(ApplHandle,
        &Pnluser,
        sizeof(Pnluser),
        "PNLUSR    ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
QUIDLTL(ApplHandle,
        "SITELST   ",
        &Error_Code);
if((Error_Code.EC.Bytes_Available) &&
   (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
   snd_error_msg(Error_Code);
   return -1;
   }
if((fp =_Ropen("FTPSITE","rr")) == NULL) {
   snd_msg("F000001","FTPSITE   ",10);
   return -1;
   }
fdbk = _Rreadk(fp,&Sitrec,_SIT_REC,__DFT,Pnluser,10);
if(fdbk->num_bytes != _SIT_REC) {
   Add_Site(ApplHandle);
   }
else {
   do {
      QXXITOZ(Site_Rec.rrn,5,0,fdbk->rrn);
      memcpy(Site_Rec.Sit_Dets.SITELBL,Sitrec.SITELBL,_SIT_REC-10);
      QUIADDLE(ApplHandle,
               &Site_Rec,
               sizeof(Site_Rec),
               "SITEINFO  ",
               "SITELST   ",
               "NEXT",
               "    ",
               &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         _Rclose(fp);
         return -1;
         }
      fdbk = _Rreadk(fp,&Sitrec,_SIT_REC,__KEY_NEXTEQ,Pnluser,10);
      }while(fdbk->num_bytes == _SIT_REC);
   }
_Rclose(fp);
return 1;
}
 
/**
  * (Function) Check_Cwd
  * Check the directory exists
  * @parms
  *     Directory
  * return 1 success
  */
int Check_Cwd(char *cwd) {
DIR *dir;
 
if(( dir = opendir(cwd)) == NULL) {
   return -1;
   }
closedir(dir);
return 1;
}
 
/**
  * (Function) Load_Cwd
  * Display the directory contents
  * @parms
  *     Application Handle
  *     Directory path
  * returns 1 success
  */
 
int Load_Cwd(char *ApplHandle,char *cwd) {
int i = 0;                                  // counter
int len = 0;                                // counter
int valid_entry;                            // flag
struct dsp_buf{
       char name[SHORT_NAME];
       char lname[MAX_NAME];
       char type[10];
       }dsp_buf;                            // dsp buffer
char msg_dta[MAX_MSG];                      // msg buf
char *ptr;                                  // ptr
DIR *dir;                                   // directory struct
path_rec_t pathrec;                         // path struct
struct dirent *entry;                       // dirent struct
struct stat info;                           // stat struct
EC_t Error_Code;                            // error struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
len = strlen(cwd);
if(( dir = opendir(cwd)) == NULL) {
   sprintf(msg_dta,"opendir() error %s",strerror(errno));
   return -1;
   }
else {
   chdir(cwd);
   memset(&pathrec,' ',sizeof(pathrec));
   if(len >= SHORT_PATH) {
      memcpy(pathrec.path,cwd,SHORT_PATH);
      memset(&pathrec.path[SHORT_PATH-1],'~',1);
      }
   else
      strcpy(pathrec.path,cwd);
   strcpy(pathrec.lpath,cwd);
   QUIPUTV(ApplHandle,
           &pathrec,
           sizeof(pathrec),
           "PATHREC   ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available)
      snd_error_msg(Error_Code);
   while((entry = readdir(dir)) != NULL) {
      if(strspn(entry->d_name, ".") == 1)
         valid_entry = 0;
      else if((strcmp(cwd,"/") == 0) &&
             (strcmp(entry->d_name,"..") == 0))
         valid_entry = 0;
      else
         valid_entry = 1;
      if(valid_entry) {
         if(stat(entry->d_name,&info) != 0) {
            sprintf(msg_dta,"Cannot retrieve stat info %s : %s",
                    entry->d_name,strerror(errno));
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            }
         memset(&dsp_buf,' ',sizeof(dsp_buf));
         if((memcmp(info.st_objtype,"*FILE",5)== 0) &&
            (S_ISREG(info.st_mode))) {
            memcpy(dsp_buf.type,"*STMF     ",10);
            memcpy(dsp_buf.lname,entry->d_name,entry->d_namelen);
            ptr = strstr(dsp_buf.lname,".FILE");
            strcpy(ptr,".SAVF");
            }
         else  {
            memcpy(dsp_buf.type,info.st_objtype,10);
            memcpy(dsp_buf.lname,entry->d_name,entry->d_namelen);
            }
         if(entry->d_namelen >= SHORT_NAME) {
            memcpy(dsp_buf.name,dsp_buf.lname,SHORT_NAME);
            memset(&dsp_buf.name[SHORT_NAME-1],'~',1);
            }
         else {
            memcpy(dsp_buf.name,dsp_buf.lname,entry->d_namelen);
            }
         memset(&dsp_buf.lname[entry->d_namelen],'\0',1);
         QUIADDLE(ApplHandle,
                  &dsp_buf,
                  sizeof(dsp_buf),
                  "CWDINF    ",
                  "CWDLST    ",
                  "NEXT",
                  "    ",
                  &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            closedir(dir);
            return -1;
            }
         }
      } /* end of !.. processing */
   closedir(dir);
   }
return 1;
}
 
/**
  * (Function) Build_Rmt_Dir
  * Build a remote directory using local objects
  * @parms
  *     Path
  * returns 1 success
  */
 
int Build_Rmt_Dir(char *dir) {
int i = 0;                                  // counter
int len = 0;                                // counter
int valid_entry;                            // flag
struct dsp_buf{
       char name[SHORT_NAME];
       char lname[MAX_NAME];
       char type[10];
       }dsp_buf;                            // dsp buf
char msg_dta[MAX_MSG];                      // msg buf
char name[MAX_NAME];                        // name buf
DIR *cwd;                                   // dir struct
struct dirent *entry;                       // dirent struct
struct stat info;                           // stat struct
 
Add_Rmt_Dir(dir);
Chg_Rmt_Dir(dir);
len = strlen(dir);
if(( cwd = opendir(dir)) == NULL) {
   sprintf(msg_dta,"opendir() error %s",strerror(errno));
   return -1;
   }
else {
   chdir(dir);
   while((entry = readdir(cwd)) != NULL) {
      if((strcmp(entry->d_name, ".") == 0) ||
        (strcmp(entry->d_name,"..") == 0))
         valid_entry = 0;
      else
         valid_entry = 1;
      if(valid_entry) {
         if(stat(entry->d_name,&info) != 0) {
            sprintf(msg_dta,"Failed to get stat info %s",
                    entry->d_name);
            snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
            }
         memcpy(dsp_buf.type,info.st_objtype,10);
         if(memcmp(info.st_objtype,"*DIR",4) == 0) {
            memcpy(name,entry->d_name,entry->d_namelen);
            memset(&name[entry->d_namelen],'\0',1);
            Build_Rmt_Dir(name);
            Go_Back_Rmt();
            }
         else {
            memcpy(name,entry->d_name,entry->d_namelen);
            memset(&name[entry->d_namelen],'\0',1);
            Put_File(name);
            }
         }
      }
   closedir(cwd);
   }
return 1;
}
 
/**
  * (Function) Not_Connected
  * set the not connected flag in panel group
  * @parms
  *     Application Handle
  * returns 1 success
  */
 
int Not_Connected(char *ApplHandle) {
int optzero = 0;                            // Option set
char connected = 'N';                       // flag
EC_t Error_Code = {0};                      // err struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
QUIPUTV(ApplHandle,
        &connected,
        sizeof(connected),
        "CONNFLAG  ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available)  {
   snd_error_msg(Error_Code);
   return -1;
   }
QUIPUTV(ApplHandle,
        &optzero,
        sizeof(int),
        "OPTCLR2   ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
init_panel(ApplHandle);
return 1;
}
 
/**
  * (Function) Set_Dir
  * Set the directory variable in panel group
  * @parms
  *     Application Handle
  *     Panel Name
  * returns 1 success
  */
 
int Set_Dir(char *ApplHandle, char *PanelName) {
int i = 0;                                  // counter
int path_len = 0;                           // counter
int functionRequested,
*funcReq = &functionRequested;              // ptr
char msg_dta[MAX_MSG];                      // msg buf
path_rec_t pathrec;                         // path struct
newpath_rec_t newrec;                       // path struct
EC_t Error_Code = {0};                      // err struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
memset(&newrec,'\0',sizeof(newrec));
memcpy(newrec.lclpath,"*SAME",5);
memcpy(newrec.rmtpath,"*SAME",5);
QUIPUTV(ApplHandle,
        &newrec,
        sizeof(newrec),
        "NPATHREC  ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
QUIDSPP(ApplHandle,
        funcReq,
        "SETDIRP   ",
        REDISPLAY_NO,
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
if(*funcReq == 500) {
   QUIGETV(ApplHandle,
           &newrec,
           sizeof(newrec),
           "NPATHREC  ",
           &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      return -1;
      }
   if(memcmp(newrec.lclpath,"*SAME",5) != 0) {
      for(i = MAX_PATH; i > 0; i--) {
         newrec.lclpath[i] = (newrec.lclpath[i] == ' ') ? '\0' : newrec.lclpath[i];
         if(newrec.lclpath[i-1] != ' ')
            break;
         }
      path_len = strlen(newrec.lclpath);
      if(memcmp(newrec.lclpath,"/qsys.lib",9) == 0) {
         for(i = 0; i > path_len; i++) {
            toupper(newrec.lclpath[i]);
            }
         }
      if(memcmp(PanelName,"CWD       ",10) == 0) {
         QUIDLTL(ApplHandle,
                "CWDLST    ",
                &Error_Code);
         if((Error_Code.EC.Bytes_Available) &&
            (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
            snd_error_msg(Error_Code);
            return -1;
            }
         Load_Cwd(ApplHandle,newrec.lclpath);
         }
      else  {
         memset(&pathrec,'\0',sizeof(pathrec));
         if(path_len > SHORT_PATH) {
            memcpy(pathrec.path,newrec.lclpath,SHORT_PATH);
            memset(&pathrec.path[SHORT_PATH - 1],'~',1);
            }
         else
            memcpy(pathrec.path,newrec.lclpath,path_len);
         memcpy(pathrec.lpath,newrec.lclpath,path_len);
         QUIPUTV(ApplHandle,
                 &pathrec,
                 sizeof(pathrec),
                 "PATHREC   ",
                 &Error_Code);
         if(Error_Code.EC.Bytes_Available) {
            snd_error_msg(Error_Code);
            return -1;
            }
         }
      }
   if(memcmp(newrec.rmtpath,"*SAME",5) != 0) {
      for(i = MAX_PATH; i > 0; i--) {
         newrec.rmtpath[i] = (newrec.rmtpath[i] == ' ') ? '\0' : newrec.rmtpath[i];
         if(newrec.rmtpath[i-1] != ' ')
            break;
         }
      path_len = strlen(newrec.rmtpath);
      if(memcmp(newrec.rmtpath,"/qsys.lib",9) == 0) {
         for(i = 0; i > path_len; i++) {
            toupper(newrec.rmtpath[i]);
            }
         }
      memset(&pathrec,'\0',sizeof(pathrec));
      if(path_len > SHORT_PATH) {
         memcpy(pathrec.path,newrec.rmtpath,SHORT_PATH);
         memset(&pathrec.path[SHORT_PATH - 1],'~',1);
         }
      else
         memcpy(pathrec.path,newrec.rmtpath,path_len);
      memcpy(pathrec.lpath,newrec.rmtpath,path_len);
      QUIPUTV(ApplHandle,
              &pathrec,
              sizeof(pathrec),
              "RPATHREC  ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available) {
         snd_error_msg(Error_Code);
         return -1;
         }
      if(memcmp(PanelName,"CWD       ",10) == 0) {
         QUIDLTL(ApplHandle,
                "CWDLST    ",
                &Error_Code);
         if((Error_Code.EC.Bytes_Available) && (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
            snd_error_msg(Error_Code);
            return -1;
            }
         Get_Rmt_Cwd(ApplHandle,newrec.rmtpath);
         }
      }
   }
return 1;
}
 
 
/**
  * (Function) Get_Lcl_Det
  * Display local object details
  * @parms
  *     Application Handle
  *     Object name
  * returns 1 success
  */
 
int Get_Lcl_Det(char *ApplHandle, char *name) {
struct Det_Buf_x{
       char atr[10];
       char links[5];
       char owner[MAX_USERID];
       char grpid[5];
       char size[20];
       char cdate[13];
       char name[SHORT_NAME];
       }det_buf;                            // dsp buffer
int i = 0;                                  // counter
char time[26];                              // time buf
char tmp[5];                                // tmp buf
char tmp_2[20];                             // tmp buf
char conv_size[48];                         // buffer
char msg_dta[MAX_MSG];                      // msg buf
char *ptr;                                  // ptr
struct passwd pwd;                          // struct
struct passwd *pd;                          // struct ptr
struct stat info;                           // stat struct
EC_t Error_Code = {0};                      // err struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
ptr = strstr(name,".SAVF");
if(ptr != NULL) {
   strcpy(ptr,".FILE");
   }
memset(&det_buf,' ',sizeof(det_buf));
if(stat(name,&info) != 0) {
   sprintf(msg_dta,"stat() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
if((pd = getpwuid(info.st_uid)) == NULL) {
   sprintf(msg_dta,"getpwuid() error %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
else
   strcpy(det_buf.owner,pd->pw_name);
if(S_ISDIR(info.st_mode))
   det_buf.atr[0] = 'd';
else if(S_ISLNK(info.st_mode))
   det_buf.atr[0] = 'l';
else
   det_buf.atr[0] = '-';
if(info.st_mode & S_IRUSR)
   det_buf.atr[1] = 'r';
else
   det_buf.atr[1] = '-';
if(info.st_mode & S_IWUSR)
   det_buf.atr[2] = 'w';
else
   det_buf.atr[2] = '-';
if(info.st_mode & S_IXUSR)
   det_buf.atr[3] = 'x';
else
   det_buf.atr[3] = '-';
if(info.st_mode & S_IRGRP)
   det_buf.atr[4] = 'r';
else
   det_buf.atr[4] = '-';
if(info.st_mode & S_IWGRP)
   det_buf.atr[5] = 'w';
else
   det_buf.atr[5] = '-';
if(info.st_mode & S_IXGRP)
   det_buf.atr[6] = 'x';
else
   det_buf.atr[6] = '-';
if(info.st_mode & S_IROTH)
   det_buf.atr[7] = 'r';
else
   det_buf.atr[7] = '-';
if(info.st_mode & S_IWOTH)
   det_buf.atr[8] = 'w';
else
   det_buf.atr[8] = '-';
if(info.st_mode & S_IXOTH)
   det_buf.atr[9] = 'x';
else
   det_buf.atr[9] = '-';
sprintf(det_buf.links,"%d",info.st_nlink);
sprintf(det_buf.grpid,"%d",info.st_gid);
sprintf(conv_size,"%.0f",(double)info.st_size);
convert_size(conv_size);
strcpy(det_buf.size,conv_size);
/* create the date */
strftime(det_buf.cdate,sizeof(det_buf.cdate),"%b %d %Y",gmtime(&info.st_ctime));
/*
memcpy(det_buf.cdate,ptr = asctime(gmtime(&info.st_ctime)),13); */
if(strlen(name) >= SHORT_NAME) {
   memcpy(det_buf.name,name,SHORT_NAME);
   memset(&det_buf.name[SHORT_NAME-1],'~',1);
   }
else
   memcpy(det_buf.name,name,strlen(name));
QUIPUTV(ApplHandle,
       &det_buf,
       sizeof(det_buf),
       "OBJINF    ",
       &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
return 1;
}
 
/**
  * (Function) check_qsys
  * check if library based request
  * @parms
  *     Application handle
  *     request type
  * returns 1 if qsyslib based
  */
 
int check_qsys(char *ApplHandle,int req_type) {
char varrcd[10];                            // rec buf
path_rec_t pathrec;                         // path struct
EC_t Error_Code = {0};                      // error struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
if(req_type == _LOCAL)
   memcpy(varrcd,"PATHREC   ",10);
else
   memcpy(varrcd,"RPATHREC  ",10);
QUIGETV(ApplHandle,
        &pathrec,
        sizeof(pathrec),
        varrcd,
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
if(memcmp(pathrec.lpath,"/QSYS.LIB",9) == 0)
   return 1;
return 0;
}
 
