/* This file is part of FTP Client for IBM i.                                    */
/*                                                                               */
/* Copyright (c) 2017 Chris Hird                                                 */
/* All rights reserved.                                                          */
/*                                                                               */
/* Redistribution and use in source and binary forms, with or without            */
/* modification, are permitted provided that the following conditions            */
/* are met:                                                                      */
/* 1. Redistributions of source code must retain the above copyright             */
/*    notice, this list of conditions and the following disclaimer.              */
/* 2. Redistributions in binary form must reproduce the above copyright          */
/*    notice, this list of conditions and the following disclaimer in the        */
/*    documentation and/or other materials provided with the distribution.       */
/*                                                                               */
/* Disclaimer :                                                                  */
/* FTP Client for IBM i is distributed in the hope that it will be useful,       */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of                */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                          */

#include <iconv.h>
#include <stdio.h>
#include <H/FTPCON>
#include <H/COMMON>
#pragma comment(copyright,_CPYRGHT)

iconv_t Get_CCSID_table(int , int);

/**
  * (Function) alarm_catcher
  * Keeps the FTP connection alive
  * @parms
  *     signal
  * returns
  */

void alarm_catcher(int sig) {

Check_Cntrl_Socket();
return;
}

/**
  * (Function) Signal handler
  * @parms
  *     Signal number
  *     Signal function
  * returns handler
  */

Sigfunc * Signal(int signo, Sigfunc *func) {
struct sigaction act, oact;

act.sa_handler = func;
sigemptyset(&act.sa_mask);
act.sa_flags = 0;

if(signo == SIGALRM) {
#ifdef SA_INTERRUPT
   act.sa_flags |= SA_INTERRUPT;  /* SunOS */
#endif
   }
else {
#ifdef SA_RESTART
   act.sa_flags |= SA_RESTART;    /* SVR4 4.4 BSD */
#endif
   }
if((sigaction(signo, &act, &oact)) < 0)
   return SIG_ERR;
return oact.sa_handler;
}

/**
  * (Function) Connect_Timeo
  * Connect to a socket with time out set. Signals error if found
  * @parms
  *     Socket ID
  *     Socket Addres Structure
  *     Socket Addres Len
  *     Seconds for timeout
  * returns connect
  */

int Connect_Timeo(int sockfd, struct sockaddr *saptr, int salen, int nsec) {
char msg_dta[MAX_MSG];
Sigfunc *sigfunc;
int n = 0;

sigfunc = Signal(SIGALRM, connect_alarm);
if(alarm(nsec) != 0) {
   sprintf(msg_dta,"Alarm already set");
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   }
   if((n = connect(sockfd,saptr,salen)) < 0) {
      close(sockfd);
      if(errno == EINTR)
         errno = ETIMEDOUT;
      }
alarm(0);
Signal(SIGALRM, sigfunc);
return n;
}

/**
  * (Function) connect_alarm
  * does nothing today but can be used to take additional actions when
  * connect fails
  * returns nothing!
  */

static void connect_alarm(int signo) {
return;
}

/**
  * (Function) Check_Cntrl_Socket
  * Check for a control socket
  * @ parms NONE
  * returns 1 on success otherwise -1
  */

