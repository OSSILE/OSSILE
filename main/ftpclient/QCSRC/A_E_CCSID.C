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
 
#include "A_E_CCSID.h"
 
/**
  * (function) convert ASCII to EBCDIC with number passed
  * Convert a number of characters to EBCIDIC from ASCII
  * @parms
  *     Character string
  *     Number of characters to convert
  * returns 1 on success or -1 on failure
  */
 
int AtoE_CCSID(char *instr, char *outstr, int num,iconv_t table) {
char msg_dta[MAX_MSG];
size_t ret_iconv;
size_t insz;
size_t outsz;
 
 
insz = num;
outsz = BUF_SIZE;
 
ret_iconv = iconv(table,
                  &instr,
                  &insz,
                  &outstr,
                  &outsz);
if(ret_iconv != 0) {
   sprintf(msg_dta,"iconv failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
return 1;
}
 
/**
  * (function) convert EBCDIC to ASCII with number passed
  * Convert a number of characters to ASCII from EBCDIC
  * @parms
  *     Character string
  *     Number of characters to convert
  * returns 1 on success or -1 on failure
  */
 
int EtoA_CCSID(char *instr, char *outstr, int num,iconv_t table) {
char msg_dta[MAX_MSG];
size_t ret_iconv;
size_t insz;
size_t outsz;
 
 
insz = num;
outsz = BUF_SIZE;
ret_iconv = iconv(table,
                  &instr,
                  &insz,
                  &outstr,
                  &outsz);
if(ret_iconv != 0) {
   sprintf(msg_dta,"iconv failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
return 1;
}
 
/**
  * (Function) Get_table
  * Get the table to convert input to ASCII
  * @parms
  *     int toCCSID
  *     int fromCCSID
  *     iconv_t table
  */
 
iconv_t Get_CCSID_table(int toCCSID, int fromCCSID) {
char msg_dta[MAX_MSG];                      /* message buf */
QtqCode_T toCode   =    {0,0,0,0,0,0};      /* PC ASCII to struct */
QtqCode_T fromCode = {0,0,0,0,0,0};         /* CCSID of the job */
 
toCode.CCSID = toCCSID;
fromCode.CCSID = fromCCSID;
 
return QtqIconvOpen(&toCode,&fromCode);
}
