     /**
      * \brief Linked List Example : Create/Fill/Dispose List
      *
      */

     H DFTACTGRP(*NO) ACTGRP(*CALLER)

      // 
      // inlude linked list prototypes
      // 
      /copy LLIST_H

     D list            S               *
     D value           S             20A   inz('Mihael Schmidt')
     
      /free
       //
       // create a linked list
       //
       // the pointer to the main data structure is returned
       // this pointer will be used for all operations with
       // the list.
       list = list_create();


       //
       // add entry to the list
       //
       // the data will be copied to the list. the variable value 
       // can be changed after adding it to the list. the list
       // entry will not be affected. 
       list_addString(list : value);


       // free all the internally allocated memory of the list
       // (as the list does not store the pointer to the entry
       // but the content itself for which memory must be allocated)
       list_dispose(list);

       *inlr = *on;
       return;
      /end-free
