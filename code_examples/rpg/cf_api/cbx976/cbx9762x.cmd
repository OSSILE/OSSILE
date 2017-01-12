/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RTVJOBITPS )                                       */
/*           Pgm( CBX9762 )                                          */
/*           SrcMbr( CBX9762X )                                      */
/*           Allow((*IPGM) (*BPGM) (*IMOD) (*BMOD) (*IREXX) (*BREXX))*/
/*           HlpPnlGrp( CBX9762H )                                   */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Retrieve Job Interrupt Status' )
 
 
          Parm     ITPSTATUS   *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for ITPSTATUS     (1)' )
 
