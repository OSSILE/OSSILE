**FREE

// =============================================================================
// CRTFRMSTMF - Create Object From Stream File
// =============================================================================



// Compile parameters
CTL-OPT DFTACTGRP(*NO) ACTGRP(*NEW);


// Prototype and Interface for this program
DCL-PR CRTFRMSTMF;
    pObj     CHAR(20);
    Cmd      CHAR(10);
    pSrcStmf CHAR(5002);
    pParms   CHAR(2002);
END-PR;

DCL-PI CRTFRMSTMF;
    pObj     CHAR(20);
    Cmd      CHAR(10);
    pSrcStmf CHAR(5002);
    pParms   CHAR(2002);
END-PI;


// Prototype for Get Attributes API
DCL-PR GetAttr INT(10) ExtPRoc('Qp0lGetAttr');
    path                 POINTER VALUE;
    attr_array           POINTER VALUE;
    buffer               POINTER VALUE;
    buffer_size_provided UNS(10) VALUE;
    buffer_size_needed   UNS(10);
    num_bytes_returned   UNS(10);
    follow_symlnk        UNS(10) VALUE;
END-PR;

DCL-DS path_name_format QUALIFIED ALIGN;
    ccsid               INT(10)     INZ(0);
    country_ID          CHAR(2)     INZ(*ALLx'00');
    language_ID         CHAR(3)     INZ(*ALLx'00');
    reserved1           CHAR(3)     INZ(*ALLx'00');
    path_type_indicator INT(10)     INZ(0);
    length_of_path_name INT(10);
    path_name_delimiter CHAR(2)     INZ('/');
    reserved2           CHAR(10)    INZ(*ALLx'00');
    path_name           CHAR(2048);
END-DS;

DCL-DS attr_array QUALIFIED ALIGN;
    num_attrs INT(10) INZ(1);
    attr      INT(10) INZ(27);
END-DS;

DCL-DS attr_return BASED(p_attr_return) QUALIFIED ALIGN;
    offset_to_next INT(10);
    attribute_id   INT(10);
    size_attr_data INT(10);
    reserved       CHAR(4);
    attr_data      CHAR(1024);
    attr_int       INT(10) OVERLAY(attr_data);
END-DS;


// Prototype for Execute Command API
DCL-PR ExecuteCommand EXTPGM('QCMDEXC');
    CommandString CHAR(32767) OPTIONS(*VARSIZE);
    CommandLength PACKED(15:5) CONST;
END-PR;


// Prototype for Process Command API
DCL-PR ProcessCommand EXTPGM('QCAPCMD');
    CommandString CHAR(32767) OPTIONS(*VARSIZE);
    CommandLength INT(10) CONST;
    OptCtlBlk     CHAR(32767) OPTIONS(*VARSIZE);
    OptCtlBlkLen  INT(10) CONST;
    OptCtlBlkFmt  CHAR(8) CONST;
    ChangedString CHAR(32767) OPTIONS(*VARSIZE);
    ChangedLength INT(10) CONST;
    ReturnLength  INT(10);
    ErrorCode     CHAR(32767) OPTIONS(*VARSIZE);
END-PR;

DCL-DS OptCtlBlk QUALIFIED;
    Type   INT(10) INZ(0);
    DBCS   CHAR(1) INZ('0');
    Prompt CHAR(1) INZ('1');
    Syntax CHAR(1) INZ('0');
    MsgKey CHAR(4) INZ(*LOVAL);
    Rsvd   CHAR(9) INZ(*LOVAL);
END-DS;


// Prototype for Move Program Message API
DCL-PR moveProgramMessages EXTPGM('QMHMOVPM');
    messageKey         char(4) const;
    messageTypes       char(40) const;
    messageTypesCount  int(10) const;
    toCallStackEntry   char(10) const;
    toCallStackCounter int(10) const;
    error              char(1) options(*varsize) const;
END-PR;


