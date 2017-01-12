     **
     **  Program . . : CBX973
     **  Description : Set Default Journal - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod Module( CBX973 )
     **              DbgView( *LIST )
     **
     **    CrtPgm    Pgm( CBX973 )
     **              Module( CBX973 )
     **              ActGrp( *NEW )
     **
     **
     **-- Control specification:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  ExcpId                        7a
     D                                1a
     D  ExcpDta                     512a
 
     **-- Global constants:
     D NULL            c                   ''
     D DFT_JRN         c                   'QDFTJRN'
     **-- Global variables:
     D DtaLen          s             10i 0
     D Idx             s             10i 0
     D DtaStr          s           1000a
 
     **-- Data area data:
     D DTAA_NAME_T     Ds                  Qualified
     D  DtaAraNam                    10a
     D  DtaAraLib                    10a
     **-- Data area format:
     D QDFTJRN         Ds                  Qualified
     D  JrnLib                       10a
     D  JrnNam                       10a
     D  JrnOpt                       20a   Dim( 5 )
     D   ObjTyp                      10a   Overlay( JrnOpt:  1 )
     D   Option                      10a   Overlay( JrnOpt: 11 )
 
     **-- Retrieve data area:
     D RtvDtaAra       Pr                  ExtPgm( 'QWCRDTAA' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  DtaAra_q                     20a   Const
     D  StrPos                       10i 0 Const
     D  DtaLen                       10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Change data area:
     D ChgDtaAra       Pr                  ExtPgm( 'QXXCHGDA' )
     D  DtaAra_q                           LikeDs( DTAA_NAME_T )
     D  DtaOfs                       10i 0 Const
     D  DtaLen                       10i 0 Const
     D  DtaVal                     2000a   Const  Options( *VarSize )
     **-- Execute command:
     D ExcCmd          Pr                  ExtPgm( 'QCMDEXC' )
     D  CmdStr                     4096a   Const  Options( *VarSize )
     D  CmdLen                       15p 5 Const
     D  CmdIGC                        3a   Const  Options( *NoPass )
     **-- Move program messages:
     D MovPgmMsg       Pr                  ExtPgm( 'QMHMOVPM' )
     D  MsgKey                        4a   Const
     D  MsgTyps                      10a   Const  Options( *VarSize )  Dim( 4 )
     D  NbrMsgTyps                   10i 0 Const
     D  ToCalStkE                  4102a   Const  Options( *VarSize )
     D  ToCalStkCnt                  10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     D  ToCalStkLen                  10i 0 Const  Options( *NoPass )
     D  ToCalStkEq                   20a   Const  Options( *NoPass )
     D  ToCalStkEdt                  10a   Const  Options( *NoPass )
     D  FrCalStkEad                    *   Const  Options( *NoPass )
     D  FrCalStkCnt                  10i 0 Const  Options( *NoPass )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFq                        20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
 
     **-- Retrieve message:
     D GetDtaLen       Pr            10i 0
     D  PxDtaAra_q                   20a   Const
     **-- Run command:
     D RunCmd          Pr            10i 0
     D  PxCmdStr                   4096a   Const  Varying
     **-- Send completion message:
     D SndCmpMsg       Pr            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D JrnOpt_e        Ds           512    Qualified
     D  NbrVal                        5i 0
     D  OfsVal                        5i 0 Dim( 5 )
     **
     D JrnOpt          Ds                  Qualified  Based( pJrnOpt )
     D   NbrOpt                       5i 0 Overlay( JrnOpt:  1 )
     D   ObjTyp                      10a   Overlay( JrnOpt:  3 )
     D   Option                      10a   Overlay( JrnOpt: 13 )
     **
     D CBX973          Pr
     D  PxLibNam                     10a
     D  PxJrnNam_q                         LikeDs( ObjNam_q )
     D  PxJrnOpt                           LikeDs( JrnOpt_e )
     D  PxCrtDtaAra                   4a
     **
     D CBX973          Pi
     D  PxLibNam                     10a
     D  PxJrnNam_q                         LikeDs( ObjNam_q )
     D  PxJrnOpt                           LikeDs( JrnOpt_e )
     D  PxCrtDtaAra                   4a
 
      /Free
 
        If  PxCrtDtaAra = '*YES';
          ExSr  CrtDtaAra;
        EndIf;
 
        ExSr  RtvJrnSet;
 
        ExSr  UpdDtaAra;
 
        *InLr = *On;
        Return;
 
 
        BegSr  RtvJrnSet;
 
          QDFTJRN.JrnLib = PxJrnNam_q.ObjLib;
          QDFTJRN.JrnNam = PxJrnNam_q.ObjNam;
 
          For  Idx = 1  to  PxJrnOpt.NbrVal;
            pJrnOpt = %Addr( PxJrnOpt ) + PxJrnOpt.OfsVal( Idx );
 
            QDFTJRN.ObjTyp(Idx) = JrnOpt.ObjTyp;
 
            If  JrnOpt.NbrOpt > 1;
              QDFTJRN.Option(Idx) = JrnOpt.Option;
            EndIf;
          EndFor;
 
        EndSr;
 
        BegSr  UpdDtaAra;
 
          DtaStr = QDFTJRN;
 
          DTAA_NAME_T.DtaAraNam = DFT_JRN;
          DTAA_NAME_T.DtaAraLib = PxLibNam;
 
          DtaLen = GetDtaLen( DTAA_NAME_T );
 
          ChgDtaAra( DTAA_NAME_T
                   : 1
                   : DtaLen
                   : DtaStr
                   );
 
          SndCmpMsg( 'Data area ' + DFT_JRN +
                     ' in library ' + %Trim( PxLibNam ) +
                     ' has been updated.'
                   );
 
        EndSr;
 
        BegSr  CrtDtaAra;
 
          RunCmd( 'CRTDTAARA DTAARA('  +
                   %Trim( PxLibNam )   + '/' + DFT_JRN +
                  ') TYPE(*CHAR) LEN(200)'
                );
 
        EndSr;
 
      /End-Free
 
     **-- Get data area length:
     P GetDtaLen       B
     D                 Pi            10i 0
     D  PxDtaAra_q                   20a   Const
 
     **-- Global constants:
     D ALL_DTA         c                   -1
     **-- Data area data:
     D DTAA0100        Ds                  Qualified
     D  BytAvl                       10i 0
     D  BytRtn                       10i 0
     D  ValTyp                       10a
     D  LibNam                       10a
     D  ValLen                       10i 0
     D  NbrDec                       10i 0
     D  DtaVal                     2000a
 
      /Free
 
        RtvDtaAra( DTAA0100
                 : %Len( DTAA0100 )
                 : PxDtaAra_q
                 : ALL_DTA
                 : %Size( DTAA0100.DtaVal )
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  DTAA0100.ValLen;
        EndIf;
 
      /End-Free
 
     P GetDtaLen       E
     **-- Run command:
     P RunCmd          B
     D                 Pi            10i 0
     D  PxCmdStr                   4096a   Const  Varying
 
      /Free
 
        Monitor;
          ExcCmd( PxCmdStr: %Len( PxCmdStr ));
 
        On-Error;
          Return  -1;
        EndMon;
 
        MovPgmMsg( *Blanks: '*COMP': 1: '*PGMBDY': 1: ERRC0100 );
 
        Return  *Zero;
 
      /End-Free
 
     P RunCmd          E
     **-- Send completion message:
     P SndCmpMsg       B
     D                 Pi            10i 0
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( 'CPF9897'
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*COMP'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return  0;
 
        EndIf;
 
      /End-Free
 
     P SndCmpMsg       E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : 'QCPFMSG   *LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
