/* This file is part of MD5 CRC tool for IBM i                                   */
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

#ifndef md5_h
   #define md5_h
        #include <qc3calha.h>                       // Hash Create
        #include <qusec.h>                          // Error Code Structs
        #include <recio.h>                          // record IO
        #include <string.h>                         // strings etc
        #include <stdlib.h>                         // standard Library
        #include <quslmbr.h>                        // list file members
        #include <qusrmbrd.h>                       // list member desc
        #include <qusgen.h>                         // Usrspc Gen structs
        #include <quscrtus.h>                       // Crt UsrSpc
        #include <qusptrus.h>                       // Get Ptr UsrSpc
        #include <qusdltus.h>                       // delete UsrSpc
        #include <ledate.h>                         // CEE date functions
        #include <errno.h>                          // errno
        #include <quslrcd.h>                        // get record length
        #include <qc3crtax.h>                       // Create context
        #include <qc3desax.h>                       // destroy context
        #include <qwccvtdt.h>                       // convert data and time

        #define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"

        #define _4MB 4194304

        typedef struct  Mbr_Dets_x {
                        char FileName[10];
                        char FileLib[10];
                        char MbrName[10];
                        } Mbr_Dets_t;

        typedef struct Filerec_x {
                        char TS[8];
                        char FileName[10];
                        char FileLib[10];
                        char MbrName[10];
                        char CrcVal[128];
                        } Filerec_t;

        typedef struct EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[48];
                        } EC_t;

        #define _ERR_REC sizeof(struct EC_x);
        #endif