// Prototype for Send Program Message API
DCL-PR SendProgramMessage EXTPGM('QMHSNDPM');
    MsgID      CHAR(7) CONST;
    MsgFile    CHAR(20) CONST;
    MsgData    CHAR(32767) CONST OPTIONS(*VARSIZE);
    MsgDataLen INT(10) CONST;
    MsgType    CHAR(10) CONST;
    CallStkEnt CHAR(10) CONST;
    CallStkCnt INT(10) CONST;
    MsgKey     CHAR(4);
    ErrorCode  CHAR(32767) OPTIONS(*VARSIZE);
END-PR;


// Expanded parameters
DCL-DS ObjDS;
    Obj CHAR(10);
    Lib CHAR(10);
END-DS;

DCL-DS SrcStmfDS;
    SrcStmfLen INT(5);
    SrcStmf    CHAR(5000);
END-DS;

DCL-DS ParmsDS;
    ParmsLen INT(5);
    Parms    CHAR(2000);
END-DS;

DCL-DS LDA QUALIFIED DTAARA(*LDA);
    Eventf_lib CHAR(10);
    Eventf_mbr CHAR(10);
END-DS;

// Prototypes for errno functions
DCL-PR strerror POINTER EXTPROC('strerror');
    errnum INT(10) VALUE;
END-PR;


// Standard API error return structure
DCL-DS APIError QUALIFIED;
    Provided INT(10) INZ(%size(APIError));
    Avail    INT(10) INZ(0);
    MsgID    CHAR(7);
    Rsvd     CHAR(1);
    MsgDta   CHAR(256);
END-DS;


// Program Status Data Strucure
DCL-DS PgmSts PSDS;
    ErrorCode CHAR(7) POS(40);
    ErrorText CHAR(80) POS(91);
END-DS;


// Valid commands and the corresponding object type
DCL-DS CommandsDS;
    *n CHAR(10) INZ('CRTCMD');
    *n CHAR(10) INZ('CRTBNDCL');
    *n CHAR(10) INZ('CRTCLMOD');
    *n CHAR(10) INZ('CRTDSPF');
    *n CHAR(10) INZ('CRTPRTF');
    *n CHAR(10) INZ('CRTLF');
    *n CHAR(10) INZ('CRTPF');
    *n CHAR(10) INZ('CRTMNU');
    *n CHAR(10) INZ('CRTPNLGRP');
    *n CHAR(10) INZ('CRTQMQRY');
    *n CHAR(10) INZ('CRTSRVPGM');
    *n CHAR(10) INZ('CRTWSCST');
    Commands CHAR(10) DIM(12) POS(1);
END-DS;

DCL-DS ObjTypesDS;
    *n CHAR(10) INZ('CMD');
    *n CHAR(10) INZ('PGM');
    *n CHAR(10) INZ('MODULE');
    *n CHAR(10) INZ('FILE');
    *n CHAR(10) INZ('FILE');
    *n CHAR(10) INZ('FILE');
    *n CHAR(10) INZ('FILE');
    *n CHAR(10) INZ('MENU');
    *n CHAR(10) INZ('PNLGRP');
    *n CHAR(10) INZ('QMQRY');
    *n CHAR(10) INZ('SRVPGM');
    *n CHAR(10) INZ('WSCST');
    ObjTypes CHAR(10) DIM(12) POS(1);
END-DS;


// String to contain the OS commands to execute
DCL-S Buffer           CHAR(1024);
DCL-S BufferSizeNeeded UNS(10);
DCL-S CommandString    CHAR(2500);
DCL-S CCSID            INT(10);
DCL-S CCSID_c          CHAR(10);
DCL-S ErrorString      CHAR(100);
DCL-S I                INT(10);
DCL-S MsgKey           CHAR(4);
DCL-S NumBytesReturned UNS(10);
DCL-S RtnCode          INT(10);
DCL-S UpdatedString    CHAR(2500);
DCL-S UpdatedStringLen INT(10);


// Extract values from the compound parameters
ObjDS   = pObj;
SrcStmfDS  = pSrcStmf;
ParmsDS = pParms;


