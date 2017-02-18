     /**
      * \brief Linked List : Unit Test
      *
      * \author Mihael Schmidt
      * \date   19.02.2011
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
      

     H nomain


      *-------------------------------------------------------------------------
      * Prototypes
      *-------------------------------------------------------------------------
     D getIntegerList  PR              *
     D   numberElements...
     D                               10I 0 const
      *
     D iterateList     PR
     D   list                          *   const
      *
     D test_create...
     D                 PR
     D test_sublist...
     D                 PR
     D test_size...
     D                 PR
     D test_merge...
     D                 PR
     D test_merge_no_skip...
     D                 PR
     D test_merge_skip...
     D                 PR
     D test_foreach...
     D                 PR
      *      
     D local_foreach   PR                  extproc('local_foreach')
     D   entryValue                    *   const
      *
     D local_foreach_with_userdata...
     D                 PR                  extproc('local_foreach_with_-
     D                                     userdata')
     D   entryValue                    *   const
     D   userdata                      *   const

      /copy RPGUNIT1,TESTCASE
      /copy 'llist_h.rpgle'


      *-------------------------------------------------------------------------
      * Globals
      *-------------------------------------------------------------------------
     D foreachSum      S             10I 0



     P test_create...
     P                 B                   export
      *
     D list            S               *
      /free
       list = list_create();
       assert(list <> *null : 'Newly created list object mustn''t be null.');


       list_dispose(list);

      /end-free
     P                 E


     P test_size...
     P                 B                   export
      *
     D list            S               *
      /free
       list = list_create();

       iEqual(0 : list_size(list));

       list_addInteger(list : 358);
       iEqual(1 : list_size(list));
       list_addInteger(list : 100);
       iEqual(2 : list_size(list));
       list_addInteger(list : 200);
       iEqual(3 : list_size(list));

       list_removeFirst(list);
       iEqual(2 : list_size(list));
       list_removeLast(list);
       iEqual(1 : list_size(list));

       list_clear(list);
       iEqual(0 : list_size(list));

       list_dispose(list);
      /end-free
     P                 E


     P test_sublist...
     P                 B                   export
      *
     D list            S               *
     D sublist         S               *
      /free
       list = getIntegerList(5);

       sublist = list_sublist(list : 2);
       iEqual(3 : list_size(sublist));
       iEqual(list_getInteger(list : 2) : list_getInteger(sublist : 0));
       iEqual(list_getInteger(list : 3) : list_getInteger(sublist : 1));
       iEqual(list_getInteger(list : 4) : list_getInteger(sublist : 2));
       list_dispose(sublist);

       sublist = list_sublist(list : 2 : 2);
       iEqual(2 : list_size(sublist));
       iEqual(list_getInteger(list : 2) : list_getInteger(sublist : 0));
       iEqual(list_getInteger(list : 3) : list_getInteger(sublist : 1));
       list_dispose(sublist);

       sublist = list_sublist(list : 3 : 5);
       iEqual(2 : list_size(sublist));
       iEqual(list_getInteger(list : 3) : list_getInteger(sublist : 0));
       iEqual(list_getInteger(list : 4) : list_getInteger(sublist : 1));
       list_dispose(sublist);

       list_dispose(list);
       list_dispose(sublist);
      /end-free
     P                 E


     P test_merge      B                   export
      *
     D list            S               *
     D list2           S               *
      /free
       list = getIntegerList(3);
       list2 = getIntegerList(5);
       
       list_merge(list : list2);
       iEqual(8 : list_size(list));
       list_dispose(list);
       
       list = list_create();
       list_addInteger(list : 1);
       list_addInteger(list : 2);
       list_merge(list : list2);
       iEqual(7 : list_size(list));
       iEqual(1 : list_getInteger(list : 0));
       iEqual(2 : list_getInteger(list : 1));
       iEqual(15 : list_getInteger(list : 2));
       iEqual(30 : list_getInteger(list : 3));
       iEqual(45 : list_getInteger(list : 4));
       iEqual(60 : list_getInteger(list : 5));
       iEqual(75 : list_getInteger(list : 6));
       
       list_dispose(list);
       list_dispose(list2);
      /end-free
     P                 E
 
     P test_merge_no_skip...
     P                 B                   export
      *
     D list            S               *
     D list2           S               *
      /free
       list = getIntegerList(3);
       list2 = getIntegerList(5);
       
       list_merge(list : list2 : *off);
       iEqual(8 : list_size(list));
       list_dispose(list);
       
       list = list_create();
       list_addInteger(list : 1);
       list_addInteger(list : 2);
       list_merge(list : list2 : *off);
       iEqual(7 : list_size(list));
       iEqual(1 : list_getInteger(list : 0));
       iEqual(2 : list_getInteger(list : 1));
       iEqual(15 : list_getInteger(list : 2));
       iEqual(30 : list_getInteger(list : 3));
       iEqual(45 : list_getInteger(list : 4));
       iEqual(60 : list_getInteger(list : 5));
       iEqual(75 : list_getInteger(list : 6));
       
       list_dispose(list);
       list_dispose(list2);
      /end-free
     P                 E


     P test_merge_skip...
     P                 B                   export
      *
     D list            S               *
     D list2           S               *
      /free
       list = getIntegerList(3);
       list2 = getIntegerList(5);
       
       list_merge(list : list2 : *on);
       iEqual(5 : list_size(list));
       list_dispose(list);
       
       list = list_create();
       list_addInteger(list : 1);
       list_addInteger(list : 2);
       list_merge(list : list2 : *on);
       iEqual(7 : list_size(list));
       iEqual(1 : list_getInteger(list : 0));
       iEqual(2 : list_getInteger(list : 1));
       iEqual(15 : list_getInteger(list : 2));
       iEqual(30 : list_getInteger(list : 3));
       iEqual(45 : list_getInteger(list : 4));
       iEqual(60 : list_getInteger(list : 5));
       iEqual(75 : list_getInteger(list : 6));
       
       list_dispose(list);
       list_dispose(list2);
      /end-free
     P                 E

     
     P test_foreach...
     P                 B                   export
      *
     D list            S               *
      /free
       list = getIntegerList(3);
       
       clear foreachSum;
       list_foreach(list : %paddr('local_foreach'));
       iEqual(90 : foreachSum);
       
       clear foreachSum;
       list_foreach(list : %paddr('local_foreach_with_userdata') : 
                    %addr(foreachSum));
       iEqual(90 : foreachSum);
       
       list_dispose(list);
      /end-free
     P                 E


     P getIntegerList  B
     D                 PI              *
     D   numberElements...
     D                               10I 0 const
      *
     D list            S               *
     D i               S             10I 0
      /free
       list = list_create();

       for i = 1 to numberElements;
         list_addInteger(list : i * 15);
       endfor;

       return list;
      /end-free
     P                 E


     P iterateList     B
     D                 PI
     D   list                          *   const
      *
     D i               S             10I 0 based(ptr)
      /free
       ptr = list_iterate(list);
       dow (ptr <> *null);
         dsply %char(i);
         ptr = list_iterate(list);
       enddo;
      /end-free
     P                 E

     
     P local_foreach   B
     D                 PI
     D   entryValue                    *   const
      *
     D value           S             10I 0 based(entryValue)
      /free
       foreachSum += value;
      /end-free
     P                 E
     
     
     P local_foreach_with_userdata...
     P                 B
     D                 PI           
     D   entryValue                    *   const
     D   userdata                      *   const
      *
     D value           S             10I 0 based(entryValue) 
     D sum             S             10I 0 based(userdata)
      /free
       sum += value;
      /end-free
     P                 E
    