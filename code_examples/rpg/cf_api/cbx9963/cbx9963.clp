/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX9963                                            */
/*  Description : Submit Job Description Job - CPP                   */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtClPgm   Pgm( CBX9963 )                                      */
/*               SrcFile( QCLSRC )                                   */
/*               SrcMbr( *PGM )                                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    ( &JobNam  &JobDsc_q  &Option )
 
     Dcl      &JobNam         *Char     10
     Dcl      &JobDsc_q       *Char     20
     Dcl      &JobDsc         *Char     10
     Dcl      &JobDsc_l       *Char     10
     Dcl      &Option         *Char     10
 
 
     MonMsg   CPF0000         *N        GoTo Error
 
 
     ChgVar      &JobDsc    %Sst(&JobDsc_q   1 10 )
     ChgVar      &JobDsc_l  %Sst(&JobDsc_q  11 10 )
 
     If        ( &JobDsc = '*JOB')      Do
     ChgVar      &JobDsc    &JobNam
     EndDo
 
     If        ( &Option = '*USRPRF')   Do
 
     SbmJob      Job( &JobNam )                                 +
                 JobD( &JobDsc_l/&JobDsc )                      +
                 PrtDev( *JOBD )                                +
                 JobQ( *JOBD )                                  +
                 JobPty( *JOBD )                                +
                 OutPty( *JOBD )                                +
                 OutQ( *JOBD )                                  +
                 User( *JOBD )                                  +
                 PrtTxt( *JOBD )                                +
                 RtgDta( *JOBD )                                +
                 RqsDta( *JOBD )                                +
                 SysLibL( *SYSVAL )                             +
                 CurLib( *USRPRF )                              +
                 InlLibL( *JOBD )                               +
                 Log( *JOBD *JOBD *JOBD )                       +
                 LogClPgm( *JOBD )                              +
                 InqMsgRpy( *JOBD )                             +
                 Hold( *JOBD )                                  +
                 ScdDate( *CURRENT )                            +
                 ScdTime( *CURRENT )                            +
                 Date( *JOBD )                                  +
                 Sws( *JOBD )                                   +
                 DspSbmJob( *YES )                              +
                 MsgQ( *USRPRF )                                +
                 SrtSeq( *USRPRF )                              +
                 LangId( *USRPRF )                              +
                 CntryId( *USRPRF )                             +
                 CcsId( *USRPRF )                               +
                 JobMsgQmx( *JOBD )                             +
                 JobMsgQfl( *JOBD )                             +
                 CpyEnvVar( *NO )                               +
                 AlwMltThd( *JOBD )                             +
                 InlAspGrp( *JOBD )                             +
                 SplFacn( *JOBD )
 
     EndDo
     Else Do
 
     SbmJob      Job( &JobNam )                                 +
                 JobD( &JobDsc_l/&JobDsc )                      +
                 PrtDev( *JOBD )                                +
                 JobQ( *JOBD )                                  +
                 JobPty( *JOBD )                                +
                 OutPty( *JOBD )                                +
                 OutQ( *JOBD )                                  +
                 User( *JOBD )                                  +
                 PrtTxt( *JOBD )                                +
                 RtgDta( *JOBD )                                +
                 RqsDta( *JOBD )                                +
                 SysLibL( *SYSVAL )                             +
                 CurLib( *CRTDFT )                              +
                 InlLibL( *JOBD )                               +
                 Log( *JOBD *JOBD *JOBD )                       +
                 LogClPgm( *JOBD )                              +
                 InqMsgRpy( *JOBD )                             +
                 Hold( *JOBD )                                  +
                 ScdDate( *CURRENT )                            +
                 ScdTime( *CURRENT )                            +
                 Date( *JOBD )                                  +
                 Sws( *JOBD )                                   +
                 DspSbmJob( *YES )                              +
                 MsgQ( *NONE )                                  +
                 SrtSeq( *SYSVAL )                              +
                 LangId( *SYSVAL )                              +
                 CntryId( *SYSVAL )                             +
                 CcsId( *SYSVAL )                               +
                 JobMsgQmx( *JOBD )                             +
                 JobMsgQfl( *JOBD )                             +
                 CpyEnvVar( *NO )                               +
                 AlwMltThd( *JOBD )                             +
                 InlAspGrp( *JOBD )                             +
                 SplFacn( *JOBD )
     EndDo
 
     Call        QMHMOVPM    ( '    '                 +
                               '*COMP'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )
 
 
     Return
 
/*-- Error handling:  -----------------------------------------------*/
 Error:
     Call        QMHMOVPM    ( '    '                 +
                               '*DIAG'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )
 
     Call        QMHRSNEM    ( '    '                 +
                               x'0000000800000000'    +
                             )
 
 EndPgm:
     EndPgm
