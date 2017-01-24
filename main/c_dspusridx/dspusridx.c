#include <stdio.h>                          // standard IO
#include <stdlib.h>                         // standrad Lib
#include <string.h>                         // string funcs
#include <qusec.h>                          // Error Code Structs
#include <qusruiat.h>                       // Retrieve Idx Attr
#include <qusrtvui.h>                       // Retrieve Idx Ent

typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[1024];
                        } EC_t;

#define _ERR_REC sizeof(struct EC_x);
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

int main(int argc, char **argv) {
int i = 0;                                  // counter
int Idx_Len = 0;                            // len IDX entry
int Ent = 0;                                // entries in USRIDX
int Atr_Len;                                // Length of Ouput buffer
int Offsets_Len = 16;                       // length of offset buffer
int Num_Ent_Ret = 0;                        // number of entries found
int Max_Ent = 1;                            // maximum entries to return
int Search_Type = 6;                        // return the first entry
int buf_len = 0;                            // buffer length
int Search_Crit_Len = 0;                    // length of serach criteria
int Search_Crit_Offset = 0;                 // not used
int NumEnt = 0;                             // number of entries in IDX
int Output_Len = 0;                         // length ouput buffer
char Lib_Name[10];                          // returned lib name
char Idx_Format[8] = "IDXE0100";            // Index format returned
char Offsets[16];                           // returned offsets
char Format[8] = "IDXA0100";                // output format
char msg_dta[2048];                         // message buffer
char *ent;                                  // mem ptr
char *Search_Crit;                          // search parm
char *tmp;                                  // temp ptr
Qus_IDXA0100_t Atr_Output;                  // Info returned
EC_t Error_Code = {0};                      // Error struct

Error_Code.EC.Bytes_Provided = _ERR_REC;

Atr_Len = sizeof(Atr_Output);
QUSRUIAT(&Atr_Output,
         Atr_Len,
         Format,
         argv[1],
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   sprintf(msg_dta,"Failed to retrieve attributes %.7s %.20s",Error_Code.EC.Exception_Id,argv[1]);
   printf("%s\n",msg_dta);
   exit(-1);
   }
printf("User Index Name %.10s\n",Atr_Output.User_Index_Name);
printf("User Index Library %.10s\n",Atr_Output.User_Index_Lib_Name);
printf("Entry Length %c\n",Atr_Output.Entry_Length_Attribute);
printf("Immediate update %c\n",Atr_Output.Immediate_Update);
printf("Key Insertion %c\n",Atr_Output.Key_Insertion);
printf("Optimized_Processing %c\n",Atr_Output.Optimized_Processing);
printf("Entry Length %d\n",Atr_Output.Entry_Length);
printf("Max Entry_Length %d\n",Atr_Output.Max_Entry_Length);
printf("Key Length %d\n",Atr_Output.Key_Length);
printf("Number Entries Added %d\n",Atr_Output.Number_Entries_Added);
printf("Number Entries Removed %d\n",Atr_Output.Number_Entries_Removed);
printf("Number Retrieve Operations %d\n",Atr_Output.Number_Retrieve_Operations);
NumEnt = (Atr_Output.Number_Entries_Added - Atr_Output.Number_Entries_Removed);
printf("Number of entries to retrieve %d\n",NumEnt);
if(NumEnt > 0) {
   // return buffer has to be 8 bytes longer than largest entry
   Output_Len = Atr_Output.Max_Entry_Length+8;
   ent = malloc(Output_Len);
   // set pointer to returned data
   tmp = ent + 8;
   Search_Crit = malloc(Atr_Output.Max_Entry_Length);
   Search_Crit_Len = Atr_Output.Max_Entry_Length;
   for(i = 0; i < NumEnt; i++) {
      // read each enry and display content
      QUSRTVUI(ent,
               Atr_Output.Max_Entry_Length+8,
               Offsets,
               Offsets_Len,
               &Num_Ent_Ret,
               Lib_Name,
               argv[1],
               Idx_Format,
               Max_Ent,
               Search_Type,
               Search_Crit,
               Search_Crit_Len,
               Search_Crit_Offset,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         sprintf(msg_dta,"Failed to retrieve entry %.7s",Error_Code.EC.Exception_Id);
         printf("%s\n",msg_dta);
         }
      printf("Entry %d %.*s\n",i,Search_Crit_Len,tmp);
      // if i == 0 need to change search type to greater than
      if(i == 0) {
         Search_Type = 2;
         }
      memcpy(Search_Crit,tmp,Atr_Output.Max_Entry_Length);
      } // for loop
   }
free(ent);
free(Search_Crit);
exit(0);
}
