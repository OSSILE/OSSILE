/* this sample looks at the signatures available in a Service program
 * and compares it with the signature of which was set when the
 * program was compiled. this allows you to verify the program
 * will run without causing a signature violation. It can be expanded
 * to look through all of the objects in a library and confirm no
 * signature violations exist.
 * @parms
 *      Server Program character 20 'PgmName   Library   '
 *      Program which uses the service program character 20 'PgmName   Library   '
 */
#include <qbnlpgmi.h>                       // ILE pgm info
#include <qbnlspgm.h>                       // Srv pgm info
#include <quscrtus.h>                       // create user space
#include <qusptrus.h>                       // ptr to usrspc
#include <qusgen.h>                         // usrspc gen hdr
#include <qusec.h>                          // error code
#include <stdio.h>                          // std IO
#include <stdlib.h>                         // std lib
#include <string.h>                         // string hdr
 
// structure type def
typedef struct  EC_x {
                Qus_EC_t EC;
                char Exception_Data[1024];
                }EC_t;
// defines
#define _1KB 1024
#define _1MB _1KB * _1KB
#define _4MB _1MB * 4
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)
 
/*
 * function Dump_Hex_Output()
 * Purpose: Prints the Hex values for the passed buffer
 * @parms
 *      Buffer
 *      size of buffer
 * returns void
 */
 
void Dump_Hex_Output(const char* buf,
                     size_t buf_len) {
while(buf_len > 0) {
   printf("%02x",*buf);
   buf_len--;
   buf++;
   }
}
 
int main(int argc, char **argv) {
int i = 0;                                  // counter
int j = 0;                                  // counter
int svrpgm_sigs = 0;                        // counter
char SpcName[20] = "QBNLPGMI  QTEMP     ";  // usrspc
char Format1[8] = "SPGL0800";               // request format
char Format[8] = "PGML0200";                // request format
char SPC_Desc[50] = {' '};                  // USRSPC Description
char Replace[10] = "*YES      ";            // Replace USRSPC
char Ext_Atr[10] = "USRSPC    ";            // Ext attr USRSPC
char Initial_Value = ' ';                   // Init val USRSPC
char Auth[10] = "*CHANGE   ";               // Pub aut to USRSPC
char Signature[16][20];                     // SrvPgm Signatures
char *List_Section;                         // usrspc list ptr
char *tmp;                                  // temp ptr
Qbn_LPGMI_PGML0200_t *Entry;                // info
Qbn_LSPGM_SPGL0800_t *SrvEntry;             // SrvPgm Info
Qus_Generic_Header_0100_t *space;           // usrspc hdr ptr
EC_t Error_Code;                            // error struct
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
QUSCRTUS(SpcName,
         Ext_Atr,
         _4MB,
         &Initial_Value,
         Auth,
         SPC_Desc,
         Replace,
         &Error_Code,
         "*USER     ");
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed to create the usrspc %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
QUSPTRUS(SpcName,
         &space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Could not get pointer to space %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
// get the service program signature first
QBNLSPGM(SpcName,
         Format1,
         argv[1],
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed to retrieve SrvPgm data %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
// get to the contents
tmp = (char *)space;
if(space->Number_List_Entries < 1) {
   printf("no signature info\n");
   exit(0);
   }
// print out the current signature for the service program
List_Section = (char *)space;
List_Section = List_Section + space->Offset_List_Data;
SrvEntry = (Qbn_LSPGM_SPGL0800_t *)List_Section;
svrpgm_sigs = space->Number_List_Entries;
for(i = 0; i < space->Number_List_Entries;i++) {
   memcpy(Signature[i],SrvEntry->Signature,16);
   printf("Signature %d : ",i);
   Dump_Hex_Output(Signature[i],16);
   printf("\n");
   SrvEntry++;
   }
// check the program
QBNLPGMI(SpcName,
         Format,
         argv[2],
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed to retrieve data\n");
   exit(-1);
   }
// get to the contents
tmp = (char *)space;
if(space->Number_List_Entries < 1) {
   printf("no info\n");
   exit(0);
   }
else {
   List_Section = (char *)space;
   List_Section = List_Section + space->Offset_List_Data;
   Entry = (Qbn_LPGMI_PGML0200_t *)List_Section;
   for(i = 0; i < space->Number_List_Entries; i++) {
      if(memcmp(argv[1],Entry->Bound_Service_Program,10) == 0) {
         printf("Program Name %.10s\n",Entry->Program_Name);
         printf("Program Library %.10s\n",Entry->Program_Library_Name);
         printf("Service Program %.10s\n",Entry->Bound_Service_Program);
         printf("Service Program Lib %.10s\n",Entry->Bound_Service_Library_Name);
         // the signature is not a normal character string
         printf("Signature : ");
         Dump_Hex_Output(Entry->Bound_Service_Signature,16);
         for(j = 0; j < svrpgm_sigs;j++) {
            if(memcmp(Signature[j],Entry->Bound_Service_Signature,16) == 0) {
               printf("\t Signature Match %d",j);
               break;
               }
            }
         printf("\n");
         printf("Activation%.10s\n",Entry->Bound_Service_Program_Activation);
         }
      Entry++;
      }
   }
exit(0);
}