int Check_Cntrl_Socket() {
int len = 0;                                // byte counter
int ret = 0;                                // return value
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
extern char cBuffer[BUF_SIZE];              // IP Buffer
char cnvBuffer[BUF_SIZE];                   // converted buffer
char msg_dta[MAX_MSG];                      // msg buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
//sprintf(msg_dta,"Control Socket check %d",hCntrlSocket);
//snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
/* create NOOP string */
sprintf(cnvBuffer,"NOOP%c%c",0x0d,0x25);
len = strlen(cnvBuffer);
/* send to the display */
snd_status_msg("GEN0001",cnvBuffer,len-2);
snd_log_msg("GEN0001",cnvBuffer,len-2);
/* convert to ASCII */
EtoA_CCSID(cnvBuffer,cBuffer,len,eaTable);
/* send to the control socket */
ret = send(hCntrlSocket,cBuffer,len,0);
/* if error send message return -1 */
if(ret < 0) {
   sprintf(msg_dta,"Connection lost %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hCntrlSocket);
   return -1;
   }
/* display server reply to screen */
nCode = Dsp_Server_Reply();
iconv_close(eaTable);
/* if message >= 500 return -1 */
if(nCode >= 500) {
   return -1;
   }
/* set alarm for another 10 seconds */
alarm(keepalive);
return 1;
}

/** (Function) Crt_Cntrl_Conn
   * Create a Control socket
   * @parms
   *    Server name/IP address
   *    Port to use
   *    Site Label
   *    Encrypted Password
   *    User Name
   *    Panel Group User
   *    Retry value
   *    Delay between retries Value
   * returns 1 on success or -1
   */

int Crt_Cntrl_Conn(char *server, int Server_Port, char *sitlbl,
                   char *E_Pwd, char *User_Id, char *Pnluser,
                   int retry, int delay) {
extern int hCntrlSocket;                    // Control Socket ID
int connected = 0;                          // connected flag
int len = 0;                                // bytes value
int i= 0, ret = 0;                          // counter
int offset = 0;                             // offset counter
int nCode = 0;                              // message code returned
int on = 1;                                 // flag
char User[MAX_USERID];                      // User ID
char Pwd[PWD_LEN];                          // password
char msg_dta[MAX_MSG] = {'\0'};             // message buffer
extern char cBuffer[BUF_SIZE];              // buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char msg_buf[BUF_SIZE];                     // message buffer
char tmp [PWD_LEN];                         // temp storage
char key [KEY_LEN];                         // key storgae
char rkeys[176];                            // return keys
char cipher[AES_LEN];                       // cipher storage
char plain [AES_LEN];                       // plain storage
struct sockaddr_in addr;                    // socket address struct
struct sigaction sact;                      // signal struct
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);

memset(&addr, 0, sizeof(addr));
Get_Host_Addr(server,&addr,Server_Port);
retry++;
for(i = 0; i < retry; i++) {
   sprintf(msg_dta,"Connecting to %s",sitlbl);
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
   hCntrlSocket = socket(AF_INET, SOCK_STREAM, 0);
   if(hCntrlSocket < 0) {
      sprintf(msg_dta,"socket() failed %s",strerror(errno));
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      iconv_close(eaTable);
      return -1;
      }
   /* try to connect to server */
   ret = Connect_Timeo(hCntrlSocket, (struct sockaddr *) &addr,sizeof(addr),delay);
   /* if failed to connect send info and sleep if required */
   if(ret < 0) {
      sprintf(msg_dta,"connect() failed %s",strerror(errno));
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
      close(hCntrlSocket);
      sprintf(msg_dta,"Sleeping for %d seconds",delay);
      snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
      sleep(delay);
      }
   else {
      /* clear out any existing signals and set keep alive */
      sigemptyset( &sact.sa_mask );
      sact.sa_flags = 0;
      sact.sa_handler = alarm_catcher;
      sigaction( SIGALRM, &sact, NULL );
      alarm(keepalive);
      connected = 1;
      break;
      }
   }
/* if failed to connect inform user */
if(connected == 0) {
   sprintf(msg_dta,"Failed to connect to %s",sitlbl);
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* display the server reply */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* set some socket options */
ret = setsockopt(hCntrlSocket,SOL_SOCKET,SO_REUSEADDR,(char *)&on,sizeof(on));
if(ret == -1) {
   sprintf(msg_dta,"Failed SO_LINGER %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   }
ret = setsockopt(hCntrlSocket,SOL_SOCKET,SO_KEEPALIVE,(char *)&on,sizeof(on));
if(ret == -1) {
   sprintf(msg_dta,"Failed SO_LINGER %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   }
/* create the user signon  and send to the server */
for(i = 0; i < MAX_USERID; i++) {
   User[i] = (User_Id[i] == ' ' ) ? '\0' : User_Id[i];
   }
sprintf(cvnBuffer,"USER %s%c%c",User,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
send(hCntrlSocket,cBuffer,len,0);
nCode = Dsp_Server_Reply();
/* get the encription key  and decript the password */
Get_Key(key,Pnluser);
AES ("DK", key, rkeys, plain, cipher);
for(i = PWD_LEN / 16, offset = 0; i > 0; i --,offset += 16) {
   memcpy(cipher,&E_Pwd[offset],16);
   AES ("D ", key, rkeys, plain, cipher);
   memcpy(&tmp[offset],plain,16);
   memset(plain,' ',16);
   memset(cipher,' ',16);
   }
/* if password not multiple of 16 convert remainder */
if((PWD_LEN % 16) > 0) {
   memset(plain,' ',16);
   memset(cipher,' ',16);
   memcpy(plain,&E_Pwd[offset],PWD_LEN % 16);
   AES ("D ", key, rkeys, plain, cipher);
   memcpy(&tmp[offset],plain,PWD_LEN % 16);
   }
/* create the password string for the server */
for(i = 0; i < PWD_LEN; i++) {
   Pwd[i] = (tmp[i] == ' ' ) ? '\0' : tmp[i];
   }
sprintf(cvnBuffer,"PASS %s%c%c",Pwd,0x0d,0x25);
snd_status_msg("GEN0001","PASS **********",15);
snd_log_msg("GEN0001","PASS **********",15);
len = strlen(cvnBuffer);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
/* send the password and if bad return info and exit */
send(hCntrlSocket,cBuffer,len,0);
nCode = Dsp_Server_Reply();
if(nCode == 530) {
   snd_log_msg("PWD0001"," ",0);
   sprintf(cvnBuffer,"QUIT%c%c",0x0d,0x25);
   len = strlen(cvnBuffer);
   EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
   send(hCntrlSocket,cBuffer,len,0);
   nCode = Dsp_Server_Reply();
   iconv_close(eaTable);
   return -1;
   }
/* successfully connected send info  and return */
sprintf(msg_dta,"Connected to %s - %d",sitlbl,hCntrlSocket);
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
iconv_close(eaTable);
return 1;
}

/**
  * (Function) End_Cntrl_Conn
  * End a control socket connection
  * @parms
  *     Site Label
  * returns 1 on success or -1
  */

int End_Cntrl_Conn(char *sitlbl) {
extern int hCntrlSocket;                    // local control socket
int len = 0;                                // bytes counter
int ret = 0;                                // return flag
int i = 0;                                  // counter
int nCode = 0;                              // returned msg code
extern char cBuffer[BUF_SIZE];              // buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char msg_dta[MAX_MSG];                      // error msg buf
struct sigaction sact;                      // signal struct
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* stop the alarm signal */
sigemptyset( &sact.sa_mask );
alarm(0);
/* inform user */
sprintf(msg_dta,"Disconnecting from %s",sitlbl);
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
/* create server message and send */
sprintf(cvnBuffer,"QUIT%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
/* if failed send log message and return */
if(ret < len) {
   sprintf(msg_dta," send() failed QUIT %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* display server reply and close local socket */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   close(hCntrlSocket);
   hCntrlSocket = -1;
   iconv_close(eaTable);
   return -1;
   }
iconv_close(eaTable);
close(hCntrlSocket);
hCntrlSocket = -1;
sprintf(msg_dta,"Disconnected from %s",sitlbl);
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
return 1;
}

/**
  * (Function) Get_Host_Addr
  * Get a Host address by name
  * @parms
  *     Server name
  *     Address Structure
  *     Port
  * returns 1 on success or -1
  */

int Get_Host_Addr(char *server,struct sockaddr_in *addr,
                  int Server_Port) {
struct hostent *hostp;                      // host struct pointer
char msg_data[80] = {' '};                  // msg array
EC_t Error_Code = {0};                      // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

addr->sin_family = AF_INET;
addr->sin_port = htons(Server_Port);
if((addr->sin_addr.s_addr  = inet_addr(server))
    ==(unsigned long) INADDR_NONE) {
   hostp = gethostbyname(server);
   if(hostp == (struct hostent *)NULL) {
      memset(msg_data,'\0',80);
      if(h_errno == 5)
         memcpy(msg_data,"Host Not Found --> HOST_NOT_FOUND.",34);
      else if(h_errno == 10)
         memcpy(msg_data,"Host Not Found --> NO_DATA || NO_ADDRESS.",41);
      else if(h_errno ==15)
         memcpy(msg_data,"Host Not Found --> NO_RECOVERY.",31);
      else if(h_errno == 20)
         memcpy(msg_data,"Host Not Found --> TRY_AGAIN.",29);
      strcat(msg_data,server);
      snd_msg("GEN0001",msg_data,strlen(msg_data));
      snd_log_msg("GEN0001",msg_data,strlen(msg_data));
      return -1;
      }
   memcpy(&addr->sin_addr,hostp->h_addr,sizeof(addr->sin_addr));
   }
return 1;
}

/**
  * (Function) Get_Listen_Socket
  * Get a listening socket
  * @parms NONE
  * returns 1 on success or -1
  */

int Get_Listen_Socket() {
extern int hLstnSocket;                     // Listen socket ID
int i = 0;                                  // counter
int ret = 0;                                // return val
int len = 0;                                // bytes counter
int nCode = 0;                              // returned msg code
char *ipaddr;                               // address buffer
char *port;                                 // Port string
extern char cBuffer[BUF_SIZE];              // IP Buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char msg_buf[BUF_SIZE];                     // msg Buffer
char msg_dta[MAX_MSG];                      // message buffer
struct sockaddr_in addr;                    // socket struct
struct sockaddr_in tmpaddr;                 // socket struct
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
memset(&addr, 0, sizeof(addr));
hLstnSocket = socket(AF_INET, SOCK_STREAM, 0);
if(hLstnSocket < 0) {
   sprintf(msg_dta," socket() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* set up the address structure */
addr.sin_family = AF_INET;
addr.sin_addr.s_addr = htonl(INADDR_ANY);
addr.sin_port = htons(0);
len = sizeof(addr);
/* bind to socket */
if(bind(hLstnSocket,(struct sockaddr *)&addr, len) < 0) {
   close(hLstnSocket);
   sprintf(msg_dta," bind() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* get socket name for listen socket */
if(getsockname(hLstnSocket,(struct sockaddr *)&addr,&len) < 0) {
   close(hLstnSocket);
   sprintf(msg_dta," getsockname() hLstnSocket failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* get socket name for control socket */
if(getsockname(hCntrlSocket,(struct sockaddr *)&tmpaddr,&len) < 0) {
   close(hLstnSocket);
   sprintf(msg_dta," getsockname() hCntrlSocket failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
ipaddr = (char *)&tmpaddr.sin_addr;
port = (char *)&addr.sin_port;
sprintf(cvnBuffer,"PORT %d,%d,%d,%d,%d,%d%c%c",
       UC(ipaddr[0]), UC(ipaddr[1]), UC(ipaddr[2]), UC(ipaddr[3]),
       UC(port[0]), UC(port[1]),0x0d,0x25);
/* listen on socket */
if(listen(hLstnSocket,1) < 0) {
   close(hLstnSocket);
   sprintf(msg_dta," listen() error %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* send user msg back */
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
/* send socket info to remote server */
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret < len) {
   sprintf(msg_dta," send() failed PORT %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* send server reply to user and return */
nCode = Dsp_Server_Reply();
iconv_close(eaTable);
if(nCode >= 500) {
   return -1;
   }
return 1;
}

/**
  * (Function) Close_Listen_Socket
  * Close the listen socket
  * @parms NONE
  * returns 1
  */

int Close_Listen_Socket() {
extern int hLstnSocket;                     // listen socket

close(hLstnSocket);
return 1;
}

/**
  * (Function) Accept_Connection
  * Accept a remote connection
  * @parms NONE
  * returns 1 on success or -1
  */

int Accept_Connection() {
struct sockaddr_in addr;                    // socket addr struct
int len = sizeof(addr);                     // byte counter
extern int hDtaSocket;                      // socket ID
extern int hLstnSocket;                     // socket ID
char msg_dta[MAX_MSG];                      // message data

/* accept the connection request */
hDtaSocket = accept(hLstnSocket,(struct sockaddr *)&addr,&len);
if(hDtaSocket < 0) {
   sprintf(msg_dta," accept() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   return -1;
   }
/* close the listen socket as we have the data connection */
close(hLstnSocket);
return 1;
}

/**
  * (Function) Get_Rmt_Cwd
  * Get the Remote Current Working Directory list and display
  * @parms
  *     Panel Group Application Handle
  *     Path on remote system
  * returns 1 on success or -1
  */

int Get_Rmt_Cwd(char *ApplHandle, char *path) {
int new_msg = 0;                            // new msg flag
int optzero = 0;                            // Option set
int i = 0;                                  // counter
int flags = 0;                              // flag
int j = 0,k = 0, l = 0;                     // counter
int len = 0;                                // byte counter
int ret = 0;                                // return val
int name_len = 0;                           // counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
extern char cBuffer[BUF_SIZE];              // IP Buffer
extern char dBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char newBuf[BUF_SIZE];                      // buffer
char msg_dta[MAX_MSG];                      // message data
char tmp[300];                              // temp buffer
char *tmp1;                                 // tmpptr
char count[128] = {'\0'};                   // record count
dsp_buf_t dsp_buf;                          // display buffer
iconv_t eaTable;
iconv_t aeTable;
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);
//sprintf(msg_dta,"Build remote path");
//snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* set transfer mode  and get listen socket */
if((tMode == 'e') || (tMode == 'E'))
   set_asc();
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
/* need to set the name format and list format for iseries */
/* if not iseries will get 500 error back just ignore */
sprintf(cvnBuffer,"SITE NAMEFMT 1%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode > 500) {
   iconv_close(eaTable);
   return -1;
   }
/* set the remote Cwd */
if(Chg_Rmt_Dir(path) != 1) {
   sprintf(msg_dta,"Failed to change path to %s",path);
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
/* get Cwd List */
sprintf(cvnBuffer,"LIST%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
// should be 125 list started for none ELPF
// should be 150 for ELP format

if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
// open the data connection
if(Accept_Connection() == -1) {
   snd_log_msg("GEN0001","Cannot Accept Socket",20);
   iconv_close(eaTable);
   return -1;
   }
//sprintf(msg_dta,"Data Connection %d",hDtaSocket);
//snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
/* delete existing list */
QUIDLTL(ApplHandle,
        "CWDLST    ",
        &Error_Code);
if((Error_Code.EC.Bytes_Available) &&
   (memcmp(Error_Code.EC.Exception_Id,"CPF6A92",7) != 0)) {
   snd_error_msg(Error_Code);
   iconv_close(eaTable);
   close(hDtaSocket);
   return -1;
   }
/* add the '..' entry   */
if(strlen(path) != 1) {
   memset(&dsp_buf,' ',sizeof(dsp_buf));
   strcpy(dsp_buf.lname,"..");
   memcpy(dsp_buf.name,"..",2);
   memcpy(dsp_buf.type,"*DIR",4);
   QUIADDLE(ApplHandle,
            &dsp_buf,
            sizeof(dsp_buf),
            "CWDINF    ",
            "CWDLST    ",
            "NEXT",
            "    ",
            &Error_Code);
   if(Error_Code.EC.Bytes_Available) {
      snd_error_msg(Error_Code);
      iconv_close(eaTable);
      close(hDtaSocket);
      return -1;
      }
   }
/* receive the list entries and load panel group */
// set up the atoe table
aeTable = Get_CCSID_table(0,819);
if((nCode == 125) || (nCode == 150)) {
   do {
      ret = recv(hDtaSocket, dBuffer, BUF_SIZE,0);
      //sprintf(msg_dta,"Received %d bytes",ret);
      //snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      if(ret > 0) {
         memset(newBuf,' ',BUF_SIZE);
         memset(cvnBuffer,0x00,BUF_SIZE);
         memcpy(cvnBuffer,dBuffer,ret);
         AtoE_CCSID(cvnBuffer,newBuf,ret,aeTable);
         //snd_log_msg("GEN0001",newBuf,ret);
         if(tmp[0] == ' ')
            j = 0;
         for(i = 0; i < ret; i++,j++) {
            /* break out the individual entries */
            if(newBuf[i] == 0x0d) {
               if(memcmp(tmp,"total",5) != 0) {
                  //snd_log_msg("GEN0001",tmp,j);
                  // j == the number of bytes in temp.
                  // 1 skip the mod settings
                  l = 11;
                  /* this will skip over each element to the name */
                  for(k = 0; k < 7; k++) {
                     while(tmp[l] == ' ') l++;
                     while(tmp[l] != ' ') l++;
                     }
                  /* now to the name */
                  while(tmp[l] == ' ') l++;
                  memset(&dsp_buf,' ',sizeof(dsp_buf));
                  name_len = (j-l)+1;
                  /* set to max display length */
                  if(name_len >= SHORT_NAME) {
                     memcpy(dsp_buf.name,&tmp[l],SHORT_NAME);
                     memset(&dsp_buf.name[SHORT_NAME-1],'~',1);
                     }
                  else {
                     memcpy(dsp_buf.name,&tmp[l],name_len-1);
                     }
                  memcpy(dsp_buf.lname,&tmp[l],name_len);
                  memset(&dsp_buf.lname[name_len-1],'\0',1);
                  /* set file type */
                  if(tmp[0] == 'd')
                     memcpy(dsp_buf.type,"*DIR",4);
                  else
                     memcpy(dsp_buf.type,"*STMF",5);
                  QUIADDLE(ApplHandle,
                           &dsp_buf,
                           sizeof(dsp_buf),
                           "CWDINF    ",
                           "CWDLST    ",
                           "NEXT",
                           "    ",
                           &Error_Code);
                  if(Error_Code.EC.Bytes_Available) {
                     snd_error_msg(Error_Code);
                     iconv_close(eaTable);
                     iconv_close(aeTable);
                     close(hDtaSocket);
                     return -1;
                     }
                  }
               j = 0;
               i += 2;
               memset(tmp,' ',300);
               }
            tmp[j] = newBuf[i];
            }
         }
      }while(ret > 0);
   }
/* close the data connection  and return msg to display */
iconv_close(aeTable);
iconv_close(eaTable);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   sprintf(msg_dta,"Failed");
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
/* resume keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Get_File
  * Get the remote file and store locally
  * @parms
  *     File details
  * returns 1 on success or -1
  */

int Get_File(char *File) {
int fd = 0;                                 // file descriptor
int ret = 0;                                // return value
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int TotalBytes = 0;                         // counter
int nCode = 0;                              // msg ID
extern char tMode;                          // Tranfer mode
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // message buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
extern char dBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* set transfer type and get listening socket */
Set_Transfer_Type();
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* request the file */
sprintf(cvnBuffer,"RETR %s%c%c",File,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   set_asc();
   iconv_close(eaTable);
   return -1;
   }
if((nCode = Dsp_Server_Reply()) >= 500) {
   sprintf(msg_dta,"Request Rejected ");
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* accept connection for data and receive the file */
if(Accept_Connection() == -1) {
   snd_log_msg("GEN0001","Cannot Accept Socket",20);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* open the file and destroy content if already exists */
fd = open(File,O_WRONLY|O_CREAT|O_TRUNC,S_IRWXU);
if(fd == -1) {
   sprintf(msg_dta,"fopen() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hDtaSocket);
   iconv_close(eaTable);
   return -1;
   }
sprintf(msg_dta,"Receiving File %s",File);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
do {
   ret = recv(hDtaSocket, dBuffer, BUF_SIZE,0);
   if(ret > 0) {
      TotalBytes += ret;
      if(write(fd,dBuffer,ret) != ret) {
         sprintf(msg_dta,"write() failed %s",strerror(errno));
         snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
         snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
         if((tMode == 'e') || (tMode == 'E'))
            set_asc();
         iconv_close(eaTable);
         return -1;
         }
      }
   }while(ret > 0);
sprintf(msg_dta,"%s : %d bytes processed",File,TotalBytes);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
close(fd);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
iconv_close(eaTable);
if((tMode == 'e') || (tMode == 'E'))
   set_asc();
/* resume keepalive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Get_Save_File
  * Get a save file from the remote system. Requires special processing
  * due to the nature of a save file
  * @parms
  *     Save File name
  * returns 1 on success or -1
  */

int Get_Save_File(char *File) {
_RFILE *fp;                                 // file pointer
_RIOFB_T *fdbk;                             // feedback struct ptr
FILE *fd;                                   // file pointer
int ret = 0;                                // return val
int len = 0;                                // byte counter
int offset = 0;                             // offset counter
int TotalBytes = 0;                         // bytes counter
int nCode = 0;                              // msg ID
char oldmode;                               // transfer mode flag
extern char tMode;                          // transfer mode
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // message buffer
char cwd[BUF_SIZE];                         // directory buffer
char F_Name[48];                            // file name
char L_Name[48];                            // library name
char Q_File[32];                            // qualified name
char FL_Name[20];                           // full name
char File_Info[31];                         // file info
char *ptr;                                  // pointer
extern char cBuffer[BUF_SIZE];              // IP buffer
char dBuffer[_SAVREC];                      // record buffer SAVF
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char cmd_str[100] = {'\0'};                 // command string
Qus_OBJD0400_t Obj_Dets;                    // object dets struct
iconv_t eaTable;
EC_t Error_Code = {0};                      // Error code data

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* if current transfer mode not binary store for resetting */
if((tMode != 'b') || (tMode != 'B')) {
   oldmode = tMode;
   snd_log_msg("MOD0001","",0);
   tMode = 'B';
   }
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   _Rclose(fp);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* set transfer type and request the file */
Set_Transfer_Type();
sprintf(cvnBuffer,"RETR %s%c%c",File,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   _Rclose(fp);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* get the server reply */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   sprintf(msg_dta,"Request Rejected ");
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   _Rclose(fp);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* accept the data connection and receive the file */
if(Accept_Connection() == -1) {
   snd_log_msg("GEN0001","Cannot Accept Socket",20);
   _Rclose(fp);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
if(getcwd(cwd,BUF_SIZE) == NULL) {
   sprintf(msg_dta,"getcwd() error : %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
memset(Q_File,'\0',32);
strcpy(L_Name,&cwd[10]);
ptr = strstr(L_Name,".LIB");
if(ptr == NULL) {
   memset(L_Name,'\0',48);
   strcpy(L_Name,"QSYS");
   }
else  {
   memset(ptr,'\0',1);
   }
/* Build the command strings and check for the save file */
strcpy(Q_File,L_Name);
strcat(Q_File,"/");
strcpy(F_Name,File);
ptr = strstr(F_Name,".SAVF");
memset(ptr,'\0',1);
strcat(Q_File,F_Name);
memset(FL_Name,' ',20);
memcpy(FL_Name,F_Name,strlen(F_Name));
memcpy(FL_Name+10,L_Name,strlen(L_Name));
QUSROBJD(&Obj_Dets,
         sizeof(Obj_Dets),
         "OBJD0400",
         FL_Name,
         "*FILE     ",
         &Error_Code);
if(Error_Code.EC.Bytes_Available > 0) {
   if(memcmp(Error_Code.EC.Exception_Id,"CPF9812",7) == 0) {
      /* save file doies not exist create it */
      strcpy(cmd_str, "QSYS/CRTSAVF FILE(");
      strcat(cmd_str,Q_File);
      strcat(cmd_str,")");
      if(system( cmd_str ) != 0) {
         snd_msg("SF00013",Q_File,strlen(Q_File));
         if((tMode == 'e') || (tMode == 'E'))
            set_asc();
         iconv_close(eaTable);
         return -1;
         }
      }
   else {
      snd_error_msg(Error_Code);
      if((tMode == 'e') || (tMode == 'E'))
         set_asc();
      iconv_close(eaTable);
      return -1;
      }
   }
else if(memcmp(Obj_Dets.Extended_Obj_Attr,"SAVF      ",10) != 0) {
   memcpy(File_Info,FL_Name,20);
   memcpy(File_Info+20,Obj_Dets.Extended_Obj_Attr,10);
   snd_msg("SF00011",File_Info,30);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* open the save file object */
if((fp = _Ropen(Q_File,"wr,lrecl=528,secure=Y")) == NULL) {
   sprintf(msg_dta,"Failed to open file : %s. error %s.",Q_File,
          strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
sprintf(msg_dta,"Transfering File %s",File);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
/* receive data and write to save file */
do {
   ret = recv(hDtaSocket,dBuffer+offset,_SAVREC - offset,0);
   offset += ret;
   if(offset == 528) {
      TotalBytes += offset;
      _Rwrite(fp,dBuffer,_SAVREC);
      offset = 0;
      }
   }while(ret > 0);
/* inform user and close up before returning */
sprintf(msg_dta,"%s : %d bytes processed",File,TotalBytes);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
_Rclose(fp);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
if((oldmode != 'b') || (oldmode != 'B')) {
   tMode = oldmode;
   Set_Transfer_Type();
   }
if((tMode == 'e') || (tMode == 'E'))
   set_asc();
/* resume keep alive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Put_File
  * put a file to the remote server
  * @parms
  *     File to be put to server
  * returns 1 on success or -1
  */

int Put_File(char *File) {
int fd = 0;                                 // file descriptor
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
int TotalBytes = 0;                         // byte counter
int Bytes_Read = 0;                         // byte counter
extern char tMode;                          // transfer Mode
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
char *ptr;                                  // pointer
char cwd[BUF_SIZE];                         // directory buffer
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
extern char dBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;
eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* open the local file */
if(!(fd = open(File,O_RDONLY)) < 0) {
   sprintf(msg_dta,"fopen() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* get a listen socket for server coms and set transfer type */
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
Set_Transfer_Type();
/* send stor request to server */
sprintf(cvnBuffer,"STOR %s%c%c",File,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   close(fd);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* get the server reply */
nCode = Dsp_Server_Reply();
if(nCode > 500) {
   close(hLstnSocket);
   close(fd);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* set up connect */
if(Accept_Connection() == -1) {
   snd_log_msg("GEN0001","Cannot Accept Socket",20);
   close(fd);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* send the file */
sprintf(msg_dta,"Sending File %s",File);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
do {
   Bytes_Read = read(fd,dBuffer,BUF_SIZE-1);
   if(Bytes_Read < 0) {
      sprintf(msg_dta,"read() failed %s",strerror(errno));
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      close(hDtaSocket);
      close(fd);
      if((tMode == 'e') || (tMode == 'E'))
         set_asc();
      iconv_close(eaTable);
      return -1;
      }
   if(Bytes_Read) {
      if(ret = send(hDtaSocket,dBuffer,Bytes_Read,0)!= Bytes_Read) {
         sprintf(msg_dta,"send() failed %s",strerror(errno));
         snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
         close(hDtaSocket);
         close(fd);
         if((tMode == 'e') || (tMode == 'E'))
            set_asc();
         iconv_close(eaTable);
         return -1;
         }
      TotalBytes += Bytes_Read;
      }
   }while(Bytes_Read > 0);
/* close out and inform user */
sprintf(msg_dta,"%s : %d bytes processed",File,TotalBytes);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
close(fd);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
if((tMode == 'e') || (tMode == 'E'))
   set_asc();
/* resume keepalive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Del_Rmt_File
  * Delete a file on the remote server
  * @parms
  *     File to be deleted on server
  * returns 1 on success or -1
  */

int Del_Rmt_File(char *File)  {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* create the request string */
sprintf(cvnBuffer,"DELE %s%c%c",File,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
/* send request to server */
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* get reply and close out */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* resume keepalive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Add_Rmt_Dir
  * Create remote directory on the server
  * @parms
  *     Directory to be created on server
  * returns 1 on success or -1
  */

int Add_Rmt_Dir(char *dir) {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* create the command */
sprintf(cvnBuffer,"MKD %s%c%c",dir,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
/* send to server and display response */
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* resume keepalive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Rmv_Rmt_Dir
  * Remove remote directory on the server
  * @parms
  *     Directory to be removed on server
  * returns 1 on success or -1
  */

int Rmv_Rmt_Dir(char *dir) {
int i = 0;                                  // counters
int j = 0;
int k = 0,l = 0;
int len = 0;                                // byte counter
int ret = 0;                                // return val
int name_len = 0;                           // counter
int nCode = 0;                              // msg ID
struct sockaddr_in addr;                    // address structure
int addr_len = sizeof(addr);                // Length
extern int hCntrlSocket;                    // control socket
extern int hLstnSocket;                     // listen socket
extern int keepalive;                       // keepalive
int DtaSocket;                              // dta socket
char Buffer[BUF_SIZE];                      // buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char newBuf[BUF_SIZE];                      // buffer
char msg_dta[MAX_MSG];                      // msg buffer
char tmp[300];                              // tmp buffer
char name[MAX_NAME];                        // name bufer
iconv_t eaTable;
iconv_t aeTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
Chg_Rmt_Dir(dir);
/* remove anything in the directory */
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
sprintf(cvnBuffer,"LIST%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
DtaSocket = accept(hLstnSocket,(struct sockaddr *)&addr,&addr_len);
if(DtaSocket < 0) {
   sprintf(msg_dta," accept() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
close(hLstnSocket);
/* remove the directory contents */
aeTable = Get_CCSID_table(0,819);
do  {
   ret = recv(DtaSocket, Buffer, BUF_SIZE, 0);
   if(ret > 0) {
      memset(newBuf,' ',BUF_SIZE);
      memset(cvnBuffer,'\0',BUF_SIZE);
      memcpy(cvnBuffer,Buffer,ret);
      AtoE_CCSID(cvnBuffer,newBuf,ret,aeTable);
      for(i = 0; i < ret; i++,j++) {
         if(newBuf[i] == 0x0d) {
            l = 33;
            for(k = 0; k < 4; k++) {
               while(tmp[l] == ' ') l++;
               while(tmp[l] != ' ') l++;
               }
            while(tmp[l] == ' ') l++;
            memset(name,' ',sizeof(name));
            name_len = j-l;
            memcpy(name,&tmp[l],name_len);
            memset(&name[name_len],'\0',1);
            /* call this process for any directories */
            if(tmp[0] == 'd')
               Rmv_Rmt_Dir(name);
            else
               Del_Rmt_File(name);
            j = 0;
            i += 2;
            memset(tmp,' ',150);
            }
         tmp[j] = newBuf[i];
         }
      }
   }while(ret > 0);
close(DtaSocket);
iconv_close(aeTable);
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* change directory back one level  and remove */
Go_Back_Rmt();
sprintf(cvnBuffer,"RMD %s%c%c",dir,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* resume keep alive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Chg_Rmt_Dir
  * Change remote directory on the server
  * @parms
  *     Directory to be set on server
  * returns 1 on success or -1
  */

int Chg_Rmt_Dir(char *dir) {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keep alive
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
/* create and send command to remote server */
sprintf(cvnBuffer,"CWD %s%c%c",dir,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* display response */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* resume keep alive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Go_Back_Rmt
  * Change remote directory one level
  * @parms NONE
  * returns 1 on success or -1
  */

int Go_Back_Rmt() {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
/* create command and send to server */
sprintf(cvnBuffer,"CDUP%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* get resonse and display to user */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* resume keep alive */
alarm(keepalive);
iconv_close(eaTable);
return 1;
}

/**
  * (Function) Dsp_Server_Reply
  * Display and convert response codes from server
  * @parms NONE
  * returns 1 on success or -1
  */

int Dsp_Server_Reply() {
int last = 0;                               // flag
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
extern int hCntrlSocket;                    // control socket
char msg_buf[BUF_SIZE];                     // msg buffer
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // Conversion buffer
char nCode[4] = {'\0'};                     // server response code
iconv_t aeTable;

aeTable = Get_CCSID_table(0,819);
/* peek at messages and get response code */
do {
   ret = recv(hCntrlSocket,cBuffer,BUF_SIZE,MSG_PEEK);
   if(ret < 0) {
      sprintf(msg_dta,"Dsp_Server_Reply recv() failed %s",
              strerror(errno));
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      iconv_close(aeTable);
      return -1;
      }
   memset(cvnBuffer,'\0',BUF_SIZE);
   for(i = 0; i < ret; i++) {
      cvnBuffer[i] = cBuffer[i];
      if(cBuffer[i] == 0x0d)
         break;
      }
   AtoE_CCSID(cvnBuffer,msg_buf,i,aeTable);
   if(msg_buf[3] != '-')
      last = 1;
   snd_status_msg("GEN0001",msg_buf,i);
   snd_log_msg("GEN0001",msg_buf,i);
   /* remove message from buffer */
   ret = recv(hCntrlSocket,cBuffer,i+2,0);
   }while(last == 0);
/* convert response code and return */
memcpy(nCode,msg_buf,3);
iconv_close(aeTable);
return atoi(nCode);
}

/**
  * (Function) Get_Rmt_Dir
  * Retrieve the remote directory contents from server
  * and store locally
  * @parms
  *     Directory to be returned on server
  * returns 1 on success or -1
  */

int Get_Rmt_Dir(char *dir) {
int i = 0, j = 0, k = 0, l = 0;             // counters
int len = 0;                                // byte counter
int ret = 0;                                // return val
int name_len = 0;                           // counter
int nCode = 0;                              // msg ID
struct sockaddr_in addr;                    // addr struct
int addr_len = sizeof(addr);                // addr struct len
extern char tMode;                          // transfer mode
extern int hCntrlSocket;                    // control socket
extern int hLstnSocket;                     // listen socket
extern int keepalive;                       // keepalive
int DtaSocket;                              // data socket
char Buffer[BUF_SIZE];                      // buffer
char oldmode;                               // old transfer mode
extern char cBuffer[BUF_SIZE];              // IP Buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char newBuf[BUF_SIZE];                      // Buffer
char msg_dta[MAX_MSG];                      // msg buffer
char tmp[300];                              // tmp buffer
char name[MAX_NAME];                        // name buffer
iconv_t eaTable;
iconv_t aeTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
/* if not binary mode store and set to binary */
if((tMode != 'b') || (tMode != 'B')) {
   oldmode = tMode;
   tMode = 'B';
   Set_Transfer_Type();
   }
/* make the local directory  and set local and remote directories */
if(mkdir(dir,S_IRWXU | S_IRGRP | S_IXGRP) != 0) {
   sprintf(msg_dta,"Unable to create local directory %s",dir);
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
chdir(dir);
Chg_Rmt_Dir(dir);
if(Get_Listen_Socket() == -1)  {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
/* ask server for remote list */
sprintf(cvnBuffer,"LIST%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* if OK copy the objects to the local system */
nCode = Dsp_Server_Reply();
if(nCode >= 500)
   iconv_close(eaTable);
   return -1;
DtaSocket = accept(hLstnSocket,(struct sockaddr *)&addr,&addr_len);
if(DtaSocket < 0) {
   sprintf(msg_dta," accept() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
close(hLstnSocket);
/* get the file list and copy to the local directory */
aeTable = Get_CCSID_table(0,819);
do {
   ret = recv(DtaSocket, Buffer, BUF_SIZE, 0);
   if(ret > 0) {
      memset(newBuf,' ',BUF_SIZE);
      memset(cvnBuffer,'\0',BUF_SIZE);
      memcpy(cvnBuffer,Buffer,ret);
      AtoE_CCSID(cvnBuffer,newBuf,ret,aeTable);
      for(i = 0; i < ret; i++,j++) {
         if(newBuf[i] == 0x0d) {
            l = 33;
            for(k = 0; k < 4; k++) {
               while(tmp[l] == ' ') l++;
               while(tmp[l] != ' ') l++;
               }
            while(tmp[l] == ' ') l++;
            memset(name,' ',sizeof(name));
            name_len = j-l;
            memcpy(name,&tmp[l],name_len);
            memset(&name[name_len],'\0',1);
            /* egt the objects from the remote system */
            if(tmp[0] == 'd')
               Get_Rmt_Dir(name);
            else
               Get_File(name);
            j = 0;
            i += 2;
            memset(tmp,' ',300);
            }
         tmp[j] = newBuf[i];
         }
      }
   }while(ret > 0);
iconv_close(aeTable);
iconv_close(eaTable);
close(DtaSocket);
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   return -1;
   }
/* change remote directory back one level and return */
Go_Back_Rmt();
chdir("..");
if((oldmode == 'a') || (oldmode == 'A')) {
   tMode = oldmode;
   Set_Transfer_Type();
   }
else if((tMode == 'e') || (tMode == 'E'))
  set_asc();
/* resume keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Get_Rmt_Det
  * Retrieve the remote File details from server
  * and display to user
  * @parms
  *     Object details to be displayed
  * returns 1 on success or -1
  */

int Get_Rmt_Det(char *ApplHandle, char *file)  {
struct Det_Buf_x {
       char atr[10];
       char links[5];
       char owner[MAX_USERID];
       char grpid[5];
       char size[20];
       char date[13];
       char name[SHORT_NAME];
       }det_buf;                            // details struct
int i = 0, j = 0, k = 0, l= 0;              // counters
int len = 0;                                // byte counter
int ret = 0;                                // return val
int name_len = 0;                           // name len
int nCode = 0;                              // msg ID
struct sockaddr_in addr;                    // addr struct
int addr_len = sizeof(addr);                // addr struct len
extern int hCntrlSocket;                    // control socket
extern int hLstnSocket;                     // listen socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // external keepalive
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char newBuf[BUF_SIZE];                      // buffer
char msg_dta[MAX_MSG];                      // msg buffer
char tmp[300];                              // tmp buffer
char size[48];                              // size buffer
iconv_t eaTable;
iconv_t aeTable;
EC_t Error_Code = {0};                      // error code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

eaTable = Get_CCSID_table(819,0);
/* stop keep alive */
alarm(0);
/* get listen socket */
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
/* create remote command */
sprintf(cvnBuffer,"LIST %s%c%c",file,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
/* accept the data connection  and close listen socket */
hDtaSocket = accept(hLstnSocket,(struct sockaddr *)&addr,&addr_len);
if(hDtaSocket < 0) {
   sprintf(msg_dta," accept() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
close(hLstnSocket);
/* loop through details and set up the structure */
aeTable = Get_CCSID_table(0,819);
do {
   ret = recv(hDtaSocket,dBuffer, BUF_SIZE, 0);
   if(ret > 0) {
      memset(newBuf,' ',BUF_SIZE);
      memset(cvnBuffer,'\0',BUF_SIZE);
      memcpy(cvnBuffer,dBuffer,ret);
      AtoE_CCSID(cvnBuffer,newBuf,ret,aeTable);
      for(i = 0; i < ret; i++,j++) {
         if(newBuf[i] == 0x0d) {
            memset(&det_buf,' ',sizeof(det_buf));
            k = 0;
            /* attributes */
            memcpy(det_buf.atr,tmp,10);
            k += 10;
            while(tmp[k] == ' ') k++;
            l = 0;
            /* links */
            while(tmp[k] != ' ')  {
                det_buf.links[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* owner */
            while(tmp[k] != ' ') {
                det_buf.owner[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* group ID */
            while(tmp[k] != ' ')  {
                det_buf.grpid[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* size */
            while(tmp[k] != ' ') {
                size[l] = tmp[k];
                k++;
                l++;
                }
             /* convert from bytes to MB,GB,TB etc */
            convert_size(size);
            memcpy(det_buf.size,size,l+1);
            while(tmp[k] == ' ') k++;
            /* date */
            memcpy(det_buf.date,&tmp[k],13);
            k += 13;
            name_len = j - k;
            if(name_len >= SHORT_NAME) {
               memcpy(det_buf.name,&tmp[k],SHORT_NAME);
               memset(&det_buf.name[SHORT_NAME-1],'~',1);
               }
            else
               memcpy(det_buf.name,&tmp[k],name_len);
            }
         tmp[j] = newBuf[i];
         }
      }
   }while(ret > 0);
/* close up and send to display */
iconv_close(eaTable);
iconv_close(aeTable);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
if(nCode >= 500)
   return -1;
QUIPUTV(ApplHandle,
        &det_buf,
        sizeof(det_buf),
        "OBJINF    ",
        &Error_Code);
if(Error_Code.EC.Bytes_Available) {
   snd_error_msg(Error_Code);
   return -1;
   }
/* reset the keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Get_Dir_Det
  * Retrieve the Directory details
  * and display to user
  * @parms
  *     Directory details to be displayed
  * returns 1 on success or -1
  */

int Get_Dir_Det(char *ApplHandle, char *dir) {
struct Det_Buf_x {
       char atr[10];
       char links[5];
       char owner[MAX_USERID];
       char grpid[5];
       char size[20];
       char date[13];
       char name[SHORT_NAME];
       }det_buf;                            // details struct
int i = 0, j = 0, k = 0, l= 0;              // counters
int len = 0;                                // byte counter
int ret = 0;                                // return val
int name_len = 0;                           // name len
int nCode = 0;                              // msg ID
struct sockaddr_in addr;                    // addr struct
int addr_len = sizeof(addr);                // addr struct len
extern int hCntrlSocket;                    // control socket
extern int hLstnSocket;                     // listen socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char newBuf[BUF_SIZE];                      // buffer
char msg_dta[MAX_MSG];                      // msg buffer
char tmp[300];                              // tmp buffer
char size[48];                              // size buffer
char lname[MAX_NAME];                       // long name
iconv_t eaTable;
iconv_t aeTable;
EC_t Error_Code = {0};                      /* error code struct */

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

eaTable = Get_CCSID_table(819,0);
/* stop keepalive */
alarm(0);
/* get a listen socket */
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   iconv_close(eaTable);
   return -1;
   }
/* create command and send to the server */
sprintf(cvnBuffer,"LIST%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
/* send server reply and exit if >= 500 or get accept data socket */
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
iconv_close(eaTable);
   return -1;
   }
hDtaSocket = accept(hLstnSocket,(struct sockaddr *)&addr,&addr_len);
if(hDtaSocket < 0) {
   sprintf(msg_dta," accept() failed %s",strerror(errno));
   snd_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
/* always close the listen socket its not required any longer */
close(hLstnSocket);
/* receiver the directory details It will lsit all objects */
aeTable = Get_CCSID_table(0,819);
do  {
   ret = recv(hDtaSocket,dBuffer, BUF_SIZE, 0);
   if(ret > 0) {
      memset(newBuf,' ',BUF_SIZE);
      memset(cvnBuffer,'\0',BUF_SIZE);
      memcpy(cvnBuffer,dBuffer,ret);
      AtoE_CCSID(cvnBuffer,newBuf,ret,aeTable);
      for(i = 0; i < ret; i++,j++) {
         if(newBuf[i] == 0x0d) {
            memset(&det_buf,' ',sizeof(det_buf));
            k = 0;
            /* attributes */
            memcpy(det_buf.atr,tmp,10);
            k += 10;
            while(tmp[k] == ' ') k++;
            l = 0;
            /* links */
            while(tmp[k] != ' ') {
                det_buf.links[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* owner */
            while(tmp[k] != ' ') {
                det_buf.owner[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* group ID */
            while(tmp[k] != ' ') {
                det_buf.grpid[l] = tmp[k];
                k++;
                l++;
                }
            while(tmp[k] == ' ') k++;
            l = 0;
            /* size */
            while(tmp[k] != ' ') {
                size[l] = tmp[k];
                k++;
                l++;
                }
            /* convert size to Mb,Gb,Tb etc */
            convert_size(size);
            memcpy(det_buf.size,size,strlen(size));
            while(tmp[k] == ' ') k++;
            /* date info */
            memcpy(det_buf.date,&tmp[k],13);
            k += 13;
            name_len = j - k;
            if(name_len > MAX_NAME) {
               /* strcmp will not match ? */
               }
            memset(lname,'\0',MAX_NAME);
            memcpy(lname,&tmp[k],name_len);
            /* concat short name if required */
            if(name_len >= SHORT_NAME)  {
               memcpy(det_buf.name,&tmp[k],SHORT_NAME);
               memset(&det_buf.name[SHORT_NAME-1],'~',1);
               }
            else
               memcpy(det_buf.name,&tmp[k],name_len);
            /* if its the right directory display */
            if(strcmp(dir,lname) == 0) {
               close(hDtaSocket);
               nCode = Dsp_Server_Reply();
               if(nCode >= 500)
                  return -1;
               QUIPUTV(ApplHandle,
                       &det_buf,
                       sizeof(det_buf),
                       "OBJINF    ",
                       &Error_Code);
               if(Error_Code.EC.Bytes_Available) {
                  snd_error_msg(Error_Code);
                  return -1;
                  }
               return 1;
               }
            j = 0;
            i += 2;
            memset(tmp,' ',300);
            }
         tmp[j] = newBuf[i];
         }
      }
   }while(ret > 0);
iconv_close(eaTable);
iconv_close(aeTable);
/* start up keepalive again */
alarm(keepalive);
return 1;
}

/**
  * (Function) convert_size
  * Converts bytes to Mb,Gb,Tb
  * @parm
  *     Character string size
  * returns Nothing
  */

int convert_size(char *size) {
double nSize,Total,Mult;                    // counters
char *Type;                                 // pointers
char *endptr;

nSize = strtod(size,&endptr);

if(nSize > (999.5 * _1GB)) {
   Type = "TB";
   Mult = _1TB;
   }
else if(nSize > (999.5 * _1MB)) {
   Type = "GB";
   Mult = _1GB;
   }
else if(nSize > (999.5 * _1KB)) {
   Type = "MB";
   Mult = _1MB;
   }
else if(nSize > 999.5) {
   Type = "kB";
   Mult = _1KB;
   }
else {
   Type = "B";
   Mult = 1;
   }
Total = nSize/((double)Mult);
if(Total < 0.0)
   Total = 0.0;
memset(size,' ',sizeof(size));
sprintf(size,"%3.1f%s",Total,Type);
return;
}

/**
  * (Function) Set_Transfer_Type
  * Set the FTP transfer type
  * @parms None
  * returns 1 on success or -1
  */

int Set_Transfer_Type() {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keep alive
char msg_dta[MAX_MSG];                      // msg buffer
extern char tMode;                          // transfer mode
char mode;                                  // mode
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
if((tMode == 'e') || (tMode == 'E'))
   mode = 'E';
else if((tMode == 'b') || (tMode == 'B'))
   mode = 'I';
else if((tMode == 'a') || (tMode == 'A'))
   mode = 'A';
/* send request to server */
sprintf(cvnBuffer,"TYPE %c%c%c",mode,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
iconv_close(eaTable);
nCode = Dsp_Server_Reply();
if(nCode >= 500)
   return -1;
/* resume keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) set_asc
  * Set the FTP transfer type to ASCII
  * @parms None
  * returns 1 on success or -1
  */

int set_asc() {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // msg buffer
char mode = 'A';                            // trnasfer mode
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
/* send request to server */
sprintf(cvnBuffer,"TYPE %c%c%c",mode,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
iconv_close(eaTable);
nCode = Dsp_Server_Reply();
if(nCode >= 500)
   return -1;
/* resume keepalive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Ren_Rmt_Obj
  * Rename objecdt on target
  * @parms
  *     Old Object Name
  *     New Object Name
  * returns 1 on success or -1
  */

int Ren_Rmt_Obj(char *oldname, char* newname) {
int ret = 0;                                // return val
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int nCode = 0;                              // msg ID
extern int hCntrlSocket;                    // control socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // msg buffer
extern char cBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keep alive */
alarm(0);
/* send request to server */
sprintf(cvnBuffer,"RNFR %s%c%c",oldname,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(eaTable);
   return -1;
   }
sprintf(cvnBuffer,"RNTO %s%c%c",newname,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
iconv_close(eaTable);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500)
   return -1;
/* resume keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) Get_File_to_Tmp
  * Get the remote file and store locally in temp storage
  * @parms
  *     File details
  * returns 1 on success or -1
  */

int Get_File_to_Tmp(char *File) {
int fd = 0;                                 // file descriptor
int ret = 0;                                // return value
int len = 0;                                // byte counter
int i = 0;                                  // loop counter
int bytes = 0;                              // bytes written to file
int TotalBytes = 0;                         // counter
int nCode = 0;                              // msg ID
extern char tMode;                          // Tranfer mode
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
char msg_dta[MAX_MSG];                      // message buffer
char cwd[BUF_SIZE];                         // directory
char cwd_1[BUF_SIZE];                       // directory
extern char cBuffer[BUF_SIZE];              // IP buffer
extern char dBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
iconv_t eaTable;

eaTable = Get_CCSID_table(819,0);
/* suspend keepalive */
alarm(0);
/* set transfer type and get listening socket */
Set_Transfer_Type();
if(Get_Listen_Socket() == -1) {
   snd_msg("GEN0001","Cannot get a Listen Socket",26);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* request the file */
sprintf(cvnBuffer,"RETR %s%c%c",File,0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   set_asc();
   iconv_close(eaTable);
   return -1;
   }
if((nCode = Dsp_Server_Reply()) >= 500) {
   sprintf(msg_dta,"Request Rejected ");
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* accept connection for data and receive the file */
if(Accept_Connection() == -1) {
   snd_log_msg("GEN0001","Cannot Accept Socket",20);
   if((tMode == 'e') || (tMode == 'E'))
      set_asc();
   iconv_close(eaTable);
   return -1;
   }
/* store the current working directory */
if(getcwd(cwd,sizeof(cwd)) == NULL) {
   snd_msg("CWD0003"," ",0);
   iconv_close(eaTable);
   return;
   }
/* set the local directory to /tmp */
if(chdir("/tmp") != 0) {
   sprintf(msg_dta,"Cannot Change Directory /tmp %s",
           strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
   iconv_close(eaTable);
   return;
   }
/* open the file and destroy content if already exists */
fd = open(File,O_WRONLY|O_CREAT|O_TRUNC|O_INHERITMODE,S_IRWXO);
if(fd == -1) {
   sprintf(msg_dta,"open() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hDtaSocket);
   return -1;
   }
sprintf(msg_dta,"Receiving File %s",File);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
do {
   ret = recv(hDtaSocket, dBuffer, BUF_SIZE,0);
   if(ret > 0) {
      TotalBytes += ret;
      if((bytes = write(fd,dBuffer,ret)) != ret) {
         sprintf(msg_dta,"write() failed %s",strerror(errno));
         snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
         snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
         if((tMode == 'e') || (tMode == 'E'))
            set_asc();
         iconv_close(eaTable);
         return -1;
         }
      }
   }while(ret > 0);
iconv_close(eaTable);
sprintf(msg_dta,"%s : %d bytes processed",File,TotalBytes);
snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
close(fd);
close(hDtaSocket);
nCode = Dsp_Server_Reply();
if((tMode == 'e') || (tMode == 'E'))
   set_asc();
if(chdir(cwd) != 0) {
   sprintf(msg_dta,"Cannot Change Directory %s %s",
           cwd,strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   snd_status_msg("GEN0001",msg_dta,strlen(msg_dta));
   return;
   }
/* resume keep alive */
alarm(keepalive);
return 1;
}

/**
  * (Function) read eplf
  * Allows a ELP format string to be proken down
  * @parms
  *     character string
  * returns 1 on success or -1
  */


int read_eplf(char *line) {
int flagcwd = 0;
time_t when = 0;
int flagsize = 0;
unsigned long size;

if (*line++ != '+') return 0;
   while (*line) {
      switch (*line) {
         case '\t':
            if (flagsize)
               printf("%10lu bytes   ",size);
            else
               printf("                   ");
            if (when)
               printf("%24.24s",ctime(&when));
            else
               printf("                        ");
            printf("   %s%s\n",line + 1,flagcwd ? "/" : "");
            return 1;
         case 's':
            flagsize = 1;
            size = 0;
            while (*++line && (*line != ','))
               size = size * 10 + (*line - '0');
            break;
         case 'm':
            while (*++line && (*line != ','))
               when = when * 10 + (*line - '0');
            break;
         case '/':
            flagcwd = 1;
         default:
            while (*line) if (*line++ == ',') break;
      }
   }
   return 0;
}

int get_feat()  {
int i = 0;                                  // counter
int ret = 0;
int len = 0;
int last = 0;
int nCode = 0;
extern int hCntrlSocket;                    // control socket
extern int hDtaSocket;                      // data socket
extern int keepalive;                       // keepalive
extern char cBuffer[BUF_SIZE];              // IP Buffer
extern char dBuffer[BUF_SIZE];              // IP buffer
char cvnBuffer[BUF_SIZE];                   // conversion buffer
char msg_dta[MAX_MSG];                      // message data
char msg_buf[BUF_SIZE];                     // msg buffer
char _LF[2] = {0x0d,0x25};                  // LF string
iconv_t eaTable;
iconv_t aeTable;
EC_t Error_Code = {0};                      // Error Code struct

Error_Code.EC.Bytes_Provided = sizeof(Error_Code);

eaTable = Get_CCSID_table(819,0);
aeTable = Get_CCSID_table(0,819);

// get the remote system type
sprintf(cvnBuffer,"SYST%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(eaTable);
   return -1;
   }
nCode = Dsp_Server_Reply();
if(nCode >= 500) {
   iconv_close(aeTable);
   iconv_close(eaTable);
   return -1;
   }
// get the remote features
sprintf(cvnBuffer,"FEAT%c%c",0x0d,0x25);
len = strlen(cvnBuffer);
snd_status_msg("GEN0001",cvnBuffer,len-2);
snd_log_msg("GEN0001",cvnBuffer,len-2);
EtoA_CCSID(cvnBuffer,cBuffer,len,eaTable);
ret = send(hCntrlSocket,cBuffer,len,0);
if(ret != len) {
   sprintf(msg_dta,"send() failed %s",strerror(errno));
   snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
   close(hLstnSocket);
   iconv_close(aeTable);
   iconv_close(eaTable);
   return -1;
   }
// read through the returned data
do {
   ret = recv(hCntrlSocket,cBuffer,BUF_SIZE,MSG_PEEK);
   if(ret < 0) {
      sprintf(msg_dta,"Dsp_Server_Reply recv() failed %s",strerror(errno));
      snd_log_msg("GEN0001",msg_dta,strlen(msg_dta));
      iconv_close(aeTable);
      iconv_close(eaTable);
      return -1;
      }
   memset(cvnBuffer,'\0',BUF_SIZE);
   for(i = 0; i < ret; i++) {
      cvnBuffer[i] = cBuffer[i];
      if(cBuffer[i] == 0x0d)
         break;
      }
   AtoE_CCSID(cvnBuffer,msg_buf,i,aeTable);
   if(memcmp(msg_buf,"500 ",4) == 0) {
      snd_log_msg("GEN0001",msg_buf,strlen(msg_buf));
      iconv_close(aeTable);
      iconv_close(eaTable);
      // clear the buffer
      ret = recv(hCntrlSocket,cBuffer,i+2,0);
      return -1;
      }
   if(memcmp(msg_buf,"211 ",4) == 0) {
      snd_status_msg("GEN0001",msg_buf,i);
      snd_log_msg("GEN0001",msg_buf,i);
      ret = recv(hCntrlSocket,cBuffer,i+2,0);
      break;
      }
   snd_status_msg("GEN0001",msg_buf,i);
   snd_log_msg("GEN0001",msg_buf,i);
   /* remove message from buffer */
   ret = recv(hCntrlSocket,cBuffer,i+2,0);
   }while(ret > 0);
iconv_close(aeTable);
iconv_close(eaTable);
return 1;
}