// Retreive the CCSID of the stream file
path_name_format.length_of_path_name = SrcStmfLen;
path_name_format.path_name = %SUBST(SrcStmf:1:SrcStmfLen);
RtnCode = GetAttr(%ADDR(path_name_format):%ADDR(attr_array):%ADDR(Buffer):%SIZE(Buffer):BufferSizeNeeded:NumBytesReturned:0);
IF RtnCode = -1;
    ErrorString = %STR(strerror(errno));
    ErrorText = 'Error determining CCSID of stream file: ' + ErrorString;
    SendProgramMessage('CPF9898':'QCPFMSG   QSYS':ErrorText:%LEN(%TRIMR(ErrorText)):
                       '*ESCAPE':'*':2:MsgKey:APIError);
ELSE;
    p_attr_return = %ADDR(Buffer);
    CCSID = attr_return.attr_int;
ENDIF;


// Create temporary source file
CommandString = 'DLTF FILE(QTEMP/QSOURCE)';
CALLP(E) ExecuteCommand(CommandString:%LEN(CommandString));

// Source physical files that are unicode create problems with CRTPF. Use Job's CCSID instead.
IF (CCSID = 1208);
    CCSID_c = '*JOB';
ELSE;
    CCSID_c = %CHAR(CCSID);
ENDIF;
CommandString = 'CRTSRCPF FILE(QTEMP/QSOURCE) RCDLEN(198) MBR(' + %TRIMR(Obj) + ') CCSID(' + CCSID_c + ')';
CALLP(E) ExecuteCommand(CommandString:%LEN(CommandString));


