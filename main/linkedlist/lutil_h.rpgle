      /if not defined(LUTIL_H)
      /define LUTIL_H
      
      *------------------------------------------------------------------------------
      *                          The MIT License (MIT)
      *
      * Copyright (c) 2017 Mihael Schmidt
      *
      * Permission is hereby granted, free of charge, to any person obtaining a copy 
      * of this software and associated documentation files (the "Software"), to deal 
      * in the Software without restriction, including without limitation the rights 
      * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
      * copies of the Software, and to permit persons to whom the Software is 
      * furnished to do so, subject to the following conditions:
      * 
      * The above copyright notice and this permission notice shall be included in 
      * all copies or substantial portions of the Software.
      *
      * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
      * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
      * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
      * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
      * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
      * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
      * SOFTWARE.
      *------------------------------------------------------------------------------


      *-------------------------------------------------------------------------
      * Prototypes for Linked List Utilities
      *-------------------------------------------------------------------------
     D lutil_listFileMembers...
     D                 PR              *   extproc('lutil_listFileMembers')
     D   library                     10A   const
     D   filename                    10A   const
      *
     D lutil_listRecordFormats...
     D                 PR              *   extproc('lutil_listRecordFormats')
     D   library                     10A   const
     D   filename                    10A   const
      *
     D lutil_listObjects...
     D                 PR              *   extproc('lutil_listObjects')
     D   lib                         10A   const
     D   obj                         10A   const options(*omit : *nopass)
     D   type                        10A   const options(*nopass)
      *
     D lutil_listJobLibraryList...
     D                 PR              *   extproc('lutil_listJobLibraryList')
     D   qualJobName                 26A   const options(*omit : *nopass)
     D   internalJobNumber...
     D                               16A   const options(*omit : *nopass)
     D   libParts                    10I 0 const options(*nopass)
      *
     D lutil_listActiveSubsystemJobs...
     D                 PR              *   extproc('lutil_listActiveSubsystemJo-
     D                                     bs')
     D  sbsLib                       10A   const options(*nopass)
     D  sbsName                      10A   const options(*nopass)
      *
     D lutil_listDatabaseRelations...
     D                 PR              *   extproc('lutil_listDatabaseRelations-
     D                                     ')
     D   library                     10A   const
     D   file                        10A   const
      *
     D lutil_listJobs  PR              *   extproc('lutil_listJobs')
     D   qualJobName                 26A   const
     D   status                      10A   const options(*nopass)
     D   activeStatus                 4A   const options(*nopass)


      *-------------------------------------------------------------------------
      * Data structure templates
      *-------------------------------------------------------------------------
     D tmpl_qualifiedJobName...
     D                 DS                  qualified based(nullPointer)
     D   jobName                     10A
     D   userName                    10A
     D   jobNumber                    6A

      /endif
      