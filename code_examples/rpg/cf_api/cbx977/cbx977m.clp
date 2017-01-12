/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX977M                                            */
/*  Description : Work with Jobs - Create command                    */
/*  Author  . . : Carsten Flensburg                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Work with Jobs command objects.               */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     command objects.                              */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX977M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     CrtMsgF     MsgF( &UtlLib/CBX977M )  Aut( *USE )

     AddMsgD     CBX0101                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'User name must be *CURUSR if CURUSR is +
                       specified.' )                                  +
                 SecLvl( *NONE )

     AddMsgD     CBX0102                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'Current user can only be specified if +
                       STATUS(*ACTIVE) is requested.' )               +
                 SecLvl( *NONE )

     AddMsgD     CBX0103                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'Please specify current user.' )                +
                 SecLvl( *NONE )

     AddMsgD     CBX0111                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'Completion status can only be specified if +
                       STATUS(*OUTQ) is requested.' )                 +
                 SecLvl( *NONE )

     AddMsgD     CBX0121                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'If JOB(*ALL) and USER(*ALL) is specified, +
                       STATUS must be *ACTIVE or *JOBQ.' )            +
                 SecLvl( *NONE )

     AddMsgD     CBX0122                                              +
                 MsgF( &UtlLib/CBX977M )                              +
                 Msg( 'If JOB(*ALL) and USER(*ALL) is specified, +
                       STATUS must be *ACTIVE or *JOBQ.' )            +
                 SecLvl( *NONE )

     CrtRpgMod  &UtlLib/CBX977 SrcFile( OSSILESRC/CBX977 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX977                  +
                 Module( &UtlLib/CBX977 )        +
                 ActGrp( *NEW )

     CrtRpgMod  &UtlLib/CBX977E SrcFile( OSSILESRC/CBX977 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX977E                 +
                 Module( &UtlLib/CBX977E )       +
                 ActGrp( *CALLER )

     CrtRpgMod  &UtlLib/CBX977L SrcFile( OSSILESRC/CBX977 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX977L                 +
                 Module( &UtlLib/CBX977L )       +
                 ActGrp( *CALLER )

     CrtRpgMod  &UtlLib/CBX977V SrcFile( OSSILESRC/CBX977 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm      &UtlLib/CBX977V                 +
                 Module( &UtlLib/CBX977V )       +
                 ActGrp( *CALLER )


     CrtPnlGrp  &UtlLib/CBX977H SrcFile( OSSILESRC/CBX977 ) SrcMbr( *PNLGRP )

     CrtPnlGrp  &UtlLib/CBX977P SrcFile( OSSILESRC/CBX977 ) SrcMbr( *PNLGRP )


     CrtCmd     Cmd( &UtlLib/WRKJOBS ) Pgm( CBX977 ) SrcFile( OSSILESRC/CBX977 ) SrcMbr( +
                  CBX977X ) Allow( *INTERACT *IPGM *IREXX *IMOD ) AlwLmtUsr( *NO ) MsgF( +
                  &UtlLib/CBX977M ) HlpPnlGrp( CBX977H ) HlpId( *CMD )


     SndPgmMsg   Msg( 'Work with Jobs command successfully' *Bcat +
                      'created in library'                  *Bcat +
                      &UtlLib                               *Tcat +
                      '.' )                                       +
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
