/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX975M                                            */
/*  Description : Run Job Command - Create command                   */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Run Job Command command objects.              */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*  Prerequisite:      Specify the appropriate value for the         */
/*                     QALWJOBITP system value, defined by the       */
/*                     &AlwJobItp variable declaration below,        */
/*                     prior to compiling this program.              */
/*                                                                   */
/*                     If you do not alter the default value of      */
/*                     '0' for the &AlwJobItp variable, no job       */
/*                     interrupt exit program will be allowed to     */
/*                     run.                                          */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX975M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     Dcl    &AlwJobItp      *Char      1    '0'

 /* To allow the job interrupt exit program to be run following an */
 /*   explicit setting in the job to be interrupted, replace the   */
 /*   above &AlwJobItp variable declaration with the one below:    */
 /*                                                                */
 /*  Dcl    &AlwJobItp      *Char      1    '1'                    */

 /* To allow the job interrupt exit program to be run without an   */
 /*   explicit setting in the job to be interrupted, replace the   */
 /*   above &AlwJobItp variable declaration with the one below:    */
 /*                                                                */
 /*  Dcl    &AlwJobItp      *Char      1    '2'                    */


     MonMsg      CPF0000    *N        GoTo Error


     AddLibLe    &UtlLib
     MonMsg      CPF2103

     CrtMsgF     MsgF( &UtlLib/CBX975M )  Aut( *USE )

     AddMsgD    CBX0001 MsgF( &UtlLib/CBX975M ) Msg( 'Job command must be run for another +
                  job.' ) SecLvl( '&N Cause . . . . . :   You specified a qualified job name +
                  identifying the job in which to run a command, that is the same as the job +
                  running this command. &N Recovery  . . . :   Specify a qualified job name +
                  that is different from the current job.' )

     AddMsgD    CBX0101 MsgF( &UtlLib/CBX975M ) Msg( 'No job command specified.' ) SecLvl( +
                  'The exit program expected to receive a command string to run, but an empty +
                  string was received, and consequently no command was run.' )

     AddMsgD    CBX0102 MsgF( &UtlLib/CBX975M ) Msg( 'Job command ended in error.' ) SecLvl( +
                  'The exit program ran the specified command and received an error from the +
                  command processor.  Check the job log of the target job &3/&2/&1 for more +
                  details on the cause of the error.' ) Fmt(( *CHAR 10 ) ( *CHAR 10 ) ( *CHAR +
                  6 ))

     AddMsgD    CBX0103 MsgF( &UtlLib/CBX975M ) Msg( 'Job command timed out.' ) SecLvl( 'The +
                  exit program did not return a response before the specified time out value +
                  of &1 seconds expired.' ) Fmt(( *BIN  4 ))


     CrtRpgMod  &UtlLib/CBX9751 SrcFile( OSSILESRC/CBX975 ) SrcMbr( *Module ) DbgView( *NONE )

     CrtPgm     &UtlLib/CBX9751 Module( &UtlLib/CBX9751 ) ActGrp( *NEW )


     CrtRpgMod  &UtlLib/CBX9752 SrcFile( OSSILESRC/CBX975 ) SrcMbr( *Module ) DbgView( *NONE )

     CrtPgm     &UtlLib/CBX9752 Module( &UtlLib/CBX9752 ) ActGrp( *NEW )


     CrtPnlGrp  &UtlLib/CBX975H SrcFile( OSSILESRC/CBX975 ) SrcMbr( *PNLGRP )


     CrtCmd     Cmd( &UtlLib/RUNJOBCMD ) Pgm( CBX9751 ) SrcFile( OSSILESRC/CBX975 ) SrcMbr( +
                  CBX975X ) HlpPnlGrp( CBX975H ) HlpId( *CMD ) PrdLib( &UtlLib )


     SndPgmMsg  Msg( 'Run Job Command command' *Bcat 'successfully created in library'   *Bcat +
                  &UtlLib *Tcat '.' ) MsgType( *COMP )


     ChgSysVal  SysVal( QALWJOBITP ) Value( &AlwJobItp )

     AddExitPgm ExitPnt( QIBM_QWC_JOBITPPGM ) Format( JITP0100 ) PgmNbr( *LOW ) Pgm( +
                  &UtlLib/CBX9752 ) Text( 'Job interrupt exit program' )

     SndPgmMsg   Msg( 'Run Job Command command'           *Bcat +
                      'successfully configured.' )              +
                 MsgType( *COMP )

     Call        QMHMOVPM    ( '    '                 +
                               '*COMP'                +
                               x'00000001'            +
                               '*PGMBDY'              +
                               x'00000001'            +
                               x'0000000800000000'    +
                             )

     RmvMsg      Clear( *ALL )

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
