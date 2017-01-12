/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd   Cmd( WRKPRFSECA )                                     */
/*             Pgm( CBX9721 )                                        */
/*             SrcMbr( CBX972X )                                     */
/*             AlwLmtUsr( *NO )                                      */
/*             MsgF( CBX972M )                                       */
/*             HlpPnlGrp( CBX972H )                                  */
/*             HlpId( *CMD )                                         */
/*             PrdLib( <library> )                                   */
/*             Aut( *EXCLUDE )                                       */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Work with Profile Security Atr' )
 
          Parm     USRPRF      *Generic    10                   +
                   Dft( *ALL )                                  +
                   Expr( *YES )                                 +
                   SpcVal(( *ALL ))                             +
                   Prompt( 'User profile' )
 
          Parm     REL         *Char       10                   +
                   Dft( *AND )                                  +
                   Rstd( *YES )                                 +
                   SpcVal(( *AND )                              +
                          ( *OR  ))                             +
                   Expr( *YES )                                 +
                   Prompt( 'Criteria relationship' )
 
          Parm     TYPE        *Char        1                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK  ' ' )                       +
                          ( *USER   '0' )                       +
                          ( *GROUP  '1' ))                      +
                   Prompt( 'Type' )
 
          Parm     STATUS      *Name       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK    )                         +
                          ( *ENABLED  )                         +
                          ( *DISABLED ))                        +
                   Prompt( 'Status' )
 
          Parm     PRFDAYS     *Int2                            +
                   Range( 1  999 )                              +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK  -1 ) ( *ACTIVE  -2 ))       +
                   Prompt( 'Profile inactivity days' )
 
          Parm     ACTDAYS     *Int2                            +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK  -1 ))                       +
                   PmtCtl( P0001 )                              +
                   Prompt( 'Activity days' )
 
          Parm     PWDTYP      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK )                            +
                          ( *NONE  )                            +
                          ( *DFT   )                            +
                          ( *PWD   ))                           +
                   Prompt( 'Password type' )
 
          Parm     PWDSTS      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK ) ( *EXPIRED ) ( *ACTIVE ))  +
                   Prompt( 'Password status' )
 
          Parm     PWDDAYS     *Int2                            +
                   Dft( *NOCHK )                                +
                   Range( 1  999 )                              +
                   SpcVal(( *NOCHK  -1 ))                       +
                   Prompt( 'Password unchanged days' )
 
          Parm     PWDEXPITV   *Int2                            +
                   Range( 1  366 )                              +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK  -2 )                        +
                          ( *NOMAX  -1 )                        +
                          ( *SYSVAL  0 ))                       +
                   Prompt( 'Password expiration interval' )
 
          Parm     INVSGNON    *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK ) ( *CHECK ) ( *SYSLMT ))    +
                   Prompt( 'Invalid signon' )
 
          Parm     USRCLS      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK   )                          +
                          ( *NONUSER )                          +
                          ( *USER    )                          +
                          ( *SYSOPR  )                          +
                          ( *PGMR    )                          +
                          ( *SECADM  )                          +
                          ( *SECOFR  ))                         +
                   Prompt( 'User class' )
 
          Parm     SPCAUT      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SngVal(( *NOCHK )                            +
                          ( *ANY   )                            +
                          ( *NONE  ))                           +
                   SpcVal(( *ALLOBJ   )                         +
                          ( *AUDIT    )                         +
                          ( *IOSYSCFG )                         +
                          ( *JOBCTL   )                         +
                          ( *SAVSYS   )                         +
                          ( *SECADM   )                         +
                          ( *SERVICE  )                         +
                          ( *SPLCTL   ))                        +
                   Max( 8 )                                     +
                   Prompt( 'Special authority' )
 
          Parm     LMTCAP      *Char       10                   +
                   Rstd( *YES )                                 +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK   )                          +
                          ( *ANYLMT  )                          +
                          ( *NO      )                          +
                          ( *PARTIAL )                          +
                          ( *YES     ))                         +
                   Prompt( 'Limit capabilities' )
 
          Parm     GRPPRF      *Generic    10                   +
                   Dft( *NOCHK )                                +
                   SpcVal(( *NOCHK ) ( *ANY ) ( *NONE ))        +
                   Prompt( 'Primary group profile' )
 
          Parm     SUPGRPPRF   *Generic    10                   +
                   Dft( *NOCHK )                                +
                   SngVal(( *NOCHK ) ( *ANY ) ( *NONE ))        +
                   Max( 15 )                                    +
                   Prompt( 'Supplemental groups' )
 
          Parm     SYSPRF        *Char      4                   +
                   Dft( *YES )                                  +
                   Rstd( *YES )                                 +
                   SpcVal(( *YES )                              +
                          ( *NO  ))                             +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Include system profiles' )
 
          Parm     UPDDFTPWD     *Char      4                   +
                   Dft( *YES )                                  +
                   Rstd( *YES )                                 +
                   SpcVal(( *YES )                              +
                          ( *NO  ))                             +
                   Expr( *YES )                                 +
                   PmtCtl( *PMTRQS )                            +
                   Prompt( 'Update default password table' )
 
          Parm     OUTPUT      *Char        3                   +
                   Rstd( *YES )                                 +
                   Dft( * )                                     +
                   SpcVal(( * 'DSP' ) ( *PRINT 'PRT' ))         +
                   Prompt( 'Output' )
 
P0001:    PmtCtl   Ctl( PRFDAYS )                               +
                   Cond(( *EQ -2 ))
 
          Dep      Ctl( &PWDTYP *EQ '*DFT' )                    +
                   Parm(( &UPDDFTPWD *EQ '*NO' ))               +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CBX1001 )
 
          Dep      Ctl( &PRFDAYS *NE -2 )                       +
                   Parm(( ACTDAYS ))                            +
                   NbrTrue( *EQ 0 )                             +
                   MsgId( CBX0101 )
 
