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
/*===================================================================*/
/*  COMMAND name :  CRTMD5                                           */
/*  Author name..:  Chris Hird                                       */
/*  Date created :  Dec 2008                                         */
/*                                                                   */
/*                                                                   */
/*  Purpose......:  Create MD5 values for member & file data         */
/*  CPP..........:  CRTMD5                                           */
/*  Revision log.:                                                   */
/*  Date     Author    Revision                                      */
/*                                                                   */
/*===================================================================*/

             CMD        PROMPT('Create a CRC for File data')

             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('File Name')
             PARM       KWD(CRCLVL) TYPE(*CHAR) LEN(5) RSTD(*YES) DFT(*MBR) SPCVAL((*FILE *FILE) (*MBR *MBR)) +
                          PROMPT('Level of CRC generation')
             PARM       KWD(CRYPT) TYPE(*INT2) RSTD(*YES) DFT(*MD5) SPCVAL((*MD5 1) (*SHA1 2) (*SHA256 3) (*SHA384 4) +
                          (*SHA512 5)) PROMPT('Hash key type')
             PARM       KWD(BUFSIZ) TYPE(*INT4) RSTD(*YES) DFT(32K) SPCVAL((32K 32768) (64K 65536) (1MB 1048576) (4MB +
                          4194304) (16MB 16711568)) PROMPT('Buffer size to use')

 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) SPCVAL((*LIBL)) PROMPT('Library name:')
             QUAL       TYPE(*NAME) LEN(10)    DFT(*ALL) SPCVAL((*ALL)) PROMPT('Member')
