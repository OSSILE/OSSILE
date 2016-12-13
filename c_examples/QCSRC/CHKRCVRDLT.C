#include <stdio.h>                          // standard I/O
#include <stdlib.h>                         // standard Lib
#include <string.h>                         // memory and string
#include <qjournal.h>                       // Journal functions
#include <qusptrus.h>                       // Pointer User Space
#include <qusdltus.h>                       // Delete User Space
#include <quscrtus.h>                       // Create User Space
#include <qusgen.h>                         // User Space Structs
#include <qwccvtdt.h>                       // Convert date
#include <ledate.h>                         // CEE date functions
#include <qusec.h>                          // Error Code Structs
 
#define _1KB 1024
#define _1MB _1KB * 1024
#define _SECSPERDAY (24 * 60 * 60)
 
typedef struct EC_x {
               Qus_EC_t EC;
               char Exception_Data[48];
               }EC_t;
 
typedef struct Jrn_Req_Inf_x {
               long int Length;
               long int Key;
               long int Data_Length;
               }Jrn_Req_Inf_t;
 
typedef struct Jrn_Req_Str_x {
               long int Num_Keys;
               Jrn_Req_Inf_t Req_Info;
               }Jrn_Req_Str_t;
 
int Crt_Usr_Spc(char *, int );
 
int main(int argc, char **argv) {
int Offset;                                 // offset counter
int junkl;                                  // Int holder
int Num_Days;                               // temp days
long i;                                     // counter
long Rcvr_Struct_Size;                      // receiver size
long Num_Rcvrs = 0;                         // number receivers
long Rec_Size = _1MB;                       // usrspc size
double secs;                                // Secs holder
unsigned char junk2[23];                    // Junk char string
char Time_Stamp[18];                        // Time Stamp holder
char Date[16];                              // date holder
char R_Date[8];                             // recvr date
char D_Date[8];                             // delete date
char *space;                                // character pointers
char *tmp;                                  // temp ptr
char *recvr_ptr;                            // recvr ptr
char Jrn_SPC_Name[20] = "JOURNAL   QTEMP     "; // usrspc
char data[60];                              // data buffer
Jrn_Req_Str_t Req_Inf;                      // request info
Qjo_RJRN0100_t *Jrn_Dets;                   // journal info ptr
Qjo_JN_Repeating_Key_Fields_t *Key_Inf_Hdr; // key hdr struct ptr
Qjo_JN_Key_1_Output_Section_t *Rcvr_Inf_Hdr;// rcvr hdr struct ptr
Qjo_JN_Repeating_Key_1_Output_t *Rcvr_Dets_Ptr; // rcvr dets ptr
Qjo_RRCV0100_t Rcvr_Output;                 // recvr info struct
EC_t Error_Code = {0};                      // Error Code
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
Num_Days = *(int *)argv[2];
Rcvr_Struct_Size = sizeof(Rcvr_Output);
// set up the date for checking delete option
CEELOCT(&junkl, &secs,junk2,NULL);
secs -= ((int)Num_Days) * _SECSPERDAY;
CEEDATM(&secs,"YYYYMMDDHHMISS999",Time_Stamp,NULL);
QWCCVTDT ("*YYMD     ", Time_Stamp, "*YMD      ", Date, &Error_Code);
strncpy(R_Date,Date,7);
// create the user space
if(!Crt_Usr_Spc(Jrn_SPC_Name,_1MB)) {
   printf("Failed to create the userspace\n");
   exit(-1);
   }
// Get a pointer to the USRSPC
QUSPTRUS(Jrn_SPC_Name,
         &space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed to get pointer\n");
   exit(-1);
   }
// Set up the Key request
Req_Inf.Num_Keys = 1;
Req_Inf.Req_Info.Key = 1;
Req_Inf.Req_Info.Data_Length = 0;
Req_Inf.Req_Info.Length = sizeof(struct Jrn_Req_Inf_x);
// Request the journal information
QjoRetrieveJournalInformation(space,
                              &Rec_Size,
                              argv[1],
                              "RJRN0100",
                              &Req_Inf,
                              &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed to retrieve information\n");
   exit(-1);
   }
// Set up the pointers to the user space
tmp = space;
Jrn_Dets = (Qjo_RJRN0100_t *)space;
// Check that all details have been returned
if(Jrn_Dets->Bytes_Available != Jrn_Dets->Bytes_Returned) {
   printf("Incorrect data retturned\n");
   exit(-1);
   }
/* Extract the journal receiver information
 * walk through the data to the receiver information at the end               */
tmp += sizeof(struct Qjo_RJRN0100);
Key_Inf_Hdr = (Qjo_JN_Repeating_Key_Fields_t *)tmp;
Offset = sizeof(struct Qjo_JN_Repeating_Key_Fields);
tmp += Offset;
Rcvr_Inf_Hdr = (Qjo_JN_Key_1_Output_Section_t *)tmp;
Num_Rcvrs = Rcvr_Inf_Hdr->Tot_Num_Jrn_Rcvs;
Offset = sizeof(struct Qjo_JN_Key_1_Output_Section);
tmp += Offset;
Rcvr_Dets_Ptr = (Qjo_JN_Repeating_Key_1_Output_t *)tmp;
// now have to get the detach date for the receivers
for(i = 0; i < Num_Rcvrs; i++) {
   QjoRtvJrnReceiverInformation(&Rcvr_Output,
                                &Rcvr_Struct_Size,
                                Rcvr_Dets_Ptr->Jrn_Rcv_Name,
                                "RRCV0100",
                                &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      printf("Exception ID %.7s\n",Error_Code.EC.Exception_Id);
      exit(-1);
      }
   strncpy(D_Date,Rcvr_Output.Detach_Date_Time,7);
   if((atoi(R_Date) > atoi(D_Date)) &&
      (memcmp(Rcvr_Output.Detach_Date_Time,"0000000000000",13) != 0)) {
      printf("Would delete receiver %.20s\n",Rcvr_Output.Jrn_Rcv_Name);
      }
   else
      printf("Would not delete receiver %.20s\n",Rcvr_Output.Jrn_Rcv_Name);
   Rcvr_Dets_Ptr++;
   }
return 1;
}
 
/**
  * (Function) Crt_UsrSpc()
  * Creates user space with details passed
  * @parms
  *     Space name and library
  *     size of user space to be created
  * returns 1 for complete
  */
 
int Crt_Usr_Spc(char *SPC_Name,
                int Initial_Size) {
char Ext_Atr[10] = "USRSPC    ";            // Extended attribute of USRSPC
char Initial_Value = '0';                   // Initial value in USRSPC
char Auth[10] = "*CHANGE   ";               // Public authority to USRSPC
char SPC_Desc[50] = {' '};                  // USRSPC Description
char Replace[10] = "*YES      ";            // Whether to replace USRSPC
EC_t Error_Code = {0};                      // Error Code struct
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
QUSCRTUS(SPC_Name,
         Ext_Atr,
         Initial_Size,
         &Initial_Value,
         Auth,
         SPC_Desc,
         Replace,
         &Error_Code,
         "*USER     ");
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Error occured %.7s\n",Error_Code.EC.Exception_Id);
   return -1;
   }
return 1;
}
