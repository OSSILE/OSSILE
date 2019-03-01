     /**
      * \brief List Implementation : ArrayList
      *
      * A list implementation with a memory block as backend. The memory
      * will be dynamically allocated and deallocated. Therefore the list
      * can grow and shrink dynamically as requested.
      *
      * <br><br>
      *
      * This list implementation works with a head data structure.
      *
      * <br><br>
      *
      * The entries are stored in an "array" which consists of pointers.
      * The pointers of the array store the start address of the memory
      * of the values.
      *
      * <br><br>
      *
      * All values are internally null-terminated. So a value of x'00'
      * won't work as expected and should be avoided.
      *
      * <br><br>
      *
      * Access to the element is accomplished through accessing the arraylist
      * with an index (position). The index is 0-based. So the first element
      * has an index of 0 (zero).
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      */


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


     H nomain
     HCOPYRIGHT('Copyright (c) 2016 Mihael Schmidt. All rights reserved.')


      *---------------------------------------------------------------
      * Prototypen
      *---------------------------------------------------------------
     D increment       PR
     D   arraylist                     *   const
     D   size                        10U 0 const options(*nopass)
      *
     D sendEscapeMessage...
     D                 PR
     D   message                  65535A   const varying
      *
     D getEntry...
     D                 PR              *
     D   arraylist                     *   const
     D   pos                         10I 0 const
      *
     D moveElements...
     D                 PR
     D   arraylist                     *   const
     D   pos                         10U 0 const
     D   pDownBy                     10I 0 const options(*nopass)

      /include 'arraylist_h.rpgle'
      /include 'libc_h.rpgle'


      *-------------------------------------------------------------------------
      * Constants
      *-------------------------------------------------------------------------
      *
      * Incrementation size of 0 (zero) doubles the size of the array.
      *
     D DEFAULT_INCREMENT_SIZE...
     D                 C                    0
     D DEFAULT_INIT_SIZE...
     D                 C                   10


      *-------------------------------------------------------------------------
      * Variables
      *-------------------------------------------------------------------------
     D tmpl_header     DS                  qualified based(nullPointer) align
     D   elementsAllocated...
     D                               10I 0
     D   elementCount                10I 0
     D   elementData                   *
     D   incrementSize...
     D                               10U 0
      *
     D tmpl_entry      DS                  qualified align based(nullPointer)
     D   value                         *
     D   length                      10I 0
      // so that the pointer is aligned on a 16-byte boundary we need to fill
      // this data structure up to the next 16 byte
     D   reserved                    12A
      *
     D hexNull         S              1A   inz(x'00')


      *-------------------------------------------------------------------------
      * Procedures
      *-------------------------------------------------------------------------

     /**
      * \brief Create arraylist
      *
      * Creates an arraylist.
      *
      * <br><br>
      *
      * The initial size is 10. The default increment size
      * is 0 which means with each incrementation the arraylist will double its
      * size.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Initial arraylist size (default: 10)
      * \param Incrementation size (default: 0 - double)
      *
      * \return Pointer to arraylist
      */
     P arraylist_create...
     P                 B                   export
     D                 PI              *
     D   initSize                    10U 0 const options(*nopass)
     D   incSize                     10U 0 const options(*nopass)
      *
     D arraylist       S               *
     D header          DS                  likeds(tmpl_header) based(arraylist)
      /free
       arraylist = %alloc(%size(tmpl_header));

       header.elementCount = 0;
       header.elementData = *null;

       // init arraylist size if passed
       if (%parms() = 0);
         header.elementsAllocated = DEFAULT_INIT_SIZE;
         header.incrementSize = DEFAULT_INCREMENT_SIZE;
       elseif (%parms() = 1);
         header.incrementSize = DEFAULT_INCREMENT_SIZE;
         header.elementsAllocated = initSize;
       elseif (%parms() = 2);
         header.incrementSize = incSize;
         header.elementsAllocated = initSize;
       endif;

       // alloc memory for entries
       header.elementData =
           %alloc(header.elementsAllocated * %size(tmpl_entry));

       return arraylist;
      /end-free
     P                 E


     /**
      * \brief Dispose arraylist
      *
      * Disposes the arraylist and all its elements. The pointer will be set
      * to *null.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      */
     P arraylist_dispose...
     P                 B                   export
     D                 PI
     D   arraylist                     *
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D i               S             10I 0
      /free
       if (arraylist <> *null);
         arraylist_clear(arraylist);
         dealloc(n) arraylist;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add element
      *
      * Adds an element to the arraylist by copying the content to dynamically
      * allocated memory. Values are stored null-terminated.
      *
      * <br><br>
      *
      * If a position is passed the caller must be certain that the
      * position is inside the bounds of the arraylist. If the position is
      * outside of the arraylist an escape message will be sent.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      * \param Pointer to new entry
      * \param Length of new entry (in byte)
      * \param Position
      */
     P arraylist_add   B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
     D   pPos                        10U 0 const options(*nopass)
      *
     D pos             S             10U 0
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      /free
       // determine the position
       if (%parms() = 3);
         pos = header.elementCount;
       elseif (%parms() = 4);
         // if a position was passed, check if it is inside the arraylist
         if (pPos >= header.elementCount);
           sendEscapeMessage('Position out of bounds');
         else;
           pos = pPos;
           moveElements(arraylist : pos);
         endif;
       endif;

       // make some space if necessary
       if (header.elementCount = header.elementsAllocated);
         increment(arraylist);
       endif;

       // get free entry
       ptr = getEntry(arraylist : pos);

       // alloc memory for this entry
       entry.value = %alloc(valueLength + 1); // +1 for the null byte
       entry.length = valueLength;

       // copy value to the entry
       memcpy(entry.value : value : valueLength);

       // set null to the last byte
       memcpy(entry.value + valueLength : %addr(hexNull) : 1);

       // update header
       header.elementCount += 1;
      /end-free
     P                 E


     /**
      * \brief Append element to the arraylist
      *
      * Adds an element to the end of the arraylist by copying the content to
      * dynamically allocated memory. Values are stored null-terminated.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      * \param Pointer to new entry
      * \param Length of new entry (in byte)
      */
     P arraylist_addLast...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      /free
       arraylist_add(arraylist : value : valueLength);
      /end-free
     P                 E


     /**
      * \brief Prepend element to the arraylist
      *
      * Adds an element to the beginning of the arraylist by copying the content to
      * dynamically allocated memory. Values are stored null-terminated. If the
      * the arraylist is not empty all other elements will be pushed down by one
      * position.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      * \param Pointer to new entry
      * \param Length of new entry (in byte)
      */
     P arraylist_addFirst...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      /free
       arraylist_add(arraylist : value : valueLength : 0);
      /end-free
     P                 E

     /**
      * \brief Get arraylist size
      *
      * Returns the number of elements currently in the arraylist.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      *
      * \return Number of elements in the arraylist
      */
     P arraylist_getSize...
     P                 B                   export
     D                 PI            10U 0
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D size            S             10U 0
      /free
       return header.elementCount;
      /end-free
     P                 E


     /**
      * \brief Get arraylist capacity
      *
      * Returns the number of elements which can be stored in the current
      * arraylist.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      *
      * \return Number of elements able to store in the arraylist
      */
     P arraylist_getCapacity...
     P                 B                   export
     D                 PI            10U 0
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D size            S             10U 0
      /free
       return header.elementsAllocated;
      /end-free
     P                 E



     /**
      * \brief Get element
      *
      * Returns a pointer to the elment at the given position. The element is
      * null-terminated. Changes to the element through the returned pointer is
      * not recommended. Use the appropriate procedures instead.
      *
      * <br><br>
      *
      * If the requested element position is not in the arraylist then an escape
      * message will be sent.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      * \param Position
      *
      * \return Pointer to the null-terminated element
      *         or *null if arraylist is empty
      */
     P arraylist_get   B                   export
     D                 PI              *
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      /free
       if (header.elementCount = 0);
         return *null;
       elseif (index >= header.elementCount);
         sendEscapeMessage('Position out of bounds');
       endif;

       ptr = getEntry(arraylist : index);

       return entry.value;
      /end-free
     P                 E


     /**
      * \brief Get first element
      *
      * Returns a pointer to the first elment in the arraylist. The element is
      * null-terminated. Changes to the element through the returned pointer is
      * not recommended. Use the appropriate procedures instead.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      *
      * \return Pointer to the null-terminated element or *null if the arraylist is empty
      */
     P arraylist_getFirst...
     P                 B                   export
     D                 PI              *
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
      /free
       return arraylist_get(arraylist : 0);
      /end-free
     P                 E


     /**
      * \brief Get last element
      *
      * Returns a pointer to the last elment in the arraylist. The element is
      * null-terminated. Changes to the element through the returned pointer is
      * not recommended. Use the appropriate procedures instead.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to arraylist
      *
      * \return Pointer to the null-terminated element
      *         or *null if the arraylist is empty
      */
     P arraylist_getLast...
     P                 B                   export
     D                 PI              *
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
      /free
       return arraylist_get(arraylist : header.elementCount - 1);
      /end-free
     P                 E


     /**
      * \brief Check if arraylist is empty
      *
      * Checks if the arraylist is empty.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      *
      * \return *on = arraylist is empty <br>
      *         *off = arraylist is not empty
      */
     P arraylist_isEmpty...
     P                 B                   export
     D                 PI              N
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
      /free
       return (header.elementCount = 0);
      /end-free
     P                 E


     /**
      * \brief Clear arraylist
      *
      * Deletes all entries. The capacity of the arraylist remains the same.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      */
     P arraylist_clear...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D i               S             10I 0
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      /free
       for i = 0 to header.elementCount-1;
         ptr = getEntry(arraylist : i);
         dealloc(n) entry.value;
       endfor;

       // TODO reduce array size?

       header.elementCount = 0;
      /end-free
     P                 E


     /**
      * \brief Remove an element
      *
      * Removes an element from the arraylist. If the given position is outside of
      * the bounds of the arraylist an escape message will be sent.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      * \param Element index to be removed
      */
     P arraylist_remove...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      /free
       if (index >= header.elementCount);
         sendEscapeMessage('Position out of bounds');
       endif;

       ptr = getEntry(arraylist : index);
       dealloc(n) entry.value; // release allocated memory

       // check if it is the last element
       if (index <> header.elementCount -1); // not the last => move other elements
         moveElements(arraylist : index + 1 : -1);
       endif;

       header.elementCount -= 1;
      /end-free
     P                 E


     /**
      * \brief Remove the first element
      *
      * Removes the first element from the arraylist.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      */
     P arraylist_removeFirst...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
      /free
       arraylist_remove(arraylist : 0);
      /end-free
     P                 E


     /**
      * \brief Remove the last element
      *
      * Removes the last element from the arraylist.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      */
     P arraylist_removeLast...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
      /free
       if (header.elementCount > 0);
         arraylist_remove(arraylist : arraylist_getSize(arraylist) - 1);
       endif;
      /end-free
     P                 E


     /**
      * \brief Remove a range of elements
      *
      * Removes a range of elements from the arraylist. The range must be inside
      * the bounds of the arraylist. If the range is outside the arraylist an
      * escape message will be sent.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      * \param Range starting index
      * \param Number of elements to remove
      */
     P arraylist_removeRange...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   index                       10U 0 const
     D   count                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D i               S             10I 0
      /free
       if (index + count -1 >= header.elementCount);
         sendEscapeMessage('Position out of bounds');
       endif;

       for i = index to index + count - 1;
         // always index for position because the other elements have moved up by one
         arraylist_remove(arraylist : index);
       endfor;

      /end-free
     P                 E


     /**
      * \brief Contains element
      *
      * Checks if the arraylist contains the passed data.
      * The check will be done byte by byte, so trailing spaces also count.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      * \param Pointer to data
      * \param Data length
      *
      * \return *on if the arraylist contains the data, *off otherwise
      */
     P arraylist_contains...
     P                 B                   export
     D                 PI              N
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      /free
       return (arraylist_indexOf(arraylist : value : valueLength) >= 0);
      /end-free
     P                 E


     /**
      * \brief Get index of element
      *
      * Returns the index of the passed element.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      * \param Pointer to data
      * \param Data length
      *
      * \return index of the element or -1 if the element is not in the arraylist
      */
     P arraylist_indexOf...
     P                 B                   export
     D                 PI            10I 0
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D i               S             10I 0
     D retVal          S             10I 0 inz(-1)
      /free
       for i = 0 to header.elementCount - 1;
         ptr = header.elementData + (i * %size(tmpl_entry));
         if (entry.length = valueLength);

           if (memcmp(entry.value : value : valueLength) = 0);
             retVal = i;
             leave;
           endif;

         endif;
       endfor;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get last index of element
      *
      * Returns the last index of the passed element.
      *
      * \author Mihael Schmidt
      * \date   16.04.2011
      *
      * \param Pointer to the arraylist
      * \param Pointer to data
      * \param Data length
      *
      * \return last index of the element
      *         or -1 if the element is not in the arraylist
      */
     P arraylist_lastIndexOf...
     P                 B                   export
     D                 PI            10I 0
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D i               S             10I 0
     D retVal          S             10I 0 inz(-1)
      /free
       for i = header.elementCount - 1 downto 0;
         ptr = header.elementData + (i * %size(tmpl_entry));
         if (entry.length = valueLength);

           if (memcmp(entry.value : value : valueLength) = 0);
             retVal = i;
             leave;
           endif;

         endif;
       endfor;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Frequency of element
      *
      * Returns the number of times the passed element is in the arraylist.
      *
      * \author Mihael Schmidt
      * \date   2011-04-19
      *
      * \param Pointer to the arraylist
      * \param Pointer to data
      * \param Data length
      *
      * \return frequency of the passed data in the arraylist
      */
     P arraylist_frequency...
     P                 B                   export
     D                 PI            10U 0
     D   arraylist                     *   const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D i               S             10I 0
     D retVal          S             10U 0
      /free
       for i = 0 to header.elementCount - 1;
         ptr = header.elementData + (i * %size(tmpl_entry));
         if (entry.length = valueLength);

           if (memcmp(entry.value : value : valueLength) = 0);
             retVal += 1;
           endif;

         endif;
       endfor;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Replace element
      *
      * Replaces the given element with the new data.
      *
      * \author Mihael Schmidt
      * \date 2011-04-19
      *
      * \param Pointer to the arraylist
      * \param Index to data which should be replaced
      * \param Pointer to the new data
      * \param Length of the new data
      */
     P arraylist_replace...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   index                       10U 0 const
     D   value                         *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      /free
       // if a position was passed, check if it is inside the array
       if (index >= header.elementCount);
         sendEscapeMessage('Position out of bounds.');
       endif;

       // get entry
       ptr = getEntry(arraylist : index);

       // alloc memory for this entry
       entry.value = %realloc(entry.value : valueLength + 1); // +1 for the null byte
       entry.length = valueLength;

       // copy value to the entry
       memcpy(entry.value : value : valueLength);

       // set null to the last byte
       memcpy(entry.value + valueLength : %addr(hexNull) : 1);
      /end-free
     P                 E


     /**
      * \brief Create a sublist
      *
      * Returns a sublist of this arraylist.
      *
      * \author Mihael Schmidt
      * \date 2011-04-19
      *
      * \param Pointer to the arraylist
      *
      * \return Pointer to the new arraylist (sublist)
      */
     P arraylist_sublist...
     P                 B                   export
     D                 PI              *
     D   arraylist                     *   const
     D   startIndex                  10U 0 const
     D   length                      10U 0 const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
      *
     D i               S             10U 0
     D endIndex        S             10U 0
     D sublist         S               *
      /free
       sublist = arraylist_create();

       if (%parms() = 3);
         endIndex = startIndex + length;
         endIndex -= 1;
       else;
         endIndex = header.elementCount - 1;
       endif;

       if (startIndex >= header.elementCount);
         sendEscapeMessage('Start index position out of bounds.');
       endif;

       if (endIndex >= header.elementCount);
         sendEscapeMessage('End index position out of bounds.');
       endif;

       for i = startIndex to endIndex;
         ptr = getEntry(arraylist : i);
         arraylist_add(sublist : entry.value : entry.length);
       endfor;

       return sublist;
      /end-free
     P                 E


     /**
      * \brief Create a copy of the arraylist
      *
      * Returns a copy of the arraylist.
      *
      * \author Mihael Schmidt
      * \date 2011-04-19
      *
      * \param Pointer to the arraylist
      *
      * \return Pointer to the new arraylist
      */
     P arraylist_copy...
     P                 B                   export
     D                 PI              *
     D   arraylist                     *   const
      *
     D copyList        S               *
      /free
       copyList = arraylist_sublist(arraylist : 0);

       return copyList;
      /end-free
     P                 E


     /**
      * \brief Swap arraylist items
      *
      * \author Mihael Schmidt
      * \date 2011-04-19
      *
      * \param Pointer to the arraylist
      * \param Item to swap
      * \param Item to swap
      */
     P arraylist_swap...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   itemPos1                    10U 0 const
     D   itemPos2                    10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr1            S               *
     D entry1          DS                  likeds(tmpl_entry) based(ptr1)
     D ptr2            S               *
     D entry2          DS                  likeds(tmpl_entry) based(ptr2)
     D tmpEntry        DS                  likeds(tmpl_entry)
      /free
       // if a position was passed, check if it is inside the array
       if (itemPos1 >= header.elementCount or
           itemPos2 >= header.elementCount);
         sendEscapeMessage('Position out of bounds');
       endif;

       ptr1 = getEntry(arraylist : itemPos1);
       ptr2 = getEntry(arraylist : itemPos2);

       tmpEntry = entry1;
       entry1 = entry2;
       entry2 = tmpEntry;
      /end-free
     P                 E


     /**
      * \brief Add all elements to the arraylist
      *
      * Adds all elements from the source arraylist to the destination arraylist.
      *
      * \param Pointer to the destination arraylist
      * \param Pointer to the source arraylist
      */
     P arraylist_addAll...
     P                 B                   export
     D                 PI
     D   destArraylist...
     D                                 *   const
     D   sourceArraylist...
     D                                 *   const
      *
     D header          DS                  likeds(tmpl_header)
     D                                     based(sourceArraylist)
     D ptr             S               *
     D entry           Ds                  likeds(tmpl_entry) based(ptr)
      *
     D i               S             10U 0
      /free
       for i = 0 to header.elementCount -1;
         ptr = getEntry(sourceArraylist : i);
         arraylist_add(destArraylist : entry.value : entry.length);
       endfor;
      /end-free
     P                 E


     /**
      * \brief Add integer value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds an integer to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addInteger...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                       10I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S             10I 0
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add short integer value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a short integer to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addShort...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                        5I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S              5I 0
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add long integer value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a long integer to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addLong...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                       20I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S             20I 0
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add packed decimal value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a packed decimal to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addDecimal...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                       15P 5 const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S             15P 5
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add float value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a float to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addFloat...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                        4F   const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S              4F
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add double value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a double to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addDouble...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                        8F   const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S              8F
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add date value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a date to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addDate...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                         D   const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S               D
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add boolean value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a boolean to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addBoolean...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                         N   const
     D   index                       10U 0 const options(*nopass)
      *
     D tmpValue        S               N
      /free
       tmpValue = value;

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue));
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(tmpValue) : %size(tmpValue) : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Add character value to the arraylist
      *
      * This procedure is a wrapper for the <em>add</em> procedure and
      * adds a character string to the arraylist.
      *
      * \param Pointer to the arraylist
      * \param Value
      * \param Position (default: append)
      */
     P arraylist_addString...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   value                    65535A   const varying
     D   index                       10U 0 const options(*nopass)
      *
     D length          S             10I 0
     D string          S          65535A   varying
      /free
       string = value;
       length = %len(value);

       if (%parms() = 2);
         arraylist_add(arraylist : %addr(string : *DATA) : length);
       elseif (%parms() = 3);
         arraylist_add(arraylist : %addr(string : *DATA) : length : index);
       endif;

      /end-free
     P                 E


     /**
      * \brief Get integer value from arraylist
      *
      * Returns the previously inserted integer value from the arraylist.
      * If the value cannot be interpreted as an integer an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getInteger...
     P                 B                   export
     D                 PI            10I 0
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S             10I 0 based(dataPtr)
     D retVal          S             10I 0
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get short integer value from arraylist
      *
      * Returns the previously inserted short integer value from the arraylist.
      * If the value cannot be interpreted as a short integer an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getShort...
     P                 B                   export
     D                 PI             5I 0
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S              5I 0 based(dataPtr)
     D retVal          S              5I 0
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get long integer value from arraylist
      *
      * Returns the previously inserted long integer value from the arraylist.
      * If the value cannot be interpreted as a long integer an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getLong...
     P                 B                   export
     D                 PI            20I 0
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S             20I 0 based(dataPtr)
     D retVal          S             20I 0
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get packed decimal value from arraylist
      *
      * Returns the previously inserted packed decimal value from the arraylist.
      * If the value cannot be interpreted as a packed decimal an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getDecimal...
     P                 B                   export
     D                 PI            15P 5
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S             15P 5 based(dataPtr)
     D retVal          S             15P 5
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get float value from arraylist
      *
      * Returns the previously inserted float value from the arraylist.
      * If the value cannot be interpreted as a float an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getFloat...
     P                 B                   export
     D                 PI             4F
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S              4F   based(dataPtr)
     D retVal          S              4F
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get dobule value from arraylist
      *
      * Returns the previously inserted double value from the arraylist.
      * If the value cannot be interpreted as a double an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getDouble...
     P                 B                   export
     D                 PI             8F
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S              8F   based(dataPtr)
     D retVal          S              8F
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get date value from arraylist
      *
      * Returns the previously inserted date value from the arraylist.
      * If the value cannot be interpreted as a date an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getDate...
     P                 B                   export
     D                 PI              D
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S               D   based(dataPtr)
     D retVal          S               D
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get boolean value from arraylist
      *
      * Returns the previously inserted boolean value from the arraylist.
      * If the value cannot be interpreted as a boolean an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getBoolean...
     P                 B                   export
     D                 PI              N
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D dataptr         S               *   based(ptr)
     D data            S               N   based(dataPtr)
     D retVal          S               N
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = data;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Get character value from arraylist
      *
      * Returns the previously inserted character string value from the arraylist.
      * If the value cannot be interpreted as a char value an escape message
      * will be sent.
      *
      * \param Pointer to the arraylist
      * \param Position
      *
      * \return Value
      */
     P arraylist_getString...
     P                 B                   export
     D                 PI         65535A   varying
     D   arraylist                     *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D retVal          S          65535A   varying
      /free
       // check if the arraylist is empty or the position is outside of the arraylist
       if (header.elementCount = 0);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       elseif (index < 0 or index > header.elementCount -1);
         sendEscapeMessage('Position out of bounds');
         return *loval;
       endif;

       ptr = getEntry(arraylist : index);

       monitor;
         // test if the temp variable is filled with the right data for the type
         // by moving the data from temp to another var (retVal in this case)
         retVal = %str(entry.value);
         %len(retVal) = entry.length;
         return retVal;
         on-error *all;
           sendEscapeMessage('Invalid value type');
           return *loval;
       endmon;

      /end-free
     P                 E


     /**
      * \brief Execute procedure for every arraylist entry
      *
      * The passed procedure will be executed for every entry
      * in the arraylist.
      *
      * <br><br>
      *
      * The user can pass data through a pointer to the procedure.
      * The pointer will not be touched by this procedure itself, so it
      * can be *null.
      *
      * <br><br>
      *
      * The value of list entry can be changed through the passed procedure.
      *
      * <br><br>
      *
      * The parameters for the passed procedure are:
      * <ul>
      *   <li>Pointer to the entry value (const)</li>
      *   <li>Value length (const) <li>
      *   <li>Pointer to the user data (const)</li>
      * </ul>
      *
      * \param Pointer to the arraylist
      * \param Procedure pointer
      * \param Pointer to user data
      */
     P arraylist_foreach...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   procPtr                       *   const procptr
     D   userData                      *   const
      *
     D foreachProc     PR                  extproc(procPtr)
     D   valuePtr                      *   const
     D   length                      10I 0 const
     D   userData                      *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D i               S             10I 0
      /free
       for i = 0 to header.elementCount - 1;
         ptr = getEntry(arraylist : i);
         foreachProc(entry.value : entry.length : userData);
       endfor;
      /end-free
     P                 E

     /**
      * \brief To character array
      *
      * Copies all entries of this arraylist to the passed array. Entries will be
      * truncated if they are too big for the array. If the array is not big
      * enough, the last entries will be silently dropped.
      *
      * \param Pointer to the arraylist
      * \param Pointer to the array
      * \param Element count
      * \param Element length
      *
      */
     P arraylist_toCharArray...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
     D   arrayPtr                      *   const
     D   count                       10U 0 const
     D   length                      10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D i               S             10I 0
     D arrayElemPtr    S               *
     D tmpLength       S             10I 0
      /free
       for i = 0 to header.elementCount - 1;
         if (count > i);
           entryPtr = getEntry(arraylist : i);
           arrayElemPtr = arrayPtr + (i * length);

           // determine how many bytes to copy (check length)
           if (entry.length < length);
             tmpLength = entry.length;
           else;
             tmpLength = length;
           endif;

           // copy entry from arraylist to array
           memcpy(arrayElemPtr : entry.value : tmpLength);
          endif;
       endfor;

      /end-free
     P                 E


     /**
      * \brief Reverse order of arraylist entries
      *
      * Reverses the order of the entries of the arraylist.
      *
      * \param Pointer to the arraylist
      */
     P arraylist_reverse...
     P                 B                   export
     D                 PI
     D   arraylist                     *   const
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D ptr1            S               *
     D entry1          DS                  likeds(tmpl_entry) based(ptr1)
     D ptr2            S               *
     D entry2          DS                  likeds(tmpl_entry) based(ptr2)
     D tmpEntry        DS                  likeds(tmpl_entry)
     D i               S             10I 0
     D endValue        S             10I 0
      /free
       if (header.elementCount <= 1);
         return;
       endif;

       endValue = header.elementCount / 2 - 1;

       for i = 0 to endValue;
         ptr1 = getEntry(arraylist : i);
         ptr2 = getEntry(arraylist : header.elementCount - i - 1);

         tmpEntry = entry1;
         entry1 = entry2;
         entry2 = tmpEntry;
       endfor;

      /end-free
     P                 E


     /**
      * \brief Split character string
      *
      * The passed character string will be split into tokens by either
      * a passed or the default separator. All tokens will be added to
      * a new arraylist which will be returned.
      *
      * <br><br>
      *
      * Empty (but not blank) values will be dropped silently.
      *
      * \author Mihael Schmidt
      * \date   26.01.2009
      *
      * \param Character string (null-terminated)
      * \param Separator (default: ;)
      *
      * \return Pointer to the filled arraylist
      */
     P arraylist_split...
     P                 B                   export
     D                 PI              *
     D   pString                  65535A   const varying
     D   pSeparator                   1A   const options(*nopass)
      *
     D length          S             10I 0
     D arraylist       S               *
     D token           S               *
     D separator       S              1A   inz(';')
     D string          S          65535A
      /free
       string = pString;

       if (%parms() = 2);
         separator = pSeparator;
       endif;

       arraylist = arraylist_create();

       token = strtok(string : separator);
       dow (token <> *null);
         arraylist_add(arraylist : token : strlen(token));
         token = strtok(*null : separator);
       enddo;

       return arraylist;
      /end-free
     P                 E


     /**
      * \brief Return character representation of arraylist
      *
      * Returns a string with the arraylist items separated either by
      * the passed or default separator. The items can be
      * enclosed by a passed character. The maximum character length
      * returned is 65535. Every character/item after that will be
      * dropped silently. Items will not be trimmed for this operation.
      *
      * <br><br>
      *
      * If the third parameter is passed, the third parameter will be
      * pre- and appended to the item. If the fourth parameter is also
      * passed the third parameter will be prepended to the item and the
      * fourth parameter will be appended to the item.
      *
      * \param Pointer to the arraylist
      * \param separator (default: ,)
      * \param enclosing character (default: nothing)
      * \param enclosing character at the end of item (default: nothing)
      *
      * \return character representation of all arraylist items
      */
     P arraylist_toString...
     P                 B                   export
     D                 PI         65535A   varying
     D   arraylist                     *   const
     D   pSeparator                   1A   const options(*omit : *nopass)
     D   pEnclosing                 100A   const varying options(*nopass)
     D   pEnclosingEnd...
     D                              100A   const varying options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D separator       S              1A   inz(',')
     D enclosingStart...
     D                 S            100A   varying
     D enclosingEnd...
     D                 S            100A   varying
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D i               S             10I 0
     D retVal          S          65535A   varying
      /free
       // check if separator is passed
       if (%parms() >= 2 and %addr(pSeparator) <> *null);
         separator = pSeparator;
       endif;

       // check if enclosing characters are passed
       if (%parms() >= 3);
         enclosingStart = pEnclosing;
         enclosingEnd = pEnclosing;
       endif;

       // check if we should use different chars for start and end of item
       if (%parms() = 4);
         enclosingEnd = pEnclosingEnd;
       endif;

       // process arraylist items
       for i = 0 to header.elementCount - 2;
         ptr = getEntry(arraylist : i);
         retVal += enclosingStart + %str(entry.value) + enclosingEnd +
                   separator;
       endfor;

       ptr = getEntry(arraylist : header.elementCount-1);
       retVal += enclosingStart + %str(entry.value) + enclosingEnd;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get entry pointer
      *
      * Returns the pointer of an entry.
      *
      * \author Mihael Schmidt
      * \date   23.06.2008
      *
      * \param Pointer to the arraylist
      * \param Position (zero-based)
      *
      * \return Pointer to arraylist entry or *null
      */
     P getEntry...
     P                 B
     D                 PI              *
     D   arraylist                     *   const
     D   pos                         10I 0 const
      *
     D i               S             10I 0
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D entry           S               *
      /free
       entry = header.elementData + (pos * %size(tmpl_entry));
       return entry;
      /end-free
     P                 E


     /**
      * \brief Push element down by x positions
      *
      * Moves the passed element up or down by the x number of entries. This
      * procedure also pushes/pulls every element under it also up or down by
      * the given number of positions.
      *
      * <br><br>
      *
      * A positive <em>downBy</em> value will push the entries down. A negative
      * <em>downBy</em> value will pull the entries up.
      *
      * \author Mihael Schmidt
      * \date   30.07.2008
      *
      * \param Pointer to the arraylist
      * \param Number of positions to go up or down (default: 1 = down by one position)
      */
     P moveElements...
     P                 B
     D                 PI
     D   arraylist                     *   const
     D   pos                         10U 0 const
     D   pDownBy                     10I 0 const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D downBy          S             10I 0 inz(1)
     D x               S             10I 0
     D elementsToCopy...
     D                 S             10I 0
     D startElement    S               *
     D tmp_mem         S               *
      /free
       if (%parms() = 3);
         downBy = pDownBy;
       endif;

       // check if the destination of the entry is before the head of the arraylist
       if (pos + downBy < 0);
         sendEscapeMessage('Destination out of bounds');
       endif;

       // resize the array if necessary
       if (header.elementsAllocated < header.elementCount + downBy);
         increment(arraylist : header.elementCount + downBy);
       endif;

       startElement = getEntry(arraylist : pos);

       elementsToCopy = header.elementCount - pos;

       if (startElement <> *null);
         // alloc temp. memory for entries
         tmp_mem = %alloc(elementsToCopy * %size(tmpl_entry));

         // copy to temp. memory
         memcpy(tmp_mem :
                startElement :
                elementsToCopy * %size(tmpl_entry));

         // copy to real destination
         memcpy(startElement + (downBy * %size(tmpl_entry)) :  // destination
                tmp_mem :                                      // source
                elementsToCopy * %size(tmpl_entry));           // number of bytes

         // release the temp. memory
         dealloc tmp_mem;
       endif;
      /end-free
     P                 E


     /**
      * \brief Increment array size
      *
      * Increases the size of the arraylist either by 2 or up to the passed
      * size. The arraylist size will be decreased if the given size is lower
      * than the current size.
      *
      * <br><br>
      *
      * If the new size cannot be less than the number of elements currently
      * in the arraylist.
      *
      * \author Mihael Schmidt
      * \date   23.06.2008
      *
      * \param Pointer to the arraylist
      * \param New size of the arraylist (default: determined by the header)
      */
     P increment       B
     D                 PI
     D   arraylist                     *   const
     D   size                        10U 0 const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(arraylist)
     D newSize         S             10U 0
      /free
       monitor;
         if (%parms() = 1);
           if (header.incrementSize = 0);
             // double the size
             newSize = header.elementsAllocated * 2;
           else;
             newSize = header.incrementSize;
           endif;
         else;
           if (size = 0);
             // double the size
             newSize = header.elementsAllocated * 2;
           elseif (size <= header.elementsAllocated);
             // return if the new size is going to be smaller
             // than the number of elements currently in the arraylist
             // (same size => do nothing)
             return;
           else;
             newSize = size;
           endif;
         endif;

         on-error *all;
           sendEscapeMessage('Maximum arraylist size reached');
       endmon;

       if (header.elementsAllocated <> newSize);
         header.elementData = %realloc(header.elementData :
                               newSize * %size(tmpl_entry));
         header.elementsAllocated = newSize;
       endif;
      /end-free
     P                 E


     /**
      * \brief Send Escape Message
      *
      * Sends an escape message with the specified Id.
      *
      * \author Mihael Schmidt
      * \date   23.06.2008
      *
      * \param Message Id
      */
     P sendEscapeMessage...
     P                 B
     D                 PI
     D   message                  65535A   const varying
      *
     D sendProgramMessage...
     D                 PR                  extpgm('QMHSNDPM')
     D  szMsgID                       7A   const
     D  szMsgFile                    20A   const
     D  szMsgData                  6000A   const  options(*varsize)
     D  nMsgDataLen                  10I 0 const
     D  szMsgType                    10A   const
     D  szCallStkEntry...
     D                               10A   const
     D  nRelativeCallStkEntry...
     D                               10I 0 const
     D  szRtnMsgKey                   4A
     D  error                       265A   options(*varsize)
      *
     D msgdata         S            512A
     D msgkey          S              4A
     D apiError        S            265A
      /free
       msgdata = message;

       sendProgramMessage('CPF9898' :
                          'QCPFMSG   *LIBL     ' :
                          %trimr(msgdata) :
                          %len(%trimr(msgdata)) :
                          '*ESCAPE   ' :
                          '*PGMBDY' :
                          0 :
                          msgkey :
                          apiError);
      /end-free
     P                 E