// Copy the source from the IFS to the temporary source file
CommandString = 'CPYFRMSTMF FROMSTMF(''' + %SUBST(SrcStmf:1:SrcStmfLen) + ''') '
              + 'TOMBR(''/QSYS.LIB/QTEMP.LIB/QSOURCE.FILE/' + %TRIM(Obj) + '.MBR'') '
              + 'MBROPT(*REPLACE)';
CALLP(E) ExecuteCommand(CommandString:%LEN(CommandString));


// Create the object by executing the chosen create command
i = %LOOKUP(Cmd:Commands);

CommandString = %TRIMR(Cmd) + ' '
              + %TRIMR(ObjTypes(i)) + '(' + %TRIMR(Lib) + '/' + %TRIMR(Obj) + ') '
              + 'SRCFILE(QTEMP/QSOURCE) SRCMBR(' + %TRIMR(Obj) + ') '
              + %SUBST(Parms:1:ParmsLen);

CALLP ProcessCommand(CommandString:%SIZE(CommandString):OptCtlBlk:%SIZE(OptCtlBlk):
                     'CPOP0100':UpdatedString:%SIZE(UpdatedString):UpdatedStringLen:
                     APIError);

if ( %scan( '*EVENTF' : CommandString ) > 0 );
  if ( Lib = '*CURLIB' );
    Lib = RetrieveCurrrentLibrary();
  endif;
  if ( Lib = '*NONE' );
    Lib = 'QGPL';
  endif;
  UpdateEventFile();
  LDA.Eventf_lib = Lib;
  LDA.Eventf_mbr = Obj;
  out LDA;
endif;

// If an error occurred then fail the command
IF APIError.Avail > 0;
    // Forward messages to caller
    APIError.Avail = 0;
    callp(e) moveProgramMessages(' ': '*COMP     *DIAG     *INFO     *ESCAPE': 4:
                                 '*PGMBDY': 1: APIError);

    // Send escape message
    ErrorText = %TRIMR(Cmd) + ' failed with message id ' + APIError.MsgID;
    SendProgramMessage('CPF9898':'QCPFMSG   QSYS':ErrorText:%LEN(%TRIMR(ErrorText)):
                       '*ESCAPE':'*':2:MsgKey:APIError);
ENDIF;


// Exit
*INLR = *ON;
RETURN;



// wrapper to get errno
DCL-PROC errno;
    DCL-PI *n INT(10);
    END-PI;

    DCL-PR sys_errno POINTER EXTPROC('__errno');
    END-PR;

    DCL-S wwreturn INT(10) BASED(p_errno);
    p_errno = sys_errno;
    RETURN wwreturn;

END-PROC;


dcl-proc RetrieveCurrrentLibrary;
  dcl-pi *n char( 10 );
  end-pi;

  dcl-s  Result char( 10 ) inz( '*NONE' );

  dcl-pr QUSRJOBI extpgm( 'QUSRJOBI' );
    RcvVar     char( 32767 ) options( *varsize );
    RcvVarLen  int( 10 )     const;
    Format     char(  8 )    const;
    QualJob    char( 26 )    const;
    IntJobId   char( 16 )    const;
  end-pr;

  dcl-ds JOBI0700 qualified;
    numsys  int( 10 )  pos( 65 );
    numprd  int( 10 )  pos( 69 );
    numcur  int( 10 )  pos( 73 );
    libl    char( 11 ) pos( 81 ) dim(250);
  end-ds;

  QUSRJOBI( JOBI0700 : %size( JOBI0700 ) : 'JOBI0700' : '*' : *blanks );

  if ( JOBI0700.numcur > 0 );
    Result = JOBI0700.libl( JOBI0700.numsys + JOBI0700.numprd + 1 );
  endif;

  return ( Result );

end-proc;


dcl-proc UpdateEventFile;

  dcl-f  EvfEvent      disk( 300 ) usage( *update ) extfile( EvfFilename ) extmbr( Obj ) usropn;

  dcl-ds EvfEvent_rec      qualified len( 300 );
    id   char( 10 );
  end-ds;
  dcl-ds New_EvfEvent_rec  likeds( Evfevent_rec );

  dcl-s  EvfFilename  char( 21 );

  dcl-ds Char3;
    Zoned3 zoned( 3 );
  end-ds;

  // File Information Structure (stat):

  dcl-ds statds   qualified;
    st_mode       uns( 10 );
    st_ino        uns( 10 );
    st_nlink      uns(  5 );
    *n            uns(  5 );
    st_uid        uns( 10 );
    st_gid        uns( 10 );
    st_size       int( 10 );
    st_atime      int( 10 );
    st_mtime      int( 10 );
    st_ctime      int( 10 );
    st_dev        uns( 10 );
    st_blksize    uns( 10 );
    st_allocsize  uns( 10 );
    st_objtype    char( 11 );
    *n            char(  1 );
    st_codepage   uns(  5 );
    st_ccsid      uns(  5 );
    st_rdev       uns( 10 );
    st_nlink32    uns( 10 );
    st_rdev64     uns( 20 );
    st_dev64      uns( 20 );
    *n            char( 36 );
    st_ino_gen_id uns( 10 );
  end-ds;

  // int stat(const char *path, struct stat *buf)

  dcl-pr stat int( 10 ) extproc('stat');
    path   pointer value options(*string);
    buf    likeds(statds);
  end-pr;

  // int stat(const char *path, struct stat *buf)

  dcl-pr CEEUTCO opdesc;
    Hours         int( 10 );
    Minutes       int( 10 );
    Seconds       float( 8 );
    fc            char( 12 ) options(*omit);
  end-pr;

  dcl-s  junk1    int( 10 );
  dcl-s  junk2    int( 10 );
  dcl-s  secs     float( 8 );
  dcl-s  epoch    timestamp( 0 );
  dcl-s  IFS_tms  timestamp( 0 );

  // Get Epoch (Unix timestammp offset).

  CEEUTCO( junk1 : junk2 : secs : *omit);
  Epoch = z'1970-01-01-00.00.00.000000' + %seconds(%int(secs));

  // Change FILEID record to reflect streamfile name instead of QTEMP/QSOURCE...

  EvfFileName = %trim( Lib ) + '/EVFEVENT';
  open EvfEvent;

  dou ( %eof( EvfEvent ) );
    read EvfEvent EvfEvent_rec;

    if ( not %eof( EvfEvent ) );
      if ( EvfEvent_rec.id = 'FILEID    ' );
        Zoned3 = SrcStmfLen;
        stat( %subst( SrcStmf : 1 : SrcStmfLen ) : statds );
        IFS_tms = epoch + %seconds(statds.st_mtime);

        New_EvfEvent_rec = %subst( EvfEvent_rec : 1 : 24 )
                         + Char3 + ' '
                         + %subst( SrcStmf : 1 : SrcStmfLen ) + ' '
                         + %char( IFS_tms : *ISO0 ) + ' '
                         + '0';
        update EvfEvent New_EvfEvent_rec;
      endif;
    endif;
  enddo;

  close EvfEvent;

end-proc;
