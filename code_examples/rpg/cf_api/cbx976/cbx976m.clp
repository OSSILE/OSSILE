/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX976M                                            */
/*  Description : Job Interrupt Status - Create commands             */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     Job Interrupt Commands' objects.              */
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
/*    CrtClPgm    Pgm( CBX976M )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib
 
     Dcl    &UtlLib         *Char     10
 
 
     MonMsg      CPF0000    *N        GoTo Error
 
 
     AddLibLe    &UtlLib
     MonMsg      CPF2103
 
 
     CrtMsgF     MsgF( &UtlLib/CBX975M )  Aut( *USE )
     MonMsg      CPF0000     *N     Do
 
     RcvMsg      MsgType( *EXCP )   Rmv( *YES )
     EndDo
 
     AddMsgD     CBX0201                                             +
                 MsgF( &UtlLib/CBX975M )                             +
                 Msg( 'Current job interrupt status is &1.' )        +
                 SecLvl( 'The job interrupt status of the current +
                          job is currently set to a value of &1. +
                          &N The job interrupt status can have the +
                          following values: +
                          &B INTERUPTIBLE   - Allow job to be +
                          interrupted +
                          &B UNINTERUPTIBLE - Do not allow job to be +
                          interrupted' )                             +
                 Fmt(( *CHAR 24 ))
 
 
     CrtRpgMod   &UtlLib/CBX9761                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *NONE )
 
     CrtPgm      &UtlLib/CBX9761                 +
                 Module( &UtlLib/CBX9761 )       +
                 ActGrp( *NEW )
 
     CrtRpgMod   &UtlLib/CBX9762                 +
                 SrcFile( &UtlLib/QRPGLESRC )    +
                 SrcMbr( *Module )               +
                 DbgView( *NONE )
 
     CrtPgm      &UtlLib/CBX9762                 +
                 Module( &UtlLib/CBX9762 )       +
                 ActGrp( *NEW )
 
 
     CrtPnlGrp   &UtlLib/CBX9761H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )
 
     CrtPnlGrp   &UtlLib/CBX9762H                +
                 SrcFile( &UtlLib/QPNLSRC )      +
                 SrcMbr( *PNLGRP )
 
 
     CrtCmd      Cmd( &UtlLib/CHGJOBITPS )                      +
                 Pgm( CBX9761 )                                 +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX9761X )                             +
                 HlpPnlGrp( CBX9761H )                          +
                 HlpId( *CMD )                                  +
                 PrdLib( &UtlLib )
 
     CrtCmd      Cmd( &UtlLib/RTVJOBITPS )                      +
                 Pgm( CBX9762 )                                 +
                 SrcFile( &UtlLib/QCMDSRC )                     +
                 SrcMbr( CBX9762X )                             +
                 Allow(( *IPGM ) ( *BPGM ) ( *IMOD )            +
                       ( *BMOD ) ( *IREXX ) ( *BREXX ))         +
                 HlpPnlGrp( CBX9762H )                          +
                 HlpId( *CMD )                                  +
                 PrdLib( &UtlLib )
 
 
     CrtClPgm    &UtlLib/CBX976                  +
                 SrcFile( &UtlLib/QCLSRC )       +
                 SrcMbr( *Pgm )
 
 
     SndPgmMsg   Msg( 'Job Interrupt Status commands'     *Bcat +
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
