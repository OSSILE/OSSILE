#include <stdio.h>                          // standard I/O
#include <stdlib.h>                         // standard I/O
#include <string.h>                         // memory and string
#include <qwcrssts.h>                       // system status collection
#include <qusptrus.h>                       // usrspc ptr
#include <quscrtus.h>                       // usrspc ptr
#include <qclrdtaq.h>                       // clear dta queue
#include <qusljob.h>                        // Jobs in system
#include <qusgen.h>                         // generic space header
#include <errno.h>                          // Error Num Conversion
#include <qusec.h>                          // error code

typedef _Packed struct  A_Job_Inf_x{
                        char Job_Name[10];
                        char Usr_Name[10];
                        char Job_Number[6];
                        char Int_Job_Id[16];
                        char Status[10];
                        char Job_Type;
                        char Job_Sub_Type;
                        char Sbs_Name[20];
                        char Job_Status[4];
                        char Function[10];
                        char Func_Type;
                        char Start_Time[13];
                        int  Pool_Id;
                        long int  CPU_Cycles;
                        int  Job_Pty;
                        long int  Num_Int_Trans;
                        long int  Tot_Resp_Time;
                        long int  Aux_IO;
                        long int  Threads;
                        char Le_Hndle[4];
                        }A_Job_Inf_t;

typedef _Packed struct  Job_List_Hdr_x {
                        unsigned int data_length;
                        unsigned int tot_cycles;
                        unsigned int number_list_entries;
                        unsigned int offset_list_entries;
                        } Job_List_Hdr_t;

typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[1024];
                        } EC_t;

// define size setting etc
#define _ERR_REC sizeof(struct EC_x);
#define _1KB 1024
#define _8K _1KB * 8
#define _32K _1KB * 32
#define _64K _1KB * 64
#define _1MB _1KB * _1KB
#define _16MB 16773120
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)
// function pre declarations
int Build_Job_Dta(Qus_Generic_Header_0100_t *, char *);
int Crt_Usr_Spc(char *, int);

