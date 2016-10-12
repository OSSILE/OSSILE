**FREE

Ctl-Opt DftActGrp(*No);

Dcl-S gURL  Varchar(128);
Dcl-S gFile SQLTYPE(BLOB_FILE);

//Use this to download a file to the IFS.

gURL       = 'https://website.com/your.zip';
gFile_Name = '/home/LIAMALLAN/zipfile.zip';
gFile_NL   = %Len(%TrimR(gFile_Name));
gFile_FO   = SQFOVR;

Exec SQL
  SELECT SYSTOOLS.HTTPGETBLOB(:gURL, '')
  INTO :gFile
  FROM SYSIBM.SYSDUMMY1;

*InLR = *On;
Return; 
