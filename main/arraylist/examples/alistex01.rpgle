     /**
      * \brief ArrayList Example : Basics
      *
      * \author Mihael Schmidt
      * \date   30.04.2011
      */

     H dftactgrp(*no) actgrp(*caller)

      *-------------------------------------------------------------------------
      * PEP
      *-------------------------------------------------------------------------
     D main            PR                  extpgm('ALISTEX01')
     D main            PI

      *-------------------------------------------------------------------------
      * Prototypes
      *-------------------------------------------------------------------------
      /include 'arraylist_h.rpgle'


      *-------------------------------------------------------------------------
      * Variables
      *-------------------------------------------------------------------------
     D arraylist       S               *
     D i               S             10I 0
     D dsp             S             50A

      /free
       // create list
       arraylist = arraylist_create();

       // fill list
       arraylist_addString(arraylist : 'Mihael');
       arraylist_addString(arraylist : 'Dieter');
       arraylist_addString(arraylist : 'Thomas');

       // iterate through list
       for i = 0 to arraylist_getSize(arraylist) - 1;
         dsp = arraylist_getString(arraylist : i);
         dsply dsp;
       endfor;

       // clean up
       arraylist_dispose(arraylist);

       *inlr = *on;
      /end-free
