/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX976M                                            */
/*  Description : Set Job Interrupt Status - Routing Program         */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*  Program function:  Sets the current job interrupt status to      */
/*                     the specified value and then transfers        */
/*                     control to the system default QSYS/QCMD       */
/*                     routing program.                              */
/*                                                                   */
/*  Prerequisite:      A routing entry must be added to the          */
/*                     subsystem description for which the above     */
/*                     change is desired:                            */
/*                                                                   */
/*                       ADDRTGE SBSD(QGPL/QBATCH)                   */
/*                               SEQNBR(9998)                        */
/*                               CMPVAL(QCMDB)                       */
/*                               PGM(CBX976)                         */
/*                               CLS(*SBSD)                          */
/*                                                                   */
/*                     The above command will ensure that this       */
/*                     program by default is run for all jobs        */
/*                     submitted by the Submit Job (SBMJOB) command  */
/*                     to a job queue pointing to subsystem QBATCH,  */
/*                     provided that the SBMJOB command's default    */
/*                     routing data is not changed.                  */
/*                                                                   */
/*                     All other job's routed into subsystem QBATCH  */
/*                     with a routing data value of QCMDB will also  */
/*                     be altered by this routing program, following */
/*                     the above change.                             */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX976 )                                      */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/
    Pgm
 
/*- Variables & constants:  -----------------------------------------*/
    Dcl        &Type          *Char      1
 
    Dcl        &BATCH         *Char      1    '0'
 
/*- Global error monitor:  ------------------------------------------*/
    MonMsg   ( CPF0000  MCH0000 )
 
 
/*- Set batch default job interrupt status:  ------------------------*/
 
    RtvJobA    Type( &Type )
 
    If       ( &Type = &BATCH )          Do
 
    ChgJobItpS ItpSts( *ALWITP )
    EndDo
 
    QSYS/TFRCTL  QSYS/QCMD
 
    EndPgm
