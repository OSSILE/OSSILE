      /if not defined (CEEAPI)
      /define CEEAPI

      *-------------------------------------------------------------------------
      * ILE CEE API Prototypes
      *-------------------------------------------------------------------------

     D cee_getOpDescInfo...
     D                 PR                  extproc('CEEDOD')
     D   position                    10I 0 const
     D   descType                    10I 0
     D   dataType                    10I 0
     D   descInfo1                   10I 0
     D   descInfo2                   10I 0
     D   length                      10I 0
     D   feedback                    12A   options(*omit)


      *-------------------------------------------------------------------------
      * Date API Prototypes
      *-------------------------------------------------------------------------
     D cee_getLilianDate...
     D                 PR                  extproc('CEEDAYS') opdesc
     D   charDate                    20A   const options(*varsize)
     D   formatString                20A   const options(*varsize)
     D   lilianDate                  10I 0
     D   errorcode                  100A   options(*varsize : *nopass)
      *
     D cee_getDateFromLilian...
     D                 PR                  extproc('CEEDATE') opdesc
     D   lilianDate                  10I 0 const
     D   formatString                20A   const options(*varsize)
     D   dateString                  20A   options(*varsize)
     D   errorcode                  100A   options(*varsize : *nopass)
      *
      * CEEDYWK returns the weekday as a number between 1 and 7
      *
      * 1 = Sonntag    / Sunday
      * 2 = Montag     / Monday
      * 3 = Dienstag   / Tuesday
      * 4 = Mittwoch   / Wednesday
      * 5 = Donnerstag / Thursday
      * 6 = Freitag    / Friday
      * 7 = Samstag    / Saturday
      *
      * 0 = Fehler bei der Berechnung / ungültiges Datum
      *
     D cee_getDayOfWeekNumeric...
     D                 PR                  extproc('CEEDYWK') opdesc
     D   lilianDate                  10I 0 const
     D   dayOfWeek                   10I 0
     D   errorcode                  100A   options(*varsize : *nopass)
      *

      *-------------------------------------------------------------------------
      * Memory Management API Prototypes
      *-------------------------------------------------------------------------
      * Interface to the CEEGTST API (Get Heap Storage).
      *  1) HeapId = Id of the heap.
      *  2) Size   = Number of bytes to allocate
      *  3) RetAddr= Return address of the allocated storage
      *  4) *OMIT  = The feedback parameter.  Specifying *OMIT here
      *              means that we will receive an exception from
      *              the API if it cannot satisfy our request.
      *              Since we do not monitor for it, the calling
      *              procedure will receive the exception.
      *-------------------------------------------------------------------------
     D cee_getStorage...
     D                 PR                  extproc('CEEGTST')
     D   heapId                      10I 0 const
     D   size                        10I 0 const
     D   retAddr                       *
     D   feedback                    12A   options(*omit)

      *-------------------------------------------------------------------------
      * Interface to the CEEFRST API (Free Storage).
      *  1) Addr   = Address of the allocated storage to be freed
      *  2) *OMIT  = The feedback parameter.  Specifying *OMIT here
      *              means that we will receive an exception from
      *              the API if it cannot satisfy our request.
      *              Since we do not monitor for it, the calling
      *              procedure will receive the exception.
      *-------------------------------------------------------------------------
     D cee_freeStorage...
     D                 PR                  extproc('CEEFRST')
     D   address                       *
     D   feedback                    12A   options(*omit)

      *-------------------------------------------------------------------------
      * Interface to the CEECZST API (Reallocate Storage).
      *  1) Addr   = Address of the allocated storage
      *  2) Size   = New size (number of bytes) of the allocated storage
      *  3) *OMIT  = The feedback parameter.  Specifying *OMIT here
      *              means that we will receive an exception from
      *              the API if it cannot satisfy our request.
      *              Since we do not monitor for it, the calling
      *              procedure will receive the exception.
      *-------------------------------------------------------------------------
     D cee_reallocateStorage...
     D                 PR                  extproc('CEECZST')
     D   address                       *
     D   size                        10I 0 const
     D   feedback                    12A   options(*omit)

      *-------------------------------------------------------------------------
      * Interface to the CEECRHP API (Create Heap).
      *  1) HeapId     = Id of the heap.
      *  2) InitSize   = Initial size of the heap.
      *  3) Incr       = Number of bytes to increment if heap must be
      *                  enlarged.
      *  4) AllocStrat = Allocation strategy for this heap.  We will
      *                  specify a value of 0 which allows the system
      *                  to choose the optimal strategy.
      *  5) *OMIT      = The feedback parameter.  Specifying *OMIT here
      *                  means that we will receive an exception from
      *                  the API if it cannot satisfy our request.
      *                  Since we do not monitor for it, the calling
      *                  procedure will receive the exception.
      *-------------------------------------------------------------------------
     D cee_createHeap...
     D                 PR                  extproc('CEECRHP')
     D   heapId                      10I 0
     D   initSize                    10I 0 const options(*omit)
     D   increment                   10I 0 const options(*omit)
     D   allocStrat                  10I 0 const options(*omit)
     D   feedback                    12A   options(*omit)

      *-------------------------------------------------------------------------
      * Interface to the CEEDSHP API (Discard Heap).
      *  1) HeapId     = Id of the heap.
      *  2) *OMIT      = The feedback parameter.  Specifying *OMIT here
      *                  means that we will receive an exception from
      *                  the API if it cannot satisfy our request.
      *                  Since we do not monitor for it, the calling
      *                  procedure will receive the exception.
      *-------------------------------------------------------------------------
     D cee_discardHeap...
     D                 PR                  extproc('CEEDSHP')
     D   heapId                      10I 0
     D   feedback                    12A   options(*omit)

      /endif
