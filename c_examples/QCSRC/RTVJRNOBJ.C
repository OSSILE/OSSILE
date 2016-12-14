// take 2 parameters, first is a 20 character journal name second is object type (*ALL)
#include <stdio.h>                          // standard I/O */
#include <stdlib.h>                         // standard I/O */
#include <string.h>                         // memory and string*/
#include <qusec.h>                          // Error Code Structs */
#include <qmhsndm.h>                        // Send message */
#include <qmhsndpm.h>                       // Send Pgm Message */
#include <qjournal.h>                       // Journal functions */
#include <errno.h>                          // error no */
 
// structure typedefs
typedef _Packed struct  Jrn_Req_Inf_x {
                        long int Length;
                        long int Key;
                        long int Data_Length;
                        char Obj[10];
                        } Jrn_Req_Inf_t;
 
typedef _Packed struct  Jrn_Req_Str_x {
                        long int Num_Keys;
                        Jrn_Req_Inf_t Req_Info;
                        } Jrn_Req_Str_t;
 
typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[48];
                        } EC_t;
// definitions
#define _ERR_REC sizeof(struct EC_x);
#define _DFT_MSGQ "*REQUESTER*LIBL     "
#define _DFT_MSGF "QCPFMSG   *LIBL     "
 
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
 
int main(int argc, char ** argv) {
long len = -1;                              // length
int i = 0;                                  // counter
int total = 0;                              // number of objects
char buf[8];                                // temp buf
char Path[5002];                            // returned path
char *buf_ptr;                              // buffer pointer
char *tmp;                                  // temp ptr
Jrn_Req_Str_t Req_Inf;                      // request info
Qjo_RJRN0100_t *Jrn_Dets;                   // journal info struct
Qjo_JN_Repeating_Key_Fields_t *hdr;         // keys header
Qjo_JN_Key_2_Output_Section_t *key_hdr;     // key header
Qjo_JN_Repeating_Key_2_Output_t *key_data;  // key data
EC_t Error_Code;                            // error code struct
 
Error_Code.EC.Bytes_Provided = _ERR_REC;
Req_Inf.Num_Keys = 1;
Req_Inf.Req_Info.Key = 2;
Req_Inf.Req_Info.Data_Length = 10;
Req_Inf.Req_Info.Length = sizeof(_Packed struct Jrn_Req_Str_x);
memcpy(Req_Inf.Req_Info.Obj,argv[2],10);
QjoRetrieveJournalInformation(buf,
                              &len,
                              argv[1],
                              "RJRN0100",
                              &Req_Inf,
                              &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
// get the number of entries that will be made available
Jrn_Dets = (Qjo_RJRN0100_t *)buf;
len = Jrn_Dets->Bytes_Available;
printf("len = %d\n",len);
buf_ptr = _C_TS_malloc(len);
QjoRetrieveJournalInformation(buf_ptr,
                              &len,
                              argv[1],
                              "RJRN0100",
                              &Req_Inf,
                              &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   snd_error_msg(Error_Code);
   exit(-1);
   }
Jrn_Dets = (Qjo_RJRN0100_t *)buf_ptr;
// print out the data
printf("Journalled object limit = %c\n",Jrn_Dets->Jrn_Object_Limit_Opt);
printf("Number of objects = %d\n",Jrn_Dets->Tot_Num_Jrn_All_Objs);
printf("Number of Files = %d\n",Jrn_Dets->Tot_Num_Jrn_Files);
printf("Number of Mbrs = %d\n",Jrn_Dets->Tot_Num_Jrn_Mbrs);
printf("Number of Dataara's = %d\n",Jrn_Dets->Tot_Num_Jrn_DtaAs);
printf("Number of DataQ's = %d\n",Jrn_Dets->Tot_Num_Jrn_DtaQs);
printf("Number of IFS = %d\n",Jrn_Dets->Tot_Num_Jrn_IFS);
printf("Number of Libs = %d\n",Jrn_Dets->Tot_Num_Jrn_Libs);
printf("Number of Access Paths = %d\n",Jrn_Dets->Tot_Num_Jrn_APs);
printf("Number of Commit Defs = %d\n",Jrn_Dets->Tot_Num_Jrn_Cmt_Defs);
printf("Jrn Recovery Count = %d\n",Jrn_Dets->Jrn_Recovery_Cnt);
printf("Bytes available = %d\n",Jrn_Dets->Bytes_Available);
// loop through the objects to get the details
tmp = buf_ptr;
key_hdr = (Qjo_JN_Key_2_Output_Section_t *)tmp;
printf("Offset to Key Info %d\n",Jrn_Dets->Off_Key_Info);
tmp += Jrn_Dets->Off_Key_Info;
// skip over number of keys field
tmp += 4;
hdr = (Qjo_JN_Repeating_Key_Fields_t *)tmp;
tmp += hdr->Off_Strt_Key_Info;
key_hdr = (Qjo_JN_Key_2_Output_Section_t *)tmp;
tmp += sizeof(_Packed struct Qjo_JN_Key_2_Output_Section);
key_data = (Qjo_JN_Repeating_Key_2_Output_t *)tmp;
total += key_hdr->Tot_Num_Jrn_Files;
total += key_hdr->Tot_Num_Jrn_DtaAs;
total += key_hdr->Tot_Num_Jrn_DtaQs;
total += key_hdr->Tot_Num_Jrn_IFS;
total += key_hdr->Tot_Num_Jrn_Libs;
for(i = 0; i < total; i++) {
   // if its IFS object need to get path from file ID
   if(memcmp(key_data->Object_Type,"*IFS",4) == 0) {
      // convert Object File ID
      if(Qp0lGetPathFromFileID(Path,sizeof(Path),key_data->Object_File_ID) == NULL) {
         printf("Qp0lGetPathFromFileID error %s\n",strerror(errno));
         }
      else {
         printf("Object %.10s Path %s \n",key_data->Object_Type,Path);
         }
      }
   else {
      printf("Object %.10s Lib %.10s Type %.10s File type %.1s\n",key_data->Object_Name,key_data->Object_Lib_Name,
             key_data->Object_Type,key_data->Reserved);
      }
   key_data++;
   }
_C_TS_free(buf_ptr);
return 1;
}
