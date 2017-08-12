      /if not defined(LLIST)
      /define LLIST

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
      * Prototypes for Linked List
      *-------------------------------------------------------------------------
     D list_create     PR              *   extproc('list_create')
      *
     D list_dispose    PR                  extproc('list_dispose')
     D   listPtr                       *
      *
     D list_add        PR              N   extproc('list_add')
     D   listPtr                       *   const
     D   ptrValue                      *   const
     D   length                      10U 0 const
     D   pos                         10U 0 const options(*nopass)
      *
     D list_addFirst   PR              N   extproc('list_addFirst')
     D   listPtr                       *
     D   valuePtr                      *   const
     D   length                      10U 0 const
      *
     D list_addLast    PR              N   extproc('list_addLast')
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   length                      10U 0 const
      *
     D list_addAll     PR              N   extproc('list_addAll')
     D   listPtr                       *   const
     D   srcListPtr                    *   const
      *
     D list_remove     PR              N   extproc('list_remove')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_removeFirst...
     D                 PR              N   extproc('list_removeFirst')
     D   listPtr                       *   const
      *
     D list_removeLast...
     D                 PR              N   extproc('list_removeLast')
     D   listPtr                       *   const
      *
     D list_clear      PR              N   extproc('list_clear')
     D   listPtr                       *   const
      *
     D list_isEmpty    PR              N   extproc('list_isEmpty')
     D   listPtr                       *   const
      *
     D list_replace    PR              N   extproc('list_replace')
     D   listPtr                       *   const
     D   ptrValue                      *   const
     D   lengthValue                 10U 0 const
     D   index                       10U 0 const
      *
     D list_get        PR              *   extproc('list_get')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getFirst   PR              *   extproc('list_getFirst')
     D   listPtr                       *   const
      *
     D list_getLast    PR              *   extproc('list_getLast')
     D   listPtr                       *   const
      *
     D list_getNext    PR              *   extproc('list_getNext')
     D   listPtr                       *   const
      *
     D list_iterate    PR              *   extproc('list_iterate')
     D   listPtr                       *   const
      *
     D list_getPrev    PR              *   extproc('list_getPrev')
     D   listPtr                       *   const
      *
     D list_abortIteration...
     D                 PR                  extproc('list_abortIteration')
     D   listPtr                       *   const
      *
     D list_resetIteration...
     D                 PR                  extproc('list_resetIteration')
     D   listPtr                       *   const
      *
     D list_contains   PR              N   extproc('list_contains')
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D list_indexOf    PR            10I 0 extproc('list_indexOf')
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D list_lastIndexOf...
     D                 PR            10I 0 extproc('list_lastIndexOf')
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D list_toCharArray...
     D                 PR                  extproc('list_toCharArray')
     D   listPtr                       *   const
     D   arrayPtr                      *   const
     D   count                       10U 0 const
     D   length                      10U 0 const
      *
     D list_size       PR            10U 0 extproc('list_size')
     D   listPtr                       *   const
      *
     D list_sublist    PR              *   extproc('list_sublist')
     D   listPtr                       *   const
     D   startIndex                  10U 0 const
     D   length                      10U 0 const options(*nopass)
      *
     D list_rotate     PR                  extproc('list_rotate')
     D   listPtr                       *   const
     D   rotatePos                   10I 0 const
      *
     D list_swap       PR              N   extproc('list_swap')
     D   listPtr                       *   const
     D   itemPos1                    10U 0 const
     D   itemPos2                    10U 0 const
      *
     D list_foreach...
     D                 PR                  extproc('list_foreach')
     D   listPtr                       *   const
     D   procPtr                       *   const procptr
     D   userData                      *   const options(*nopass)
      *
     D list_toString   PR         65535A   varying extproc('list_toString')
     D   listPtr                       *   const
     D   separator                    1A   const varying options(*omit:*nopass)
     D   enclosing                  100A   const varying options(*nopass)
     D   enclosingEnd               100A   const varying options(*nopass)
      *
     D list_split      PR              *   extproc('list_split') opdesc
     D   string                   65535A   const options(*varsize)
     D   separator                    1A   const options(*nopass)
      *
     D list_reverse    PR                  extproc('list_reverse')
     D   listPtr                       *   const
      *
     D list_copy       PR              *   extproc('list_copy')
     D   listPtr                       *   const
      *
     D list_frequency...
     D                 PR            10U 0 extproc('list_frequency')
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D list_addString...
     D                 PR              N   extproc('list_addString') opdesc
     D   listPtr                       *   const
     D   value                    65535A   const options(*varsize)
     D   index                       10U 0 const options(*nopass)
      *
     D list_addInteger...
     D                 PR              N   extproc('list_addInteger')
     D   listPtr                       *   const
     D   value                       10I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addLong...
     D                 PR              N   extproc('list_addLong')
     D   listPtr                       *   const
     D   value                       20I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addShort...
     D                 PR              N   extproc('list_addShort')
     D   listPtr                       *   const
     D   value                        5I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addFloat...
     D                 PR              N   extproc('list_addFloat')
     D   listPtr                       *   const
     D   value                        4F   const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addDouble...
     D                 PR              N   extproc('list_addDouble')
     D   listPtr                       *   const
     D   value                        8F   const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addBoolean...
     D                 PR              N   extproc('list_addBoolean')
     D   listPtr                       *   const
     D   value                         N   const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addDecimal...
     D                 PR              N   extproc('list_addDecimal')
     D   listPtr                       *   const
     D   value                       15P 5 const
     D   index                       10U 0 const options(*nopass)
      *
     D list_addDate...
     D                 PR              N   extproc('list_addDate')
     D   listPtr                       *   const
     D   value                         D   const
     D   index                       10U 0 const options(*nopass)
      *
     D list_getString...
     D                 PR         65535A   extproc('list_getString')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getInteger...
     D                 PR            10I 0 extproc('list_getInteger')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getShort...
     D                 PR             5I 0 extproc('list_getShort')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getLong...
     D                 PR            20I 0 extproc('list_getLong')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getFloat...
     D                 PR             4F   extproc('list_getFloat')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getDouble...
     D                 PR             8F   extproc('list_getDouble')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getBoolean...
     D                 PR              N   extproc('list_getBoolean')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getDecimal...
     D                 PR            15P 5 extproc('list_getDecimal')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_getDate...
     D                 PR              D   extproc('list_getDate')
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D list_sort       PR                  extproc('list_sort')
     D   listPtr                       *   const
     D   sortAlgo                      *   const procptr
      *
     D list_removeRange...
     D                 PR                  extproc('list_removeRange')
     D   listPtr                       *   const
     D   index                       10U 0 const
     D   numberElements...
     D                               10U 0 const
      *
     D list_merge...
     D                 PR                  extproc('list_merge')
     D   destList                      *   const
     D   sourceList                    *   const
     D   skipDuplicates...
     D                                 N   const options(*nopass)

      /endif

      /copy 'llist_so_h.rpgle'
