      /if not defined(QUSEC)
      /define QUSEC
      /copy QSYSINC/QRPGLESRC,QUSEC
      /endif

      /if not defined (LIBC)
      /define LIBC
      *-------------------------------------------------------------------------
      * Prototypes for C-Functions
      *-------------------------------------------------------------------------
      *
      * string functions
      *
     D strtok          PR              *   extproc('strtok')
     D  i_string                       *   value  options(*string)
     D  i_token                        *   value  options(*string)
      *
     D strlen          PR            10U 0 extproc('strlen')
     D   string                        *   value
      *
     D strcmp          PR            10I 0 extproc('strcmp')
     D  string1                        *   value
     D  string2                        *   value
      *
     D strncmp         PR            10I 0 extproc('strncmp')
     D  string1                        *   value
     D  string2                        *   value
     D  count                        10I 0 value
      *
     D strcmpi         PR            10I 0 extproc('strcmpi')
     D  string1                        *   value
     D  string2                        *   value
      *
     D strcasecmp      PR            10I 0 extproc('strcasecmp')
     D  string1                        *   value
     D  string2                        *   value
      *
     D strncasecmp     PR            10I 0 extproc('strncasecmp')
     D  string1                        *   value
     D  string2                        *   value
     D  count                        10I 0 value            
      * 
     D strstr          PR              *   extproc('strstr')
     D  string1                        *   value
     D  string2                        *   value
      * 
     D strcspn         PR            10I 0 extproc('strcspn')
     D  string1                        *   value
     D  string2                        *   value
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

      *
      * error handling
      *
     D errno           PR              *   extproc('__errno')
      *
     D strerr          PR              *   extproc('strerror')
     D  errnum                       10I 0 value
      * for backwards compatibility
     D strerror        PR              *   extproc('strerror')
     D  errnum                       10I 0 value

      /endif

      /if not defined(FCNTL_PROTOTYPE)   
      *
      * fcntl() commands
      *
     D F_DUPFD         C                   0
     D F_GETFL         C                   6
     D F_SETFL         C                   7
     D F_GETOWN        C                   8
     D F_SETOWN        C                   9
      *
      * fcntl() flags
      *
     D O_NONBLOCK      C                   128
     D O_NDELAY        C                   128
     D FNDELAY         C                   128
     D FASYNC          C                   512                     
 
      *--------------------------------------------------------------------
      *   fcntl()--Change Descriptor Attributes
      *
      *   int fcntl(int descriptor, int command, ...)
      *
      *   The third parameter (when used with sockets) is also an
      *   integer passed by value.. it specifies an argument for
      *   some of the commands.
      *
      *   commands supported in sockets are:
      *          F_GETFL -- Return the status flags for the descriptor
      *          F_SETFL -- Set status flags for the descriptor
      *                    (Arg =)status flags (ORed) to set.
      * (the commands below arent terribly useful in RPG)
      *          F_DUPFD -- Duplicate the descriptor
      *                    (Arg =)minimum value that new descriptor can be
      *          F_GETOWN -- Return the process ID or group ID that's
      *                     set to receive SIGIO & SIGURG
      *          F_SETOWN -- Set the process ID or group ID that's
      *                     to receive SIGIO & SIGURG
      *                    (Arg =)process ID (or neg value for group ID)
      *
      *  returns -1 upon error.
      *          successful values are command-specific.
      *--------------------------------------------------------------------
     D fcntl           PR            10I 0 extproc('fcntl')
     D   socketDesc                  10I 0 value
     D   command                     10I 0 value
     D   arg                         10I 0 value options(*nopass)
 
      /define FCNTL_PROTOTYPE
      /endif      
  
