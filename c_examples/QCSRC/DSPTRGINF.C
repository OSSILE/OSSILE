/* Purpose of this program is to show how to retrieve the triggers attached to a file
 * using the API's available. The program could be updated to remove or disable any
 * triggers.
 * @parms
 *      File Name 20 character 'FileName  Library   '
 */
#include <stdio.h>                          // standard I/O
#include <stdlib.h>                         // standard I/O
#include <string.h>                         // memory and string
#include <qusptrus.h>                       // Pointer User Space
#include <qusdltus.h>                       // Delete User Space
#include <quscrtus.h>                       // Create User Space
#include <qusgen.h>                         // User Space Structs
#include <qusec.h>                          // Error Code Structs
#include <except.h>                         // exception header
#include <qmhsndm.h>                        // send message
#include <qmhsndpm.h>                       // Send Program Message
#include <qdbrtvfd.h>                       // retrieve file desc
#include <errno.h>
 
typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[48];
                        } EC_t;
 
#define _ERR_REC sizeof(struct EC_x);
 
#define _DFT_MSGQ "*REQUESTER*LIBL     "
#define _DFT_MSGF "QCPFMSG   *LIBL     "
#define _1KB 1024
#define _1MB _1KB * 1024
#define _4MB _1MB * 4
#define _16MB 16773120
#define MAX_MSG 2048
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)
 
/*
 * function snd_error_msg()
 * Purpose: Forward an Error Message to the message queue.
 * @parms
 *      Error Code Structure
 * returns void
 */
 
void snd_error_msg(EC_t Error_Code) {
int data_len = 0;                           // data length
char Msg_Type[10] = "*INFO     ";           // msg type
char Msg_File[20] = "QCPFMSG   *LIBL     "; // Message file to use
char Msg_Key[4] = {' '};                    // msg key
char QRpy_Q[20] = {' '};                    // reply queue
EC_t E_Code = {0};                          // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
if(Error_Code.EC.Bytes_Available < 16)
   data_len = 16;
else
   data_len = Error_Code.EC.Bytes_Available - 16;  // BA + BP +msgid +rsvd
QMHSNDPM(Error_Code.EC.Exception_Id,
         Msg_File,
         Error_Code.Exception_Data,
         data_len,
         "*DIAG     ",
         "*         ",
         0,
         Msg_Key,
         &E_Code);
if(E_Code.EC.Bytes_Available > 0) {
   snd_error_msg(E_Code);
   }
QMHSNDM(Error_Code.EC.Exception_Id,
        Msg_File,
        Error_Code.Exception_Data,
        data_len,
        Msg_Type,
        _DFT_MSGQ,
        1,
        QRpy_Q,
        Msg_Key,
        &E_Code);
if(E_Code.EC.Bytes_Available > 0) {
   snd_error_msg(E_Code);
   }
return;
}
 
/*
 * function snd_msg()
 * Purpose: Place a message in the message queue.
 * @parms
 *      string MsgID
 *      string Msg_Data
 *      int Msg_Dta_Len
 * returns void
 */
 
void snd_msg(char * MsgID,char * Msg_Data,int Msg_Dta_Len) {
char Msg_Type[10] = "*INFO     ";           // msg type
char Call_Stack[10] = {"*EXT      "};       // call stack entry
char QRpy_Q[20] = {' '};                    // reply queue
char Msg_Key[4] = {' '};                    // msg key
EC_t Error_Code = {0};                      // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
QMHSNDM(MsgID,
        _DFT_MSGF,
        Msg_Data,
        Msg_Dta_Len,
        Msg_Type,
        _DFT_MSGQ,
        1,
        QRpy_Q,
        Msg_Key,
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
QMHSNDPM(MsgID,
         _DFT_MSGF,
         Msg_Data,
         Msg_Dta_Len,
         "*DIAG     ",
         "*         ",
         0,
         Msg_Key,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   }
return;
}
 
/*
 * function Crt_Usr_Spc()
 * Purpose: To create a Userspace object.
 * @parms
 *      string Name
 *      int size
 * returns 1 on sucess
 */
 
int Crt_Usr_Spc(char *SPC_Name, int Initial_Size) {
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
   snd_error_msg(Error_Code);
   return -1;
   }
return 1;
}
 
/*
 * function Crt_Q_Name()
 * Purpose: To create a qualified object name. LIB/OBJ
 * @parms
 *      string object
 *      string q name
 * returns 1 success
 */
 
