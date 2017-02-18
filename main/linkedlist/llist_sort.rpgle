     /**
      * \brief Linked List : Sorting Algorithms
      *
      *
      * \author Mihael Schmidt
      * \date   2009-02-17
      *
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


     H NOMAIN


      *---------------------------------------------------------------
      * Prototypen
      *---------------------------------------------------------------
      /copy 'llist_h.rpgle'
      /copy 'llist_in_h.rpgle'
      /copy 'ceeapi_h.rpgle'


      *-------------------------------------------------------------------------
      * Procedures
      *-------------------------------------------------------------------------

     /**
      *  \brief Insertion sort
      *
      * The list will be sorted inline.
      *
      * \author Mihael Schmidt
      * \date   2009-02-17
      *
      * \param Pointer to the list
      */
     P list_sort_insertionSort...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D keepRunning     S               N   inz(*on)
     D entryPtr1       S               *
     D entry1          DS                  likeds(tmpl_entry) based(entryPtr1)
     D entryPtr2       S               *
     D entry2          DS                  likeds(tmpl_entry) based(entryPtr2)
     D rc              S             10I 0
     D length          S             10U 0
     D shouldSwap      S               N   inz(*off)
     D top             S               N   inz(*off)
     D bottom          S               N   inz(*off)
      /free
       if (header.size <= 1);
         return;
       endif;

       entryPtr1 = getListEntryDs(listPtr : 0);
       entryPtr2 = getListEntryDs(listPtr : 1);

       dow (keepRunning);
         if (entry1.length < entry2.length);
           length = entry1.length;
         else;
           length = entry2.length;
         endif;

         rc = memcmp(entry1.value : entry2.value : length);
         if (rc > 0);
           shouldSwap = *on;

         elseif (rc = 0 and entry1.length > entry2.length); // check the length of the values
           shouldSwap = *on;

         else;
           // correct order => go down again
           shouldSwap = *off;
         endif;


         if (shouldSwap);
           top = *off;
           bottom = *off;

           internal_swap(listPtr : *omit : *omit : entryPtr1 : entryPtr2);

           //
           // get next entries to check
           //

           // check if we are already at the top
           if (entry2.prev <> *null); // note: entry2 is now above entry1
             // go one up
             entryPtr1 = entry2.prev;
           else;
             // we are at the top, now go down again
             top = *on;

             // skip one entry because we just made the check
             if (entry1.next <> *null);
               entryPtr2 = entry1.next;
             else;
               bottom = *on;
             endif;
           endif;

         else;
           // check next entries
           if (bottom); // need to go up

             if (entry1.prev <> *null);
               entryPtr2 = entryPtr1;
               entryPtr1 = entry2.prev;
             else;
               top = *on;

               // go down
               entryPtr1 = entryPtr2;
               entryPtr2 = entry1.next;
             endif;

           else;        // need to go down

             if (entry2.next <> *null);
               entryPtr1 = entryPtr2;
               entryPtr2 = entry1.next;
             else;
               bottom = *on;

               if (entry1.prev <> *null);
                 // go up again
                 entryPtr2 = entryPtr1;
                 entryPtr1 = entry2.prev;
               else;
                 top = *on;
               endif;

             endif;

           endif;
         endif;


         // if both ends have been visited without change => end loop
         if (top and bottom);
           keepRunning = *off;
         endif;

         // reset things
         shouldSwap = *off;
       enddo;
      /end-free
     P                 E
