/*
   minizip.c
   Version 1.01e, February 12th, 2005
 
   Copyright (C) 1998-2005 Gilles Vollant
*/
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <fcntl.h>
 
#ifdef unix
# include <unistd.h>
# include <utime.h>
# include <sys/types.h>
# include <sys/stat.h>
#else
# include <direct.h>
# include <io.h>
#endif
 
#include "zip.h"
 
#ifdef WIN32
#define USEWIN32IOAPI
#include "iowin32.h"
#endif
 
#ifndef AS400
#define CASESENSITIVITY (0)
#else
#define CASESENSITIVITY (2)
#endif
 
#ifdef FPRINT2SNDMSG
#include <qusec.h>
#include <qmhsndpm.h>
void snd_OS400_msg OF((char []));
char printtext[256];
Qus_EC_t error_code;
char message_key[4];
#endif
 
#ifdef AS400
char err_str[24];
char *err_str2;
int rc;
#endif
 
#define WRITEBUFFERSIZE (16384)
#define MAXFILENAME (256)
 
#ifdef WIN32
uLong filetime(f, tmzip, dt)
    char *f;                /* name of file to get info on */
    tm_zip *tmzip;             /* return value: access, modific. and creation times */
    uLong *dt;             /* dostime */
{
  int ret = 0;
  {
      FILETIME ftLocal;
      HANDLE hFind;
      WIN32_FIND_DATA  ff32;
 
      hFind = FindFirstFile(f,&ff32);
      if (hFind != INVALID_HANDLE_VALUE)
      {
        FileTimeToLocalFileTime(&(ff32.ftLastWriteTime),&ftLocal);
        FileTimeToDosDateTime(&ftLocal,((LPWORD)dt)+1,((LPWORD)dt)+0);
        FindClose(hFind);
        ret = 1;
      }
  }
  return ret;
}
#else
#ifdef unix
uLong filetime(f, tmzip, dt)
    char *f;               /* name of file to get info on */
    tm_zip *tmzip;         /* return value: access, modific. and creation times */
    uLong *dt;             /* dostime */
{
  int ret=0;
  struct stat s;        /* results of stat() */
  struct tm* filedate;
  time_t tm_t=0;
 
  if (strcmp(f,"-")!=0)
  {
    char name[MAXFILENAME+1];
    int len = strlen(f);
    if (len > MAXFILENAME)
      len = MAXFILENAME;
 
    strncpy(name, f,MAXFILENAME-1);
    /* strncpy doesnt append the trailing NULL, of the string is too long. */
    name[ MAXFILENAME ] = '\0';
 
    if (name[len - 1] == '/')
      name[len - 1] = '\0';
    /* not all systems allow stat'ing a file with / appended */
    if (stat(name,&s)==0)
    {
      tm_t = s.st_mtime;
      ret = 1;
    }
  }
  filedate = localtime(&tm_t);
 
  tmzip->tm_sec  = filedate->tm_sec;
  tmzip->tm_min  = filedate->tm_min;
  tmzip->tm_hour = filedate->tm_hour;
  tmzip->tm_mday = filedate->tm_mday;
  tmzip->tm_mon  = filedate->tm_mon ;
  tmzip->tm_year = filedate->tm_year;
 
  return ret;
}
#else
uLong filetime(f, tmzip, dt)
    char *f;                /* name of file to get info on */
    tm_zip *tmzip;             /* return value: access, modific. and creation times */
    uLong *dt;             /* dostime */
{
    return 0;
}
#endif
#endif
 
 
 
 
int check_exist_file(filename)
    const char* filename;
{
    FILE* ftestexist;
    int ret = 1;
    ftestexist = fopen(filename,"rb");
    if (ftestexist==NULL)
        ret = 0;
    else
        fclose(ftestexist);
    return ret;
}
 
void do_banner()
{
// AS400  printf("MiniZip 1.01b, demo of zLib + Zip package written by Gilles Vollant\n");
    printf("MiniZip 1.01e, demo of zLib + Zip package written by Gilles Vollant\n");
    printf("more info at http://www.winimage.com/zLibDll/unzip.html\n\n");
}
 