int Crt_Q_Name(char *Object,char *Q_Name) {
int i,j = 0;                                // counters
 
for(i = 10,j = 0; i < 20; i++,j++) {
   Q_Name[j] = (Object[i] == ' ') ? '\0' : Object[i];
   }
Q_Name[j] = '\0';
strcat(Q_Name,"/");
j = strlen(Q_Name);
for(i = 0;i < 10;i++,j++) {
   Q_Name[j] = (Object[i] == ' ') ? '\0' : Object[i];
   }
Q_Name[j] = '\0';
return 1;
}
 
 
int main(int argc, char **argv) {
int i = 0;                                  // counter
int ret = 0;                                // cmd ret val
int num_trg = 0;                            // number of triggers
int debug = 1;                              // debug flag
char Q_File[22];                            // Qual File name
char DB_SPC[20] = "TRGINFO   QTEMP     ";   // USRSPC
char Rtn_File_Name[20];                     // returned file name
char trigger_name[269];                     // trigger name
char trigger_lib[11];                       // trigger library
char cmd[1024];                             // command buffer
char Q_Trgf[22];                            // Qual Trigger File
char Trgf[20] = "TRGDETS             ";     // Trigger File
char msg_dta[1024];                         // message buf
char *dbptr;                                // char ptr
char *tmp;                                  // temp ptr
Qdb_Qdbftrg_Head_t *hdr;                    // header info
Qdb_Qdbftrg_Def_Head_t *def_hdr;            // definition header
Qdb_Qdbftrg_Name_Area_t *trg_name;          // trigger name definition
EC_t Error_Code = {0};                      // Error code data
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
// create the user space
QUSPTRUS(DB_SPC,
         &dbptr,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9801",7) == 0) {
      if(!Crt_Usr_Spc(DB_SPC,_16MB)) {
         exit(-1);
         }
      QUSPTRUS(DB_SPC,
               &dbptr,
               &Error_Code);
      if(Error_Code.EC.Bytes_Available > 0) {
         snd_error_msg(Error_Code);
         exit(-1);
         }
      }
   else {
      snd_error_msg(Error_Code);
      exit(-1);
      }
   }
memset(Q_File,' ',22);
Crt_Q_Name(argv[1],Q_File);
// get the trigger information
QDBRTVFD(dbptr,
         _16MB,
         Rtn_File_Name,
         "FILD0400",
         argv[1],
         "*FIRST    ",
         "0",
         "*LCL      ",
         "*EXT      ",
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
hdr = (Qdb_Qdbftrg_Head_t *)dbptr;
printf("Bytes Returned %d\n",hdr->Qdb_Qdbftrg_Bytes_Returned);
num_trg = hdr->Qdb_Qdbftrg_Num_Trgs;
if(num_trg > 0) {
   // triggers are set
   printf("Num Triggers %d Offset %d\n",num_trg,hdr->Qdb_Qdbftrg_Off_Ent_Num1);
   tmp = dbptr;
   tmp += hdr->Qdb_Qdbftrg_Off_Ent_Num1;
   def_hdr = (Qdb_Qdbftrg_Def_Head_t *)tmp;
   // loop through all of the trigger definitions
   printf("Going into for loop %d\n",num_trg);
   for(i = 0; i < num_trg; i++) {
      // if enabled disable and display the entry
      if(*def_hdr->Qdb_Qdbftrg_Def_State == 'E') {
         printf("Offset to Trigger Name %d\n",def_hdr->Qdb_Qdbftrg_Def_Off_Trg_Name);
         tmp += def_hdr->Qdb_Qdbftrg_Def_Off_Trg_Name;
         trg_name = (Qdb_Qdbftrg_Name_Area_t *)tmp;
         printf("Trigger Name length %d\n",trg_name->Qdb_Qdbftrg_Name_Len);
         printf("Trigger Lib length %d\n",trg_name->Qdb_Qdbftrg_Name_Lib_Len);
         printf("Trigger Name %.50s\n",trg_name->Qdb_Qdbftrg_Name_Qual);
         memset(trigger_name,'\0',268);
         memset(trigger_name,'\0',268);
         tmp = (char *)trg_name->Qdb_Qdbftrg_Name_Qual;
         tmp += 10;
         memcpy(trigger_name,tmp,trg_name->Qdb_Qdbftrg_Name_Len);
         memcpy(trigger_lib,trg_name->Qdb_Qdbftrg_Name_Qual,trg_name->Qdb_Qdbftrg_Name_Lib_Len);
         } // trigger is enabled
      else {
         printf("Trigger disabled\n");
         }
      // move to the next entry
      tmp = (char *)def_hdr;
      tmp += def_hdr->Qdb_Qdbftrg_Def_Len;
      def_hdr = (Qdb_Qdbftrg_Def_Head_t *)tmp;
      }
   }
else {
   printf("No triggers attached to the file %s\n",Q_File);
   }
exit(0);
}
