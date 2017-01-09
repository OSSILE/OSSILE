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

#ifndef common_h
   #define common_h
        /* standard include files */
        #include <stdio.h>                          /* Standard I/O  */
        #include <stdlib.h>                         /* Standard library */
        #include <qusec.h>                          /* Error Code   */
        #include <recio.h>                          /* Record level File I/O */
        #include <decimal.h>                        /* Decimal support */
        #include <signal.h>                         /* Signal handler */
        #include <string.h>                         /* String handlers */
        #include <except.h>                         /* exception handling */
        #include <ctype.h>                          /* types header */

        #define _LOCAL 1
        #define _REMOTE 2
        #define BUF_SIZE 1024
        #define MAX_DIR_LEN 55
        #define MAX_MSG 250
        #define MAX_USERID 25
        #define KEY_LEN 16
        #define AES_LEN 16
        #define MAX_SITE 25
        #define MAX_PATH 255
        #define SHORT_PATH 60
        #define SHORT_NAME 60
        #define MAX_NAME 255
        #define PWD_LEN 25
        #define _1KB 1024
        #define _1MB _1KB * 1024
        #define _1GB ((long)_1MB * 1024)
        #define _1TB ((double)_1GB * 1024)
        #define _32K "32768"
        #define _CPYRGHT "Copyright (c) Chris Hird 2016"

        typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[1024];
                        } EC_t;

        #define _ERR_REC sizeof(_Packed struct EC_x)

        #pragma mapinc("sitl","*LIBL/FTPSITE(SITEREC)","both","","","SIT_F")
        #include "sitl"
        typedef SIT_F_SITEREC_both_t SITREC;
        #define _SIT_REC sizeof(SITREC)
        /* config file */
        #pragma mapinc("ftpcfg","*LIBL/FTPCFG(SFWREC)","both","_P","","DATA_F")
        #include "ftpcfg"
        typedef DATA_F_SFWREC_both_t CFGREC;
        #define _REC sizeof(CFGREC)
#endif

