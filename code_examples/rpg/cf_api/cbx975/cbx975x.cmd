/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RUNJOBCMD )                                        */
/*           Pgm( CBX9751 )                                          */
/*           SrcMbr( CBX975X )                                       */
/*           HlpPnlGrp( CBX975H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
    Cmd        Prompt( 'Run Job Command' )
 
    Parm       JOB      Q0001               +
               Min(1)                       +
               Choice(*NONE)                +
               Prompt('Job name')
 
    Parm       CMD      *CmdStr    3000     +
               Vary( *YES *INT2 )           +
               Min( 1 )                     +
               Prompt( 'Command')
 
    Parm       TIMEOUT  *Int2               +
               Dft( 25 )                    +
               Range( 5  3600 )             +
               Expr( *YES )                 +
               Choice( 'Seconds, 5-3600' )  +
               Prompt( 'Command time-out' )
 
Q0001:                                      +
    Qual                *Name        10     +
               Min( 1 )                     +
               Expr( *YES )
 
    Qual                *Name        10     +
               Min( 1 )                     +
               Expr( *YES )                 +
               Prompt( 'User' )
 
    Qual                *Char         6     +
               Min( 1 )                     +
               Range( '000000' '999999' )   +
               Full( *YES )                 +
               Expr( *YES )                 +
               Prompt( 'Number' )
 
