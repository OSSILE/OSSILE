#include <stdio.h>                          // standard I/O
#include <stdlib.h>                         // standard I/O
#include <recio.h>                          // Record I/O
#include <string.h>                         // memory and string
#include <qmhqrdqd.h>                       // Data Queue

#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

int main(int argc, char** argv) {
int Inf_Len;                                // Info Len
Qmh_Qrdqd_RDQD0200_t Info;                  // DQ Info
Qmh_Qrdqd_RDQD0100_t Info1;                 // DQ Info

Inf_Len = sizeof(Info);
if(memcmp(argv[2],"*DDM",4) == 0) {
   Inf_Len = sizeof(Info);
   QMHQRDQD(&Info,
            Inf_Len,
            "RDQD0200",
            argv[1]);
   printf("APPC Device = %.10s\n",Info.APPC_Device);
   printf("Mode = %.8s\n",Info.Mode);
   printf("Remote Location = %.8s\n",Info.Remote_Location);
   printf("Local Location = %.8s\n",Info.Local_Location);
   printf("Remote Network ID = %.8s\n",Info.Remote_Network_ID);
   printf("Remote Data Queue Name = %.10s\n",Info.Remote_Data_Queue_Name);
   printf("Remote Data Queue Lib = %.10s\n",Info.Remote_Data_Queue_Library);
   printf("Data Queue Name = %.10s\n",Info.Data_Queue_Name);
   printf("Data Queue Lib = %.10s\n",Info.Data_Queue_Library);
   printf("Relational DB Entry = %.10s\n",Info.Relational_Database);
   }
else {
   Inf_Len = sizeof(Info1);
   QMHQRDQD(&Info1,
            Inf_Len,
            "RDQD0100",
            argv[1]);
   printf("Message length = %d\n",Info1.Message_Length);
   printf("Key length = %d\n",Info1.Key_Length);
   printf("Sequence = %c\n",*Info1.Sequence);
   printf("Include Sender ID = %c\n",*Info1.Include_Sender_Id);
   printf("Force Indicators = %c\n",*Info1.Force_Indicators);
   printf("Text = %.50s\n",Info1.Text);
   printf("Type = %c\n",*Info1.Type);
   printf("Auto Reclaim = %c\n",*Info1.Automatic_Reclaim);
   printf("Num Messages = %d\n",Info1.Number_Messages);
   printf("Max Messages = %d\n",Info1.Max_Number_Messages);
   printf("Name = %.10s\n",Info1.Data_Queue_Name);
   printf("Library = %.10s\n",Info1.Data_Queue_Library);
   printf("Max Entries = %d\n",Info1.Max_Number_Entries_Allowed);
   printf("Initial Entries = %d\n",Info1.Initial_Number_Entries);
   printf("Max Entries Specified = %d\n",Info1.Max_Number_Entries_Specified);
   }
return 1;
}

