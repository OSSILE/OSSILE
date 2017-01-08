/*
   miniunz.c
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
#else
# include <direct.h>
# include <io.h>
#endif
 
#include "unzip.h"
 
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
 
#define WRITEBUFFERSIZE (8192)
#define MAXFILENAME (256)
 
#ifdef WIN32
#define USEWIN32IOAPI
#include "iowin32.h"
#endif
/*
  mini unzip, demo of unzip package
 
  usage :
  Usage : miniunz [-exvlo] file.zip [file_to_extract] [-d extractdir]
 
  list the file in the zipfile, and print the content of FILE_ID.ZIP or README.TXT
    if it exists
*/
 
 
/* change_file_date : change the date/time of a file
    filename : the filename of the file where date/time must be modified
    dosdate : the new date at the MSDos format (4 bytes)
    tmu_date : the SAME new date at the tm_unz format */
void change_file_date(filename,dosdate,tmu_date)
    const char *filename;
    uLong dosdate;
    tm_unz tmu_date;
{
#ifdef WIN32
  HANDLE hFile;
  FILETIME ftm,ftLocal,ftCreate,ftLastAcc,ftLastWrite;
 
  hFile = CreateFile(filename,GENERIC_READ | GENERIC_WRITE,
                      0,NULL,OPEN_EXISTING,0,NULL);
  GetFileTime(hFile,&ftCreate,&ftLastAcc,&ftLastWrite);
  DosDateTimeToFileTime((WORD)(dosdate>>16),(WORD)dosdate,&ftLocal);
  LocalFileTimeToFileTime(&ftLocal,&ftm);
  SetFileTime(hFile,&ftm,&ftLastAcc,&ftm);
  CloseHandle(hFile);
#else
#ifdef unix
  struct utimbuf ut;
  struct tm newdate;
  newdate.tm_sec = tmu_date.tm_sec;
  newdate.tm_min=tmu_date.tm_min;
  newdate.tm_hour=tmu_date.tm_hour;
  newdate.tm_mday=tmu_date.tm_mday;
  newdate.tm_mon=tmu_date.tm_mon;
  if (tmu_date.tm_year > 1900)
      newdate.tm_year=tmu_date.tm_year - 1900;
  else
      newdate.tm_year=tmu_date.tm_year ;
  newdate.tm_isdst=-1;
 
  ut.actime=ut.modtime=mktime(&newdate);
  utime(filename,&ut);
#endif
#endif
}
 
 
/* mymkdir and change_file_date are not 100 % portable
   As I don't know well Unix, I wait feedback for the unix portion */
 
int mymkdir(dirname)
    const char* dirname;
{
    int ret=0;
#ifdef WIN32
    ret = mkdir(dirname);
#else
#ifdef unix
    ret = mkdir (dirname,0775);
#endif
#endif
    return ret;
}
 
int makedir (newdir)
    char *newdir;
{
  char *buffer ;
  char *p;
  int  len = (int)strlen(newdir);
 
  if (len <= 0)
    return 0;
 
  buffer = (char*)malloc(len+1);
  strcpy(buffer,newdir);
 
  if (buffer[len-1] == '/') {
    buffer[len-1] = '\0';
  }
  if (mymkdir(buffer) == 0)
    {
      free(buffer);
      return 1;
    }
 
  p = buffer+1;
  while (1)
    {
      char hold;
 
      while(*p && *p != '\\' && *p != '/')
        p++;
      hold = *p;
      *p = 0;
      if ((mymkdir(buffer) == -1) && (errno == ENOENT))
        {
          printf("couldn't create directory %s\n",buffer);
          free(buffer);
          return 0;
        }
      if (hold == 0)
        break;
      *p++ = hold;
    }
  free(buffer);
  return 1;
}
 
void do_banner()
{
//AS400  printf("MiniUnz 1.01b, demo of zLib + Unz package written by Gilles Vollant\n");
    printf("MiniUnz 1.01e, demo of zLib + Unz package written by Gilles Vollant\n");
    printf("more info at http://www.winimage.com/zLibDll/unzip.html\n\n");
}
 
