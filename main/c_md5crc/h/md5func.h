#ifndef md5func_h
   #define md5func_h
        #include <H/MD5>                    // Hash Create

        int Crt_Q_Mbr_Name(Mbr_Dets_t *, char *);
        int Cvt_Hex_Buf(char *, char *, int);
        int Crt_Usr_Spc(char *, int);
        int Calc_Hash_Val(char *, char *, int, Qc3_Format_ALGD0100_T);
        int Get_Src_Rec_Len(Mbr_Dets_t *);
        #endif