void do_help()
{
    printf("Usage : minizip [-o] [-a] [-0 to -9] [-p password] file.zip [files_to_add]\n\n" \
           "  -o  Overwrite existing file.zip\n" \
           "  -a  Append to existing file.zip\n" \
           "  -0  Store only\n" \
           "  -1  Compress faster\n" \
           "  -9  Compress better\n\n");
}
 
/* calculate the CRC32 of a file,
   because to encrypt a file, we need known the CRC32 of the file before */
int getFileCrc(const char* filenameinzip,void*buf,unsigned long size_buf,unsigned long* result_crc)
{
   unsigned long calculate_crc=0;
   int err=ZIP_OK;
   FILE * fin = fopen(filenameinzip,"rb");
   unsigned long size_read = 0;
   unsigned long total_read = 0;
   if (fin==NULL)
   {
       err = ZIP_ERRNO;
   }
 
    if (err == ZIP_OK)
        do
        {
            err = ZIP_OK;
            size_read = (int)fread(buf,1,size_buf,fin);
            if (size_read < size_buf)
                if (feof(fin)==0)
            {
#ifndef FPRINT2SNDMSG
                printf("error in reading %s\n",filenameinzip);
#else
                sprintf(printtext,"error in reading %s\n",filenameinzip);
                snd_OS400_msg(printtext);
#endif
                err = ZIP_ERRNO;
            }
 
            if (size_read>0)
                calculate_crc = crc32(calculate_crc,buf,size_read);
            total_read += size_read;
 
        } while ((err == ZIP_OK) && (size_read>0));
 
    if (fin)
        fclose(fin);
 
    *result_crc=calculate_crc;
#ifndef FPRINT2SNDMSG
    printf("file %s crc %x\n",filenameinzip,calculate_crc);
#else
    sprintf(printtext,"file %s crc %x\n",filenameinzip,calculate_crc);
    snd_OS400_msg(printtext);
#endif
    return err;
}
 
