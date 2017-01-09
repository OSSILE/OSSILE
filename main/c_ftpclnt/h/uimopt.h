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

#ifndef uimopt_h
   #define uimopt_h
        /* include files for UIM */
        #include <euiafex.h>                        /* app formatted data exit pgm */
        #include <euialcl.h>                        /* Act Lst Opt/Pull down  call */
        #include <euialex.h>                        /* actListOpt/Pulldown Field */
        #include <euicsex.h>                        /* Cursor sensitive prompt epgm */
        #include <euifkcl.h>                        /* Function Key call exit pgm */
        #include <euigpex.h>                        /* General Panel Exit Pgm */
        #include <euiilex.h>                        /* Incomplete list processing */
        #include <euimicl.h>                        /* Menu Item Exit Program */
        #include <euitaex.h>                        /* Text Area Data exit program */
        #include <quiaddle.h>                       /* Add List Entry */
        #include <quigetlm.h>                       /* Get List Entries Mult */
        #include <quigetle.h>                       /* Get List entry */
        #include <quiupdle.h>                       /* Upadte List Entry */
        #include <quirmvle.h>                       /* Remove List Entry */
        #include <quidltl.h>                        /* Delete List */
        #include <quiputv.h>                        /* Put Variable */
        #include <quigetv.h>                        /* Get Dialogue Variable */
        #include <quiaddpw.h>                       /* Add Pop up Window */
        #include <quirmvpw.h>                       /* Remove Pop up Window */
        #include <quiopnda.h>                       /* Open Display Application */
        #include <quidspp.h>                        /* Display panel */
        #include <quicloa.h>                        /* Close Application */
        #include <quiaddpa.h>                       /* Add print Application */
        #include <quiprtp.h>                        /* Print panel */
        #include <quirmvpa.h>                       /* Remove Print Application */


        /* global structs */
        Qui_AFX_t  UiExitApplFormat;
        Qui_ALC_t  UiCallListOpt;
        Qui_ALX_t  UiExitListOpt;
        Qui_CSX_t  UiExitCursorPrompt;
        Qui_FKC_t  UiCallFuncKey;
        Qui_GPX_t  UiExitGeneral;
        Qui_ILX_t  UiExitIcnList;
        Qui_MIC_t  UiCallMenuOpt;
        Qui_TAX_t  UiExitTxtDta;

        /* common defines */
        #define EXITPROG        "EXITPROG  "
        #define SAME            "SAME"
        #define HELPFULL_NO     "NO"
        #define CLOSEOPT_NORMAL "M"
        #define REDISPLAY_NO    "N"
        #define REDISPLAY_YES   "Y"
        #define EXTEND_NO       "N"
        #define APPSCOPE_CALLER -1
        #define EXITPARM_STR    0
        #define EXITPROG_BUFLEN 20
        #define MAX_LIST 200
#endif

