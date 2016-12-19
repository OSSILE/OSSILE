#include <qszrtvpr.h>                       // Retrve Prd Info
#include <qusec.h>                          // Error Code Structs
#include <stdio.h>                          // standard I/O
#include <string.h>                         // memory and string

typedef struct  EC_x {
                Qus_EC_t EC;
                char Exception_Data[48];
                }EC_t;

#define _ERR_REC sizeof(struct EC_x);
#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

int main(int argc, char *argv[]) {
int Inst_Opt = 1;                           // INSTALLED flag
Qsz_Product_Info_Rec_t Prd_Inf;             // Prod Info Struct
Qsz_PRDR0100_t Prod_Dets;                   // returned data
EC_t Error_Code = {0};                      // Error Code Struct
Error_Code.EC.Bytes_Provided = _ERR_REC;

memcpy(Prd_Inf.Product_Id,"*OPSYS ",7);
memcpy(Prd_Inf.Release_Level,"*CUR  ",6);
memcpy(Prd_Inf.Product_Option,"0000",4);
memcpy(Prd_Inf.Load_Id,"*CODE     ",10);

QSZRTVPR(&Prod_Dets,
         sizeof(Prod_Dets),
         "PRDR0100",
         &Prd_Inf,
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   printf("%.7s\n",Error_Code.EC.Exception_Id);
   exit(-1);
   }
printf("Installed = OS Version %.6s\n",Prod_Dets.Release_Level);
exit(0);
}                    