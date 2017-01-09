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

#ifndef msgfunc_h
   #define msgfunc_h
        #include <qmhsndm.h>                        /* send message */
        #include <qmhsndpm.h>                       /* Send Program Message */
        #include <qmhrcvm.h>                        /* Receive Message */
        #include "common.h"

        typedef struct Rpy_Msg_x {
               Qmh_Rcvm_RCVM0100_t msg_struct;
               char Msg_Data[20];
               }Rpy_Msg_t;

        void snd_msg(char *,char *,int);
        void snd_log_msg(char *,char *,int);
        void snd_status_msg(char *,char *,int);
        void snd_error_msg(EC_t);
        void snd_quit_msg(void);
#endif

