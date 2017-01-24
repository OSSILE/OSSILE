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

