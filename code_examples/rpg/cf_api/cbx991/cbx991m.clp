/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX991M                                            */
/*  Description : Add & Remove User Auditing - Create commands       */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Add User Auditing and Remove User Auditing    */
/*                     command objects.                              */
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
/*    CrtClPgm    Pgm( CBX991M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Pgm        &UtlLib

             Dcl        &UtlLib         *Char     10
             Dcl        &SrcLib         *char     10   'OSSILESRC '

     MonMsg      CPF0000    *N        GoTo Error


     CrtMsgF     MsgF( &UtlLib/CBX991M )  Aut( *USE )

     AddMsgD     CBX0101                                             +
                 MsgF( &UtlLib/CBX991M )                             +
                 Msg( 'If AUDLVL(*NONE) is specified REPLACE(*YES) +
                       is required.' )                               +
                 SecLvl( *NONE )


     CrtRpgMod  &UtlLib/CBX9911 SrcFile( &SrcLib/CBX991) SrcMbr( *Module ) DbgView(*LIST )

     CrtPgm     &UtlLib/CBX9911 Module( &UtlLib/CBX9911 ) ActGrp( *NEW )

     CrtRpgMod  &UtlLib/CBX9911V SrcFile( &SrcLib/CBX991) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm     &UtlLib/CBX9911V Module( &UtlLib/CBX9911V ) ActGrp( *NEW )

     CrtPnlGrp  &UtlLib/CBX9911H SrcFile( &SrcLib/CBX991) SrcMbr( *PNLGRP )

     CrtCmd     Cmd( &UtlLib/ADDUSRAUD ) Pgm( CBX9911 ) SrcFile( &SrcLib/CBX991 ) SrcMbr( +
                  CBX9911X ) VldCkr( CBX9911V ) AlwLmtUsr( *NO ) MsgF( CBX991M ) HlpPnlGrp( +
                  CBX9911H ) HlpId( *CMD ) Aut( *EXCLUDE )


     SndPgmMsg   Msg( 'Add User Auditing command'         *Bcat +
                      'successfully created in library'   *Bcat +
                      &UtlLib                             *Tcat +
                      '.' )                                     +
                 MsgType( *COMP )


     CrtRpgMod  &UtlLib/CBX9912 SrcFile( &SrcLib/CBX991 ) SrcMbr( *Module ) DbgView( *LIST )

     CrtPgm     &UtlLib/CBX9912 Module( &UtlLib/CBX9912 ) ActGrp( *NEW )

     CrtRpgMod  &UtlLib/CBX9912V SrcFile( &SrcLib/CBX991 ) SrcMbr( *Module ) DbgView(*LIST )

     CrtPgm     &UtlLib/CBX9912V Module( &UtlLib/CBX9912V ) ActGrp( *NEW )


     CrtPnlGrp  &UtlLib/CBX9912H SrcFile( &SrcLib/CBX991 ) SrcMbr( *PNLGRP )

     CrtCmd     Cmd( &UtlLib/RMVUSRAUD ) Pgm( CBX9912 ) SrcFile( &SrcLib/CBX991 ) SrcMbr( +
                  CBX9912X ) VldCkr( CBX9912V ) AlwLmtUsr( *NO ) HlpPnlGrp( CBX9912H ) HlpId( +
                  *CMD ) Aut( *EXCLUDE )


     SndPgmMsg   Msg( 'Remove User Auditing command'      *Bcat +
                      'successfully created in library'   *Bcat +
                      &UtlLib                             *Tcat +
                      '.' )                                     +
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
