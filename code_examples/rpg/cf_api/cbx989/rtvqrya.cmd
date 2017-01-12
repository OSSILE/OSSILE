/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RTVQRYA )                                          */
/*           Pgm( CBX989 )                                           */
/*           SrcMbr( CBX989X )                                       */
/*           Allow((*IPGM) (*BPGM) (*IMOD) (*BMOD) (*IREXX) (*BREXX))*/
/*           HlpPnlGrp( CBX989H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Retrieve Query Attributes' )
 
 
          Parm     JOB           Q0001                          +
                   Dft( * )                                     +
                   SngVal(( * ))                                +
                   Prompt( 'Job name' )
 
          Parm     QRYTIMLMT   *Dec     ( 10 0 )                +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for QRYTIMLMT  (10 0)' )
 
          Parm     DEGREE      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for DEGREE       (10)' )
 
          Parm     NBRTASKS    *Dec      ( 5 0 )                +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for NBRTASKS    (5 0)' )
 
          Parm     ASYNCJ      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for ASYNCJ       (10)' )
 
          Parm     APYRMT      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for APYRMT       (10)' )
 
          Parm     QRYOPTLIB   *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for QRYOPTLIB    (10)' )
 
          Parm     QRYSTGLMT   *Dec     ( 10 0 )                +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for QRYSTGLMT  (10 0)' )
 
 
 Q0001:   Qual                     *Name     10                 +
                   Min( 1 )                                     +
                   Expr( *YES )
 
          Qual                     *Name     10                 +
                   Min( 1 )                                     +
                   Expr( *YES )                                 +
                   Prompt( 'User' )
 
          Qual                     *Char      6                 +
                   Range( '000000' '999999' )                   +
                   Full( *YES )                                 +
                   Expr( *YES )                                 +
                   Prompt( 'Number' )
 
