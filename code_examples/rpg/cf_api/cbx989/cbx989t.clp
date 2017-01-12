/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX989T                                            */
/*  Description : Retrieve Query Attributes - Test                   */
/*  Author  . . : Carsten Flensburg                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  This program tests the RTVQRYA command.       */
/*                                                                   */
/*                                                                   */
/*  Requirements:      This program must be run by a user profile    */
/*                     having *JOBCTL special authority.             */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX985T )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm
 
     Dcl    &QryTimLmt      *Dec      10
     Dcl    &Degree         *Char     10
     Dcl    &AsyncJ         *Char     10
     Dcl    &ApyRmt         *Char     10
     Dcl    &NbrTasks       *Dec       5
     Dcl    &QryOptLib      *Char     10
     Dcl    &QryStgLmt      *Dec      10
 
     MonMsg      CPF0000    *N        GoTo Error
 
 
     RtvQryA     Job( * )                    +
                 QryTimLmt( &QryTimLmt )     +
                 Degree( &Degree )           +
                 NbrTasks( &NbrTasks )       +
                 AsyncJ( &AsyncJ )           +
                 ApyRmt( &ApyRmt )           +
                 QryOptLib( &QryOptLib )     +
                 QryStgLmt( &QryStgLmt )
 
 
     SndPgmMsg   Msg( 'RTVQRYA command ended normally.' )       +
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
