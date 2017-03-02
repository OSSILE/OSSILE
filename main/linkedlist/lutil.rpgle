     /**
      * \brief Linked List Utilities
      *
      * This module contains several procedures which uses the linked
      * list procedures for storing simple data.
      *
      * \author Mihael Schmidt
      * \date   23.02.2008
      *
      * \rev 15.03.2008 Mihael Schmidt
      *      added procedure lutil_listObjects
      *
      * \rev 18.03.2009 Mihael Schmidt
      *      added procedure lutil_listDatabaseRelations
      */


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


     HNOMAIN


      /if not defined(QUSEC)
      /define QUSEC
      /copy QSYSINC/QRPGLESRC,QUSEC
      /endif


      *------------------------------------------------------------------------
      * Prototypen
      *------------------------------------------------------------------------
      /copy LUTIL_H
      /copy LLIST_H
      /copy OS_API_H
      /copy USRSPC_H
      /copy PARMEVAL_H
      /copy LIBC_H


     /**
      * \brief List file member names
      *
      * All member names of a file are placed into a linked list.
      * This list is returned to the caller. On any error *null is
      * returned.
      *
      * \author Mihael Schmidt
      * \date   23.02.2008
      *
      * \param Library name
      * \param File name
      *
      * \return pointer to list or *null if any error occurs
      */
     P lutil_listFileMembers...
     P                 B                   export
     D                 PI              *
     D   library                     10A   const
     D   filename                    10A   const
      *
     D list            S               *
     D usPtr           S               *
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
     D usName          S             10A
     D usLib           S             10A   inz('QTEMP')
     D dataPtr         S               *
     D usData          S             10A   based(dataPtr)
     D i               S             10I 0
      /free
       monitor;
         reset QUSEC;
         QUSBPRV = 0;

         usName = %subst(%str(tmpnam(*omit)) : 7);

         createUserSpace(usName + usLib : *blank : 4096 : X'00' : '*ALL' :
                         'List Util UserSpace' : '*YES' : QUSEC );

         // change user space attributes to autoextend
         userspace_attr.size = 1;       // 1=attribute will be changed
         userspace_attr.key = 3;        // 3=extensibility attribute
         userspace_attr.dataLength = 1;
         userspace_attr.data = '1';     // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : userspace_attr : QUSEC);

         retrieveUserspacePtr(usName + usLib : usPtr : QUSEC);

         listFileMembers( usName + usLib : 'MBRL0100' : filename + library :
                          '*ALL' : '1' : QUSEC);

         list = list_create();

         // iterate through retrieved members
         for i = 0 to usHeader.nmbrEntries - 1;
           dataPtr = usPtr + usHeader.offsetList + (i * usHeader.entrySize);
           list_add(list : %addr(usData) : %len(%trim(usData)));
         endfor;

         deleteUserspace(usName + usLib : QUSEC);

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;

       endmon;

       return list;
      /end-free
     P                 E

     /**
      * \brief List record format names
      *
      * All record format names of a file are placed into a linked list.
      * This list is returned to the caller. On any error *null is
      * returned.
      *
      * \author Mihael Schmidt
      * \date   25.02.2008
      *
      * \param Library name
      * \param File name
      *
      * \return Pointer to list or *null if any error occured
      */
     P lutil_listRecordFormats...
     P                 B                   export
     D                 PI              *
     D   library                     10A   const
     D   filename                    10A   const
      *
     D list            S               *
     D usPtr           S               *
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
     D usName          S             10A
     D usLib           S             10A   inz('QTEMP')
     D dataPtr         S               *
     D usData          S             10A   based(dataPtr)
     D i               S             10I 0
      /free
       monitor;
         reset QUSEC;
         QUSBPRV = 0;

         usName = %subst(%str(tmpnam(*omit)) : 7);

         createUserSpace(usName + usLib : *blank : 4096 : X'00' : '*ALL' :
                         'List Util UserSpace' : '*YES' : QUSEC );

         // change user space attributes to autoextend
         userspace_attr.size = 1;       // 1=attribute will be changed
         userspace_attr.key = 3;        // 3=extensibility attribute
         userspace_attr.dataLength = 1;
         userspace_attr.data = '1';     // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : userspace_attr : QUSEC);

         retrieveUserspacePtr(usName + usLib : usPtr : QUSEC);

         listRecordFormats( usName + usLib : 'RCDL0100' : filename + library :
                          '1' : QUSEC);

         list = list_create();

         // iterate through retrieved members
         for i = 0 to usHeader.nmbrEntries - 1;
           dataPtr = usPtr + usHeader.offsetList + (i * usHeader.entrySize);
           list_add(list : %addr(usData) : %len(%trim(usData)));
         endfor;

         deleteUserspace(usName + usLib : QUSEC);

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;

       endmon;

       return list;
      /end-free
     P                 E


     /**
      * \brief List objects
      *
      * All object names are placed into a linked list.
      * This list is returned to the caller. On any error *null is
      * returned.
      *
      * <br><br>
      *
      * The entries in the list have the following format:
      * <ul>
      *   <li>10A Library name</li>
      *   <li>10A Object name</li>
      *   <li>10A Object type</li>
      * </ul>
      *
      * <br><br>
      * As this procedure utilizes the QUSLOBJ i5/OS API the parameters
      * here accept the same names and generic names for library, name and
      * object type.
      *
      * \param Library
      * \param Object name (default: *all)
      * \param Object type (default: *all)
      *
      * \return Pointer to list or *null if any error occured
      */
     P lutil_listObjects...
     P                 B                   export
     D                 PI              *
     D   pLibrary                    10A   const
     D   pObject                     10A   const options(*omit : *nopass)
     D   pType                       10A   const options(*nopass)
      *
     D lib             S             10A   inz('*ALL')
     D obj             S             10A   inz('*ALL')
     D type            S             10A   inz('*ALL')
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
     D usName          S             10A
     D usLib           S             10A   inz('QTEMP')
     D usPtr           S               *
      *
     D ptr             S               *
     D i               S             10I 0
     D list            S               *   inz(*null)
      /free
       monitor;
         lib = pLibrary;

         reset QUSEC;
         QUSBPRV = 0;

         usName = %subst(%str(tmpnam(*omit)) : 7);

         if (%parms() >= 2 and %addr(pObject) <> *null);
           obj = pObject;
         endif;

         if (%parms() = 3);
           type = pType;
         endif;

         // userspace erstellen
         createUserspace(usName + usLib : 'DATA' : 4096 : X'00' : '*ALL' :
                       %trimr(usName) + ' UserSpace' : '*YES' : QUSEC);

         userspace_attr.size = 1;   // 1=attribute will be changed
         userspace_attr.key = 3;    // 3=extensibility attribute
         userspace_attr.dataLength = 1;
         userspace_attr.data = '1'; // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : userspace_attr : QUSEC);

         retrieveUserSpacePtr(usName + usLib : usPtr : QUSEC);

         listObjects( usName + usLib : 'OBJL0100' : obj + lib : type : QUSEC );

         list = list_create();

         for i = 0 to usHeader.nmbrEntries - 1;
           ptr = usPtr + usHeader.offsetList + (i * usHeader.entrySize);
           list_add(list : ptr : 30);
         endfor;

         // delete userspace
         deleteUserspace(usName + usLib : QUSEC);

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;
       endmon;

       return list;
      /end-free
     P                 E


     /**
      * \brief List Job Library List
      *
      * All libraries of the library list of the specified job will be added
      * in the order of the library list returned in a linked list.
      *
      * <br><br>
      *
      * The qualified job name consists of the following parts:
      * <ul>
      *   <li>CHAR (10) - Job Name</li>
      *   <li>CHAR (10) - User Name</li>
      *   <li>CHAR (6) - Job Number</li>
      * </ul>
      *
      * <br>
      *
      * If both parameters are passed then the library list of the job with
      * the qualified job name will be retrieved.
      *
      * \author Mihael Schmidt
      * \date   10.04.2008
      *
      * \param Qualified Job Name (optinal, default = current job)
      * \param Internal Job Number (optinal)
      * \param Library parts (see LUTIL_C)
      *
      * \return Pointer to list or *null if any error occured
      */
     P lutil_listJobLibraryList...
     P                 B                   export
     D                 PI              *
     D   qualJobName                 26A   const options(*omit : *nopass)
     D   internalJobNumber...
     D                               16A   const options(*omit : *nopass)
     D   libParts                    10I 0 const options(*nopass)
      *
     D selLibParts     DS                  qualified
     D   system                        N
     D   product                       N
     D   current                       N
     D   user                          N
     D   selParts                     4A   overlay(selLibParts)
      *
     D jobi0700ds      DS                  qualified
     D   bytesReturned...
     D                               10I 0
     D   bytesAvailable...
     D                               10I 0
     D   jobname                     10A
     D   username                    10A
     D   jobnumber                    6A
     D   intJobNumber                16A
     D   jobstatus                   10A
     D   jobtype                      1A
     D   jobsubtype                   1A
     D   reserved                     2A
     D   numberSysLibs...
     D                               10I 0
     D   numberProdLibs...
     D                               10I 0
     D   numberCurrentLibs...
     D                               10I 0
     D   numberUserLibs...
     D                               10I 0
      *
     D offsetSystem    S             10I 0
     D offsetProduct   S             10I 0
     D offsetCurrent   S             10I 0
     D offsetUser      S             10I 0
      *
     D list            S               *
     D receiver        S          65535A
     D libPtr          S               *
     D lib             S             11A   based(libPtr)
     D i               S             10I 0
      /free
       monitor;
         reset QUSEC;
         QUSBPRV = 0;

         if (%parms() = 3);
           selLibParts.selParts = evalParm(libParts);
         else;
           selLibParts.selParts = '1111';
         endif;

         if (%parms() >= 1 and %addr(qualJobName) <> *null);
           retrieveJobInformation(receiver : %len(receiver) : 'JOBI0700' :
               qualJobName : '' : QUSEC);
         elseif (%parms() >= 2 and %addr(internalJobNumber) <> *null);
           retrieveJobInformation(receiver : %len(receiver) : 'JOBI0700' :
               '*INT' : internalJobNumber :QUSEC);
         else;
           retrieveJobInformation(receiver : %len(receiver) : 'JOBI0700' :
               '*' : '' : QUSEC);
         endif;

         jobi0700ds = receiver;

         list = list_create();

         // calculate offsets
         offsetSystem = 80;
         offsetProduct = offsetSystem + jobi0700ds.numberSysLibs * 11;
         offsetCurrent = offsetProduct + jobi0700ds.numberProdLibs * 11;
         offsetUser = offsetCurrent + jobi0700ds.numberCurrentLibs * 11;

         // add system libraries
         if (selLibParts.system);
           libPtr = %addr(receiver) + offsetSystem;
           for i = 0 to jobi0700ds.numberSysLibs - 1;
             list_add(list : libPtr : %len(%trimr(lib)));
             libPtr = libPtr + 11;
           endfor;
         endif;

         // add product libraries
         if (selLibParts.product);
           libPtr = %addr(receiver) + offsetProduct;
           for i = 0 to jobi0700ds.numberProdLibs - 1;
             list_add(list : libPtr : %len(%trimr(lib)));
             libPtr = libPtr + 11;
           endfor;
         endif;

         // add current library
         if (selLibParts.current and jobi0700ds.numberCurrentLibs > 0);
           libPtr = %addr(receiver) + offsetCurrent;
           list_add(list : libPtr : %len(%trimr(lib)));
         endif;

         // add user libraries
         if (selLibParts.user);
           libPtr = %addr(receiver) + offsetUser;
           for i = 0 to jobi0700ds.numberUserLibs - 1;
             list_add(list : libPtr : %len(%trimr(lib)));
             libPtr = libPtr + 11;
           endfor;
         endif;

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;
       endmon;

       return list;
      /end-free
     P                 E


     /**
      * \brief List Active Jobs in Subsystem
      *
      * All active jobs of the specified subsystem will be added to the list.
      * The entries of the list are qualified job names which consist of the
      * following parts:
      * <ul>
      *   <li>CHAR (10) - Job Name</li>
      *   <li>CHAR (10) - User Name</li>
      *   <li>CHAR (6) - Job Number</li>
      * </ul>
      *
      * <br>
      *
      * Subsystem monitor jobs are exluded from the list.
      *
      * \author Mihael Schmidt
      * \date   29.04.2008
      *
      * \param Subsystemdescription library
      * \param Subsystemdescription name
      *
      * \return Pointer to list or *null if any error occured
      *
      * \info The user calling this procedure must have *JOBCTL
      *       authorities else this procedure returns *null.
      */
     P lutil_listActiveSubsystemJobs...
     P                 B                   export
     D                 PI              *
     D  sbsLib                       10A   const options(*nopass)
     D  sbsName                      10A   const options(*nopass)
      *
     D cSbsName        C                   1906
      *
     D list            S               *   inz(*null)
     D usLib           S             10A   inz('QTEMP')
     D usName          S             10A
     D usPtr           S               *
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
     D i               S             10I 0
      *
     D jobPtr          S               *
     D jobDs           DS                  qualified based(jobPtr)
     D   name                        10A
     D   user                        10A
     D   number                       6A
     D   internalId                  16A
     D   status                      10A
     D   type                         1A
     D   subtype                      1A
     D   reserved1                    2A
     D   infoStatus                   1A
     D   reserved2                    3A
     D   fieldsReturned...
     D                               10I 0
     D   keyArray                     1A
      *
     D keyArrPtr       S               *
     D jobKeyArray     DS                  qualified based(keyArrPtr)
     D   bytesReturned...
     D                               10I 0
     D   keyField                    10I 0
     D   dataType                     1A
     D   reserved                     3A
     D   dataLength                  10I 0
     D   data                        20A
      /free
       monitor;
         reset QUSEC;
         QUSBPRV = 0;

         usName = %subst(%str(tmpnam(*omit)) : 7);

         // userspace erstellen
         createUserspace(usName + usLib : 'DATA' : 4096 : X'00' : '*ALL' :
                       %trimr(usName) + ' UserSpace' : '*YES' : QUSEC);

         userspace_attr.size = 1;   // 1=attribute will be changed
         userspace_attr.key = 3;    // 3=extensibility attribute
         userspace_attr.dataLength = 1;
         userspace_attr.data = '1'; // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : userspace_attr : QUSEC);

         retrieveUserSpacePtr(usName + usLib : usPtr : QUSEC);

         listJobs(usName + usLib : 'JOBL0200' : '*ALL      *ALL      *ALL' :
                '*ACTIVE' : QUSEC : '*' : 1 : cSbsName);

         list = list_create();

         for i = 0 to usHeader.nmbrEntries - 1;
           jobPtr = usPtr + usHeader.offsetList + (i * usHeader.entrySize);
           keyArrPtr = %addr(jobDs.keyArray);

           if (jobKeyArray.keyField <> cSbsName or
               jobKeyArray.dataType <> 'C' or
               jobKeyArray.dataLength <> 20);
             // TODO send message to job log
             list_dispose(list);
             list = *null;
             leave;
           endif;

           // only list jobs in requested subsystem
           // and ignore subsystem monitor jobs
           if (jobKeyArray.data = sbsName + sbsLib and
               jobDs.type <> 'M');
             list_add(list : %addr(jobDs) : 26);
           endif;
         endfor;

         // delete userspace
         deleteUserspace(usName + usLib : QUSEC);

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;
       endmon;

       return list;
      /end-free
     P                 E


     /**
      * \brief List database relations
      *
      * All database relations (logical files, views and indices) are added
      * to the list. This list is returned to the caller. On any error *null is
      * returned. If the file does not exist *null is returned. If the file has
      * no relations an empty list is returned.
      *
      * <br><br>
      *
      * The entries in the list have the following format:
      * <ul>
      *   <li>10A File name</li>
      *   <li>10A Library name</li>
      * </ul>
      *
      * \author Mihael Schmidt
      * \date   19.03.2009
      *
      * \param Library name
      * \param File name
      *
      * \return pointer to list or *null if any error occurs
      */
     P lutil_listDatabaseRelations...
     P                 B                   export
     D                 PI              *
     D   library                     10A   const
     D   file                        10A   const
      *
     D usAttr          DS                  likeds(userspace_attr)
     D usLib           S             10A
     D usName          S             10A
     D usPtr           S               *
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
      *
     D localPtr        S               *
     D dblr0100        DS                  qualified based(localPtr)
     D   filename                    10A
     D   library                     10A
     D   depFilename                 10A
     D   depLibrary                  10A
     D   depType                      1A
     D   reserved                     3A
     D   joinRefNumber...
     D                               10I 0
     D   constraintLibraryName...
     D                               10A
     D   constraintNameLength...
     D                               10I 0
     D   constraintName...
     D                              258A
      *
     D i               S             10I 0
     D list            S               *
      /free
       monitor;
         usLib = 'QTEMP';
         usName = %subst(%str(tmpnam(*omit)) : 7);

         reset QUSEC;
         QUSBPRV = 0;

         // creating/modifying userspace
         createUserspace(usName + usLib : 'LUTIL' : 65536 : ' ' : '*ALL' :
                         'LUTIL Userspace' : '*YES' : QUSEC );

         usAttr.size = 1;   // 1=attribute will be changed
         usAttr.key = 3;    // 3=extensibility attribute
         usAttr.dataLength = 1;
         usAttr.data = '1'; // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : usAttr : QUSEC);

         retrieveUserSpacePtr(usName + usLib : usPtr : QUSEC);

         listDatabaseRelations(usName + usLib : 'DBRL0100' : file + library :
                               *blank : *blank : QUSEC);

         list = list_create();

         for i = 0 to usHeader.nmbrEntries - 1;
           localPtr = usPtr + (i * usHeader.entrySize) + usHeader.offsetList;
           if (dblr0100.depFilename = '*NONE');
             // no dependencies
             leave;
           else;
             list_add(list : %addr(dblr0100.depFilename) : 20);
           endif;
         endfor;

         if (usPtr <> *null);
           deleteUserspace(usName + usLib : QUSEC);
         endif;

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
           return *null;
       endmon;

       return list;
      /end-free
     P                 E


     /**
      * \brief List jobs
      *
      * Returns a list of qualified job names which matches the passed parameters.
      *
      * <br><br>
      *
      * The qualified job name consists of the following parts:
      * <ul>
      *   <li>CHAR (10) - Job Name</li>
      *   <li>CHAR (10) - User Name</li>
      *   <li>CHAR (6) - Job Number</li>
      * </ul>
      *
      * <br><br>
      *
      * Valid values for the job status are : *ACTIVE, *JOBQ, *OUTQ, *ALL.
      *
      * \author Mihael Schmidt
      * \date   16.04.2009
      *
      * \param Qualified job name
      * \param Job status (default: *ALL)
      * \param Active job status (optional)
      *
      * \info For valid values for the parameters look at the i5/OS API QUSLJOB
      *       and QUSRJOBI.
      */
     P lutil_listJobs  B                   export
     D                 PI              *
     D   qualJobName                 26A   const
     D   pStatus                     10A   const options(*nopass)
     D   activeStatus                 4A   const options(*nopass)
      *
     D list            S               *
     D usLib           S             10A   inz('QTEMP')
     D usName          S             10A
     D usPtr           S               *
     D usHeader        DS                  likeds(userspace_gen) based(usPtr)
     D i               S             10I 0
     D status          S             10A   inz('*ALL')
      *
     D jobPtr          S               *
     D jobDs           DS                  qualified based(jobPtr)
     D   qualJobName                 26A
     D   name                        10A   overlay(qualJobName)
     D   user                        10A   overlay(qualJobName : *next)
     D   number                       6A   overlay(qualJobName : *next)
     D   internalId                  16A
     D   status                      10A
     D   type                         1A
     D   subtype                      1A
     D   reserved1                    2A
     D   infoStatus                   1A
     D   reserved2                    3A
     D   fieldsReturned...
     D                               10I 0
     D   keyArray                     1A
      *
     D receiver        S           1000A
     D jobi0200ds      DS                   qualified
     D   raw                        226A
     D   activeStatus                 4A    overlay(raw : 108)
      /free
       if (%parms() >= 2);
         status = pStatus;
       endif;

       monitor;
         reset QUSEC;
         QUSBPRV = 0;

         usName = %subst(%str(tmpnam(*omit)) : 7);

         // userspace erstellen
         createUserspace(usName + usLib : 'DATA' : 4096 : X'00' : '*ALL' :
                       %trimr(usName) + ' UserSpace' : '*YES' : QUSEC);

         userspace_attr.size = 1;   // 1=attribute will be changed
         userspace_attr.key = 3;    // 3=extensibility attribute
         userspace_attr.dataLength = 1;
         userspace_attr.data = '1'; // user space is extensible
         changeUserspaceAttr(usLib : usName + usLib : userspace_attr : QUSEC);

         retrieveUserSpacePtr(usName + usLib : usPtr : QUSEC);

         listJobs(usName + usLib : 'JOBL0200' : qualJobName : status : QUSEC);

         list = list_create();

         for i = 0 to usHeader.nmbrEntries - 1;
           jobPtr = usPtr + usHeader.offsetList + (i * usHeader.entrySize);
           if (status = '*ALL' or jobDs.status = status);

             // for active jobs we may have to check for active job status
             if (%parms() = 3);
               retrieveJobInformation(receiver : %len(receiver) : 'JOBI0200' :
                                      jobDs.qualJobName : '' : QUSEC);
               jobi0200ds = receiver;
               if (jobi0200ds.activeStatus = activeStatus);
                 list_add(list : %addr(jobDs.qualJobName) : 26);
               endif;
             else;
               // don't have to check the active status, just add the job to the list
               list_add(list : %addr(jobDs.qualJobName) : 26);
             endif;
           endif;
         endfor;

         on-error *all;
           if (list <> *null);
             list_dispose(list);
           endif;
       endmon;

       return list;
      /end-free
     P                 E
