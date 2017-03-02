     /**
      * \brief List Jobs Example
      *
      * This example shows how to list all active jobs of the current user
      * which are really "wasting" resources (active status = RUN).
      *
      * \author Mihael Schmidt
      * \date   18.04.2009
      */

     H dftactgrp(*no) actgrp(*caller)


      *-------------------------------------------------------------------------
      * Prototypes
      *-------------------------------------------------------------------------
      /copy LLIST_H
      /copy LUTIL_H


      *-------------------------------------------------------------------------
      * Variables
      *-------------------------------------------------------------------------
     D qualJobName     DS                  likeds(tmpl_qualifiedJobName) inz
     D list            S               *
     D entry           S             26A   based(entryPointer)


      /free
       // list all active jobs of the current user
       qualJobName.jobName = '*ALL';
       qualJobName.userName = '*CURRENT';
       qualJobName.jobNumber = '*ALL';

       list = lutil_listJobs(qualJobName : '*ACTIVE' : 'RUN');

       // check if we have at least one job
       if (not list_isEmpty(list));

         // iterate through the returned jobs.
         // the qualified job name is returned
         entryPointer = list_iterate(list);
         dow (entryPointer <> *null);
           dsply entry;
           entryPointer = list_iterate(list);
         enddo;

       else;
         dsply 'no jobs match the current filter';
       endif;

       // clean up
       list_dispose(list);

       *inlr = *on;
       return;
      /end-free
