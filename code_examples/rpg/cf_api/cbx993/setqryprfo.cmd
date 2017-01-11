/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd     Cmd( SETQRYPRFO )                                   */
/*               Pgm( CBX993 )                                       */
/*               SrcMbr( CBX993X )                                   */
/*               VldCkr( CBX993V )                                   */
/*               HlpPnlGrp( CBX993H )                                */
/*               HlpId( *CMD )                                       */
/*               PmtOvrPgm( CBX993O )                                */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
        Cmd      Prompt( 'Set Query Profile Options' )
 
        Parm     OPTLIB      *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )                              +
                 Keyparm( *YES )                           +
                 Prompt( 'Profile options library' )
 
        Parm     DBGCSRPOS   *Char        1                +
                 Dft( *MSGLIN )                            +
                 Rstd( *YES )                              +
                 SpcVal(( *MSGLIN ' ' ) ( *NONDBG 'N' ))   +
                 Prompt( 'Debug cursor position' )
 
        Parm     SBMPARM     E0001                         +
                 Prompt( 'Submit job parameters' )
 
        Parm     ALWOUTFILE  *Char        1                +
                 Dft( *YES )                               +
                 Rstd( *YES )                              +
                 SpcVal(( *NO  'Y' ) ( *YES ' ' ))         +
                 Prompt( 'Allow output file' )
 
        Parm     INZSIZE     E0002                         +
                 Dft( *NOMAX )                             +
                 SngVal(( *NOMAX 0 ))                      +
                 Prompt( 'Output file initial size' )
 
        Parm     CREATE      *Char        4                +
                 Dft( *NO )                                +
                 Rstd( *YES )                              +
                 SpcVal(( *NO  )                           +
                        ( *YES ))                          +
                 Expr( *YES )                              +
                 Prompt( 'Create profile opts data area' )
 
Q0001:  Qual                 *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )
 
        Qual                 *Name       10                +
                 Min( 1 )                                  +
                 Expr( *YES )                              +
                 Prompt( 'Library' )
 
E0001:  Elem                 *Char        1                +
                 Dft( *JOBD )                              +
                 Rstd( *YES )                              +
                 SpcVal(( *JOBD ' ' ) ( QCMDB 'B' ))       +
                 Prompt( 'Routing data' )
 
        Elem                 *Char        1                +
                 Dft( *JOBD )                              +
                 Rstd( *YES )                              +
                 SpcVal(( *JOBD    'J' )                   +
                        ( *CURRENT 'C' )                   +
                        ( *USRPRF  'U' )                   +
                        ( *DEV     'D' ))                  +
                 Prompt( 'Output queue' )
 
        Elem                 *Char        1                +
                 Dft( *JOBD )                              +
                 Rstd( *YES )                              +
                 SpcVal(( *JOBD    'J' )                   +
                        ( *CURRENT 'C' )                   +
                        ( *USRPRF  'U' )                   +
                        ( *SYSVAL  'S' ))                  +
                 Prompt( 'Print device' )
 
        Elem                 *Char        1                +
                 Dft( *JOBD )                              +
                 Rstd( *YES )                              +
                 SpcVal(( *JOBD    'J' )                   +
                        ( *RQD     'R' )                   +
                        ( *DFT     'D' )                   +
                        ( *SYSRPYL 'S' ))                  +
                 Prompt( 'Inquiry message reply' )
 
        Elem                 *Name       10                +
                 Dft( *JOBD )                              +
                 SpcVal(( *JOBD ) ( *QRY ))                +
                 Prompt( 'Job name' )
 
        Elem                 Q0001                         +
                 Dft( *USRPRF )                            +
                 SngVal(( *USRPRF ))                       +
                 Prompt( 'Job description' )
 
        Elem                 Q0001                         +
                 Dft( *JOBD )                              +
                 SngVal(( *JOBD ))                         +
                 Prompt( 'Job queue' )
 
        Elem                 *Char        1                +
                 Dft( *JOBD )                              +
                 Rstd( *YES )                              +
                 SpcVal(( *JOBD 'J' ) ( *CURRENT ' ' ))    +
                 Prompt( 'User' )
 
E0002:    Elem               *Int4                         +
                 Dft( 200000 )                             +
                 Range( 1  2147483646 )                    +
                 Expr( *YES )                              +
                 Prompt( 'Initial number of records' )
 
          Elem               *Int2                         +
                 Dft( 10000 )                              +
                 Range( 1  32767 )                         +
                 Expr( *YES )                              +
                 Prompt( 'Increment number of records' )
 
          Elem               *Int2                         +
                 Dft( 3 )                                  +
                 Range( 1  32767 )                         +
                 Expr( *YES )                              +
                 Prompt( 'Maximum increments' )
 
