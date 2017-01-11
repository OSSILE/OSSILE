/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKJOBQJOB )                                       */
/*           Pgm( CBX9953 )                                          */
/*           SrcMbr( CBX9953X )                                      */
/*           VldCkr( CBX9953V )                                      */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           AlwLmtUsr( *NO )                                        */
/*           HlpPnlGrp( CBX9953H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Job Queue Jobs' )
 
             Parm       JOBQ        Q0001                            +
                        Min( 1 )                                     +
                        Prompt( 'Job queue' )
 
 
 Q0001:      Qual                   *Name                            +
                        Expr( *YES )
 
             Qual                   *Name                            +
                        Dft( *LIBL )                                 +
                        SpcVal(( *LIBL ) ( *CURLIB ))                +
                        Expr( *YES )                                 +
                        Prompt( 'Library' )
 
