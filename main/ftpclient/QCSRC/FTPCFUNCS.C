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
 
#include <qusptrus.h>
#include <H/FTPCFUNCS>
#pragma comment(copyright,_CPYRGHT)
 
/**
  * (Function) cmd_check
  * Error trapping function for Command checking API
  * @parms
  *     Exception structure
  * returns NULL
  */
 
static void cmd_check(_INTRPT_Hndlr_Parms_T *excp_info) {
int *count = (int *)(excp_info->Com_Area);
char MsgFs[2][20] = {"*REQUESTER          ",
                     "FTPCMSGQ  *LIBL     "};
char Msg_File[20] = "FTPCMSGF  *LIBL     "; // msg file
char Msg_Type[10] = "*INFO     ";           // msg type
char Call_Stack[10] = {"*EXT      "};       // call stack entry
char QRpy_Q[20] = {' '};                    // reply queue
char Msg_Key[4] = {' '};                    // msg key
char msg_dta[255];                          // message data
Rcv_Msg_t rtv_dta;                          // message struct
EC_t Error_Code = {0};                      // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
 
QMHRCVPM(&rtv_dta,
         sizeof(rtv_dta),
         "RCVM0100",
         "*         ",
         0,
         "*ANY      ",
         (char *) (&(excp_info->Msg_Ref_Key)),
         0,
         "*SAME     ",
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   sprintf(msg_dta,"Failed to retrieve message data");
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   return;
   }
if((memcmp(excp_info->Msg_Id,"CPF0005",7) == 0) ||
   (memcmp(excp_info->Msg_Id,"CPF2103",7) == 0) ||
   (memcmp(excp_info->Msg_Id,"CPF2112",7) == 0)) {
   *count = 0;
   }
else if(memcmp(excp_info->Msg_Id,"CPF6801",7) == 0) {
   *count = 2;
   }
else {
   *count = 1;
   }
if(*count == 1)  {
   QMHSNDM(excp_info->Msg_Id,
           "QCPFMSG   *LIBL     ",
           rtv_dta.msg_data,
           rtv_dta.msg_struct.Data_Returned,
           Msg_Type,
           MsgFs,
           2,
           QRpy_Q,
           Msg_Key,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      Error_Code.EC.Bytes_Available = 0;
      }
   QMHSNDPM(excp_info->Msg_Id,
            "QCPFMSG   *LIBL     ",
            rtv_dta.msg_data,
           rtv_dta.msg_struct.Data_Returned,
            "*STATUS   ",
            "*EXT      ",
            0,
            "    ",
            &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      Error_Code.EC.Bytes_Available = 0;
      }
   }
QMHCHGEM(&(excp_info->Target), 0,
         (char *) (&(excp_info->Msg_Ref_Key)),
         "*HANDLE   ","",0,&Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
return;
}
 
/**
 * (Function) Issue_Cmd
 * @parms
 *      Command string
 * returns 1 on success or returned value
 */
 
int Issue_Cmd(char *cmd_str) {
volatile int e_count = 0;                   // error flag
char msg_dta[50];                           // msg buffer
char reply;                                 // reply
 
#pragma exception_handler(cmd_check,e_count,0,_C2_ALL,_CTLA_HANDLE)
e_count = 0;
QCMDEXC(cmd_str,strlen(cmd_str));
#pragma disable_handler
if(e_count == 2) {
   return 2;
   }
if(e_count == 1) {
   snd_msg("GEN0001","QCMDEXC Caught exception.",25);
   return -1;
   }
return 1;
}
 
/**
  * (Function) compare
  * return largest string
  * @parm
  *     string 1
  *     string 2
  * returns largest string
  */
 
int compare(const void *arg1, const void *arg2) {
   return(strcmp((char *)arg1, (char *)arg2));
}
 
/**
  * (Function) Check_Lib_List
  * Check if install library in users library list
  * @parms
  *     install lib
  * returns 1 success yes 0 no
  */
 
int Check_Lib_List(char *instlib) {
int j = 0;
int JobInf_Len = 1024;                      // Buffer len
char JFmt[8] = "JOBI0750";                  // Job Inf Fmt
char QJobDets[26] = "*                         "; // Use Current
char msg_dta[255];                          // msg buf
char IntJobId[16] = "                ";     // buffer
char Buffer[1024];                          // buffer
char *ptr;                                  // ptr
Lib_Info_t *Libptr;                         // lib info ptr
Qwc_JOBI0750_t *LiblDets;                   // Job Inf Struct
EC_t Error_Code = {0};                      // Error struct
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
 
QUSRJOBI(Buffer,
         JobInf_Len,
         JFmt,
         QJobDets,
         IntJobId,
         &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
LiblDets = (Qwc_JOBI0750_t *)Buffer;
if(LiblDets->Number_User_Libs > 0) {
   ptr = Buffer + LiblDets->Offset_User_Libs;
   Libptr = (Lib_Info_t *)ptr;
   for(j = 0; j < LiblDets->Number_User_Libs; j++) {
      if(memcmp(Libptr->Lib_Name,instlib,10) == 0)
         return 1;
      Libptr++;
      }
   }
return 0;
}
