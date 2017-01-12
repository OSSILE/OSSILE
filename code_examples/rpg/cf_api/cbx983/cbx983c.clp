/*-------------------------------------------------------------------*/
/*                                                                   */
/*  Program . . : CBX983C                                            */
/*  Description : Set User Query Attributes - Routing Program        */
/*  Author  . . : Carsten Flensburg                                  */
/*  Published . : System iNetwork Systems Management Tips Newsletter */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*  Program function:  Sets the current job's query attributes as    */
/*                     defined by its user's previously registered   */
/*                     user query attributes and then transfers      */
/*                     control to the system default QSYS/QCMD       */
/*                     routing program.                              */
/*                                                                   */
/*                     Before compiling this program ensure that     */
/*                     the GRPPRFOPT parameter of the SETUSRQRYA     */
/*                     command is appropriately set.  By default     */
/*                     GRPPRFOPT(*NONE) is specified.                */
/*                                                                   */
/*                                                                   */
/*  Prerequisite:      A routing entry must be added to the          */
/*                     subsystem description for which the above     */
/*                     change is desired:                            */
/*                                                                   */
/*                       ADDRTGE SBSD(QGPL/QBATCH)                   */
/*                               SEQNBR(9998)                        */
/*                               CMPVAL(QCMDB)                       */
/*                               PGM(CBX983C)                        */
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
/*  Work Management - Routing entries:                               */
/*    http://publib.boulder.ibm.com/infocenter/systems/index.jsp?    */
/*      topic=/rzaks/rzaksaboutroutingentries.htm                    */
/*                                                                   */
/*  Routing Entries - Everything You Always Wanted to Know:          */
/*    http://www-1.ibm.com/support/docview.wss?                      */
/*      uid=nas1aebbb23a7f8b7a1d862565c2007d3147                     */
/*                                                                   */
/*   A Crash Course in Work Management:                              */
/*    http://systeminetwork.com/article/crash-course-work-           */
/*      management-0                                                 */
/*                                                                   */
/*  iSeries Starter Kit: Demystifying Routing:                       */
/*    http://systeminetwork.com/article/iseries-starter-kit-         */
/*    demystifying-routing                                           */
/*                                                                   */
/*  Work with Routing Entries command:                               */
/*    http://systeminetwork.com/article/apis-example-retrieve-       */
/*      subsystem-entries-api                                        */
/*                                                                   */
/*                                                                   */
/*  Compile options:                                                 */
/*    CrtClPgm    Pgm( CBX983C )                                     */
/*                SrcFile( QCLSRC )                                  */
/*                SrcMbr( *PGM )                                     */
/*                                                                   */
/*-------------------------------------------------------------------*/
    PGM
 
/*- Global error monitor:  ------------------------------------------*/
    MONMSG   ( CPF0000  MCH0000 )
 
/*- Set user query attributes:  -------------------------------------*/
 
    SETUSRQRYA   GRPPRFOPT( *NONE )
 
    QSYS/TFRCTL  QSYS/QCMD
 
    ENDPGM
