#include <H/MD5FUNC>                        // functions header
#pragma comment(copyright,_CPYRGHT)

#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

int main(int argc, char *argv[]) {
_RFILE *fp;                                 // file data ptr
_RFILE *fp1;                                // data store ptr
_RIOFB_T  *fdbk;                            // Feed back Ptr
int CrcLvl = 0;                             // CRC level *FILE / *MBR
int Initial_Size = 4194304;                 // UsrSpc Initial size
int key_size = 0;                           // returned Key size
int Encrypt = 0;                            // Algorithm type
int i,m = 0;                                // counters
int rec_len = 0;                            // record length
int junkl;                                  // Int holder
unsigned int max_buf = 0;                   // buffer size
unsigned int offset = 0;                    // buffer size
unsigned long total_bytes = 0;              // total bytes read
unsigned long total_recs = 0;               // total records
unsigned long num_recs = 0;                 // total records
unsigned long adler_mbr = 1;                // member adler value
double secs_initial;                        // Secs holder
double secs_end;                            // Secs holder
double secs_start;                          // Secs holder
double secs_stop;                           // Secs holder
unsigned char junk2[23];                    // Junk char string
char Q_Name[36];                            // file name
char Spc_Name[20] = "USLMBR    QTEMP     "; // Usrspc
char Hex_Output[128];                       // Key output converted
char Csp;                                   // service provider
char Override = '0';                        // no overrides
char *tmp;                                  // tmp ptr
char *buffer;                               // malloc ptr
char *Output;                               // hash
char *List_Section;                         // usrspc list ptr
char *Hdr_Section;                          // usrspc hdr ptr
char *Alg;                                  // Algorthm ptr
Qc3_Format_ALGD0100_T Alg_Inf;              // algorithm details
Qdb_Mbrd0200_t *Mbrd;                       // member dets ptr
Qdb_Ldbm_MBRL0300_t *Entry_List;            // mbr struct ptr
Qdb_Ldbm_Header_t *Header;                  // mbr header ptr
Qus_Generic_Header_0100_t *space;           // generic headers
Mbr_Dets_t MbrInf;                          // member info
Mbr_Dets_t *Args;                           // passed args ptr
Filerec_t Filerec;                          // file buffer
EC_t   Error_Code = {0};                    // Error_Code struct

Error_Code.EC.Bytes_Provided = _ERR_REC;
// open file to store details
if((fp1 =_Ropen("MD5DETS","rr+")) == NULL) {
   printf("Unable to open the MD5DETS File");
   exit(-1);
   }
// copy the file name
memcpy(Filerec.FileName,argv[1],20);
// encryption type
Encrypt = *(short int *)argv[3];
Alg = (char *)&Encrypt;
// CRC level
if(memcmp(argv[2],"*FILE",5) == 0)
   CrcLvl = 1;
// size of buffer to use for encryption
max_buf = *(int *)argv[4];
Args = (Mbr_Dets_t *)argv[1];
// get the record length for the file
rec_len = Get_Src_Rec_Len(Args);
// stdout message re type of encryption being used
if(Encrypt == 1) {
   printf("Creating MD5 Hash\n");
   key_size = 16;
   Output = malloc(key_size);
   }
else if(Encrypt == 2) {
   printf("Creating SHA-1 Hash\n");
   key_size = 20;
   Output = malloc(key_size);
   }
else if(Encrypt == 3) {
   printf("Creating SHA-256 Hash\n");
   key_size = 32;
   Output = malloc(key_size);
   }
else if(Encrypt == 4) {
   printf("Creating SHA-384 Hash\n");
   key_size = 48;
   Output = malloc(key_size);
   }
else if(Encrypt == 5) {
   printf("Creating SHA-512 Hash\n");
   key_size = 64;
   Output = malloc(key_size);
   }
// set up the user space for member information
QUSPTRUS(Spc_Name,
         &space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   // if it does not exist then create it
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9801",7) == 0) {
      if(Crt_Usr_Spc(Spc_Name,Initial_Size) != 1) {
         printf("Failed to create space exiting\n");
         exit(-1);
         }
      else {
         QUSPTRUS(Spc_Name,
                  &space,
                  &Error_Code);
         if(Error_Code.EC.Bytes_Available > 0) {
            printf("Could not get pointer to UsrSpc Exiting\n");
            exit(-1);
            }
         }
      }
   }
// list the file members
QUSLMBR(Spc_Name,
        "MBRL0320",
        argv[1],
        "*ALL      ",
        &Override,
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("Error List MBRD %.7s\n",Error_Code.EC.Exception_Id);
   exit(0);
   }
// go to output
List_Section = (char *)space;
List_Section = List_Section + space->Offset_List_Data;
Entry_List = (Qdb_Ldbm_MBRL0300_t *)List_Section;
Hdr_Section = (char *)space;
Hdr_Section = Hdr_Section + space->Offset_Header_Section;
Header = (Qdb_Ldbm_Header_t *)Hdr_Section;
// if no member quit
if(Header->Total_Members < 1) {
   printf("No members in the file\n");
   exit(0);
   }
// if *FILE create context at File level
if(CrcLvl == 1) {
   // create the context
   QC3CRTAX(Alg,
            "ALGD0500",
            Alg_Inf.Alg_Context_Token,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      printf("Failed to create context\n");
      exit(0);
      }
   Alg_Inf.Final_Op_Flag = '0';
   }
 // build the time stamp for the file
