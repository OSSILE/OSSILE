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
 
#include "uimopt.h"
#include "common.h"
#pragma comment(copyright,_CPYRGHT)
 
#define PNLGRP          "FTP11PG   *LIBL     "
#define ILEPGMLIB       "FTP11P    *LIBL     "
#define EXITPROG        "EXITPROG  "
#define BLANK "          "
 
int main(int argc,char *argv[]) {
_RFILE    *fp;                              // file Ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
CFGREC   CfgRec;                            // File struct
int Record_Count;                           // various integers
int ret = 0;                                // return flag
int Function_Requested,
* Func_Req = &Function_Requested;           // int pointer
char Close_Opt = 'M';                       // close option
char SvrSec;                                // Server Security flag
char CltSec;                                // Client Security flag
char Eject = 'Y';                           // eject page
char Share_ODP = 'N';                       // share open dta path
char applHandle[8];                         // application handle
char varBuffer[130];                        // char buffer
char tmp[2];                                // tmp array
char PrtPnlName[10] = "FTPPRINT  ";         // print panel
char PrtHdr[10] = "HEADER    ";             // print header
char Prt_File[20] = "FTPPRTF   *LIBL     "; // print File
char Alt_Prt_File[10] = "*NONE     ";       // alt print file
char Usr_Data[10] = {' '};                  // user data
char msg_dta[255];                          // message data
EC_t Error_Code = {0};                      // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
// open and read the config file
if((fp =_Ropen("FTPCFG","rr+")) == NULL) {
   snd_msg("F000001","FTPCFG     *LIBL     ",20);
   exit(-1);
   }
fdbk = _Rreadf(fp,&CfgRec,_REC,__DFT);
if(fdbk->num_bytes == EOF) {
   snd_msg("F000002","FTPCFG" ,6);
   // add dummy text and continue
   memcpy(CfgRec.PRDID,"*NONE  FTPCLNT   0100000000000",30);
   CfgRec.KEEPALIVE = 10;
   fdbk = _Rwrite(fp,&CfgRec,_REC);
   if(fdbk->num_bytes != _REC) {
      sprintf(msg_dta,"Failed to add dummy info to CFG file");
      snd_msg("GEN0001",msg_dta,strlen(msg_dta));
      _Rclose(fp);
      exit(-1);
      }
   }
QUIOPNDA(applHandle,
         PNLGRP,
         APPSCOPE_CALLER,
         EXITPARM_STR,
         HELPFULL_NO,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
QUIPUTV(applHandle,
        &CfgRec,
        _REC,
        "CFGINFO   ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
if(memcmp(argv[1],"*     ",6) == 0) {
   QUIDSPP(applHandle,
           Func_Req,
           "FTP11      ",
           REDISPLAY_NO,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   if(*Func_Req == 500) {
      QUIGETV(applHandle,
              &CfgRec,
              _REC,
              "CFGINFO   ",
              &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         snd_error_msg(Error_Code);
         exit(-1);
         }
      fdbk = _Rupdate(fp,&CfgRec,_REC);
      if(fdbk->num_bytes != _REC) {
         snd_msg("F000003","FTPCFG     *LIBL     ",20);
         _Rclose(fp);
         exit(-1);
         }
      }
   }
else {
   QUIADDPA(applHandle,
            Prt_File,
            Alt_Prt_File,
            &Share_ODP,
            Usr_Data,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   QUIPRTP(applHandle,
           PrtHdr,
           &Eject,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   QUIPRTP(applHandle,
           PrtPnlName,
           &Eject,
           &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   QUIRMVPA(applHandle,
            &Close_Opt,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   }
_Rclose(fp);
QUICLOA(applHandle,
        CLOSEOPT_NORMAL,
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
return;
}
 
