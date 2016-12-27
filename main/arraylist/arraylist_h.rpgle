      /if not defined (ARRAYLIST_H)
      /define ARRAYLIST_H
      
      *------------------------------------------------------------------------------
      *                          The MIT License (MIT)
      *
      * Copyright (c) 2016 Mihael Schmidt
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
      * Prototypen
      *-------------------------------------------------------------------------
     D arraylist_create...
     D                 PR              *   extproc('arraylist_create')
     D   initSize                    10U 0 const options(*nopass)
     D   incSize                     10U 0 const options(*nopass)
      *
     D arraylist_dispose...
     D                 PR                  extproc('arraylist_dispose')
     D   vector                        *
      *
     D arraylist_add...
     D                 PR                  extproc('arraylist_add')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
     D   pos                         10U 0 const options(*nopass)
      *
     D arraylist_addFirst...
     D                 PR                  extproc('arraylist_addFirst')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_addLast...
     D                 PR                  extproc('arraylist_addLast')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_get...
     D                 PR              *   extproc('arraylist_get')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getFirst...
     D                 PR              *   extproc('arraylist_getFirst')
     D   arraylist                     *   const
      *
     D arraylist_getLast...
     D                 PR              *   extproc('arraylist_getLast')
     D   arraylist                     *   const
      *
     D arraylist_isEmpty...
     D                 PR              N   extproc('arraylist_isEmpty')
     D   arraylist                     *   const
      *
     D arraylist_getSize...
     D                 PR            10U 0 extproc('arraylist_getSize')
     D   arraylist                     *   const
      *
     D arraylist_getCapacity...
     D                 PR            10U 0 extproc('arraylist_getCapacity')
     D   arraylist                     *   const
      *
     D arraylist_clear...
     D                 PR                  extproc('arraylist_clear')
     D   arraylist                     *   const
      *
     D arraylist_remove...
     D                 PR                  extproc('arraylist_remove')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_removeFirst...
     D                 PR                  extproc('arraylist_removeFirst')
     D   arraylist                     *   const
      *
     D arraylist_removeLast...
     D                 PR                  extproc('arraylist_removeLast')
     D   arraylist                     *   const
      *
     D arraylist_removeRange...
     D                 PR                  extproc('arraylist_removeRange')
     D   arraylist                     *   const
     D   index                       10U 0 const
     D   count                       10U 0 const
      *
     D arraylist_contains...
     D                 PR              N   extproc('arraylist_contains')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_indexOf...
     D                 PR            10I 0 extproc('arraylist_indexOf')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_lastIndexOf...
     D                 PR            10I 0 extproc('arraylist_lastIndexOf')
     D   arraylist                     *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_frequency...
     D                 PR            10U 0 extproc('arraylist_frequency')
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_replace...
     D                 PR                  extproc('arraylist_replace')
     D   arraylist                     *   const
     D   index                       10U 0 const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D arraylist_copy...
     D                 PR              *   extproc('arraylist_copy')
     D   arraylist                     *   const
      *
     D arraylist_sublist...
     D                 PR              *   extproc('arraylist_sublist')
     D   arraylist                     *   const
     D   startIndex                  10U 0 const
     D   length                      10U 0 const options(*nopass)
      *
     D arraylist_swap...
     D                 PR                  extproc('arraylist_swap')
     D   arraylist                     *   const
     D   itemPos1                    10U 0 const
     D   itemPos2                    10U 0 const
      *
     D arraylist_addAll...
     D                 PR                  extproc('arraylist_addAll')
     D   destArraylist...
     D                                 *   const
     D   sourceArraylist...
     D                                 *   const
      *
     D arraylist_addInteger...
     D                 PR                  extproc('arraylist_addInteger')
     D   arraylist                     *   const
     D   value                       10I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addShort...
     D                 PR                  extproc('arraylist_addShort')
     D   arraylist                     *   const
     D   value                        5I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addLong...
     D                 PR                  extproc('arraylist_addLong')
     D   arraylist                     *   const
     D   value                       20I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addDecimal...
     D                 PR                  extproc('arraylist_addDecimal')
     D   arraylist                     *   const
     D   value                       15P 5 const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addFloat...
     D                 PR                  extproc('arraylist_addFloat')
     D   arraylist                     *   const
     D   value                        4F   const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addDouble...
     D                 PR                  extproc('arraylist_addDouble')
     D   arraylist                     *   const
     D   value                        8F   const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addDate...
     D                 PR                  extproc('arraylist_addDate')
     D   arraylist                     *   const
     D   value                         D   const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addBoolean...
     D                 PR                  extproc('arraylist_addBoolean')
     D   arraylist                     *   const
     D   value                         N   const
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_addString...
     D                 PR                  extproc('arraylist_addString')
     D   arraylist                     *   const
     D   value                    65535A   const varying
     D   index                       10U 0 const options(*nopass)
      *
     D arraylist_getInteger...
     D                 PR            10I 0 extproc('arraylist_getInteger')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getShort...
     D                 PR             5I 0 extproc('arraylist_getShort')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getLong...
     D                 PR            20I 0 extproc('arraylist_getLong')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getDecimal...
     D                 PR            15P 5 extproc('arraylist_getDecimal')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getFloat...
     D                 PR             4F   extproc('arraylist_getFloat')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getDouble...
     D                 PR             8F   extproc('arraylist_getDouble')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getDate...
     D                 PR              D   extproc('arraylist_getDate')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getBoolean...
     D                 PR              N   extproc('arraylist_getBoolean')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_getString...
     D                 PR         65535A   extproc('arraylist_getString')
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D arraylist_foreach...
     D                 PR                  extproc('arraylist_foreach')
     D   arraylist                     *   const
     D   procPtr                       *   const procptr
     D   userData                      *   const
      *
     D arraylist_toCharArray...
     D                 PR                  extproc('arraylist_toCharArray')
     D   arraylist                     *   const
     D   arrayPtr                      *   const
     D   count                       10U 0 const
     D   length                      10U 0 const
      *
     D arraylist_reverse...
     D                 PR                  extproc('arraylist_reverse')
     D   arraylist                     *   const
      *
     D arraylist_split...
     D                 PR              *   extproc('arraylist_split')
     D   string                   65535A   const varying
     D   separator                    1A   const options(*nopass)
      *
     D arraylist_toString...
     D                 PR         65535A   varying extproc('arraylist_toString')
     D   arraylist                     *   const
     D   separator                    1A   const options(*omit : *nopass)
     D   enclosing                  100A   const varying options(*nopass)
     D   enclosingEnd               100A   const varying options(*nopass)

      /endif
      