void do_help()
{
    printf("Usage : miniunz [-e] [-x] [-v] [-l] [-o] [-p password] file.zip [file_to_extr.] [-d extractdir]\n\n" \
           "  -e  Extract without pathname (junk paths)\n" \
           "  -x  Extract with pathname\n" \
           "  -v  list files\n" \
           "  -l  list files\n" \
           "  -d  directory to extract into\n" \
           "  -o  overwrite files without prompting\n" \
           "  -p  extract crypted file using password\n\n");
}
 
 
int do_list(uf)
    unzFile uf;
{
    uLong i;
    unz_global_info gi;
    int err;
 
    err = unzGetGlobalInfo (uf,&gi);
    if (err!=UNZ_OK)
#ifndef FPRINT2SNDMSG
        printf("error %d with zipfile in unzGetGlobalInfo \n",err);
#else
      { sprintf(printtext,"error %d with zipfile in unzGetGlobalInfo\n",err);
        snd_OS400_msg(printtext); }
#endif
#ifdef AS400
    printf("\n");
#endif
    printf(" Length  Method   Size  Ratio   Date    Time   CRC-32     Name\n");
    printf(" ------  ------   ----  -----   ----    ----   ------     ----\n");
    for (i=0;i<gi.number_entry;i++)
    {
        char filename_inzip[256];
#ifdef AS400
        char filename_ebcdic[256];
#endif
        unz_file_info file_info;
        uLong ratio=0;
        const char *string_method;
        char charCrypt=' ';
        err = unzGetCurrentFileInfo(uf,&file_info,filename_inzip,sizeof(filename_inzip),NULL,0,NULL,0);
        if (err!=UNZ_OK)
        {
#ifndef FPRINT2SNDMSG
            printf("error %d with zipfile in unzGetCurrentFileInfo\n",err);
#else
            break;
            sprintf(printtext,"error %d with zipfile in unzGetCurrentFileInfo\n",err);
            snd_OS400_msg(printtext);
#endif
        }
        if (file_info.uncompressed_size>0)
            ratio = (file_info.compressed_size*100)/file_info.uncompressed_size;
 
        /* display a '*' if the file is crypted */
        if ((file_info.flag & 1) != 0)
            charCrypt='*';
 
        if (file_info.compression_method==0)
            string_method="Stored";
        else
        if (file_info.compression_method==Z_DEFLATED)
        {
            uInt iLevel=(uInt)((file_info.flag & 0x6)/2);
            if (iLevel==0)
              string_method="Defl:N";
            else if (iLevel==1)
              string_method="Defl:X";
            else if ((iLevel==2) || (iLevel==3))
              string_method="Defl:F"; /* 2:fast , 3 : extra fast*/
        }
        else
            string_method="Unkn. ";
 
#ifdef AS400
        strcpy(filename_ebcdic, filename_inzip);
        a2e(filename_ebcdic);
#endif
        printf("%7lu  %6s%c%7lu %3lu%%  %2.2lu-%2.2lu-%2.2lu  %2.2lu:%2.2lu  %8.8lx   %s\n",
                file_info.uncompressed_size,string_method,
                charCrypt,
                file_info.compressed_size,
                ratio,
                (uLong)file_info.tmu_date.tm_mon + 1,
                (uLong)file_info.tmu_date.tm_mday,
                (uLong)file_info.tmu_date.tm_year % 100,
                (uLong)file_info.tmu_date.tm_hour,(uLong)file_info.tmu_date.tm_min,
#ifndef AS400
                (uLong)file_info.crc,filename_inzip);
#else
                (uLong)file_info.crc,filename_ebcdic);
#endif
        if ((i+1)<gi.number_entry)
        {
            err = unzGoToNextFile(uf);
            if (err!=UNZ_OK)
            {
#ifndef FPRINT2SNDMSG
                printf("error %d with zipfile in unzGoToNextFile\n",err);
#else
                sprintf(printtext,"error %d with zipfile in unzGoToNextFile\n",err);
                snd_OS400_msg(printtext);
#endif
                break;
            }
        }
    }
 
#ifndef AS400
    return 0;
#else
    printf("\n");
    return err;
