**free
dcl-pi *n;
  //parameters in CREATE FUNCTION (INPUT)
  INlib  char(10);
  inFile char(10);
  INmbr  char(10);
  //parameters in CREATE FUNCTION (OUTPUT)
  OUTname CHAR(10);
  OUTtype CHAR(10);
  OUTdatcrt Date;
  OUTdatchg Date;
  OUTtext char(50);
  // null values indicators (IN)
  INlib_i  int(5);
  INfile_i int(5);
  INmbr_i  int(5);
  // null values indicators (OUT)
  OUTname_i int(5);
  OUTtype_i int(5);
  OUTdatcrt_i int(5);
  OUTdatchg_i  int(5);
  OUTtext_i int(5);
  // parameters STYLE SQL
  SQLSTATE CHAR(5);
  qual_function varchar(571);
  name_function varchar(128);
  diag_msg varchar(80);
  call_type int(10);
end-pi;
// Create USer Space
dcl-s USRSPC    CHAR(20)  inz('LISTMBR   QTEMP');
dcl-pr QUSCRTUS  EXTPGM('QUSCRTUS');
  USname  CHAR(20)   CONST;
  USattribut CHAR(50) CONST;
  USsize   INt(10) CONST;
  UScontenu CHAR(1) CONST;
  USaut  CHAR(10)  CONST;
  UStext CHAR(50)   CONST;
  USreplace CHAR(10)  CONST;
  USerrcode  likeds(errcodeDS);
end-pr;
// Delete USer Space
dcl-pr QUSDLTUS  EXTPGM('QUSDLTUS');
  USname  CHAR(20)   CONST;
  USerrcode  likeds(errcodeDS);
end-pr;
// Retreive Pointer
dcl-pr QUSPTRUS  EXTPGM('QUSPTRUS');
  USname  CHAR(20)   CONST;
  ptr Pointer;
END-PR;

// API members list
dcl-pr QUSLMBR  EXTPGM('QUSLMBR');
  USname  CHAR(20)   CONST;
  Format    CHAR(8) CONST;
  ficlib  CHAR(20) CONST;
  Member  CHAR(10) CONST;
  OVRDBF  ind  CONST;
end-pr;

// various fields
Dcl-s ptr  Pointer;
dcl-s i Int(10);
// header
dcl-s ptrinfos  Pointer;
dcl-ds RTVINF  based(ptrinfos);
  offset  int(10);
  size   int(10);
  elem_count int(10);
  elem_len int(10);
end-ds;

// list
dcl-s ptrlist Pointer;
Dcl-ds member based(ptrlist) qualified;
  name CHAR(10);
  type CHAR(10);
  DatCrt CHAR(7);
  TimCrt  CHAR(6);
  DatChg  CHAR(7);
  TimChg CHAR(6);
  text CHAR(50);
End-DS;
Dcl-ds errcodeDS  qualified;
  sizeDS   INt(10) inz(%size(errcodeDS));
  sizeneeded Int(10);
  msgID CHAr(7);
  reserved CHAR(1);
  errdta  CHar(50);
End-ds;

// main code
if call_type < 0 ;
  // fisrt call
  SQLSTATE = '00000'  ;
  // create list
  QUSCRTUS(usrspc: *Blanks: 1024: x'00': '*USE':
           'Liste des membres': '*YES' : errcodeDS);
  Monitor;
    QUSLMBR(usrspc: 'MBRL0200': INfile + INlib
            : INmbr: *ON);
  on-error;
    SQLSTATE = '38I00';
    diag_msg = 'unable to generate list';
    return;
  endmon;
  // retreive pointeur
  QUSPTRUS(usrspc : ptr);
  ptrinfos = ptr + 124;

  // first element
  ptrlist = ptr + offset;
  return;
  elseif    call_type = 0 ;
i+=1;
  if i<=elem_count;
  //  "normal" call , return One member
    OUTname = member.name;
    OUTtype = member.type;
    Monitor;
    OUTdatcrt = %date(member.datcrt : *CYMD0);
      on-error *all;
    OUTdatcrt_i = -1;
      Endmon;
    Monitor;
    OUTdatchg = %date(member.datchg : *CYMD0);
      on-error *all;
    OUTdatchg_i = -1;
      Endmon;
    OUTtext = member.text;

    if i<elem_count;
      //next element
      ptrlist = ptrlist + elem_len;
    endif;
    else;
  // End OF List
    SQLSTATE = '02000';
    *INLR = *on;
  endif;
  return;
  else;
// final call, cleanup
  QUSDLTUS(usrspc: errcodeDS) ;
  *inlr = *on;
endif;