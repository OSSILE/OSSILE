#include <H/MD5>                             // header file
#include <H/MD5FUNC>                         // header file

#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

/**
  * (Function) Crt_Q_Mbr_Name()
  * Builds a qualified member name string from elements passed
  * @parms
  *     Member details struct
  *     output string
  * returns 1 for complete
  */

int Crt_Q_Mbr_Name(Mbr_Dets_t *MbrInf,
                   char *Q_Name) {
int i,j = 0;                                // counters

memset(Q_Name,' ',34);
// library name section of the string
for(i = 0,j = 0; i < 10; i++,j++) {
   Q_Name[j] = (MbrInf->FileLib[i] == ' ') ? '\0' : MbrInf->FileLib[i];
   }
Q_Name[j] = '\0';
strcat(Q_Name,"/");
j = strlen(Q_Name);
// file name
for(i = 0;i < 10;i++,j++) {
   Q_Name[j] = (MbrInf->FileName[i] == ' ') ? '\0' : MbrInf->FileName[i];
   }
Q_Name[j] = '\0';
strcat(Q_Name,"(");
j = strlen(Q_Name);
// member name
for(i = 0; i < 10;i++,j++) {
   Q_Name[j] = (MbrInf->MbrName[i] == ' ') ? '\0' : MbrInf->MbrName[i];
   }
Q_Name[j] = '\0';
strcat(Q_Name,")");
return 1;
}

/**
  * (Function) Converts input to hex values
  * creates a Hex based ouput for input string
  * @parms
  *     Input
  *     output
  *     length
  * returns 1 for complete
  */

int Cvt_Hex_Buf(char *inbuf,
                char *outbuf,
                int buflen) {
// read each byte and convert to hex value
while(buflen) {
   sprintf(outbuf,"%02x",*inbuf);
   buflen--;
   inbuf++;
   outbuf += 2;
   }
return buflen;
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
   printf("Error Creating User Space %.7s\n",Error_Code.EC.Exception_Id);
   return -1;
   }
return 1;
}

/**
  * (Function) Calc_Hash_Val
  * Calculate the hash value of the data buffer passed in
  * @parms
  *     Input buffer
  *     Output buffer ptr
  *     length of input buffer
  *     format struct
  * returns 1 for complete
  */

Calc_Hash_Val(char *Input,
              char *Output,
              int Len,
              Qc3_Format_ALGD0100_T Alg_Inf) {
char Crypt_Dev[10] = "          ";          // Crypt device
char Csp;                                   // service provider
char *Alg;                                  // ptr to Algorithm type
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
Csp = Qc3_Any_CSP;
Alg = (char *)&Alg_Inf;
QC3CALHA(Input,
         &Len,
         Qc3_Data,
         Alg,
         Qc3_Alg_Token,
         &Csp,
         Crypt_Dev,
         Output,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Failed in hash calc %.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
}

/**
  * (Function) Get_Src_rec_Len
  * Calculate the length of the buffer required for a file record
  * @parms
  *     file mbr info
  * returns 1 for complete
  */

int Get_Src_Rec_Len(Mbr_Dets_t *File) {
int ret = 0;                                // return val
char Name[20] = "QUSLRCD   QTEMP     ";     // User Space name
char Format[8] = "RCDL0200";                // record format ret
char Override = '1';                        // Override parm
char *tmp;                                  // tmp ptr
Qus_Generic_Header_0100_t *space;           // usrspc hdr ptr
Qdb_Lrcd_Header_t *Header;                  // record header inf
Qdb_Lrcd_RCDL0200_t *Data;                  // record info
Qus_EC_t   Error_Code = {0};                // Error_Code struct

Error_Code.Bytes_Provided = sizeof(Error_Code);
// create the user space
Crt_Usr_Spc(Name,_4MB);
QUSPTRUS(Name,
         &space,
         &Error_Code);
if(Error_Code.Bytes_Available > 0) {
   printf("Could not get pointer to User SPace %.7s\n",Error_Code.Exception_Id);
   QUSDLTUS(Name,
            &Error_Code);
   exit(-1);
   }
QUSLRCD(Name,
        Format,
        &File->FileName,
        &Override,
        &Error_Code);
if(Error_Code.Bytes_Available > 0) {
   printf("Error extracting record length %.7s\n",Error_Code.Exception_Id);
   QUSDLTUS(Name,
            &Error_Code);
   exit(-1);
   }
tmp = (char *)space;
tmp = tmp + space->Offset_List_Data;
Data = (Qdb_Lrcd_RCDL0200_t *)tmp;
tmp = (char *)space;
tmp = tmp + space->Offset_Header_Section;
Header = (Qdb_Lrcd_Header_t *)tmp;
ret = Data->Record_Length;
QUSDLTUS(Name,
         &Error_Code);
return ret;
}