#endif
}
 
 
int do_extract_currentfile(uf,popt_extract_without_path,popt_overwrite,password)
    unzFile uf;
    const int* popt_extract_without_path;
    int* popt_overwrite;
    const char* password;
{
    char filename_inzip[256];
    char* filename_withoutpath;
    char* p;
    int err=UNZ_OK;
    FILE *fout=NULL;
    void* buf;
    uInt size_buf;
 
    unz_file_info file_info;
    uLong ratio=0;
    err = unzGetCurrentFileInfo(uf,&file_info,filename_inzip,sizeof(filename_inzip),NULL,0,NULL,0);
 
    if (err!=UNZ_OK)
    {
#ifndef FPRINT2SNDMSG
        printf("error %d with zipfile in unzGetCurrentFileInfo\n",err);
#else
        sprintf(printtext,"error %d with zipfile in unzGetCurrentFileInfo\n",err);
        snd_OS400_msg(printtext);
#endif
        return err;
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
        return UNZ_INTERNALERROR;
    }
 
#ifdef AS400
        a2e(filename_inzip);
#endif
 
    p = filename_withoutpath = filename_inzip;
    while ((*p) != '\0')
    {
        if (((*p)=='/') || ((*p)=='\\'))
            filename_withoutpath = p+1;
        p++;
    }
 
    if ((*filename_withoutpath)=='\0')
    {
        if ((*popt_extract_without_path)==0)
        {
#ifndef FPRINT2SNDMSG
            printf("creating directory: %s\n",filename_inzip);
#else
            sprintf(printtext,"creating directory: %s\n",filename_inzip);
            snd_OS400_msg(printtext);
#endif
            mymkdir(filename_inzip);
        }
    }
    else
    {
        const char* write_filename;
        int skip=0;
 
        if ((*popt_extract_without_path)==0)
            write_filename = filename_inzip;
        else
            write_filename = filename_withoutpath;
 
        err = unzOpenCurrentFilePassword(uf,password);
        if (err!=UNZ_OK)
        {
#ifndef FPRINT2SNDMSG
            printf("error %d with zipfile in unzOpenCurrentFilePassword\n",err);
#else
            sprintf(printtext,"error %d with zipfile in unzOpenCurrentFilePassword\n",err);
            snd_OS400_msg(printtext);
#endif
        }
 
        if (((*popt_overwrite)==0) && (err==UNZ_OK))
        {
            char rep=0;
            FILE* ftestexist;
            ftestexist = fopen(write_filename,"rb");
            if (ftestexist!=NULL)
            {
                fclose(ftestexist);
                do
                {
                    char answer[128];
                    int ret;
 
#ifndef AS400
                    printf("The file %s exists. Overwrite ? [y]es, [n]o, [A]ll: ",write_filename);
#else
                    printf("The file %s exist. Overwrite ? [y]es, [n]o, [A]ll: \n",write_filename);
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
            }
 
            if (rep == 'N')
                skip = 1;
 
            if (rep == 'A')
                *popt_overwrite=1;
        }
 
        if ((skip==0) && (err==UNZ_OK))
        {
            fout=fopen(write_filename,"wb");
 
            /* some zipfile don't contain directory alone before file */
            if ((fout==NULL) && ((*popt_extract_without_path)==0) &&
                                (filename_withoutpath!=(char*)filename_inzip))
            {
                char c=*(filename_withoutpath-1);
                *(filename_withoutpath-1)='\0';
                makedir(write_filename);
                *(filename_withoutpath-1)=c;
                fout=fopen(write_filename,"wb");
            }
 
            if (fout==NULL)
            {
#ifndef FPRINT2SNDMSG
                printf("error opening %s\n",write_filename);
#else
                sprintf(printtext,"error opening %s\n",write_filename);
                snd_OS400_msg(printtext);
#endif
            }
        }
 
        if (fout!=NULL)
        {
#ifndef FPRINT2SNDMSG
            printf(" extracting: %s\n",write_filename);
#else
            sprintf(printtext," extracting: %s\n",write_filename);
            snd_OS400_msg(printtext);
#endif
 
            do
            {
                err = unzReadCurrentFile(uf,buf,size_buf);
                if (err<0)
                {
#ifndef FPRINT2SNDMSG
                    printf("error %d with zipfile in unzReadCurrentFile\n",err);
#else
                    sprintf(printtext,"error %d with zipfile in unzReadCurrentFile\n",err);
                    snd_OS400_msg(printtext);
#endif
                    break;
                }
                if (err>0)
                    if (fwrite(buf,err,1,fout)!=1)
                    {
#ifndef FPRINT2SNDMSG
                        printf("error in writing extracted file\n");
#else
                        sprintf(printtext,"error in writing extracted file\n");
                        snd_OS400_msg(printtext);
#endif
                        err=UNZ_ERRNO;
                        break;
                    }
            }
            while (err>0);
            if (fout)
                    fclose(fout);
 
            if (err==0)
                change_file_date(write_filename,file_info.dosDate,
                                 file_info.tmu_date);
        }
 
        if (err==UNZ_OK)
        {
            err = unzCloseCurrentFile (uf);
            if (err!=UNZ_OK)
            {
#ifndef FPRINT2SNDMSG
                printf("error %d with zipfile in unzCloseCurrentFile\n",err);
#else
                sprintf(printtext,"error %d with zipfile in unzCloseCurrentFile\n",err);
                snd_OS400_msg(printtext);
#endif
            }
        }
        else
            unzCloseCurrentFile(uf); /* don't lose the error */
    }
 
    free(buf);
    return err;
}
 
 
int do_extract(uf,opt_extract_without_path,opt_overwrite,password)
    unzFile uf;
    int opt_extract_without_path;
    int opt_overwrite;
    const char* password;
{
    uLong i;
    unz_global_info gi;
    int err;
    FILE* fout=NULL;
 
    err = unzGetGlobalInfo (uf,&gi);
    if (err!=UNZ_OK)
#ifndef FPRINT2SNDMSG
        printf("error %d with zipfile in unzGetGlobalInfo \n",err);
#else
      { sprintf(printtext,"error %d with zipfile in unzGetGlobalInfo \n",err);
        snd_OS400_msg(printtext); }
#endif
 
    for (i=0;i<gi.number_entry;i++)
    {
#ifndef AS400
        if (do_extract_currentfile(uf,&opt_extract_without_path,
                                      &opt_overwrite,
                                      password) != UNZ_OK)
#else
        err = do_extract_currentfile(uf,&opt_extract_without_path,
                                      &opt_overwrite,
                                      password);
        if (err != UNZ_OK)
#endif
            break;
 
        if ((i+1)<gi.number_entry)
        {
            err = unzGoToNextFile(uf);
            if (err!=UNZ_OK)
            {
#ifndef FPRINT2SNDMSG
                printf("error %d with zipfile in unzGoToNextFile\n",err);
#else
                sprintf(printtext,"error %d with zipfile in unzGoToNextFile\n",err);
                snd_OS400_msg(printtext);
#endif
                break;
            }
        }
    }
 
#ifndef AS400
    return 0;
#else
    return err;
#endif
}
 
int do_extract_onefile(uf,filename,opt_extract_without_path,opt_overwrite,password)
    unzFile uf;
    const char* filename;
    int opt_extract_without_path;
    int opt_overwrite;
    const char* password;
{
#ifdef AS400
    char filename_ascii[MAXFILENAME];
#endif
    int err = UNZ_OK;
    if (unzLocateFile(uf,filename,CASESENSITIVITY)!=UNZ_OK)
    {
#ifndef AS400
        printf("file %s not found in the zipfile\n",filename);
#else  /* Convert EBCDIC to ASCII*/
        strcpy(filename_ascii, filename);
        a2e(filename_ascii);
#endif
#ifndef FPRINT2SNDMSG
        printf("file %s not found in the zipfile\n",filename);
#else  /* Convert EBCDIC to ASCII*/
        sprintf(printtext,"file %s not found in the zipfile\n",filename_ascii);
        snd_OS400_msg(printtext);
#endif
        return 2;
    }
 
    if (do_extract_currentfile(uf,&opt_extract_without_path,
                                      &opt_overwrite,
                                      password) == UNZ_OK)
        return 0;
    else
        return 1;
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
    const char *zipfilename=NULL;
    const char *filename_to_extract=NULL;
    const char *password=NULL;
    char filename_try[MAXFILENAME+16] = "";
    int i;
    int opt_do_list=0;
    int opt_do_extract=1;
    int opt_do_extract_withoutpath=0;
    int opt_overwrite=0;
    int opt_extractdir=0;
    const char *dirname=NULL;
    unzFile uf=NULL;
#ifdef AS400
    int err;
    const char *filename_to_extract_ascii=NULL;
    const char *password_ascii=NULL;
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
                    if ((c=='l') || (c=='L'))
                        opt_do_list = 1;
                    if ((c=='v') || (c=='V'))
                        opt_do_list = 1;
                    if ((c=='x') || (c=='X'))
                        opt_do_extract = 1;
                    if ((c=='e') || (c=='E'))
                        opt_do_extract = opt_do_extract_withoutpath = 1;
                    if ((c=='o') || (c=='O'))
                        opt_overwrite=1;
                    if ((c=='d') || (c=='D'))
                    {
                        opt_extractdir=1;
                        dirname=argv[i+1];
                    }
 
                    if (((c=='p') || (c=='P')) && (i+1<argc))
                    {
                        password=argv[i+1];
#ifdef AS400
                        password_ascii=argv[i+1];
#endif
                        i++;
                    }
                }
            }
            else
            {
                if (zipfilename == NULL)
                    zipfilename = argv[i];
                else if ((filename_to_extract==NULL) && (!opt_extractdir))
                        filename_to_extract = argv[i] ;
#ifdef AS400
                        filename_to_extract_ascii = argv[i] ;
#endif
            }
        }
    }
 
    if (zipfilename!=NULL)
    {
 
#        ifdef USEWIN32IOAPI
        zlib_filefunc_def ffunc;
#        endif
 
        strncpy(filename_try, zipfilename,MAXFILENAME-1);
        /* strncpy doesnt append the trailing NULL, of the string is too long. */
        filename_try[ MAXFILENAME ] = '\0';
 
#        ifdef USEWIN32IOAPI
        fill_win32_filefunc(&ffunc);
        uf = unzOpen2(zipfilename,&ffunc);
#        else
        uf = unzOpen(zipfilename);
#        endif
        if (uf==NULL)
        {
            strcat(filename_try,".zip");
#            ifdef USEWIN32IOAPI
            uf = unzOpen2(filename_try,&ffunc);
#            else
            uf = unzOpen(filename_try);
#            endif
        }
    }
 
    if (uf==NULL)
    {
#ifndef FPRINT2SNDMSG
        printf("Cannot open %s or %s.zip\n",zipfilename,zipfilename);
#else
        sprintf(printtext,"Cannot open %s or %s.zip\n",zipfilename,zipfilename);
        snd_OS400_msg(printtext);
#endif
#ifdef AS400
        sprintf(err_str, "%d", 1);
        err_str2 = strcat("MINIUNZ_RTNCDE=", err_str);
        rc = putenv(err_str2);
#endif
        return 1;
    }
