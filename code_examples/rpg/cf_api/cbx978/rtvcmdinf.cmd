/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Compile options:                                                 */
/*                                                                   */
/*    CrtCmd Cmd( RTVCMDINF )                                        */
/*           Pgm( CBX978 )                                           */
/*           SrcMbr( CBX978X )                                       */
/*           Allow((*IPGM) (*BPGM) (*IMOD) (*BMOD) (*IREXX) (*BREXX))*/
/*           HlpPnlGrp( CBX978H )                                    */
/*           HlpId( *CMD )                                           */
/*                                                                   */
/*-------------------------------------------------------------------*/
          Cmd      Prompt( 'Retrieve Command Information' )
 
          Parm     CMD           Q0001                          +
                   Min( 1 )                                     +
                   Choice( *NONE )                              +
                   Prompt( 'Command' )
 
          Parm     RTNCMD      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for RTNCMD       (10)' )
 
          Parm     RTNLIB      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for RTNLIB       (10)' )
 
          Parm     PGM         *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PGM          (10)' )
 
          Parm     PGMLIB      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PGMLIB       (10)' )
 
          Parm     SRCFIL      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for SRCFIL       (10)' )
 
          Parm     SRCLIB      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for SRCLIB       (10)' )
 
          Parm     SRCMBR      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for SRCMBR       (10)' )
 
          Parm     VLDCKR      *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for VLDCKR       (10)' )
 
          Parm     VLDCKRLIB   *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for VLDCKRLIB    (10)' )
 
          Parm     MODE        *Char     100                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for MODE        (100)' )
 
          Parm     ALLOW       *Char     150                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for ALLOW       (150)' )
 
          Parm     ALWLMTUSR   *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for ALWLMTUSR     (1)' )
 
          Parm     MAXPOS      *Dec     ( 10 0 )                +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for MAXPOS     (10 0)' )
 
          Parm     PMTFILE     *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PMTFILE      (10)' )
 
          Parm     PMTFILELIB  *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PMTFILELIB   (10)' )
 
          Parm     MSGF        *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for MSGF         (10)' )
 
          Parm     MSGFLIB     *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for MSGFLIB      (10)' )
 
          Parm     HLPPNLGRP   *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for HLPPNLGRP    (10)' )
 
          Parm     HLPPNLGRPL  *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for HLPPNLGRPL   (10)' )
 
          Parm     HLPID       *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for HLPID        (10)' )
 
          Parm     HLPSCHIDX   *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for HLPSCHIDX    (10)' )
 
          Parm     HLPSCHIDXL  *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for HLPSCHIDXL   (10)' )
 
          Parm     CURLIB      *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for CURLIB       (10)' )
 
          Parm     PRDLIB      *Char        10                  +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PRDLIB       (10)' )
 
          Parm     PMTOVRPGM   *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PMTOVRPGM    (10)' )
 
          Parm     PMTOVRPGML  *Char      10                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PMTOVRPGML   (10)' )
 
          Parm     TGTRLS      *Char       6                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for TGTRLS        (6)' )
 
          Parm     TEXT        *Char      50                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for TEXT         (50)' )
 
          Parm     CPPSTATE    *Char       2                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for CPPSTATE      (2)' )
 
          Parm     VCPSTATE    *Char       2                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for VCPSTATE      (2)' )
 
          Parm     POPSTATE    *Char       2                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for POPSTATE      (2)' )
 
          Parm     CCSID       *Dec     (  5 0 )                +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for CCSID       (5 0)' )
 
          Parm     ENBGUI      *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for ENBGUI        (1)' )
 
          Parm     THDSAFE     *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for THDSAFE       (1)' )
 
          Parm     MLTTHDACN   *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for MLTTHDACN     (1)' )
 
          Parm     PXYIND      *Char       1                    +
                   RtnVal( *YES )                               +
                   Prompt( 'CL var for PXYIND        (1)' )
 
 
 Q0001:   Qual                     *Name     10                   +
                   Min( 1 )                                     +
                   Expr( *YES )
 
          Qual                     *Name     10                   +
                   Dft( *LIBL )                                 +
                   SpcVal(( *LIBL ) ( *CURLIB ))                +
                   Expr( *YES )                                 +
                   Prompt( 'Library' )
 
