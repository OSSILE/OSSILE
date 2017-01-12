/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX99AM                                            */
/*  Description : Query Governor Exit Program - Setup                */
/*  Author  . . : Carsten Flensburg                                  */
/*                                                                   */
/*                                                                   */
/*  Program function:  Compiles, creates and configures all the      */
/*                     query governor exit program objects.          */
/*                                                                   */
/*                     This program expects a single parameter       */
/*                     specifying the library to contain the         */
/*                     query governor exit program.                  */
/*                                                                   */
/*                     Object sources must exist in the respective   */
/*                     source type default source files in the       */
/*                     command object library.                       */
/*                                                                   */
/*  Requirements:      This program must be run by a user profile    */
/*                     having *ALLOBJ special authority.             */
/*                                                                   */
/*                     The system audit journal QAUDJRN must exist   */
/*                     for this utility to run successfully.         */
/*                                                                   */
/*                     The User Function Usage commands published    */
/*                     in the August 25, 2005 issue of APIs by       */
/*                     Example in the System iNetwork Programming    */
/*                     Tips Newsletter                               */
/*                                                                   */
/*                       ADDFCNREG  - Add Function Registration      */
/*                       CHGUSRFCNU - Change User Function Usage     */
/*                                                                   */
/*                     need to be installed to complete this setup   */
/*                     successfully.                                 */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX99AM )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
     Pgm    &UtlLib

     Dcl    &UtlLib         *Char     10
     Dcl    &CurUsr         *Char     10

     MonMsg      CPF0000    *N        GoTo Error


     ChkObj      QAUDJRN    *JRN


     CrtBndRpg  Pgm( &UtlLib/CBX99A ) SrcFile( &UtlLib/QRPGLESRC ) SrcMbr( CBX99A ) DbgView( +
                  *NONE ) Replace( *NO ) Aut( *USE )

     ChgObjOwn  Obj( &UtlLib/CBX99A ) ObjType( *SRVPGM ) NewOwn( QSYSOPR )

     ChgPgm     Pgm( &UtlLib/CBX99A ) RmvObs( *ALL )


     RtvJobA     CurUser( &CurUsr )

     AddFcnReg   FcnID( CBX_SYSOPR_SYSADMIN )                   +
                 FcnType( *PRODUCT )                            +
                 FcnName( 'System operator functions' )         +
                 FcnDesc( 'System resource control functions' )
     MonMsg      CPF228F

     AddFcnReg   FcnID( CBX_SQL_ADMIN )                         +
                 FcnPrdId( CBX_SYSOPR_SYSADMIN )                +
                 FcnType( *GROUP )                              +
                 FcnName( 'SQL resource administration' )      +
                 FcnDesc( 'Cryptographic function access' )
     MonMsg      CPF228F

     AddFcnReg   FcnID( CBX_QUERY_400_ALLOW_INTER )             +
                 FcnGrpId( CBX_SQL_ADMIN )                      +
                 FcnPrdId( CBX_SYSOPR_SYSADMIN )                +
                 AllObjAut( *NOTUSED )                          +
                 Default( *DENIED )                             +
                 FcnType( *ADMIN )                              +
                 FcnName( 'Allow interactive Query/400' )       +
                 FcnDesc( 'Run queries exceeding QRYTIMLMT query attribute' )


     ChgUsrFcnU  FcnID( CBX_QUERY_400_ALLOW_INTER )             +
                 UsrPrf( &CurUsr )                              +
                 Usage( *ALLOWED )


     SndPgmMsg   Msg( 'Query governor exit program has'   *Bcat +
                      'successfully been created in'      *Bcat +
                      'library'                           *Bcat +
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