#ifndef FPRINT2SNDMSG
    printf("%s opened\n",filename_try);
#else
    sprintf(printtext,"%s opened\n",filename_try);
    snd_OS400_msg(printtext);
#endif
 
    if (opt_do_list==1)
#ifndef AS400
        return do_list(uf);
#else
      { err = do_list(uf);
        sprintf(err_str, "%d", err);
        err_str2 = strcat("MINIUNZ_RTNCDE=", err_str);
        rc = putenv(err_str2);
        return err; }
#endif
    else if (opt_do_extract==1)
    {
// does not support output dir option for now...
        if (opt_extractdir && chdir(dirname))
        {
          printf("Error changing into %s, aborting\n", dirname);
          exit(-1);
        }
 
#ifndef AS400
        if (filename_to_extract == NULL)
            return do_extract(uf,opt_do_extract_withoutpath,opt_overwrite,password);
        else
            return do_extract_onefile(uf,filename_to_extract,
                                      opt_do_extract_withoutpath,opt_overwrite,password);
#else
        if (password != NULL) e2a(password_ascii);
        if (filename_to_extract == NULL)
            err = do_extract(uf,opt_do_extract_withoutpath,opt_overwrite,password_ascii);
        else {
            e2a(filename_to_extract_ascii);
            err = do_extract_onefile(uf,filename_to_extract_ascii,
                                      opt_do_extract_withoutpath,opt_overwrite,password_ascii);  }
        sprintf(err_str, "%d", err);
        err_str2 = strcat("MINIUNZ_RTNCDE=", err_str);
        rc = putenv(err_str2);
        return err;
#endif
    }
    unzCloseCurrentFile(uf);
 
    return 0;
}
