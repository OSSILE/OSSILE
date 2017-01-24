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

#ifndef ftpcon_h
   #define ftpcon_h
        #include <H/COMMON>
        #include <quiaddle.h>
        #include <quidltl.h>
        #include <quiputv.h>
        #include <qusrobjd.h>
        #include <signal.h>
        #include <dirent.h>
        #include <recio.h>
        #include <errno.h>
        #include <sys/types.h>
        #include <sys/time.h>
        #include <sys/stat.h>
        #include <ctype.h>
        #include <fcntl.h>
        #include <sys/errno.h>
        #include <sys/ioctl.h>
        #include <sys/socket.h>
        #include <netdb.h>
        #include <unistd.h>
        #include <netinet/in.h>
        #include <signal.h>
        #include <dirent.h>
        #include <recio.h>
        #define INVALID_SOCKET (-1)
        #define DEFAULT_PORT_NUM 21
        #define BUF_SIZE 1024
        #define _SAVREC 528
        #define UC(b) (((int)b)&0xff)

        typedef _Packed struct  dsp_buf_x{
                                char name[SHORT_NAME];
                                char lname[MAX_NAME];
                                char type[10];
                                } dsp_buf_t;

        typedef void Sigfunc(int);

        int  hLstnSocket = INVALID_SOCKET,         /* Listen Socket */
             hCntrlSocket = INVALID_SOCKET,        /* Control Socket */
             hDtaSocket  = INVALID_SOCKET,         /* Data Socket */
             Connected   = 0,                      /* Remote Connected */
             keepalive = 0;                        /* keep alive timer */
        char tMode = 'a';                          /* transfer Mode */

        char cBuffer[BUF_SIZE],
             dBuffer[BUF_SIZE];

        int Connect_Timeo(int, struct sockaddr *, int, int);
        static void connect_alarm(int);
        Sigfunc * Signal(int, Sigfunc *);
        int Crt_Cntrl_Conn(char *,int,char *,char *, char *, char *, int, int),
        End_Cntrl_Conn(char *),
        Get_Listen_Socket(),
        Close_Listen_Socket(),
        Accept_Connection(),
        Go_Back_Rmt(),
        Dsp_Server_Reply(),
        Check_Cntrl_Socket(),
        Get_Rmt_Cwd(char *, char *),
        Get_File(char *),
        Get_Save_File(char *),
        Put_File(char *),
        Del_Rmt_File(char *),
        Get_Rmt_Det(char *, char *),
        Get_Dir_Det(char *, char *),
        Ren_Rmt_Obj(char *, char *),
        Add_Rmt_Dir(char *),
        Rmv_Rmt_Dir(char *),
        Chg_Rmt_Dir(char *),
        convert_size(char *),
        Set_Transfer_Type(),
        Get_Host_Addr(char *,struct sockaddr_in *, int);
#endif

