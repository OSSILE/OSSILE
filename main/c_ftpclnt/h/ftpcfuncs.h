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

#ifndef ftpcfuncs_h
   #define ftpcfuncs_h
        #include <qmhsndpm.h>                       /* snd pgm msg*/
        #include <qmhsndm.h>                        /* snd msg*/
        #include <qmhchgem.h>                       /* chg Err Msg */
        #include <qcmdexc.h>                        /* QCMDEXC       */
        #include <qcmdchk.h>                        /* QCMDCHK       */
        #include <qmhrcvpm.h>                       /* receive pgm msg */
        #include <qusrjobi.h>                       /* retrieve job info */
        #include "common.h"


        typedef _Packed struct  Rcv_Msg_x {
                        Qmh_Rcvpm_RCVM0100_t msg_struct;
                        char msg_data[2048];
                        }Rcv_Msg_t;

        typedef _Packed struct  IP_x {
                        char ip_addr[16];
                        char notes[51];
                        } IP_t;
        /* Library info strcuture */
        typedef _Packed struct  Lib_Info{
                        char Lib_Name[10];
                        char Lib_Text_Description[50];
                        int  Lib_ASP_Number;
                        char Lib_ASP_Name[10];
                        char Reserved[2];
                        } Lib_Info_t;

        static void cmd_check(_INTRPT_Hndlr_Parms_T *);
        int Issue_Cmd(char *);
        int compare(const void *, const void *);
        int Check_Lib_List(char *);
#endif

