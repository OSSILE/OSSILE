/* purpose of this program is to extract information about the system such as
 * memory utilization and DASD utilization. It shows how to call the various API's
 * required to carry out the task.
 * @parms
 *      *NONE
 */
#include <stdio.h>                          // Standard I/O
#include <stdlib.h>                         // Standard Lib
#include <recio.h>                          // File Record level access
#include <xxcvt.h>                          // Conversion of int etc to zoned/packed
#include <decimal.h>                        // needed for mapping custdets file
#include <qwcrssts.h>                       // ret syssts
#include <qusec.h>                          // Error Code Structures
 
// error struct define
typedef struct EC_x {
               Qus_EC_t EC;
               char Exception_Data[48];
               }EC_t;
// definitions
#define _1KB 1024
#define _8K _1KB * 8
#define _32K _1KB * 32
#define _64K _1KB * 64
#define _1MB _1KB * _1KB
#define _1GB ((long)_1MB * _1KB)
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)
 
int main(int argc, char **argv) {
int List_Info_Len = sizeof(List_Info);      // list info len
float pct_avail;                            // available percent
float dasd_avail;                           // dasd available
char Reset[10] = "*NO       ";              // reset info
char Fmt_Name[8] = "SSTS0200";              // request format
Qwc_SSTS0200_t List_Info;                   // list info struct
EC_t Error_Code = {0};                      // error struct
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
QWCRSSTS(&List_Info,
         List_Info_Len,
         Fmt_Name,
         Reset,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Error code QWCRSSTS %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
// convert the information and push to stdout
pct_avail = (float)100 - (List_Info.Pct_System_ASP_used/10000);
dasd_avail = List_Info.Total_Aux_Storage * pct_avail/100000;
// print the information to stdout
printf("Percentage Available disk %.1f%%\n",pct_avail);
printf("Total %.3fGB\n",(float)List_Info.Total_Aux_Storage/1000);
printf("Dasd available = %.3fGB\n",dasd_avail);
printf("System Name %.8s\n",List_Info.System_Name);
if(*List_Info.Restricted_State == '0')
   printf("System not in Restricted State\n");
if(*List_Info.Restricted_State == '1')
   printf("System in Restricted State\n");
printf("Processor Used %.1f%%\n",(float)List_Info.Pct_Processing_Unit_Used/1000);
printf("Jobs in System %d\n",List_Info.Jobs_In_System);
printf("%% Perm Addresses %.3f%%\n",(float)List_Info.Pct_Perm_Addresses/1000);
printf("%% Temp Addresses %.3f%%\n",(float)List_Info.Pct_Temp_Addresses/1000);
printf("System ASP %.3fGB\n",List_Info.System_ASP/1000);
printf("%% System ASP Used %.3f%%\n",(float)List_Info.Pct_System_ASP_used/10000);
printf("Total Storage %.3fGB\n",(float)List_Info.Total_Aux_Storage/1000);
printf("Unprotected %dMB\n",List_Info.Current_Unprotect_Storage);
printf("Max Unprotected %dMB\n",List_Info.Maximum_Unprotect_Storage);
if(List_Info.DB_Capability == -1)
   printf("DB Capability not reported\n");
else
   printf("%% DB Capability %.1f%%\n",(float)List_Info.DB_Capability/1000);
printf("Number of partitions %d\n",List_Info.Number_Of_Partitions);
printf("Partition Identifier %d\n",List_Info.Partition_Identifier);
printf("Current Processor Capacity %.2f\n",(float)List_Info.Current_Processing_Capacity/100);
if(List_Info.Processor_Sharing_Attribute == '0')
   printf("Processor Sharing *NONE\n");
if(List_Info.Processor_Sharing_Attribute == '1')
   printf("Processor Sharing *CAPPED\n");
if(List_Info.Processor_Sharing_Attribute == '2')
   printf("Processor Sharing *UNCAPPED\n");
printf("Number of processors %d\n",List_Info.Number_Of_Processors);
printf("Number Active Jobs %d\n",List_Info.Active_Jobs_In_System);
printf("Active Threads %d\n",List_Info.Active_Threads_In_System);
printf("Max jobs in System %d\n",List_Info.Maximum_Jobs_In_System);
printf("Temp 256MB segments %.2f%%\n",(float)List_Info.Temp_256MB_Segments/100);
printf("Temp 4GB Segments %.2f%%\n",(float)List_Info.Temp_4GB_Segments/100);
printf("Perm 256MB Segments %.2f%%\n",(float)List_Info.Perm_256MB_Segments/100);
printf("Perm 4GB Segments %.2f%%\n",(float)List_Info.Perm_4GB_Segments/100);
printf("Curr Interactive Perf %d%%\n",List_Info.Cur_Interactive_Performance);
printf("Uncapped CPU Used %.2f%%\n",(float)List_Info.Uncapped_CPU_Capacity_Used/10);
if(List_Info.Shared_Processor_Pool_Used == -1)
   printf("Shared Processor not used\n");
else
   printf("Shared processor used %.2f%%\n",
                              (float)List_Info.Shared_Processor_Pool_Used/10);
printf("Main memory %.3fGB\n",(float)List_Info.Main_Storage_Size/1048576);
exit(0);
}
