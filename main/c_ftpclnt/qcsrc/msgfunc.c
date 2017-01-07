/* This file is part of FTP Client for IBM i.                                    */
/*                                                                               */
/* Copyright (c) 2017 Chris Hird                                                 */
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
/* Disclaimer :                                                                  */
/* FTP Client for IBM i is distributed in the hope that it will be useful,       */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of                */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                          */

#include <qmhsndm.h>                        /* send message */
#include <qmhsndpm.h>                       /* Send Program Message */
#include "msgfunc.h"

/**
  *(function) snd_msg
  * Send a message to the message queue
  * @parms
  *     Mesage ID
  *     Message data
  *     Data Len
  * returns nothing
  */

void snd_msg(char * MsgID,char * Msg_Data,int Msg_Dta_Len) {
char MsgQ[20] = "FTPCMSGQ  *LIBL     ";     // msg queues
char Msg_File[20] = "FTPCMSGF  *LIBL     "; // msg file
char Msg_Type[10] = "*INFO     ";           // msg type
char Call_Stack[10] = {"*EXT      "};       // call stack entry
char QRpy_Q[20] = {' '};                    // reply queue
char Msg_Key[4] = {' '};                    // msg key
EC_t Error_Code = {0};                      // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

QMHSNDM(MsgID,
        Msg_File,
        Msg_Data,
        Msg_Dta_Len,
        Msg_Type,
        MsgQ,
        1,
        QRpy_Q,
        Msg_Key,
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
QMHSNDPM(MsgID,
         Msg_File,
         Msg_Data,
         Msg_Dta_Len,
         "*DIAG     ",
         "*         ",
         4,
         Msg_Key,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
return;
}

/**
  *(function) Snd_log_msg
  * Send a message to the log message queue
  * @parms
  *     Message ID
  *     Message data
  *     Data Len
  * returns nothing
  */

void snd_log_msg(char * MsgID,char * Msg_Data,int Msg_Dta_Len) {
char MsgQ[20] = "FTPCLOGQ  QTEMP     ";     // msg queues
char Msg_File[20] = "FTPCMSGF  *LIBL     "; // msg file
char Msg_Type[10] = "*INFO     ";           // msg type
char Call_Stack[10] = {"*EXT      "};       // call stack entry
char QRpy_Q[20] = {' '};                    // reply queue
char Msg_Key[4] = {' '};                    // msg key
EC_t Error_Code = {0};                      // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

QMHSNDM(MsgID,
        Msg_File,
        Msg_Data,
        Msg_Dta_Len,
        Msg_Type,
        MsgQ,
        1,
        QRpy_Q,
        Msg_Key,
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
}

/**
  *(function) snd_error_msg
  * Send an error message to the message queue
  * @parms
  *     Error_Structure
  * returns nothing
  */

void snd_error_msg(EC_t Error_Code) {
char Call_Stack[10] = "*EXT      ";         // call stack entry
char Msg_Key[4];                            // msg key
EC_t E_Code = {0};                          // error code struct

E_Code.EC.Bytes_Provided = sizeof(E_Code);

QMHSNDM(Error_Code.EC.Exception_Id,
        "QCPFMSG   *LIBL     ",
        Error_Code.Exception_Data,
        48,
        "*INFO     ",
        "*REQUESTER          ",
        1,
        "                    ",
        Msg_Key,
        &E_Code);
if(E_Code.EC.Bytes_Available > 0) {
   snd_error_msg(E_Code);
   }
}

/**
  *(function) snd_status_msg
  * Send a status message to the user
  * @parms
  *     Message ID
  *     Message data
  *     Data Len
  * returns nothing
  */

void snd_status_msg(char * Msg_Id, char *Msg_Data, int Msg_Dta_Len) {
char Msg_File[20] = "FTPCMSGF  *LIBL     ";   // msg queue
char Msg_Type[10] = "*STATUS   ";             // msg type
char Call_Stack[10] = {"*EXT      "};         // call stack entry
char QRpy_Q[20] = {' '};                      // reply queue
char Msg_Key[4] = {' '};                      // msg key
EC_t Error_Code = {0};                        // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

QMHSNDPM(Msg_Id,
         Msg_File,
         Msg_Data,
         Msg_Dta_Len,
         Msg_Type,
         Call_Stack,
         0,
         Msg_Key,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
}

/**
  *(function) snd_quit_msg
  * Send a Quit message to caller
  * @parms NONE
  * returns nothing
  */

void snd_quit_msg() {
int  Msg_Dta_Len = 0;
char Msg_Dta[10];
char Msg_Id[7] = "CPF6A02";
char Msg_File[20] = "QCPFMSGF  *LIBL     "; // msg queue
char Msg_Type[10] = "*STATUS   ";           // msg type
char Call_Stack[10] = {"*CALLER   "};       // call stack entry
char QRpy_Q[20] = {' '};                    // reply queue
char Msg_Key[4] = {' '};                    // msg key
EC_t Error_Code = {0};                      // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

QMHSNDPM(Msg_Id,
         Msg_File,
         Msg_Dta,
         Msg_Dta_Len,
         Msg_Type,
         Call_Stack,
         0,
         Msg_Key,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
}

