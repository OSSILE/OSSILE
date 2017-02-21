     /**
      * \brief Linked List Implementation
      *
      * This is a typical Doubly-Linked List (Two-Way Linked List) Implementation
      * using dynamic memory allocation. The list is particular suitable for
      * character values but does also work with any other data (f. e. data
      * structures).
      *
      * <br><br>
      *
      * Values are stored as null-terminated chars.
      *
      * <br><br>
      *
      * Operations that index into the list will traverse the list from
      * the beginning or the end, whichever is closer to the specified index.
      *
      * <br><br>
      *
      * <b>Iteration:</b> With the procedure <em>getNext</em> the list is
      * traversable in the top-bottom direction. Each call to <em>getNext</em>
      * will return the next entry of the list till the end of the list.
      * If the walk through the list should be stopped early (before the end
      * of the list) the method <em>abortIteration</em> should be called.
      * If the list is structurally modified at any time
      * after an iteration has begun in any way, the result of the iteration
      * can not be safely determined. If an iteratioj is not going to continue
      * the procedure <em>abortIteration</em> should be called. After that
      * call it is safe to modify the list again.
      *
      * <br><br>
      *
      * Throughout this service program a zero-based index is used.
      *
      * <br><br>
      *
      * This list implementation is not thread-safe.
      *
      * \author Mihael Schmidt
      * \date   20.12.2007
      *
      * \rev 22.11.2009 Mihael Schmidt
      *      Added sorting support <br>
      *      Changed memory management to user created heap <br>
      *      Added removeRange procedure <br>
      *      Bug fix: list_addAll does not work if value has x'00'
      *
      * \rev 15.12.2009 Mihael Schmidx
      *      Added merge procedure
      * 
      * \rev 19.02.2011 Mihael Schmidt
      *      Fixed list_sublist procedure <br>
      *      Added list_resetIteration <br>
      *      Deprecated list_abortIteration <br>
      *      Added list_iterate <br>
      *      Deprecated list_getNext <br>
      *      Userdata parameter on list_foreach is now optional <br>
      *      list_merge got new parameter to only optionally skip duplicate entries
      */

      *------------------------------------------------------------------------
      *
      * Copyright (c) 2007-2009 Mihael Schmidt
      * All rights reserved.
      *
      * This file is part of the LLIST service program.
      *
      * LLIST is free software: you can redistribute it and/or modify it under
      * the terms of the GNU Lesser General Public License as published by
      * the Free Software Foundation, either version 3 of the License, or
      * any later version.
      *
      * LLIST is distributed in the hope that it will be useful,
      * but WITHOUT ANY WARRANTY; without even the implied warranty of
      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      * GNU Lesser General Public License for more details.
      *
      * You should have received a copy of the GNU Lesser General Public
      * License along with LLIST.  If not, see http://www.gnu.org/licenses/.
      *
      *------------------------------------------------------------------------


     H NOMAIN
     H COPYRIGHT('Copyright (c) 2007-2017 Mihael Schmidt. All rights reserved.')


      *-------------------------------------------------------------------------
      * Prototypen
      *-------------------------------------------------------------------------
      /copy 'llist_h.rpgle'
      /copy 'llist_in_h.rpgle'
      /copy 'ceeapi_h.rpgle'


      *-------------------------------------------------------------------------
      * Procedures
      *-------------------------------------------------------------------------

     /**
      *  \brief Create list
      *
      * Creates a list. A header is generated for the list and the pointer to
      * the list returned.
      *
      * <br><br>
      *
      * A list must be disposed via the procedure <em>dispose</em> to free all
      * allocated memory.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \return Pointer to the list
      */
     P list_create     B                   export
     D                 PI              *
      *
     D listPtr         S               *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D heapId          S             10I 0
      /free
       cee_createHeap(heapId : *omit : *omit : *omit : *omit);

       // allocate memory for list header
       cee_getStorage(heapId : %size(tmpl_header) : listPtr : *omit);

       header.id = LIST_ID;
       header.heapId = heapId;
       header.size = 0;
       header.bytes = 0;
       header.firstEntry = *null;
       header.lastEntry = *null;
       header.iteration = -1;
       header.iterNextEntry = *null;
       header.iterPrevEntry = *null;

       return listPtr;
      /end-free
     P                 E


     /**
      * \brief Dispose list
      *
      * The memory for whole list are is released
      * (deallocated). The list pointer is set to *null;
      *
      * <br><br>
      *
      * If the passed pointer is already *null the procedure simply returns.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      */
     P list_dispose    B                   export
     D                 PI
     D   listPtr                       *
     D header          DS                  likeds(tmpl_header) based(listPtr)
      /free
       if (listPtr = *null);
         // do nothing
       else;

         if (isLinkedListImpl(listPtr));
           cee_discardHeap(header.heapId : *omit);
           listPtr = *null;
         endif;

       endif;
      /end-free
     P                 E


     /**
      * \brief Add list entry
      *
      * Adds an entry at an exact position in the list. If the position is
      * outside the list the procedure returns <em>*off</em>. The current
      * entry of the list at that position will be pushed one position down
      * the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to the new value
      * \param Length of the new value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_add        B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   ptrValue                      *   const
     D   length                      10U 0 const
     D   pos                         10U 0 const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D nextEntryPtr    S               *
     D nextEntry       DS                  likeds(tmpl_entry)
     D                                     based(nextEntryPtr)
     D prevEntryPtr    S               *
     D prevEntry       DS                  likeds(tmpl_entry)
     D                                     based(prevEntryPtr)
     D newEntryPtr     S               *
     D newEntry        DS                  likeds(tmpl_entry)
     D                                     based(newEntryPtr)
     D tmpPtr          S               *
     D retVal          S               N   inz(*on)
      /free
       if (%parms() = 4);

         if (isLinkedListImpl(listPtr));
           // check if the position is outside of the list
           if (pos < 0 or pos > header.size -1);
             sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           endif;

           nextEntryPtr = getListEntryDs(listPtr : pos);
           if (nextEntryPtr <> *null);
             if (nextEntry.prev <> *null);
               prevEntryPtr = nextEntry.prev;
             else;
               // must be the start of the list (which has no previous entry)
             endif;

             //
             // create new entry
             //

             // alloc memory for this entry
             cee_getStorage(header.heapId:%size(tmpl_entry):newEntryPtr:*omit);
             newEntry.length = length + 1;     // +1 for the null value
             cee_getStorage(header.heapId : length + 1 : newEntry.value :*omit);
             newEntry.next = *null;
             newEntry.prev = *null;

             // copy value to the list entry
             memcpy(newEntry.value : ptrValue : length);

             // set null to the last byte
             tmpPtr = newEntry.value + length;
             memcpy(tmpPtr : %addr(hexNull) : 1);

             // set pointers so that the list is correctly linked again
             newEntry.prev = prevEntryPtr;
             newEntry.next = nextEntryPtr;
             nextEntry.prev = newEntryPtr;
             if (prevEntryPtr <> *null);
               prevEntry.next = newEntryPtr;
             endif;

             // update header
             header.size += 1;
             if (newEntry.prev = *null);
               header.firstEntry = newEntryPtr;
             endif;

           else;
             // could not get entry at given position
             retVal = *off;
           endif;

         else;
           retVal = *off;
         endif;

       else; // append to the end of the list
         retVal = list_addLast(listPtr : ptrValue : length);
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Add list entry to the top of the list
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to new value
      * \param Length of new value
      *
      * \return *on = successful <br>
      *         *off = error
      */
     P list_addFirst   B                   export
     D                 PI              N
     D   listPtr                       *
     D   valuePtr                      *   const
     D   length                      10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D newEntryPtr     S               *
     D newEntry        DS                  likeds(tmpl_entry)
     D                                     based(newEntryPtr)
     D nextEntryPtr    S               *
     D nextEntry       DS                  likeds(tmpl_entry)
     D                                     based(nextEntryPtr)
     D tmpPtr          S               *
     D retVal          S               N   inz(*on)
      /free
       if (isLinkedListImpl(listPtr));

         //
         // create new entry
         //

         // alloc memory for this entry
         cee_getStorage(header.heapId:%size(tmpl_entry):newEntryPtr:*omit);
         newEntry.length = length + 1;     // +1 for the null value
         cee_getStorage(header.heapId : length + 1 : newEntry.value :*omit);
         newEntry.next = *null;
         newEntry.prev = *null;

         // copy value to the list entry
         memcpy(newEntry.value : valuePtr : length);

         // add null
         tmpPtr = newEntry.value + length;
         memcpy(tmpPtr : %addr(hexNull) : 1);

         if (header.size > 0);
           nextEntryPtr = getListEntryDs(listPtr : 0);
           nextEntry.prev = newEntryPtr;
           newEntry.next = nextEntryPtr;
         endif;

         // update header
         header.size += 1;
         header.firstEntry = newEntryPtr;
         if (header.size = 1);
           header.lastEntry = newEntryPtr;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Add list entry to the end of the list
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to new value
      * \param Length of new value
      *
      * \return *on = successful <br>
      *         *off = error
      */
     P list_addLast    B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   length                      10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D newEntryPtr     S               *
     D newEntry        DS                  likeds(tmpl_entry)
     D                                     based(newEntryPtr)
     D prevEntryPtr    S               *
     D prevEntry       DS                  likeds(tmpl_entry)
     D                                     based(prevEntryPtr)
     D tmpPtr          S               *
     D retVal          S               N   inz(*on)
      /free
       if (isLinkedListImpl(listPtr));

         //
         // create new entry
         //

         // alloc memory for this entry
         cee_getStorage(header.heapId:%size(tmpl_entry):newEntryPtr:*omit);
         newEntry.length = length + 1;     // +1 for the null value
         cee_getStorage(header.heapId : length + 1 : newEntry.value :*omit);
         newEntry.next = *null;
         newEntry.prev = *null;

         // copy value to the list entry
         memcpy(newEntry.value : valuePtr : length);

         // add null
         tmpPtr = newEntry.value + length;
         memcpy(tmpPtr : %addr(hexNull) : 1);

         if (header.size > 0);
           prevEntryPtr = getListEntryDs(listPtr : header.size -1);
           prevEntry.next = newEntryPtr;
           newEntry.prev = prevEntryPtr;
         endif;

         // update header
         header.size += 1;
         header.lastEntry = newEntryPtr;
         if (header.size = 1);
           header.firstEntry = newEntryPtr;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Add all elements of a list
      *
      * Adds all elements of the passed list to the end of this list.
      * Elements will not be referenced but storage newly allocated.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the destination list
      * \param Pointer to the source list
      *
      * \return *on = all elements added to list <br>
      *         *off = not all or none elements added
      */
     P list_addAll     B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   srcListPtr                    *   const
      *
     D retVal          S               N   inz(*on)
     D header          DS                  likeds(tmpl_header) based(srcListPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
      /free
       if (isLinkedListImpl(listPtr) and
           isLinkedLIstImpl(srcListPtr));

         entryPtr = header.firstEntry;
         dow (entryPtr <> *null);

           // entry.length -1 => dont include the null value
           if (not list_add(listPtr : entry.value : entry.length-1));
             retVal = *off;
             leave;
           endif;

           entryPtr = entry.next;
         enddo;
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Remove list entry
      *
      * Removes an entry from the list at the given position. If the
      * position is outside of the list the return value will be <em>*off</em>.
      *
      * <br><br>
      *
      * The index is 0 (zero) based.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      * \param index of the entry in the list (zero-based)
      *
      * \return *on = entry removed
      *         *off = error
      */
     P list_remove     B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D nextEntryPtr    S               *
     D nextEntry       DS                  likeds(tmpl_entry)
     D                                     based(nextEntryPtr)
     D prevEntryPtr    S               *
     D prevEntry       DS                  likeds(tmpl_entry)
     D                                     based(prevEntryPtr)
     D retVal          S               N   inz(*on)

      /free
       if (isLinkedListImpl(listPtr));

         // check if the position is outside of the list
         if (index < 0 or index > header.size -1);
           return *off;
         endif;

         ptr = getListEntryDs(listPtr : index);
         if (ptr = *null);
           return *off;
         endif;

         nextEntryPtr = entry.next;
         prevEntryPtr = entry.prev;

         if (prevEntryPtr <> *null);
           prevEntry.next = nextEntryPtr;
         endif;

         if (nextEntryPtr <> *null);
           nextEntry.prev = prevEntryPtr;
         endif;

         // free memory
         cee_freeStorage(entry.value : *omit);
         cee_freeStorage(ptr : *omit);

         // update header
         header.size -= 1;
         if (nextEntryPtr = *null);
           header.lastEntry = prevEntryPtr;
         endif;
         if (prevEntryPtr = *null);
           header.firstEntry = nextEntryPtr;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Remove first list entry
      *
      * Removes the first entry from the list.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      *
      * \return *on = entry removed <br>
      *         *off = error
      */
     P list_removeFirst...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const

      /free
       return list_remove(listPtr : 0);
      /end-free
     P                 E


     /**
      * \brief Remove last list entry
      *
      * Removes the last entry from the list.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      *
      * \return *on = entry removed <br>
      *         *off = error (escape message)
      */
     P list_removeLast...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D retVal          S               N   inz(*off)

      /free
       if (isLinkedListImpl(listPtr));
         retVal = list_remove(listPtr : header.size - 1);
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Clear list
      *
      * Deletes all entries in the list.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      *
      * \return *on = successful <br>
      *         *off = error
      */
     P list_clear      B                   export
     D                 PI              N
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D tmpPtr          S               *
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D retVal          S               N   inz(*off)
      /free
       if (isLinkedListImpl(listPtr));

         ptr = header.lastEntry;
         dow (ptr <> *null);
           tmpPtr = entry.prev;

           if (entry.value <> *null);
             cee_freeStorage(entry.value : *omit);
           endif;

           cee_freeStorage(ptr : *omit);
           ptr = tmpPtr;
         enddo;

         // update header
         header.size = 0;
         header.firstEntry = *null;
         header.lastEntry = *null;
         header.bytes = %size(tmpl_header);
         header.iteration = -1;
         header.iterNextEntry = *null;
         header.iterPrevEntry = *null;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get next entry
      *
      * Iterates through the list and gets the next entry. If the iterator is
      * at the end of the list this method will return <em>null</em>. The
      * iteration can be aborted early with the procedure <em>
      * list_resetIteration</em>.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      *
      * \return Pointer to entry or *null if no more entries in list
      *
      * \deprecated Use <em>list_iterate</em> instead.
      */
     P list_getNext    B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
      /free
       return list_iterate(listPtr);
      /end-free
     P                 E


     /**
      * \brief Iterate list
      *
      * Iterates through the list and returns the next entry. If the iterator is
      * at the end of the list this method will return <em>null</em>. The
      * iteration can be aborted early with the procedure <em>list_resetIteration</em>.
      *
      * \author Mihael Schmidt
      * \date   19.2.2011
      *
      * \param Pointer to the list
      *
      * \return Pointer to entry or *nµll if no more entries in list
      */
     P list_iterate    B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D retVal          S               *
      /free
       if (isLinkedListImpl(listPtr));

         if (header.iteration + 1 = header.size);
           list_resetIteration(listPtr);
           retVal = *null;
         else;
           header.iteration += 1;

           if (header.iterNextEntry = *null);
             entryPtr = getListEntryDs(listPtr : header.iteration);
           else;
             entryPtr = header.iterNextEntry;
           endif;

           header.iterNextEntry = entry.next;
           header.iterPrevEntry = entry.prev;

           retVal = entry.value;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get previous entry
      *
      * Iterates through the list and gets the previous entry. If the iterator is
      * before the start of the list this method will return <em>null</em>. The
      * iteration can be aborted early with the procedure <em>list_resetIteration</em>.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      *
      * \return Pointer to entry or *null if no more entries in list
      */
     P list_getPrev    B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D retVal          S               *
      /free
       if (isLinkedListImpl(listPtr));

         if (header.iteration = 0);
           list_resetIteration(listPtr);
           retVal = *null;
         else;

           if (header.iteration = -1);
             header.iteration = header.size;
           endif;

           header.iteration -= 1;

           if (header.iterPrevEntry = *null);
             entryPtr = getListEntryDs(listPtr : header.iteration);
           else;
             entryPtr = header.iterPrevEntry;
           endif;

           if (entryPtr = *null);
             retVal = *null;
           else;
             header.iterNextEntry = entry.next;
             header.iterPrevEntry = entry.prev;

             retVal = entry.value;
           endif;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Abort iteration
      *
      * If the iteration through the list should be aborted early this
      * procedure should be called.
      *
      * \author Mihael Schmidt
      * \date   18.12.2007
      *
      * \param Pointer to the list
      * 
      * \deprecated Use <em>list_resetIteration</em> instead.
      */
     P list_abortIteration...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
      /free
       list_resetIteration(listPtr);
      /end-free
     P                 E


     /**
      * \brief Reset iteration
      *
      * Resets the internal iteration state of the list so that the next 
      * call to <em>list_iterate</em> will return the first element.
      *
      * \author Mihael Schmidt
      * \date   19.2.2011
      *
      * \param Pointer to the list
      */
     P list_resetIteration...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
      /free
       if (isLinkedListImpl(listPtr));
         header.iteration = -1;
         header.iterNextEntry = *null;
         header.iterPrevEntry = *null;
       endif;
      /end-free
     P                 E


     /**
      * \brief Replaces an entry in the list
      *
      * An element in the list will be replaced. If there is no element
      * at that position the return value will be <em>*off</em>.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to new value
      * \param Length of new value
      * \param index of new value
      *
      * \return *on = entry successfully replaced <br>
      *         *off = error
      */
     P list_replace    B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   ptrValue                      *   const
     D   lengthValue                 10U 0 const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D retVal          S               N   inz(*on)
      /free
       if (isLinkedListImpl(listPtr));

         // check if the position is outside of the list
         if (index < 0 or index > header.size -1);
           return *off;
         endif;

         entryPtr = getListEntryDs(listPtr : index);
         entry.length = lengthValue + 1;
         cee_reallocateStorage(entry.value : lengthValue + 1 : *omit); // +1 for the null byte

         // copy value to the list entry
         memcpy(ptrValue : entry.value : lengthValue);

         // set null to the last byte
         memcpy(entry.value + lengthValue : %addr(hexNull) : 1);
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Contains entry
      *
      * Checks if this list contains the passed entry.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to value
      * \param Length of value
      *
      * \return *on = list contains value <br>
      *         *off = list does not contain value
      */
     P list_contains   B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D retVal          S               N   inz(*off)
      /free
       if (isLinkedListImpl(listPtr));

         entryPtr = header.firstEntry;
         dow (entryPtr <> *null);
           if (valueLength = entry.length - 1 and
               memcmp(valuePtr : entry.value : valueLength) = 0); // dont include the null
             retVal = *on;
             leave;
           endif;

           entryPtr = entry.next;
         enddo;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Check if list is empty
      *
      * Checks if the list is empty.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      *
      * \return *on = list is empty <br>
      *         *off = list is not empty
      */
     P list_isEmpty    B                   export
     D                 PI              N
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D retVal          S               N
      /free
       if (isLinkedListImpl(listPtr));

         if (header.size = 0);
           retVal = *on;
         else;
           retVal = *off;
         endif;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get entry
      *
      * Returns a list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Pointer to a null terminated string or
      *         *null if an error occured or there is no
      *         entry at that position
      */
     P list_get        B                   export
     D                 PI              *
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D retVal          S               *
     D tmp             S           1000A   based(entry.value)
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           return *null;
         elseif (index < 0 or index > header.size -1);
           return *null;
         endif;

         entryPtr = getListEntryDs(listPtr : index);
         retVal = entry.value;
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get first entry
      *
      * Returns the first entry of the list.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      *
      * \return Pointer to a null terminated string or
      *         *null if the list is empty or an error occured
      */
     P list_getFirst   B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
     D retVal          S               *   inz(*null)
      /free
       if (isLinkedListImpl(listPtr));
         retVal = list_get(listPtr : 0);
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Get last entry
      *
      * Returns the last entry of the list.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      *
      * \return Pointer to a null terminated string or
      *         *null if the list is empty or an error occured
      */
     P list_getLast    B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D retVal          S               *   inz(*null)
      /free
       if (isLinkedListImpl(listPtr));
         retVal = list_get(listPtr : header.size -1);
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Index of entry
      *
      * Returns the index of the passed entry or -1 if the entry could not
      * be found in the list.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to the value
      * \param Length of the value
      *
      * \return index of the entry or -1 if entry not in list
      */
     P list_indexOf    B                   export
     D                 PI            10I 0
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D i               S             10I 0 inz(-1)
     D retVal          S             10I 0 inz(-1)
      /free
       if (isLinkedListImpl(listPtr));

         entryPtr = header.firstEntry;
         dow (entryPtr <> *null);
           i += 1;

           if (valueLength = entry.length - 1 and
               memcmp(valuePtr : entry.value : valueLength) = 0); // dont include the null
             retVal = i;
             leave;
           endif;

           entryPtr = entry.next;
         enddo;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Last index of entry
      *
      * Returns the last indes of the passed entry or -1 if the entry
      * could not be found in the list.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to the value
      * \param Length of the value
      *
      * \return index of the entry or -1 if entry not in list
      */
     P list_lastIndexOf...
     P                 B                   export
     D                 PI            10I 0
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D i               S             10I 0
     D retVal          S             10I 0 inz(-1)
      /free
       if (isLinkedListImpl(listPtr));

         entryPtr = header.lastEntry;
         i = header.size;
         dow (entryPtr <> *null);
           i -= 1;

           if (valueLength = entry.length - 1 and
               memcmp(valuePtr : entry.value : valueLength) = 0); // dont include the null
             retVal = i;
             leave;
           endif;

           entryPtr = entry.prev;
         enddo;

       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief To character array
      *
      * Copies all entries of this list to the passed array. Entries will be
      * truncated if they are too big for the array. If the array is not big
      * enough, the last entries will be silently dropped.
      *
      * \author Mihael Schmidt
      * \date   19.12.2007
      *
      * \param Pointer to the list
      * \param Pointer to the array
      * \param Element count
      * \param Element length
      *
      */
     P list_toCharArray...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
     D   arrayPtr                      *   const
     D   count                       10U 0 const
     D   length                      10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D i               S             10I 0
     D arrayElemPtr    S               *
     D tmpLength       S             10I 0
      /free
       if (isLinkedListImpl(listPtr));
         if (header.size = 0);
           return;
         endif;

         for i = 0 to header.size;
           if (count > i);
             entryPtr = getListEntryDs(listPtr : i);
             arrayElemPtr = arrayPtr + (i * length);

             if (entry.length < length);
               tmpLength = entry.length;
             else;
               tmpLength = length;
             endif;

             memcpy(arrayElemPtr : entry.value : tmpLength);

           endif;
         endfor;

       endif;
      /end-free
     P                 E


     /**
      * \brief Check for linked list implementation
      *
      * Checks if the pointer points to a linked list implementation.
      * The linked list implementation of this service program has
      * an id in the first 20 bytes of the list header.
      *
      * <br><br>
      *
      * If the pointer does not point to a list implementation an
      * escape message will be sent.
      *
      * \author Mihael Schmidt
      * \date   23.12.2007
      *
      * \param Pointer to the list
      *
      * \return *on = is linked list implementation <br>
      *         *off = is no linked list implementation (escape message)
      */
     P isLinkedListImpl...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D isList          S               N
      /free
       monitor;
         if (header.id = LIST_ID);
           isList = *on;
         else;
           isList = *off;
         endif;

         on-error *all;
           isList = *off;
       endmon;

       if (not isList);
         sendEscapeMessage(MSG_NO_LIST_IMPL);
       endif;

       return isList;
      /end-free
     P                 E


     /**
      * \brief Send Escape Message
      *
      * Sends an escape message with the specified id.
      *
      * \author Mihael Schmidt
      * \date   23.12.2007
      *
      * \param Message id
      */
     P sendEscapeMessage...
     P                 B                   export
     D                 PI
     D   id                          10I 0 const
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
       if (id = MSG_NO_LIST_IMPL);
         msgdata = 'The pointer does not point to a list data structure.';
       elseif (id = MSG_POSITION_OUT_OF_BOUNDS);
         msgdata = 'The index points outside the list. No such element in ' +
                   'the list.';
       elseif (id = MSG_INVALID_VALUE_TYPE);
         msgdata = 'The requested type does not correspond to the list ' +
                   'entry type.';
       endif;

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


     /**
      * \brief Get list entry data structure
      *
      * Returns the data structure of a list entry.
      *
      * \author Mihael Schmidt
      * \date   23.12.2007
      *
      * \param Pointer to the list
      * \param List position (zero-based)
      *
      * \return Pointer to list entry or *null
      */
     P getListEntryDs...
     P                 B                   export
     D                 PI              *
     D   listPtr                       *   const
     D   pos                         10I 0 const
      *
     D i               S             10I 0
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
      /free
       monitor;
         if (pos < header.size / 2);
           // walk through the list from the start to the end
           entryPtr = header.firstEntry;
           for i = 0 to pos-1;
             if (entryPtr = *null);
               leave;
             endif;

             entryPtr = entry.next;
           endfor;

         else;
           // walk through the list from the end to the start
           entryPtr = header.lastEntry;
           for i = header.size -1 downto pos + 1;
             if (entryPtr = *null);
               leave;
             endif;

             entryPtr = entry.prev;
           endfor;

         endif;

         on-error *all;
           entryPtr = *null;
       endmon;

       return entryPtr;
      /end-free
     P                 E

     /**
      * \brief Get list size
      *
      * Returns the number elements in the list.
      *
      * \author Mihael Schmidt
      * \date   16.01.2008
      *
      * \param Pointer to the list
      *
      * \return number of elements in the list or -1 if an error occurs
      */
     P list_size       B                   export
     D                 PI            10U 0
     D  listPtr                        *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
      /free
       if (isLinkedListImpl(listPtr));
         return header.size;
       else;
         return -1;
       endif;
      /end-free
     P                 E


     /**
      * \brief Create sublist
      *
      * Creates a list with copies of a part of the passed list.
      *
      * \author Mihael Schmidt
      * \date   16.1.2008
      *
      * \param Pointer to the list
      * \param start of the index to copy
      * \param number of elements to copy
      *
      * \return new list
      */
     P list_sublist    B                   export
     D                 PI              *
     D   listPtr                       *   const
     D   startIndex                  10U 0 const
     D   length                      10U 0 const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D newListPtr      S               *
     D i               S             10I 0
     D endIndex        S             10I 0
      /free
       if (isLinkedListImpl(listPtr));

         if (%parms() = 2);
           endIndex = header.size -1;
         else;
           endIndex = startIndex + length - 1;
         endif;

         if (startIndex < 0);
           return *null;
         endif;

         newListPtr = list_create();

         entryPtr = getListEntryDs(listPtr : startIndex);

         for i = startIndex to endIndex;
           if (header.size > i);
             list_add(newListPtr : entry.value : entry.length - 1);
             entryPtr = entry.next;
           else;
             leave;
           endif;
         endfor;

         return newListPtr;

       else;
         return *null;
       endif;
      /end-free
     P                 E


     /**
      * \brief Rotate list by n positions
      *
      * Rotatas items in the list by the given number.
      *
      * <br><br>
      *
      * The elements from the end will be pushed to the front.
      * A rotation of one will bring the last element to the first
      * position and the first element will become the second element
      * (pushed one position down the list).
      *
      * <br><br>
      *
      * Only a forward rotation is possible. No negative number of
      * rotations are valid.
      *
      * <br><br>
      *
      * The number of rotations may even be greater than the size of
      * the list. Example: List size 4, rotation number 5 = rotation
      * number 1.
      *
      * \author Mihael Schmidt
      * \date   23.01.2008
      *
 ‡    * \param Pointer to the list
      * \param Number positions to rotate list
      */
     P list_rotate     B                   export
     D                 PI
     D   listPtr                       *   const
     D   rotatePos                   10I 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D newStartPtr     S               *
     D newStartEntry   DS                  likeds(tmpl_entry) based(newStartPtr)
     D newEndPtr       S               *
     D newEndEntry     DS                  likeds(tmpl_entry) based(newEndPtr)
     D firstPtr        S               *
     D firstEntry      DS                  likeds(tmpl_entry) based(firstPtr)
     D lastPtr         S               *
     D lastEntry       DS                  likeds(tmpl_entry) based(lastPtr)
     D absRotPos       S             10I 0
      /free
       if (isLinkedListImpl(listPtr));
         if (header.size = 0);
           return;
         endif;

         absRotPos = %rem(rotatePos : list_size(listPtr));

         if (absRotPos > 0);
           firstPtr = header.firstEntry;
           lastPtr = header.lastEntry;

           // connect the ends of the list
           firstEntry.prev = lastPtr;
           lastEntry.next = firstPtr;

           // set new start entry
           newStartPtr = getListEntryDs(listPtr :
                                        list_size(listPtr) - absRotPos);
           // set new end entry
           newEndPtr = newStartEntry.prev;

           // disconnect new end and new start entry
           newEndEntry.next = *null;
           newStartEntry.prev = *null;

           // update header
           header.firstEntry = newStartPtr;
           header.lastEntry = newEndPtr;
         endif;

       endif;
      /end-free
     P                 E


     /**
      * \brief Swap list items
      *
      *
      * \author Mihael Schmidt
      * \date   23.01.2008
      *
      * \param Pointer to the list
      * \param List item to swap
      * \param List item to swap
      */
     P list_swap       B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   itemPos1                    10U 0 const
     D   itemPos2                    10U 0 const
      /free
       if (isLinkedListImpl(listPtr));
         return internal_swap(listPtr : itemPos1 : itemPos2);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     P internal_swap   B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   itemPos1                    10U 0 const options(*omit)
     D   itemPos2                    10U 0 const options(*omit)
     D   itemPtr1                      *   const options(*nopass)
     D   itemPtr2                      *   const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
      *
     D entryPtr1       S               *
     D entry1          DS                  likeds(tmpl_entry) based(entryPtr1)
     D entryPtr1P      S               *
     D entry1P         DS                  likeds(tmpl_entry) based(entryPtr1P)
     D entryPtr1N      S               *
     D entry1N         DS                  likeds(tmpl_entry) based(entryPtr1N)
      *
     D entryPtr2       S               *
     D entry2          DS                  likeds(tmpl_entry) based(entryPtr2)
     D entryPtr2P      S               *
     D entry2P         DS                  likeds(tmpl_entry) based(entryPtr2P)
     D entryPtr2N      S               *
     D entry2N         DS                  likeds(tmpl_entry) based(entryPtr2N)
      *
     D tmpPtr          S               *
      /free
       if (%parms() = 3);

         // check both items point to the same entry
         if (itemPos1 = itemPos2);
           return *on;
         endif;

         // check if item is out of bounds
         if (itemPos1 < 0 or
             itemPos2 < 0 or
             itemPos1 >= header.size or
             itemPos2 >= header.size);
           return *off;
         endif;

         entryPtr1 = getListEntryDs(listPtr : itemPos1);
         entryPtr2 = getListEntryDs(listPtr : itemPos2);

       elseif (%parms() = 5);
         entryPtr1 = itemPtr1;
         entryPtr2 = itemPtr2;
       else;
         return *off;
       endif;

         // check if the entries are valid
         if (entryPtr1 <> *null and entryPtr2 <> *null);
           entryPtr1P = entry1.prev;
           entryPtr1N = entry1.next;
           entryPtr2P = entry2.prev;
           entryPtr2N = entry2.next;


           // check if the two nodes are neighbouring nodes
           if (entry1.next = entryPtr2);
             entry1.next = entry2.next;
             entry2.next = entryPtr1;

             entry2.prev = entry1.prev;
             entry1.prev = entryPtr2;

             if (entryPtr1P <> *null);
               entry1P.next = entryPtr2;
             endif;

             if (entryPtr2N <> *null);
               entry2N.prev = entryPtr1;
             endif;

           elseif (entry1.prev = entryPtr2); // neighbouring nodes (other way round)
             entry2.next = entry1.next;
             entry1.next = entryPtr2;

             entry1.prev = entry2.prev;
             entry2.prev = entryPtr1;


             if (entryPtr1N <> *null);
               entry1N.prev = entryPtr2;
             endif;

             if (entryPtr2P <> *null);
               entry2P.next = entryPtr1;
             endif;

           else; // no neighbours
             tmpPtr = entry1.next;
             entry1.next = entry2.next;
             entry2.next = tmpPtr;

             tmpPtr = entry1.prev;
             entry1.prev = entry2.prev;
             entry2.prev = tmpPtr;

             if (entryPtr1P <> *null);
               entry1P.next = entryPtr2;
             endif;

             if (entryPtr1N <> *null);
               entry1N.prev = entryPtr2;
             endif;

             if (entryPtr2P <> *null);
               entry2P.next = entryPtr1;
             endif;

             if (entryPtr2N <> *null);
               entry2N.prev = entryPtr1;
             endif;

           endif;


           if (entry1.prev = *null);         // check if it is the first item
             header.firstEntry = entryPtr1;
           endif;

           if (entry2.prev = *null);         // check if it is the first item
             header.firstEntry = entryPtr2;
           endif;

           if (entry1.next = *null);         // check if it is the last item
             header.lastEntry = entryPtr1;
           endif;

           if (entry2.next = *null);         // check if it is the last item
             header.lastEntry = entryPtr2;
           endif;

           return *on;
         else;
           return *off;
         endif;

      /end-free
     P                 E


     /**
      * \brief Execute procedure for every list item
      *
      * The passed procedure will be executed for every item
      * in the list.
      *
      * <br><br>
      *
      * The user can pass data through a pointer to the procedure.
      * The pointer will not be touched by this procedure itself, so it
      * can be *null.
      *
      * <br><br>
      *
      * The value of list entry can be changed through the passed procedure
      * but not the size of the entry/allocated memory.
      *
      * \author Mihael Schmidt
      * \date   23.01.2008
      *
      * \param Pointer to the list
      * \param Procedure pointer
      * \param Pointer to user data (optional)
      */
     P list_foreach...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
     D   procPtr                       *   const procptr
     D   userData                      *   const options(*nopass)
      *
     D foreachProc     PR                  extproc(procPtr)
     D   valuePtr                      *   const
     D   userData                      *   const options(*nopass)
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D userDataPassed  S               N
      /free
       userDataPassed = (%parms() = 3);
      
       if (isLinkedListImpl(listPtr));
         ptr = header.firstEntry;
         dow (ptr <> *null);
         
           if (userDataPassed);
             foreachProc(entry.value : userData);
           else;
             foreachProc(entry.value);
           endif;
           
           ptr = entry.next;
         enddo;
       endif;
      /end-free
     P                 E


     /**
      * \brief Return character representation of list
      *
      * Returns a string with the list items separated either by
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
      * \author Mihael Schmidt
      * \date   08.02.2008
      *
      * \param Pointer to the list
      * \param separator (default: ,)
      * \param enclosing character (default: nothing)
      * \param enclosing character at the end of item (default: nothing)
      *
      * \return character representation of all list items
      */
     P list_toString   B                   export
     D                 PI         65535A   varying
     D   listPtr                       *   const
     D   pSeparator                   1A   const varying options(*omit:*nopass)
     D   pEnclosing                 100A   const varying options(*nopass)
     D   pEnclosingEnd...
     D                              100A   const varying options(*nopass)
      *
     D noSeparator     S               n   inz(*off)
     D separator       S              1A   inz(',')
     D enclosingStart...
     D                 S            100A   varying
     D enclosingEnd...
     D                 S            100A   varying
     D valuePtr        S               *
     D retVal          S          65535A   varying
      /free
       if (isLinkedListImpl(listPtr));

         // check if separator is passed
         if (%parms() >= 2 and %addr(pSeparator) <> *null);
           noSeparator = (%len(pSeparator) = 0);
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

         // process list items
         valuePtr = list_getNext(listPtr);
         dow (valuePtr <> *null);
           if (noSeparator);
             retVal += enclosingStart + %str(valuePtr) + enclosingEnd;
           else;
             retVal += enclosingStart + %str(valuePtr) + enclosingEnd +
                       separator;
           endif;

           valuePtr = list_getNext(listPtr);
         enddo;

         // remove the last separator
         if (not noSeparator and %len(retVal) > 0);
           %len(retVal) = %len(retVal) -1;
         endif;
       endif;

       return retVal;
      /end-free
     P                 E


     /**
      * \brief Split character string
      *
      * The passed character string will be split into tokens by either
      * a passed or the default separator. All tokens will be added to
      * a new list which will be returned.
      *
      * <br><br>
      *
      * Empty (but not blank) values will be dropped silently.
      *
      * \author Mihael Schmidt
      * \date   08.02.2008
      *
      * \param Character string (null-terminated)
      * \param Separator (default: ;)
      *
      * \return Pointer to the filled list
      */
     P list_split      B                   export
     D                 PI              *   opdesc
     D   pString                  65535A   const options(*varsize)
     D   pSeparator                   1A   const options(*nopass)
      *
     D descType        S             10I 0
     D dataType        S             10I 0
     D descInfo1       S             10I 0
     D descInfo2       S             10I 0
     D length          S             10I 0
      *
     D list            S               *
     D token           S               *
     D separator       S              1A   inz(';')
     D string          S          65535A   inz(*blank)
      /free
       cee_getOpDescInfo(1 : descType : dataType : descInfo1 : descInfo2 :
                         length : *omit);
       string = %subst(pString : 1 : length);

       if (%parms() = 2);
         separator = pSeparator;
       endif;

       list = list_create();

       token = getToken(string : separator);
       dow (token <> *null);
         list_add(list : token : getStringLength(token));
         token = getToken(*null : separator);
       enddo;

       return list;
      /end-free
     P                 E


     /**
      * \brief Reverse list
      *
      * Reverse the order of the list by simply switching the previous and
      * next pointers of each element.
      *
      * \param Pointer to the list
      */
     P list_reverse    B                   export
     D                 PI
     D listPtr                         *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D ptr             S               *
     D entry           DS                  likeds(tmpl_entry) based(ptr)
     D tmp             S               *
      /free
       ptr = header.lastEntry;

       dow (ptr <> *null);
         tmp = entry.prev;
         entry.prev = entry.next;
         entry.next = tmp;
         ptr = tmp;
       enddo;

       // update header
       tmp = header.firstEntry;
       header.firstEntry = header.lastEntry;
       header.lastEntry = tmp;
      /end-free
     P                 E


     /**
      * \brief Create a copy of a list
      *
      * Creates a list with copies of all elements of the list.
      *
      * \author Mihael Schmidt
      * \date   7.4.2008
      *
      * \param Pointer to the list
      *
      * \return Pointer to te new list
      */
     P list_copy       B                   export
     D                 PI              *
     D   listPtr                       *   const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D newListPtr      S               *   inz(*null)
      /free
       if (isLinkedListImpl(listPtr));

         newListPtr = list_create();

         entryPtr = header.firstEntry;

         dow (entryPtr <> *null);
           list_add(newListPtr : entry.value : entry.length - 1);
           entryPtr = entry.next;
         enddo;

         return newListPtr;

       endif;

       return newListPtr;
      /end-free
     P                 E


     /**
      * \brief Frequency of a value in the list
      *
      * Returns the number of times the passed value
      * can be found in the list.
      *
      * \author Mihael Schmidt
      * \date   05.04.2008
      *
      * \param Pointer to the list
      * \param Pointer to the value
      * \param Length of the value
      *
      * \return number of copies of passed value in the list
      */
     P list_frequency...
     P                 B                   export
     D                 PI            10U 0
     D   listPtr                       *   const
     D   valuePtr                      *   const
     D   valueLength                 10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D count           S             10U 0 inz(0)
      /free
       if (isLinkedListImpl(listPtr));

         entryPtr = header.firstEntry;
         dow (entryPtr <> *null);

           if (valueLength = entry.length - 1 and
               memcmp(valuePtr : entry.value : valueLength) = 0); // dont include the null
             count += 1;
           endif;

           entryPtr = entry.next;
         enddo;

       endif;

       return count;
      /end-free
     P                 E


     /**
      * \brief Add character list entry
      *
      * Adds a character entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Character value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addString...
     P                 B                   export
     D                 PI              N   opdesc
     D   listPtr                       *   const
     D   value                    65535A   const options(*varsize)
     D   index                       10U 0 const options(*nopass)
      *
     D descType        S             10I 0
     D dataType        S             10I 0
     D descInfo1       S             10I 0
     D descInfo2       S             10I 0
     D length          S             10I 0
      *
     D string          S          65535A   inz(*blank)
      /free
       cee_getOpDescInfo(2 : descType : dataType : descInfo1 : descInfo2 :
                         length : *omit);
       string = %subst(value : 1 : length);

       if (%parms() = 2);
         return list_add(listPtr : %addr(string) : length);
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(string) : length : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add integer list entry
      *
      * Adds an integer entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Integer value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addInteger...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                       10I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D integer         S             10I 0
      /free
       integer = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(integer) : 4);
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(integer) : 4 : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add long list entry
      *
      * Adds a long entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Long value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addLong...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                       20I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S             20I 0
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : 8);
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : 8 : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add short list entry
      *
      * Adds a short entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Short value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addShort...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                        5I 0 const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S              5I 0
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : 2);
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : 2 : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add float list entry
      *
      * Adds a float entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Float value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addFloat...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                        4F   const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S              4F
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : %size(local));
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : %size(local) : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add double list entry
      *
      * Adds a double entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Double value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addDouble...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                        8F   const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S              8F
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : %size(local));
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : %size(local) : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add boolean list entry
      *
      * Adds a boolean entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Boolean value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addBoolean...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                         N   const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S               N
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : %size(local));
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : %size(local) : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add packed decimal list entry
      *
      * Adds a packed decimal entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Packed decimal value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addDecimal...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                       15P 5 const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S             15P 5
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : %size(local));
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : %size(local) : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Add date list entry
      *
      * Adds a date entry to the list. If the position is outside the list
      * the procedure returns <em>*off</em>. The current entry of the list at
      * that position will be pushed one position down the list.
      *
      * <br><br>
      *
      * If no position is passed to the procedure then the entry will be
      * appended to the end of the list (like <em>addLast</em>).
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param Date value
      * \param List position for the new value (optional)
      *
      * \return *on = entry added the list <br>
      *         *off = error
      */
     P list_addDate...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   value                         D   const
     D   index                       10U 0 const options(*nopass)
      *
     D local           S               D
      /free
       local = value;

       if (%parms() = 2);
         return list_add(listPtr : %addr(local) : %size(local));
       elseif (%parms() = 3);
         return list_add(listPtr : %addr(local) : %size(local) : index);
       else;
         return *off;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get character entry
      *
      * Returns a character list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Character string of the specified position
      */
     P list_getString...
     P                 B                   export
     D                 PI         65535A
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S          65535A   based(entry.value)
     D testVar         S          65535A
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *blank;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *blank;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = %subst(temp : 1 : entry.length - 1); // subtract the appended null value
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *blank;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get integer entry
      *
      * Returns an integer list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Integer value of the specified position
      */
     P list_getInteger...
     P                 B                   export
     D                 PI            10I 0
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S             10I 0 based(entry.value)
     D testVar         S             10I 0
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> 4);  // integer = 4 byte
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get short entry
      *
      * Returns a short list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Short value of the specified position
      */
     P list_getShort...
     P                 B                   export
     D                 PI             5I 0
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S              5I 0 based(entry.value)
     D testVar         S              5I 0
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> 2);  // short = 2 byte
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get long entry
      *
      * Returns a long list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \parem Pointer to the list
      * \param List position
      *
      * \return Long value of the specified position
      */
     P list_getLong...
     P                 B                   export
     D                 PI            20I 0
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S             20I 0 based(entry.value)
     D testVar         S             20I 0
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> 8);  // long = 8 byte
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**ç
      * \brief Get float entry
      *
      * Returns a float list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Float value of the specified position
      */
     P list_getFloat...
     P                 B                   export
     D                 PI             4F
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S              4F   based(entry.value)
     D testVar         S              4F
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> %size(temp));
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get double entry
      *
      * Returns a double list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Double value of the specified position
      */
     P list_getDouble...
     P                 B                   export
     D                 PI             8F
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
    ‡D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S              8F   based(entry.value)
     D testVar         S              8F
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> %size(temp));
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get boolean entry
      *
      * Returns a boolean list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Boolean value of the specified position
      */
     P list_getBoolean...
     P                 B                   export
     D                 PI              N
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S               N   based(entry.value)
     D testVar         S               N
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> 1);
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get packed decimal entry
      *
      * Returns a packed decimal list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Packed decimal value of the specified position
      */
     P list_getDecimal...
     P                 B                   export
     D                 PI            15P 5
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S             15P 5 based(entry.value)
     D testVar         S             15P 5
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> %size(temp));
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Get date entry
      *
      * Returns a date list entry specified by the passed index.
      *
      * \author Mihael Schmidt
      * \date   21.09.2008
      *
      * \param Pointer to the list
      * \param List position
      *
      * \return Date value of the specified position
      */
     P list_getDate...
     P                 B                   export
     D                 PI              D
     D   listPtr                       *   const
     D   index                       10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
     D temp            S               D   based(entry.value)
     D testVar         S               D
      /free
       if (isLinkedListImpl(listPtr));
         // check if list is empty or the position is outside of the list
         if (header.size = 0);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         elseif (index < 0 or index > header.size -1);
           sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
           return *loval;
         endif;

         entryPtr = getListEntryDs(listPtr : index);

         if (entry.length -1 <> %size(temp));
           sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
         endif;

         monitor;
           // test if the temp variable is filled with the right data for the type
           // by moving the data from temp to another var (testVar in this case)
           testVar = temp;
           return testVar;
           on-error *all;
             sendEscapeMessage(MSG_INVALID_VALUE_TYPE);
             return *loval;
         endmon;
       endif;
      /end-free
     P                 E


     /**
      * \brief Remove range of elements
      *
      * Removes a number of elements from the list.
      *
      * \param Pointer to the list
      * \param Starting index
      * \param Number of elements to remove
      *
      * \throws CPF9898 Position out of bounds
      */
     P list_removeRange...
     P                 B                   export
     D                 PI
     D   listPtr                       *   const
     D   index                       10U 0 const
     D   pNumberElements...
     D                               10U 0 const
      *
     D header          DS                  likeds(tmpl_header) based(listPtr)
     D numberElements  S             10U 0
     D i               S             10U 0
      /free
       isLinkedListImpl(listPtr);

       // check if the start is in the range of the list
       if (index > header.size - 1);
         sendEscapeMessage(MSG_POSITION_OUT_OF_BOUNDS);
       endif;

       if (index + pNumberElements > header.size -1);
         numberElements = header.size - index;
       else;
         numberElements = pNumberElements;
       endif;

       for i = 1 to numberElements;
         list_remove(listPtr : index);
       endfor;

      /end-free
     P                 E

     /**
      * \brief Sort list
      *
      * Sorts the list with the passed procedure.
      *
      * <br>
      *
      * The passed procedure should have the list pointer as its
      * only parameter (const) and should sort the list in-place.
      *
      * \param Pointer to the list
      * \param Procedure pointer to the sort procedure
      */
     P list_sort       B                   export
     D                 PI
     D   listPtr                       *   const
     D   sortAlgorithm...
     D                                 *   const procptr
      *
     D sort            PR                  extproc(sortAlgorithm)
     D   listPtr                       *   const
      /free
       if (isLinkedListImpl(listPtr));
         sort(listPtr);
       endif;
      /end-free
     P                 E


     /**
      * \brief Merge lists
      *
      * Merges the elements of second list with the first list. Elements which
      * are already in the first list are not added by default (see third parameter).
      *
      * \author Mihael Schmidt
      * \date   15.12.2009
      *
      * \param Destination list
      * \param Source list
      * \param Skip duplicates (default: *off)
      */
     P list_merge      B                   export
     D                 PI
     D   destList                      *   const
     D   sourceList                    *   const
     D   pSkipDuplicates...
     D                                 N   const options(*nopass)
      *
     D skipDuplicates...
     D                 S               N   inz(*off)
     D header          DS                  likeds(tmpl_header) based(sourceList)
     D entryPtr        S               *
     D entry           DS                  likeds(tmpl_entry) based(entryPtr)
      /free
       if (%parms() = 3);
         skipDuplicates = pSkipDuplicates;
       endif;
       
       if (isLinkedListImpl(destList) and
           isLinkedListImpl(sourceList));

         entryPtr = header.firstEntry;
         dow (entryPtr <> *null);
         
           if (skipDuplicates);
             if (not list_contains(destList : entry.value : entry.length - 1));
               list_add(destList : entry.value : entry.length - 1); // dont include the null value
             endif;
           else;
             list_add(destList : entry.value : entry.length - 1); // dont include the null value
           endif;

           entryPtr = entry.next;
         enddo;

       endif;
      /end-free
     P                 E
