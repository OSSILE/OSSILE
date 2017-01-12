/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( WRKJOBS )                                          */
/*           Pgm( CBX977 )                                           */
/*           SrcMbr( CBX977X )                                       */
/*           Allow( *INTERACT *IPGM *IREXX *IMOD )                   */
/*           VldCkr( CBX977V )                                       */
/*           MsgF( CBX977M )                                         */
/*           HlpPnlGrp( CBX977H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
             Cmd        Prompt( 'Work with Jobs' )
 
             Parm       JOB         *Generic     10                  +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *CURRENT ))                +
                        Prompt('Job name')
 
             Parm       USER        *Generic     10                  +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *CURRENT ) ( *CURUSR ))    +
                        Prompt( 'User name' )
 
             Parm       STATUS      *Char        10                  +
                        Rstd(*YES)                                   +
                        Dft( *ACTIVE )                               +
                        SpcVal(( *ACTIVE ) ( *JOBQ ) ( *OUTQ )       +
                               ( *ALL ) ( *NONOUTQ ))                +
                        Prompt( 'Job status')
 
             Parm       JOBTYPE     *Char         1                  +
                        Rstd( *YES )                                 +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL    '*' )                       +
                               ( *AUTO   'A' )                       +
                               ( *BATCH  'B' )                       +
                               ( *INTER  'I' )                       +
                               ( *SBSMON 'M' )                       +
                               ( *SPLRDR 'R' )                       +
                               ( *SPLWTR 'W' )                       +
                               ( *SYS    'S' )                       +
                               ( *SCPF   'X' ))                      +
                        Prompt( 'Job type' )
 
             Parm       CURUSR      *Sname       10                  +
                        Dft( *NOCHK )                                +
                        SpcVal(( *NOCHK  ' ' ))                      +
                        PmtCtl( P0001 )                              +
                        Prompt( 'Current user' )
 
             Parm       COMPSTS     *Char        10                  +
                        Rstd( *YES )                                 +
                        Dft( *ALL )                                  +
                        SpcVal(( *ALL ) ( *NORMAL ) ( *ABNORMAL ))   +
                        PmtCtl( P0002 )                              +
                        Prompt( 'Completion status' )
 
 
P0001:       PmtCtl     Ctl( USER )                                  +
                        Cond(( *EQ '*CURUSR' ))
 
P0002:       PmtCtl     Ctl( STATUS )                                +
                        Cond(( *EQ '*OUTQ' ))
 
 
             Dep        Ctl( &USER *NE '*CURUSR' )                   +
                        Parm(( CURUSR ))                             +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0101 )
 
             Dep        Ctl( &USER *EQ '*CURUSR' )                   +
                        Parm(( &STATUS *EQ '*ACTIVE' ))              +
                        NbrTrue( *EQ 1 )                             +
                        MsgId( CBX0102 )
 
             Dep        Ctl( &USER *EQ '*CURUSR' )                   +
                        Parm(( &CURUSR *EQ ' ' ))                    +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0103 )
 
             Dep        Ctl( &STATUS *NE '*OUTQ' )                   +
                        Parm(( COMPSTS ))                            +
                        NbrTrue( *EQ 0 )                             +
                        MsgId( CBX0111 )
 
             Dep        Ctl( &JOB *EQ '*ALL' )                       +
                        Parm(( &USER *EQ '*ALL' )                    +
                             ( &STATUS *EQ '*ALL' ))                 +
                        NbrTrue( *LE 1 )                             +
                        MsgId( CBX0121 )
 
             Dep        Ctl( &JOB *EQ '*ALL' )                       +
                        Parm(( &USER *EQ '*ALL' )                    +
                             ( &STATUS *EQ '*OUTQ' ))                +
                        NbrTrue( *LE 1 )                             +
                        MsgId( CBX0122 )
 
