#include <stdio.h>                          // standard io
#include <stdlib.h>                         // standard lib
#include <string.h>                         // string funcs
#include <qusec.h>                          // error code
#include <qusptrus.h>                       // usrspc ptr
#include <quscrtus.h>                       // crt usrspc
#include <qusdltus.h>                       // dlt usrspc
#include <qdbldbr.h>                        // list dbr
#include <qusgen.h>                         // User space gen hdr
 
typedef _Packed struct  EC_x {
                        Qus_EC_t EC;
                        char Exception_Data[1024];
                        } EC_t;
#define _1MB 1024*1024
 
/*
 * function Crt_Usr_Spc()
 * Purpose: To create a Userspace object.
 * @parms
 *      string Name
 *      int size
 * returns 1 on sucess
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
   printf("CRTUSRSPC %.7s\n",Error_Code.EC.Exception_Id);
   return -1;
   }
return 1;
}
 
int main(int argc, char **argv) {
int i = 0;                                  // counter
char UsrSpc[20] = "LSTDBR    QTEMP     ";   // usrspc name
char Cst_Name[260];                         // buffer
char *tmp;                                  // temp ptr
Qus_Generic_Header_0100_t *space;           // space ptr
Qdb_Dbrl0200_t *dbr;                        // dbr ptr
Qdb_Ldbr_Input_Parms_t *Hdr;                // hdr ptr
EC_t Error_Code;                            // error code
 
Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
if(!Crt_Usr_Spc(UsrSpc,_1MB)) {
   printf("Failed to create USRSPC");
   exit(-1);
   }
QUSPTRUS(UsrSpc,
         &space,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0){
   printf("QUSPTRUS %.7s\n",Error_Code.EC.Exception_Id);
   QUSDLTUS(UsrSpc,&Error_Code);
   exit(-1);
   }
QDBLDBR(UsrSpc,
        "DBRL0200",
        argv[1],
        "*FIRST    ",
        "          ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available > 0){
   printf("QUSPTRUS %.7s\n",Error_Code.EC.Exception_Id);
   QUSDLTUS(UsrSpc,&Error_Code);
   exit(-1);
   }
printf("Offset value = %d\n",space->Offset_List_Data);
printf("Data Created %.13s\n",space->Date_Time_Created);
printf("Offset Input Parameter %d\n",space->Offset_Input_Parameter);
printf("Offset Header %d\n",space->Offset_Header_Section);
printf("Size each entry %d\n",space->Size_Each_Entry);
printf("Number list entries %d\n",space->Number_List_Entries);
tmp = (char *)space;
tmp += space->Offset_List_Data;
dbr = (Qdb_Dbrl0200_t *)tmp;
for(i = 0; i < space->Number_List_Entries; i++) {
   printf("File name %.10s\n",dbr->File_Name);
   printf("Library name %.10s\n",dbr->Library_Name);
   printf("Member name %.10s\n",dbr->Member_Name);
   printf("Dep File %.10s\n",dbr->Dependent_File_Name);
   printf("Dep Lib %.10s\n",dbr->Dependent_File_Library_Name);
   printf("Dep Mbr %.10s\n",dbr->Dependent_File_Member_Name);
   printf("Dep Type %.1s\n",dbr->Dependency_Type);
   printf("Join Ref Number %lu\n",dbr->Join_Reference_Number);
   printf("Join File Number %lu\n",dbr->Join_Filenumber);
   printf("Cst Lib %.10s\n",dbr->Constraint_Library_Name);
   printf("Cst Name Length %lu\n",dbr->Constraint_Name_Length);
   memcpy(Cst_Name,dbr->Constraint_Name,dbr->Constraint_Name_Length);
   memset(&Cst_Name[dbr->Constraint_Name_Length],'\0',1);
   printf("Constraint Name %s\n",Cst_Name);
   dbr++;
   }
exit(0);
}
