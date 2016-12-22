#include<stdio.h>
#include<string.h>
#include <stdlib.h>
#include<time.h>

#define _CPYRGHT "Copyright (c) Chris Hird 2016 Made available under the terms of the license of the containing project"
#pragma comment(copyright,_CPYRGHT)

int main(int argc, char **argv) {
int dom[12] = {31,28,31,30,31,30,31,31,30,31,30,31}; // days in month
char wday[7][3] = {"Sun","Mon","Tue","Wed","Thu","Fri","Sat"}; // dow array
int dom_left = 0;                           // days left in month
char Path[255];                             // path to cpy save to
char Cmd[255];                              // command string
time_t lt;                                  // time struct
struct tm *ts;                              // time struct GMTIME
int LY;                                     // Leap year flag

// copy in the base path where the images are to be copied
sprintf(Path,"/mnt/shieldnas/");
// get the time structure filled with current time
if(time(&lt) == -1) {
   printf("Error with Time calculation\n");
   exit(-1);
   }
// create the local time struct
ts = localtime(&lt);
// if leap year LY = 0
LY = ts->tm_year%4;
// if leap year increment feb days in month
if(LY == 0)
 dom[1] = 29;
// check for end of month
dom_left = dom[ts->tm_mon] - ts->tm_mday;
// if submitted via the job scheduler
if(memcmp(argv[1],"*SCHED",6) == 0) {
   if((dom_left < 7) && (ts->tm_wday == 5)) {
      // replace the catalogue entry
      system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
      system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(MTHA01) KEEP(*NO)");
      system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(MTHA01) VOLNAM(MTHA01) IMGSIZ(50000)");
      system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
      system("RUNBCKUP BCKUPOPT(*MONTHLY) DEV(VRTTAP01)");
      // create the path variable
      sprintf(Path,"/mnt/shieldnas1/Monthly");
      // move the IMGCLGE object to the NAS
      sprintf(Cmd,"CPY OBJ('/backup/MTHA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
      }
   else if(ts->tm_wday == 5) {
      // replace the catalogue entry
      system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
      system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(WEKA01) KEEP(*NO)");
      system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(WEKA01) VOLNAM(WEKA01) IMGSIZ(50000)");
      system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
      system("RUNBCKUP BCKUPOPT(*WEEKLY) DEV(VRTTAP01)");
      // create the path
      sprintf(Path,"/mnt/shieldnas1/Weekly");
      // move the IMGCLGE object to the NAS
      sprintf(Cmd,"CPY OBJ('/backup/WEKA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
      }
   else {
      // replace the catalogue entry
      system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
      system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(DAYA01) KEEP(*NO)");
      system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(DAYA01) VOLNAM(DAYA01) IMGSIZ(10000)");
      system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
      system("RUNBCKUP BCKUPOPT(*DAILY) DEV(VRTTAP01)");
      sprintf(Path,"/mnt/shieldnas1/Daily/%.3s",wday[ts->tm_wday]);
      // move the IMGCLGE object to the NAS
      sprintf(Cmd,"CPY OBJ('/backup/DAYA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
      }
   }
else if(memcmp(argv[1],"*DAILY",6) == 0) {
   // replace the catalogue entry
   system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
   system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(DAYA01) KEEP(*NO)");
   system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(DAYA01) VOLNAM(DAYA01) IMGSIZ(10000)");
   system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
   system("RUNBCKUP BCKUPOPT(*DAILY) DEV(VRTTAP01)");
   sprintf(Path,"/mnt/shieldnas1/Daily/%.3s",wday[ts->tm_wday]);
   // move the IMGCLGE object to the NAS
   sprintf(Cmd,"CPY OBJ('/backup/DAYA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
   }
else if(memcmp(argv[1],"*WEEKLY",7) == 0) {
   // replace the catalogue entry
   system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
   system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(WEKA01) KEEP(*NO)");
   system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(WEKA01) VOLNAM(WEKA01) IMGSIZ(50000)");
   system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
   system("RUNBCKUP BCKUPOPT(*WEEKLY) DEV(VRTTAP01)");
   sprintf(Path,"/mnt/shieldnas1/Weekly");
   sprintf(Cmd,"CPY OBJ('/backup/WEKA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
   }
else if(memcmp(argv[1],"*MONTHLY",8) == 0) {
      // replace the catalogue entry
      system("LODIMGCLG IMGCLG(BACKUP) OPTION(*UNLOAD) DEV(VRTTAP01)");
      system("RMVIMGCLGE IMGCLG(BACKUP) IMGCLGIDX(*VOL) VOL(MTHA01) KEEP(*NO)");
      system("ADDIMGCLGE IMGCLG(BACKUP) FROMFILE(*NEW) TOFILE(MTHA01) VOLNAM(MTHA01) IMGSIZ(50000)");
      system("LODIMGCLG IMGCLG(BACKUP) DEV(VRTTAP01)");
      system("RUNBCKUP BCKUPOPT(*MONTHLY) DEV(VRTTAP01)");
      sprintf(Path,"/mnt/shieldnas1/Monthly");
      sprintf(Cmd,"CPY OBJ('/backup/MTHA01') TODIR('%s') TOCCSID(*CALC) REPLACE(*YES)",Path);
   }
if(system(Cmd) != 0)
   printf("%s\n",Cmd);
return 0;
}
