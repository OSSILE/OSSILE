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

DCL-PR moveProgramMessages EXTPGM('QMHMOVPM');
    messageKey         char(4) const;
    messageTypes       char(40) const;
    messageTypesCount  int(10) const;
    toCallStackEntry   char(10) const;
    toCallStackCounter int(10) const;
    error              char(1) options(*varsize) const;
END-PR;

DCL-DS OptCtlBlk QUALIFIED;
    Type   INT(10) INZ(0);
    DBCS   CHAR(1) INZ('0');
    Prompt CHAR(1) INZ('1');
    Syntax CHAR(1) INZ('0');
    MsgKey CHAR(4) INZ(*LOVAL);
    Rsvd   CHAR(9) INZ(*LOVAL);
END-DS;

DCL-DS APIError QUALIFIED;
    Provided INT(10) INZ(%size(APIError));
    Avail    INT(10) INZ(0);
    MsgID    CHAR(7);
    Rsvd     CHAR(1);
    MsgDta   CHAR(256);
END-DS;


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


// Program Status Data Strucure
DCL-DS PgmSts PSDS;
    ErrorCode CHAR(7) POS(40);
    ErrorText CHAR(80) POS(91);
END-DS;


// Valid commands and the cooresponding object type
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
    *n CHAR(10) INZ('CRTSRVPGM');
    Commands CHAR(10) DIM(10) POS(1);
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
    *n CHAR(10) INZ('SRVPGM');
    ObjTypes CHAR(10) DIM(10) POS(1);
END-DS;


// String to contain the OS commands to execute
DCL-S CommandString    CHAR(2500);
DCL-S I                INT(10);
DCL-S MsgKey           CHAR(4);
DCL-S UpdatedString    CHAR(2500);
DCL-S UpdatedStringLen INT(10);


// Extract values from the compound parameters
ObjDS   = pObj;
SrcStmfDS  = pSrcStmf;
ParmsDS = pParms;


// Create temporary source file
CommandString = 'DLTF FILE(QTEMP/QSOURCE)';
CALLP(E) ExecuteCommand(CommandString:%LEN(CommandString));

CommandString = 'CRTSRCPF FILE(QTEMP/QSOURCE) RCDLEN(198) MBR(' + %TRIMR(Obj) + ')';
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
