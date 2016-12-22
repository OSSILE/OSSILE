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
int data_len = 0;                           // counter
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
int j = 0;                                  // counter
int ret = 0;                                // cmd ret val
int num_cst = 0;                            // number of constraints
int debug = 1;                              // debug flag
int offset = 0;                             // usrspc offset
char Q_File[22];                            // Qual File name
char DB_SPC[20] = "CSTINFO   QTEMP     ";   // USRSPC
char Rtn_File_Name[20];                     // returned file name
char msg_dta[1024];                         // message buf
char *tmp;                                  // temp ptr
char *dbptr;                                // temp ptr
char *expr;                                 // expr buf ptr
Qdb_Qdbfh_t *hdr;                           // header info
Qdb_Qdbfphys_t *pf_dets;                    // File details
Qdb_Qdbf_Constraint_t *cst;                 // constraint info
Qdb_Qdbf_Keyn_t *keyn;                      // key fields
Qdb_Qdbf_Riafk_Afkd_t *cst_def;             // cst definition
Qdb_Qdbf_Chk_Cst_t *chk;                    // check constraint
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
         "FILD0100",
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
// set up the pointers
hdr = (Qdb_Qdbfh_t *)dbptr;
printf("Primary Key flag %d\n",hdr->Qaaf2.Qdbfpkey);
printf("Unique Constraint flag %d\n",hdr->Qaaf2.Qdbfunqc);
tmp = dbptr + hdr->Qdbpfof;
pf_dets = (Qdb_Qdbfphys_t *)tmp;
if(pf_dets->Qdbfcstn > 0) {
   printf(" %d Constraints on file\n",pf_dets->Qdbfcstn);
   tmp = dbptr + pf_dets->Qdbfofcs;
   offset += pf_dets->Qdbfofcs;
   cst = (Qdb_Qdbf_Constraint_t *)tmp;
   for(i = 0; i < pf_dets->Qdbfcstn; i++) {
      printf("Type = %c\n",cst->Qdbf_type);
      if(cst->Qdbf_type == 'F') {
         printf("referential constraint ");
         for(j = 0; j < cst->Qdbf_cst_lp2; j++)
            printf("%c",cst->Qdbf_cst_name[j]);
         printf("\n");
         printf("Check Pending=%c\nState=%c\nEnabled=%c\nCheck='%c'\n",
                           cst->Qdbf_chkpd,cst->Qdbf_state,cst->Qdbf_abled,cst->Qdbf_cst_checked);
         tmp += cst->Qdbf_hlen;
         keyn = (Qdb_Qdbf_Keyn_t *)tmp;
         printf("Parent Structure len = %d\n",keyn->Qdbf_Kslen);
         printf("Parent Number of keys = %d\n",keyn->Qdbf_Nokys);
         printf("Parent Constraint Key length = %d\n",keyn->Qdbf_Klen);
         printf("Parent Key Name = %.32s\n",keyn->Qdbf_Narray.Qdbf_Kname);
         tmp += keyn->Qdbf_Kslen;
         keyn = (Qdb_Qdbf_Keyn_t *)tmp;
         printf("Dependant Structure len = %d\n",keyn->Qdbf_Kslen);
         printf("Dependant Number of keys = %d\n",keyn->Qdbf_Nokys);
         printf("Dependant Constraint Key length = %d\n",keyn->Qdbf_Klen);
         printf("Dependant Key Name = %.32s\n",keyn->Qdbf_Narray.Qdbf_Kname);
         tmp += keyn->Qdbf_Kslen;
         cst_def = (Qdb_Qdbf_Riafk_Afkd_t *)tmp;
         printf("Parent File %.64s\n",cst_def->Qdbf_Riafk_Pkfn);
         printf("Parent File Name %.10s\n",cst_def->Qdbf_Riafk_Pkfn);
         printf("Parent File Lib %.10s\n",cst_def->Qdbf_Riafk_Pkln);
         printf("Delete Rule %c\n",cst_def->Qdbf_Riafk_Fkcdr);
         printf("Update Rule %c\n",cst_def->Qdbf_Riafk_Fkcur);
         }
      else if((cst->Qdbf_type == 'P') || (cst->Qdbf_type == 'U')) {
         printf("Primary Key Constraint\n");
         tmp += cst->Qdbf_hlen;
         keyn = (Qdb_Qdbf_Keyn_t *)tmp;
         printf("Structure len = %d\n",keyn->Qdbf_Kslen);
         printf("Number of keys = %d\n",keyn->Qdbf_Nokys);
         printf("Constraint Key length = %d\n",keyn->Qdbf_Klen);
         printf("Key Name = %.32s\n",keyn->Qdbf_Narray.Qdbf_Kname);
         }
      else if(cst->Qdbf_type == 'C') {
         printf("Check Constraint\n");
         tmp += cst->Qdbf_hlen;
         chk = (Qdb_Qdbf_Chk_Cst_t *)tmp;
         printf("Check Constraint Structure Len %l\n",chk->Qdbf_chkcst_len);
         printf("Expression length %l\n",chk->Qdbf_chkexpr_len);
         printf("Rounding Mode %c\n",chk->Qdbf_chk_dfp_round);
         printf("Warnings Mode %c\n",chk->Qdbf_chk_dfp_warnings);
         expr = malloc(sizeof(char) * (chk->Qdbf_chkexpr_len + 1));
         memset(expr,'\0',(chk->Qdbf_chkexpr_len + 1));
         tmp += sizeof(_Packed struct Qdb_Qdbf_Chk_Cst);
         memcpy(expr,tmp,chk->Qdbf_chkexpr_len);
         printf("Expression %s\n",expr);
         }
      else
         printf("Unknown Constraint type\n");
      offset += cst->Qdbf_csto;
      tmp = dbptr;
      tmp += offset;
      cst = (Qdb_Qdbf_Constraint_t *)tmp;
      }
   }
QUSDLTUS(DB_SPC,
         &Error_Code);
exit(0);
}