int main(int argc, char **argv) {
int A_Key_Input[12] = {1906,101,601,602,    // active job key struct
                       401,307,304,1802,
                       1402,1801,1401,2008};
int i,rc = 0;                               // various ints
int data_length = 0;                        // length of space data
char Job_Type = '*';                        // Job Info type
char msg_dta[255];                          // message data
char Reset[10] = "*YES      ";              // Reset request
char Spc_Name[20] = "QUSLJOB   QTEMP     "; // space name
char Sys_Spc_Name[20] = "SYSSTATUS QTEMP     "; // space name
char Tmp_Spc_Name[20] = "ACTJOB    QTEMP     "; // space name
char Format_Name[8] = "JOBL0200";           // Job Format
char Q_Job_Name[26] = "*ALL      *ALL      *ALL  ";  // Job Name
char *sys_space;                            // job info ptr
char *tmp_space;                            // job info ptr
char *tmp;                                  // temp ptr
Qwc_SSTS0200_t Buf;                         // system status buffer
Qus_Generic_Header_0100_t *space;           // User Space Hdr Ptr
Job_List_Hdr_t *Space_Hdr;                  // job list space hdr
A_Job_Inf_t *AJBuf;                         // struct for active job info
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = _ERR_REC;
// get usrspc pointers
QUSPTRUS(Spc_Name,
         &space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9801",7) == 0) {
      // create the user space
      if(Crt_Usr_Spc(Spc_Name,_16MB) != 1) {
         printf(" Create error %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      QUSPTRUS(Spc_Name,
               &space,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         printf("Pointer error %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      }
   else {
      printf("Some error %.7s\n",Error_Code.EC.Exception_Id);
      exit(-1);
      }
   }
QUSPTRUS(Tmp_Spc_Name,
         &tmp_space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9801",7) == 0) {
      // create the user space
      if(Crt_Usr_Spc(Tmp_Spc_Name,_16MB) != 1) {
         printf(" Create error 2 %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      QUSPTRUS(Tmp_Spc_Name,
               &tmp_space,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         printf("Pointer error 2 %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      }
   else {
      printf("Some error 2 %.7s\n",Error_Code.EC.Exception_Id);
      exit(-1);
      }
   }
QUSPTRUS(Sys_Spc_Name,
         &sys_space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9801",7) == 0) {
      // create the user space
      if(Crt_Usr_Spc(Sys_Spc_Name,_64K) != 1) {
         printf(" Create error 3 %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      QUSPTRUS(Sys_Spc_Name,
               &sys_space,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         printf("Pointer error 3 %.7s\n",Error_Code.EC.Exception_Id);
         exit(-1);
         }
      }
   else {
      printf("Some error s %.7s\n",Error_Code.EC.Exception_Id);
      exit(-1);
      }
   }
Space_Hdr = (Job_List_Hdr_t *)tmp_space;
QWCRSSTS(&Buf,
         sizeof(Buf),
         "SSTS0200",
         Reset,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("QWCRSSTS error %.7s\n",Error_Code.EC.Exception_Id);
   return -1;
   }
// list the jobs to the user space
QUSLJOB(Spc_Name,
        Format_Name,
        Q_Job_Name,
        "*ACTIVE   ",
        &Error_Code,
        Job_Type,
        12,
        A_Key_Input);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("QUSLJOB error %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
// map the data
Buf.Jobs_In_System = space->Number_List_Entries;
// build the job structure
Build_Job_Dta(space,tmp_space);
memcpy(sys_space,&Buf,sizeof(Buf));
// lets see whats in the space
tmp = tmp_space;
tmp += Space_Hdr->offset_list_entries;
AJBuf = (A_Job_Inf_t *)tmp;
for(i = 0; i < Space_Hdr->number_list_entries; i++ ) {
   printf("Job Info %26.s ",AJBuf->Job_Name);
   printf("Status %.10s ",AJBuf->Status);
   printf("Job Type %c ",AJBuf->Job_Type);
   printf("Job Sub Type %c ",AJBuf->Job_Sub_Type);
   printf("Sbs Name %.20s ",AJBuf->Sbs_Name);
   printf("Job Status %.4s ",AJBuf->Job_Status);
   printf("Function %.10s",AJBuf->Function);
   printf("Function Type %c ",AJBuf->Func_Type);
   printf("Pool ID %d ",AJBuf->Pool_Id);
   printf("CPU Cycles %lu ",AJBuf->CPU_Cycles);
   printf("Job Priority %d ",AJBuf->Job_Pty);
   printf("Num Int Trans %lu ",AJBuf->Num_Int_Trans);
   printf("Total Resp Time %lu ",AJBuf->Tot_Resp_Time);
   printf("Aux IO %lu ",AJBuf->Aux_IO);
   printf("Threads = %lu \n",AJBuf->Threads);
   AJBuf++;
   }
return 1;
}

/**
  * (Function) Build_Job_Dta()
  * Read through output and build job data struct
  * @parms
  *     Space ptr
  *     temp spc ptr
  * returns 1 for complete
  */

int Build_Job_Dta(Qus_Generic_Header_0100_t *space,
                  char *tmp_space) {
int i,j = 0;                                // counters
int data_length = 0;                        // data length
int num_fields = 0;                         // number fields
int key = 0;                                // field key
int dta_len = 0;                            // key data length
int dta_offset = 0;                         // data offset
char c;                                     // char holder
char reset[10] = "*YES      ";              // reset entry
char *tmp;                                  // temp ptr
char *List_Section;                         // list ptr
char *key_dta;                              // key ptr
char *next_entry;                           // next ptr
char *Buf_Ptr;                              // buffer ptr
char Tmp_Spc_Name[20] = "ACTJOB    QTEMP     "; // space name
Qus_JOBL0200_t *Hdr;                        // header ptr
Qwc_SSTS0200_t Sys_Buf;                     // system status buffer
Qus_Ljob_Key_Fields_t *Key_Info;            // key info ptr
A_Job_Inf_t Buf;                            // struct
Job_List_Hdr_t *Space_Hdr;                  // job list space hdr

dta_offset = sizeof(_Packed struct Qus_Ljob_Key_Fields);
List_Section = (char *)space;
List_Section += space->Offset_List_Data;
// add the list entries hdr info
Space_Hdr = (Job_List_Hdr_t *)tmp_space;
Space_Hdr->number_list_entries = space->Number_List_Entries;
Space_Hdr->offset_list_entries = sizeof(_Packed struct Job_List_Hdr_x);
data_length = Space_Hdr->offset_list_entries;
Space_Hdr->tot_cycles = 0;
// set up the list pointer
tmp = tmp_space + sizeof(_Packed struct Job_List_Hdr_x);
Buf_Ptr = tmp;

for(j = 0; j < space->Number_List_Entries; j++) {
   Hdr = (Qus_JOBL0200_t *)List_Section;
   tmp = List_Section;
   tmp += sizeof(_Packed struct Qus_JOBL0200);
   Key_Info = (Qus_Ljob_Key_Fields_t *)tmp;
   Buf.CPU_Cycles = 0;
   memcpy(Buf.Job_Name,Hdr->Job_Name_Used,54);
   key = Key_Info->Key_Field;
   next_entry = tmp + Key_Info->Length_Field_Info_Rtnd;
   num_fields = Hdr->Number_Fields_Rtnd;
   for(i = 0; i < num_fields; i++) {
      key_dta = (char *)Key_Info;
      key_dta += dta_offset;
      switch(key) {
         case   101   :   {
            if(Key_Info->Length_Data > 0) {
               memcpy(Buf.Job_Status,key_dta,4);
               break;
               }
            }
         case   401   :   {
            if(Key_Info->Length_Data > 0) {
               memcpy(Buf.Start_Time,key_dta,13);
               break;
               }
            }
         case   601   :   {
            if(Key_Info->Length_Data > 0) {
               memcpy(Buf.Function,key_dta,10);
               break;
               }
            }
         case   602   :   {
            if(Key_Info->Length_Data > 0) {
               memcpy(&Buf.Func_Type,key_dta,1);
               break;
               }
            }
         case   1906   :   {
            if(Key_Info->Length_Data > 0) {
               memcpy(Buf.Sbs_Name,key_dta,20);
               break;
               }
            }
         case   304   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.CPU_Cycles = *(long int *)key_dta;
               Space_Hdr->tot_cycles += Buf.CPU_Cycles;
               break;
               }
            }
         case   307   :   {
            if(Key_Info->Length_Data > 0)  {
               Buf.Pool_Id = *(int *)key_dta;
               break;
               }
            }
         case   1401   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.Aux_IO = *(long int *)key_dta;
               break;
               }
            }
         case   1402   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.Num_Int_Trans = *(long int *)key_dta;
               break;
               }
            }
         case   1801   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.Tot_Resp_Time = *(long int *)key_dta;
               break;
               }
            }
         case   1802   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.Job_Pty = *(int *)key_dta;
               break;
               }
            }
         case   2008   :   {
            if(Key_Info->Length_Data > 0) {
               Buf.Threads = *(long int *)key_dta;
               break;
               }
            }
         default   :   {
            break;
            }
         }
      Key_Info = (Qus_Ljob_Key_Fields_t *)next_entry;
      next_entry += Key_Info->Length_Field_Info_Rtnd;
      key = Key_Info->Key_Field;
      }
   // now copy the data to the list buffer
   List_Section += space->Size_Each_Entry;
   data_length += sizeof(Buf);
   memcpy(Buf_Ptr,&Buf,sizeof(Buf));
   Buf_Ptr += sizeof(Buf);
   }
Space_Hdr->data_length = data_length;
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
char Ext_Atr[10] = "USRSPC    ";            // Ext attr USRSPC
char Initial_Value = '0';                   // Init val USRSPC
char Auth[10] = "*CHANGE   ";               // Pub aut to USRSPC
char SPC_Desc[50] = {' '};                  // USRSPC Description
char Replace[10] = "*YES      ";            // Replace USRSPC
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = _ERR_REC;
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
   printf(" Create space error %.7s\n",Error_Code.EC.Exception_Id);
   return -1;
   }
return 1;
}