CEELOCT(&junkl, &secs_initial,junk2,NULL);
for(m = 0; m < Header->Total_Members;m++) {
   total_bytes = 0;
   if((memcmp(Args->MbrName,"*ALL",4) == 0) || (memcmp(Args->MbrName,Entry_List->Member_Name,10) == 0)) {
      memcpy(MbrInf.FileName,argv[1],20);
      memcpy(MbrInf.MbrName,Entry_List->Member_Name,10);
      memcpy(Filerec.MbrName,Entry_List->Member_Name,10);
      // create the qualified name
      Crt_Q_Mbr_Name(&MbrInf,Q_Name);
      if(Entry_List->Offset_Mbrd > 0) {
         // if *MBR create context at member level
         if(CrcLvl == 0) {
            QC3CRTAX(Alg,
                     "ALGD0500",
                     Alg_Inf.Alg_Context_Token,
                     &Error_Code);
            if(Error_Code.EC.Bytes_Available > 0) {
               printf("Failed to create context\n");
               exit(0);
               }
            Alg_Inf.Final_Op_Flag = '0';
            }
         buffer = malloc(max_buf);
         printf("CRC Creation for Member %.10s\n",Entry_List->Member_Name);
         if((fp = _Ropen(Q_Name,"rr,arrseq = Y,blkrcd = Y,riofb = N")) == NULL){
            printf("Name = %s\n",Q_Name);
            printf("error opening file %s\n",strerror(errno));
            printf("Failed to open the file %.s\n",Q_Name);
            exit(-1);
            }
         // get the time for time check
         CEELOCT(&junkl, &secs_start,junk2,NULL);
         num_recs = 0;
         // loop through the file
         do {
            offset = 0;
            /* read the data into the buffer till full */
            do {
               fdbk = _Rreadn(fp,buffer + offset,rec_len,__DFT);
               if(fdbk->num_bytes > 0) {
                  total_bytes += fdbk->num_bytes;
                  offset += fdbk->num_bytes;
                  num_recs++;
                  }
               }while(((max_buf - offset) > rec_len) && (fdbk->num_bytes == rec_len));
            if(num_recs > 0)
               Calc_Hash_Val(buffer,Output,offset,Alg_Inf);
            }while(fdbk->num_bytes == rec_len);
         total_recs += num_recs;
         } // member offset > 0
      // calculate the member hash
      CEELOCT(&junkl, &secs_stop,junk2,NULL);
      if(CrcLvl == 0) {
         Alg_Inf.Final_Op_Flag = '1';
         Calc_Hash_Val(NULL,Output,0,Alg_Inf);
         memset(Hex_Output,'\0',sizeof(Hex_Output));
         Cvt_Hex_Buf(Output,Hex_Output,key_size);
         memset(Filerec.CrcVal,' ',128);
         memcpy(Filerec.CrcVal,Hex_Output,strlen(Hex_Output));
         printf("Member CRC = %s\n",Hex_Output);
         printf("Records read = %lu\n",num_recs);
         printf("Seconds taken = %f\n",secs_stop - secs_start);
         QWCCVTDT("*CURRENT  ",
                  "          ",
                  "*DTS      ",
                  Filerec.TS,
                  &Error_Code);
         fdbk = _Rwrite(fp1,&Filerec,sizeof(Filerec));
         if(fdbk->num_bytes != sizeof(Filerec)) {
            printf("Failed to add data to MD5DETS\n");
            }
         // destroy the context
         QC3DESAX(Alg_Inf.Alg_Context_Token,
                  &Error_Code);
         if(Error_Code.EC.Bytes_Available > 0) {
            printf("Failed to destroy context\n");
            exit(0);
            }
         _Rclose(fp);
         } /* CRC MBR Lvl */
      } /* ALL or member matched */
   Entry_List++;
   }
// now create one for the file
CEELOCT(&junkl, &secs_end,junk2,NULL);
if(CrcLvl == 1) {
   Alg_Inf.Final_Op_Flag = '1';
   Calc_Hash_Val(NULL,Output,0,Alg_Inf);
   memset(Hex_Output,'\0',sizeof(Hex_Output));
   Cvt_Hex_Buf(Output,Hex_Output,key_size);
   memset(Filerec.CrcVal,' ',128);
   memcpy(Filerec.CrcVal,Hex_Output,strlen(Hex_Output));
   memcpy(Filerec.MbrName,"*ALL      ",10);
   printf("File CRC = %s\n",Hex_Output);
   QWCCVTDT("*CURRENT  ",
            "          ",
            "*DTS      ",
            Filerec.TS,
            &Error_Code);
   fdbk = _Rwrite(fp1,&Filerec,sizeof(Filerec));
   if(fdbk->num_bytes != sizeof(Filerec)) {
      printf("Failed to add data to MD5DETS\n");
      }
   // destroy the context
   QC3DESAX(Alg_Inf.Alg_Context_Token,
            &Error_Code);
   if(Error_Code.EC.Bytes_Available > 0) {
      printf("Failed to destroy context\n");
      exit(0);
      }
   }
// print to STDOUT the compiled information
printf("Members reviewed = %d\n",Header->Total_Members);
printf("Total bytes checked = %lu\n",total_bytes);
printf("Total records read %lu\n",total_recs);
printf("Total time taken = %f\n",(secs_end - secs_initial));
// delete the userspace
QUSDLTUS(Spc_Name,
         &Error_Code);
return 1;
}

