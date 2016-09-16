**free
//****************************************************
// This is a demo of Python calling RPG
//****************************************************

 ctl-opt AlwNull(*UsrCtl) DftActGrp(*NO);

//****************************************************
// Native I/O files
//****************************************************
 dcl-f XPRODCAT DISK Rename(PRODUCTS :XPRODC_t) Keyed;

//****************************************************
// Global data
//****************************************************
 dcl-c ARRAYMAX      999;
 dcl-ds prod_t qualified based(Template);
   prod  int(10);
   cat   int(10);
   title varchar(64);
   photo varchar(64);
   price packed(12:2);
 end-ds;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// main Control flow
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dcl-pi *n;
     myCat                  Int(10: 0);
     myMax                  Int(10: 0);
     myCount                Int(10: 0);
     findMe                 likeds(prod_t) dim(ARRAYMAX);
 end-pi;

 // Mainline
        if myCat > 9;
          product_all(myMax:myCount:findMe);
        else;
          product_search_cat(MyCat:myMax:myCount:findMe);
        endif;
        return; // *inlr = *on;


//****************************************************
//  product_all:
//    Routine to load the search items on disk.
//****************************************************
 dcl-proc product_all;
     dcl-pi product_all;
       Max               Int(10: 0);
       Count             Int(10: 0);
       Item              likeds(prod_t) dim(ARRAYMAX);
     end-pi;
// vars
     dcl-s cat           Int(10: 0)  inz(0);
     dcl-ds PRODFILE1    likerec(XPRODC_t:*INPUT);

          Count = 0;
          setll (cat) XPRODCAT;
          read XPRODCAT PRODFILE1;
          dow not %eof(XPRODCAT);
            if Count = Max;
              leave;
            endif;
            Count += 1;
            Item(Count).PROD     = PRODFILE1.PROD;
            Item(Count).CAT      = PRODFILE1.CAT;
            Item(Count).TITLE    = PRODFILE1.TITLE;
            Item(Count).PHOTO    = PRODFILE1.PHOTO;
            Item(Count).PRICE    = PRODFILE1.PRICE;
            read XPRODCAT PRODFILE1;
          enddo;
 end-proc;

//****************************************************
//  product_search_cat:
//    Routine to load the search items on disk.
//****************************************************
 dcl-proc product_search_cat;
     dcl-pi product_search_cat;
       cat               Int(10: 0) const;
       Max               Int(10: 0);
       Count             Int(10: 0);
       Item              likeds(prod_t) dim(ARRAYMAX);
     end-pi;
// vars
     dcl-ds PRODFILE1    likerec(XPRODC_t:*INPUT);

          Count = 0;
          setll (cat) XPRODCAT;
          reade (cat) XPRODCAT PRODFILE1;
          dow not %eof(XPRODCAT);
            if Count = Max;
              leave;
            endif;
            Count += 1;
            Item(Count).PROD     = PRODFILE1.PROD;
            Item(Count).CAT      = PRODFILE1.CAT;
            Item(Count).TITLE    = PRODFILE1.TITLE;
            Item(Count).PHOTO    = PRODFILE1.PHOTO;
            Item(Count).PRICE    = PRODFILE1.PRICE;
            reade (cat) XPRODCAT PRODFILE1;
          enddo;
 end-proc;