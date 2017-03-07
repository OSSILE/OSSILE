      /if not defined(LIBC)
      /define LIBC

      *-------------------------------------------------------------------------
      * Prototypes for C-Functions
      *-------------------------------------------------------------------------

      /if not defined(QUSEC)
      /define QUSEC
      /copy QSYSINC/QRPGLESRC,QUSEC
      /endif

      *
      * string functions
      *
     D strtok          PR              *          extproc('strtok')
     D  i_string                       *   value  options(*string)
     D  i_token                        *   value  options(*string)
      *
     D strlen          PR            10U 0 extproc('strlen')
     D   string                        *   value
      *
     D requestControlBlockLower...
     D                 DS                  qualified
     D   type                        10I 0 inz(0)
     D   ccsid                       10I 0 inz(0)
     D   case                        10I 0 inz(0)
     D   res1                        10A   inz(*ALLX'00')
      *
     D requestControlBlockUpper...
     D                 DS                  qualified
     D   type                        10I 0 inz(1)
     D   ccsid                       10I 0 inz(0)
     D   case                        10I 0 inz(0)
     D   res1                        10A   inz(*ALLX'00')
      *
     D caseConvert     PR                  extproc('QlgConvertCase')
     D   reqContBlock                      const
     D                                     likeds(requestControlBlockUpper)
     D   input                     1024A   const options(*varsize)
     D   output                    1024A   options(*varsize)
     D   len                         10I 0 const
     D   errorcode                         likeds(QUSEC) options(*varsize)

      *
      * memory functions
      *
     D memcpy          PR              *          extproc('memcpy')
     D  dest                           *   value
     D  source                         *   value
     D  count                        10U 0 value
      *
     D memset          PR              *          extproc('memset')
     D  i_pDest                        *   value
     D  i_char                       10I 0 value
     D  i_count                      10U 0 value
      *
     D memmove         PR              *          extproc('memmove')
     D  pMemDest                       *   value
     D  pMemSrc                        *   value
     D  memSize                      10U 0 value
      *
     D memcmp          PR            10I 0        extproc('memcmp')
     D  pBuf1                          *   value
     D  pBuf2                          *   value
     D  count                        10U 0 value
      *
     D memicmp         PR            10I 0        extproc('__memicmp')
     D  pBuf1                          *   value
     D  pBuf2                          *   value
     D  count                        10U 0 value

      *
      * math functions
      *
     D ceiling         PR             8F   extproc('ceil')
     D   value                        8F   value
      *
     D floor           PR             8F   extproc('floor')
     D   value                        8F   value

      *
      * other functions
      *
     D tmpnam          PR              *   extproc('tmpnam')
     D   buffer                      39A   options(*omit)
      *
     D tmpnamIFS       PR              *   extproc('_C_IFS_tmpnam')
     D   buffer                      39A   options(*omit)
      *
     D system          PR            10I 0 extproc('system')
     D   command                       *   value options(*string)
      *
     D srand           PR                         extproc('srand')
     D  i_seed                       10U 0 value
      *
     D rand            PR            10I 0        extproc('rand')
      *
     D qsort           PR              *          extproc('qsort')
     D  memPtr                         *   value
     D  numElem                      10U 0 value
     D  width                        10U 0 value
     D  pSortFunc                      *   value  procptr
      *
     D bsearch         PR              *          extproc('bsearch')
     D  keyPtr                         *   value
     D  memPtr                         *   value
     D  numElem                      10U 0 value
     D  width                        10U 0 value
     D  pSearchFnc                     *   value  procptr

      /endif

