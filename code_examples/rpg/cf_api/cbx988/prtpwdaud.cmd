/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd  Cmd( PRTPWDAUD )                                       */
/*            Pgm( CBX988 )                                          */
/*            SrcMbr( CBX988X )                                      */
/*            HlpPnlGrp( CBX988H )                                   */
/*            HlpId( *CMD )                                          */
/*            Aut( *USE )                                            */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
         Cmd        Prompt( 'Print Password Audit Report' )
 
         Parm       JRNRCV       E0001                     +
                    Dft( *CURRENT )                        +
                    SngVal(( *CURRENT ) ( *CURCHAIN ))     +
                    Prompt( 'Journal receiver searched' )
 
         Parm       FROMTIME     E0002                     +
                    Dft( *FIRST )                          +
                    SngVal(( *FIRST     000000 )           +
                           ( *YESTERDAY 000001 )           +
                           ( *WEEKBACK  000002 ))          +
                    Prompt( 'Starting date and time' )
 
         Parm       TOTIME       E0003                     +
                    Dft( *LAST )                           +
                    SngVal(( *LAST      000000 )           +
                           ( *YESTERDAY 000001 ))          +
                    Prompt( 'Ending date and time' )
 
         Parm       USRPRF       *Name       10            +
                    Dft( *ALL )                            +
                    SpcVal(( *ALL ))                       +
                    Expr( *YES )                           +
                    Prompt( 'User profile' )
 
         Parm       TGTPRF       *Name       10            +
                    Dft( *ALL )                            +
                    SpcVal(( *ALL ))                       +
                    Expr( *YES )                           +
                    Prompt( 'Target user profile' )
 
         Parm       PWDCHKSTS    *Char       10            +
                    Rstd( *YES )                           +
                    Dft( *ANY )                            +
                    SngVal(( *ANY ) ( *NONPASS ))          +
                    SpcVal(( *PASSED  )                    +
                           ( *SYSVAL  )                    +
                           ( *EXITPGM )                    +
                           ( *NONE    )                    +
                           ( *NOCHK   ))                   +
                    Max( 5 )                               +
                    Prompt( 'Password check status' )
 
E0001:   Elem                    Q0001                     +
                    Min( 1 )                               +
                    Choice( *NONE )                        +
                    Prompt( 'Starting journal receiver' )
 
         Elem                    Q0001                     +
                    Dft( *CURRENT )                        +
                    SngVal(( *CURRENT ))                   +
                    Prompt( 'Ending journal receiver' )
 
Q0001:   Qual                    *Name       10            +
                    Min( 1 )                               +
                    Expr( *YES )
 
         Qual                    *Name       10            +
                    Dft( *LIBL )                           +
                    SpcVal(( *LIBL ) ( *CURLIB ))          +
                    Expr( *YES )                           +
                    Prompt( 'Library' )
 
E0002:   Elem                    *Date                     +
                    Expr( *YES )                           +
                    Prompt( 'Starting date' )
 
         Elem                    *Time                     +
                    Expr( *YES )                           +
                    Prompt( 'Starting time' )
 
E0003:   Elem                    *Date                     +
                    Expr( *YES )                           +
                    Prompt( 'Ending date' )
 
         Elem                    *Time                     +
                    Expr( *YES )                           +
                    Prompt( 'Ending time' )
 