#ifdef FPRINT2SNDMSG
void snd_OS400_msg(OS400msg)
    char OS400msg[256];
{
    error_code.Bytes_Provided = 16;
 
        QMHSNDPM("CPF9898", "QCPFMSG   *LIBL     ", OS400msg, strlen((char *)OS400msg + 1),
             "*DIAG     ", "*         ", 0, message_key, &error_code);
}
#endif
 
 
int main(argc,argv)
    int argc;
    char *argv[];
{
    int i;
    int opt_overwrite=0;
    int opt_compress_level=Z_DEFAULT_COMPRESSION;
    int zipfilenamearg = 0;
    char filename_try[MAXFILENAME+16];
    int zipok;
    int err=0;
    int size_buf=0;
    void* buf=NULL;
    const char* password=NULL;
#ifdef AS400
    const char* password_ascii=NULL;
#endif
 
#ifndef NODOBANNER
    do_banner();
#endif
    if (argc==1)
    {
        do_help();
        return 0;
    }
    else
    {
        for (i=1;i<argc;i++)
        {
            if ((*argv[i])=='-')
            {
                const char *p=argv[i]+1;
 
                while ((*p)!='\0')
                {
                    char c=*(p++);;
                    if ((c=='o') || (c=='O'))
                        opt_overwrite = 1;
                    if ((c=='a') || (c=='A'))
                        opt_overwrite = 2;
                    if ((c>='0') && (c<='9'))
                        opt_compress_level = c-'0';
 
                    if (((c=='p') || (c=='P')) && (i+1<argc))
                    {
                        password=argv[i+1];
#ifdef AS400
                        password_ascii=argv[i+1];
                        e2a(password_ascii);
#endif
                        i++;
                    }
                }
            }
            else
                if (zipfilenamearg == 0)
                    zipfilenamearg = i ;
        }
    }
 
    size_buf = WRITEBUFFERSIZE;
    buf = (void*)malloc(size_buf);
    if (buf==NULL)
    {
#ifndef FPRINT2SNDMSG
        printf("Error allocating memory\n");
#else
        sprintf(printtext,"Error allocating memory\n");
        snd_OS400_msg(printtext);
#endif
        return ZIP_INTERNALERROR;
    }
 
    if (zipfilenamearg==0)
        zipok=0;
    else
    {
        int i,len;
        int dot_found=0;
 
        zipok = 1 ;
        strncpy(filename_try, argv[zipfilenamearg],MAXFILENAME-1);
        /* strncpy doesnt append the trailing NULL, of the string is too long. */
        filename_try[ MAXFILENAME ] = '\0';
 
        len=(int)strlen(filename_try);
        for (i=0;i<len;i++)
            if (filename_try[i]=='.')
                dot_found=1;
 
        if (dot_found==0)
            strcat(filename_try,".zip");
 
        if (opt_overwrite==2)
        {
            /* if the file don't exist, we not append file */
            if (check_exist_file(filename_try)==0)
                opt_overwrite=1;
        }
        else
        if (opt_overwrite==0)
            if (check_exist_file(filename_try)!=0)
            {
                char rep=0;
                do
                {
                    char answer[128];
                    int ret;
#ifndef AS400
                    printf("The file %s exists. Overwrite ? [y]es, [n]o, [a]ppend : ",filename_try);
#else
                    printf("The file %s exist. Overwrite ? [y]es, [n]o, [a]ppend : \n",filename_try);
#endif
                    ret = scanf("%1s",answer);
                    if (ret != 1)
                    {
                       exit(EXIT_FAILURE);
                    }
                    rep = answer[0] ;
                    if ((rep>='a') && (rep<='z'))
#ifndef AS400
                        rep -= 0x20;
#else
                        rep += 0x40;
#endif
                }
                while ((rep!='Y') && (rep!='N') && (rep!='A'));
                if (rep=='N')
                    zipok = 0;
                if (rep=='A')
                    opt_overwrite = 2;
            }
    }
 
    if (zipok==1)
    {
        zipFile zf;
        int errclose;
#        ifdef USEWIN32IOAPI
        zlib_filefunc_def ffunc;
        fill_win32_filefunc(&ffunc);
        zf = zipOpen2(filename_try,(opt_overwrite==2) ? 2 : 0,NULL,&ffunc);
#        else
        zf = zipOpen(filename_try,(opt_overwrite==2) ? 2 : 0);
#        endif
 
        if (zf == NULL)
        {
#ifndef FPRINT2SNDMSG
            printf("error opening %s\n",filename_try);
#else
            sprintf(printtext,"error opening %s\n",filename_try);
            snd_OS400_msg(printtext);
#endif
            err= ZIP_ERRNO;
        }
        else
#ifndef FPRINT2SNDMSG
            printf("creating %s\n",filename_try);
#else
          { sprintf(printtext,"creating %s\n",filename_try);
            snd_OS400_msg(printtext); }
#endif
 
        for (i=zipfilenamearg+1;(i<argc) && (err==ZIP_OK);i++)
        {
#ifndef AS400
            if (!((((*(argv[i]))=='-') || ((*(argv[i]))=='/')) &&
#else /* allow separator (/) */
            if (!((((*(argv[i]))=='-')) &&
#endif
                  ((argv[i][1]=='o') || (argv[i][1]=='O') ||
                   (argv[i][1]=='a') || (argv[i][1]=='A') ||
                   (argv[i][1]=='p') || (argv[i][1]=='P') ||
                   ((argv[i][1]>='0') || (argv[i][1]<='9'))) &&
                  (strlen(argv[i]) == 2)))
            {
                FILE * fin;
                int size_read;
                const char* filenameinzip = argv[i];
#ifdef AS400
                const char* filename_ascii = argv[i];
#endif
                zip_fileinfo zi;
                unsigned long crcFile=0;
 
                zi.tmz_date.tm_sec = zi.tmz_date.tm_min = zi.tmz_date.tm_hour =
                zi.tmz_date.tm_mday = zi.tmz_date.tm_mon = zi.tmz_date.tm_year = 0;
                zi.dosDate = 0;
                zi.internal_fa = 0;
                zi.external_fa = 0;
                filetime(filenameinzip,&zi.tmz_date,&zi.dosDate);
 
/*
                err = zipOpenNewFileInZip(zf,filenameinzip,&zi,
                                 NULL,0,NULL,0,NULL / * comment * /,
                                 (opt_compress_level != 0) ? Z_DEFLATED : 0,
                                 opt_compress_level);
*/
                if ((password != NULL) && (err==ZIP_OK))
                    err = getFileCrc(filenameinzip,buf,size_buf,&crcFile);
 
#ifndef AS400
                err = zipOpenNewFileInZip3(zf,filenameinzip,&zi,
                                 NULL,0,NULL,0,NULL /* comment*/,
                                 (opt_compress_level != 0) ? Z_DEFLATED : 0,
                                 opt_compress_level,0,
                                 /* -MAX_WBITS, DEF_MEM_LEVEL, Z_DEFAULT_STRATEGY, */
                                 -MAX_WBITS, DEF_MEM_LEVEL, Z_DEFAULT_STRATEGY,
                                 password,crcFile);
#else  /* Convert EBCDIC to ASCII*/
                if (filenameinzip != NULL) e2a(filename_ascii);
                err = zipOpenNewFileInZip3(zf,filename_ascii,&zi,
                                 NULL,0,NULL,0,NULL /* comment*/,
                                 (opt_compress_level != 0) ? Z_DEFLATED : 0,
                                 opt_compress_level,0,
                                 /* -MAX_WBITS, DEF_MEM_LEVEL, Z_DEFAULT_STRATEGY, */
                                 -MAX_WBITS, DEF_MEM_LEVEL, Z_DEFAULT_STRATEGY,
                                 password_ascii,crcFile);
                a2e(filenameinzip);
#endif
 
                if (err != ZIP_OK)
#ifndef FPRINT2SNDMSG
                    printf("error in opening %s in zipfile\n",filenameinzip);
#else
                {   sprintf(printtext,"error in opening %s in zipfile\n",filenameinzip);
                    snd_OS400_msg(printtext); }
#endif
                else
                {
                    fin = fopen(filenameinzip,"rb");
                    if (fin==NULL)
                    {
                        err=ZIP_ERRNO;
#ifndef FPRINT2SNDMSG
                        printf("error in opening %s for reading\n",filenameinzip);
#else
                        sprintf(printtext,"error in opening %s for reading\n",filenameinzip);
                        snd_OS400_msg(printtext);
#endif
                    }
                }
 
                if (err == ZIP_OK)
                    do
                    {
                        err = ZIP_OK;
                        size_read = (int)fread(buf,1,size_buf,fin);
                        if (size_read < size_buf)
                            if (feof(fin)==0)
                        {
#ifndef FPRINT2SNDMSG
                            printf("error in reading %s\n",filenameinzip);
#else
                            sprintf(printtext,"error in reading %s\n",filenameinzip);
                            snd_OS400_msg(printtext);
#endif
                            err = ZIP_ERRNO;
                        }
 
                        if (size_read>0)
                        {
                            err = zipWriteInFileInZip (zf,buf,size_read);
                            if (err<0)
                            {
#ifndef FPRINT2SNDMSG
                                printf("error in writing %s in the zipfile\n",
                                                 filenameinzip);
#else
                                sprintf(printtext,"error in writing %s in the zipfile\n",
                                                 filenameinzip);
                                snd_OS400_msg(printtext);
#endif
                            }
 
                        }
                    } while ((err == ZIP_OK) && (size_read>0));
 
                if (fin)
                    fclose(fin);
 
                if (err<0)
                    err=ZIP_ERRNO;
                else
                {
                    err = zipCloseFileInZip(zf);
                    if (err!=ZIP_OK)
#ifndef FPRINT2SNDMSG
                        printf("error in closing %s in the zipfile\n",
                                    filenameinzip);
#else
                      { sprintf(printtext,"error in closing %s in the zipfile\n",
                                    filenameinzip);
                        snd_OS400_msg(printtext); }
#endif
                }
            }
        }
        errclose = zipClose(zf,NULL);
        if (errclose != ZIP_OK)
#ifndef FPRINT2SNDMSG
            printf("error in closing %s\n",filename_try);
#else
          { sprintf(printtext,"error in closing %s\n",filename_try);
            snd_OS400_msg(printtext);
            err = errclose; }
#endif
    }
    else
    {
       do_help();
    }
 
    free(buf);
#ifdef FPRINT2SNDMSG
    sprintf(printtext,"Program minizip completed with return code %d\n",err);
    snd_OS400_msg(printtext);
#endif
#ifdef AS400
    sprintf(err_str, "%d", err);
    err_str2 = strcat("MINIZIP_RTNCDE=", err_str);
    rc = putenv(err_str2);
#endif
    return 0;
}
