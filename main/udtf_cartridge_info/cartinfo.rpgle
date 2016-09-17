**free
/if not defined( Copying_prototypes )
//---------------------------------------------------------------/
//                                                               /
//  Brief description of collection of procedures.               /
//                                                               /
//  Procedures:                                                  /
//                                                               /
//  Cartidge_Info         - return info about tape cartridges.   /
//                                                               /
//  Compilation:                                                 /
//                                                               /
//*>  CRTRPGMOD MODULE(&O/&FNR) SRCSTMF('&FP')                 <*/
//*>  CRTSRVPGM SRVPGM(&O/&FNR) EXPORT(*ALL)                 - <*/
//*>              TEXT('Cartridge_Info')                       <*/
//                                                               /
//---------------------------------------------------------------/
//  2016-08-19 : Christian Jorgensen                             /
//               Create module.                                  /
//---------------------------------------------------------------/

ctl-opt debug;
ctl-opt option( *Srcstmt : *NoDebugIO );
ctl-opt thread( *serialize );

ctl-opt nomain;

//----------------------------------------------------------------
// Exported procedures:

/endif

/if not defined( CARTINFO_prototype_copied )

// Procedure:    Cartridge_Info
// Description:  Return information about tape cartridges.

dcl-pr Cartridge_Info extproc( *dclcase );
  // Incoming parameters
  p_TapMlb                                               varchar( 10 ) const;
  p_CartID                                               varchar(  6 ) const;
  p_CatName                                              varchar( 10 ) const;
  p_CatSys                                               varchar(  8 ) const;
  // Returned parameters
  p_Cartridge_ID                                         varchar(  6 );
  p_Volume_ID                                            varchar( 10 );
  p_Tape_library_name                                    varchar( 10 );
  p_Category                                             varchar( 10 );
  p_Category_system                                      varchar(  8 );
  p_Density                                              varchar( 10 );
  p_Changed_timestamp                                    timestamp;
  p_Referenced_timestamp                                 timestamp;
  p_Location                                             varchar( 10 );
  p_Location_indicator                                   varchar( 32 );
  p_Volume_status                                        varchar( 32 );
  p_Owner_ID                                             varchar( 32 );
  p_Write_protected                                      varchar( 32 );
  p_Encoding                                             varchar( 32 );
  p_Cartridge_ID_source                                  varchar( 32 );
  p_In_Import_Export_slot                                varchar( 32 );
  p_Media_type                                           varchar( 32 );
  // Null indicators for incoming parameters
  n_TapMlb                                               int( 5 ) const;
  n_CartID                                               int( 5 ) const;
  n_CatName                                              int( 5 ) const;
  n_CatSys                                               int( 5 ) const;
  // Null indicators for returned parameters
  n_Cartridge_ID                                         int( 5 );
  n_Volume_ID                                            int( 5 );
  n_Tape_library_name                                    int( 5 );
  n_Category                                             int( 5 );
  n_Category_system                                      int( 5 );
  n_Density                                              int( 5 );
  n_Changed_timestamp                                    int( 5 );
  n_Referenced_timestamp                                 int( 5 );
  n_Location                                             int( 5 );
  n_Location_indicator                                   int( 5 );
  n_Volume_status                                        int( 5 );
  n_Owner_ID                                             int( 5 );
  n_Write_protected                                      int( 5 );
  n_Encoding                                             int( 5 );
  n_Cartridge_ID_source                                  int( 5 );
  n_In_Import_Export_slot                                int( 5 );
  n_Media_type                                           int( 5 );

  // SQL parameters.
  Sql_State   char( 5 );
  Function    varchar( 517 ) const;
  Specific    varchar( 128 ) const;
  MsgText     varchar( 70 );
  CallType    int( 5 )       const;
end-pr;

//----------------------------------------------------------------
// Exported data:

/define CARTINFO_prototype_copied
/if defined( Copying_prototypes )
/eof

/endif
/endif

//----------------------------------------------------------------
// Constants:

dcl-c CALL_STARTUP    -2;
dcl-c CALL_OPEN       -1;
dcl-c CALL_FETCH       0;
dcl-c CALL_CLOSE       1;
dcl-c CALL_FINAL       2;

dcl-c PARM_NULL       -1;
dcl-c PARM_NOTNULL     0;

dcl-c CCSID_UTF16   1200;
dcl-c IMGCATLIB     'QUSRSYS   ';

//----------------------------------------------------------------
// Data types:

dcl-ds RCTG0100_t template qualified;
  Bytes_returned                                   int( 10 );
  Bytes_available                                  int( 10 );
  Offset_to_cartridge_information                  int( 10 );
  Number_of_cartridge_information_entries          int( 10 );
  Length_of_cartridge_information_entry            int( 10 );
end-ds;

dcl-ds Cartridge_entry_t template qualified;
  Cartridge_ID                                     char(  6 );
  Volume_ID                                        char(  6 );
  Tape_library_name                                char( 10 );
  Category                                         char( 10 );
  Category_system                                  char(  8 );
  Density                                          char( 10 );
  Change_date                                      char(  7 );
  Change_time                                      char(  6 );
  Reference_date                                   char(  7 );
  Reference_time                                   char(  6 );
  Location                                         char( 10 );
  Location_indicator                               char(  1 );
  Volume_status                                    char(  2 );
  Owner_ID                                         char( 17 );
  Write_protection                                 char(  1 );
  Code                                             char(  1 );
  Cartridge_ID_source                              char(  1 );
  Import_Export_slot                               char(  1 );
  Media_type                                       char(  2 );
end-ds;

//----------------------------------------------------------------
// Global data:

// API error data structure:

dcl-ds ApiError;
  AeBytPrv  int( 10 )   inz( %size( ApiError ) );
  AeBytAvl  int( 10 );
  AeExcpId  char( 7 );
  *n        char( 1 );
  AeExcpDta char( 128 );
end-ds;

//----------------------------------------------------------------
// Prototypes:

/define Copying_prototypes
/undefine Copying_prototypes

//----------------------------------------------------------------
// Procedure:    Cartridge_Info
// Description:  Return information about image catalog,

dcl-proc Cartridge_Info export;

  dcl-pi *n;
    // Incoming parameters
    p_TapMlb                                               varchar( 10 ) const;
    p_CartID                                               varchar(  6 ) const;
    p_CatName                                              varchar( 10 ) const;
    p_CatSys                                               varchar(  8 ) const;
    // Returned parameters
    p_Cartridge_ID                                         varchar(  6 );
    p_Volume_ID                                            varchar( 10 );
    p_Tape_library_name                                    varchar( 10 );
    p_Category                                             varchar( 10 );
    p_Category_system                                      varchar(  8 );
    p_Density                                              varchar( 10 );
    p_Changed_timestamp                                    timestamp;
    p_Referenced_timestamp                                 timestamp;
    p_Location                                             varchar( 10 );
    p_Location_indicator                                   varchar( 32 );
    p_Volume_status                                        varchar( 32 );
    p_Owner_ID                                             varchar( 32 );
    p_Write_protected                                      varchar( 32 );
    p_Encoding                                             varchar( 32 );
    p_Cartridge_ID_source                                  varchar( 32 );
    p_In_Import_Export_slot                                varchar( 32 );
    p_Media_type                                           varchar( 32 );
    // Null indicators for incoming parameters
    n_TapMlb                                               int( 5 ) const;
    n_CartID                                               int( 5 ) const;
    n_CatName                                              int( 5 ) const;
    n_CatSys                                               int( 5 ) const;
    // Null indicators for returned parameters
    n_Cartridge_ID                                         int( 5 );
    n_Volume_ID                                            int( 5 );
    n_Tape_library_name                                    int( 5 );
    n_Category                                             int( 5 );
    n_Category_system                                      int( 5 );
    n_Density                                              int( 5 );
    n_Changed_timestamp                                    int( 5 );
    n_Referenced_timestamp                                 int( 5 );
    n_Location                                             int( 5 );
    n_Location_indicator                                   int( 5 );
    n_Volume_status                                        int( 5 );
    n_Owner_ID                                             int( 5 );
    n_Write_protected                                      int( 5 );
    n_Encoding                                             int( 5 );
    n_Cartridge_ID_source                                  int( 5 );
    n_In_Import_Export_slot                                int( 5 );
    n_Media_type                                           int( 5 );

    // SQL parameters.
    Sql_State   char( 5 );
    Function    varchar( 517 ) const;
    Specific    varchar( 128 ) const;
    MsgText     varchar( 70 );
    CallType    int( 5 )       const;
  end-pi;

  dcl-pr QTARCTGI extpgm( 'QTARCTGI' );
    *n likeds( RCTG0100_t );
    *n int( 10 )    const;
    *n char( 8 )    const;
    *n char( 10 )   const;
    *n char( 6 )    const;
    *n char( 18 )   const;
    *n char( 1024 ) const options( *varsize );
  end-pr;

  dcl-s  LoTapMlb         char( 10 );
  dcl-s  LoCartID         char(  6 );
  dcl-s  LoCatName        char( 10 );
  dcl-s  LoCatSys         char(  8 );
  dcl-s  SaveCallType     like( CallType  ) static;  // Save CallType from previous call...
  dcl-s  SaveLoTapMlb     like( LoTapMlb  ) static;  // Save tape library from previous call...
  dcl-s  SaveLoCartID     like( LoCartID  ) static;  // Save cartridge ID from previous call...
  dcl-s  SaveLoCatName    like( LoCatName ) static;  // Save category name from previous call...
  dcl-s  SaveLoCatSys     like( LoCatSys  ) static;  // Save category system from previous call...

  dcl-ds CartInfoHdr      likeds( RCTG0100_t ) based( ptrCartInfoHdr );
  dcl-s  ptrCartInfoHdr   pointer static;
  dcl-ds CartInfoDtl      likeds( Cartridge_entry_t ) based( ptrCartInfoDtl );
  dcl-s  ptrCartInfoDtl   pointer static;

  dcl-s  CurEntry         like( RCTG0100_t.Number_of_cartridge_information_entries ) static;

  dcl-s  Buffer_size         int( 10 );

  // Start all fields at not NULL.

  n_Cartridge_ID                                         = PARM_NOTNULL;
  n_Volume_ID                                            = PARM_NOTNULL;
  n_Tape_library_name                                    = PARM_NOTNULL;
  n_Category                                             = PARM_NOTNULL;
  n_Category_system                                      = PARM_NOTNULL;
  n_Density                                              = PARM_NOTNULL;
  n_Changed_timestamp                                    = PARM_NOTNULL;
  n_Referenced_timestamp                                 = PARM_NOTNULL;
  n_Location                                             = PARM_NOTNULL;
  n_Location_indicator                                   = PARM_NOTNULL;
  n_Volume_status                                        = PARM_NOTNULL;
  n_Owner_ID                                             = PARM_NOTNULL;
  n_Write_protected                                      = PARM_NOTNULL;
  n_Encoding                                             = PARM_NOTNULL;
  n_Cartridge_ID_source                                  = PARM_NOTNULL;
  n_In_Import_Export_slot                                = PARM_NOTNULL;
  n_Media_type                                           = PARM_NOTNULL;

  //  Open, fetch & close...

  select;
    when  CallType = CALL_OPEN;

      // Verify that tape library device was specified.

      if ( n_TapMlb = PARM_NULL ) or
         ( p_TapMlb = '' );
          SQL_State = '38999';
          MsgText = 'Tape library device must be specified';
          return;
      else;
        LoTapMlb= p_TapMlb;
      endif;

      // Verify that cartridge ID was specified.

      if ( n_CartID = PARM_NULL ) or
         ( p_CartID = '' );
          SQL_State = '38999';
          MsgText = 'Cartridge ID must be specified';
          return;
      else;
        LoCartID = p_CartID;
      endif;

      // Verify that category name was specified.

      if ( n_CatName = PARM_NULL ) or
         ( p_CatName = '' );
          SQL_State = '38999';
          MsgText = 'Category name must be specified';
          return;
      else;
        LoCatName = p_CatName;
      endif;

      // Verify that category system was specified.
      // If category name is *SHARE400, *INSERT or *EJECT, ignore system.

      if ( %scan( p_CatName : '*SHARE400,*INSERT,*EJECT' ) = 0 );
        if ( n_CatSys = PARM_NULL ) or
           ( p_CatSys = '' );
            SQL_State = '38999';
            MsgText = 'Category system must be specified';
            return;
        else;
          LoCatSys = p_CatSys;
        endif;
      else;
        clear LoCatSys;
      endif;

      // Get cartidge basic info.

      ptrCartInfoHdr = %alloc( %size( CartInfoHdr ) );
      ptrCartInfoDtl = *null;
      QTARCTGI( CartInfoHdr
              : %size( CartInfoHdr )
              : 'RCTG0100'
              : LoTapMlb
              : LoCartID
              : LoCatName + LoCatSys
              : ApiError
              );

      if ( AeBytAvl > 0 );
        if ( AeExcpID = 'CPF67D2' ); // CPF67D2 returns EOF...
          SQL_State = '02000';
          dealloc ptrCartInfoHdr;
          return;
        else;
          SQL_State = '38999';
          MsgText = 'Error ' + AeExcpID + ', please check joblog.';
          return;
        endif;
      endif;

      // Expand buffer and get cartridge entries.

      Buffer_size = CartInfoHdr.Bytes_Available + ( CartInfoHdr.Number_of_cartridge_information_entries * CartInfoHdr.Length_of_cartridge_information_entry );
      ptrCartInfoHdr = %realloc( ptrCartInfoHdr : Buffer_size );
      QTARCTGI( CartInfoHdr
              : Buffer_size
              : 'RCTG0100'
              : LoTapMlb
              : LoCartID
              : LoCatName + LoCatSys
              : ApiError
              );
      if ( AeBytAvl > 0 );
        SQL_State = '38999';
        MsgText = 'Error ' + AeExcpID + ', please check joblog.';
        return;
      endif;

      ptrCartInfoDtl = ptrCartInfoHdr + CartInfoHdr.Offset_to_cartridge_information;

      // Reset current entry before fetching.

      CurEntry = 0;

    when  CallType = CALL_FETCH;

      // If previous call was for fetch and no more entries, return EOF.

      if ( CallType  = SaveCallType  ) and
         ( LoTapMlb  = SaveLoTapMlb  ) and
         ( LoCartID  = SaveLoCartID  ) and
         ( LoCatName = SaveLoCatName ) and
         ( LoCatSys  = SaveLoCatSys  ) and
         ( CurEntry  = CartInfoHdr.Number_of_cartridge_information_entries );
        SQL_State = '02000';
        return;
      endif;

      // If there are cartridge entries, get next entry.

      if ( CartInfoHdr.Number_of_cartridge_information_entries > 0 );
        CurEntry += 1;
        ptrCartInfoDtl = ptrCartInfoHdr + CartInfoHdr.Offset_to_cartridge_information
                                        + ( CartInfoHdr.Length_of_cartridge_information_entry * ( CurEntry - 1 ) );


        // Copy cartridge entry data to parameters.

        p_Cartridge_ID                             = %trimr( CartInfoDtl.Cartridge_ID        );

        select;
          when ( CartInfoDtl.Volume_ID = '*NL' );
            p_Volume_ID = 'NON-LABELED';
          when ( CartInfoDtl.Volume_ID = '' );
            p_Volume_ID = 'UNKNOWN';
          other;
            p_Volume_ID                            = %trimr( CartInfoDtl.Volume_ID           );
        endsl;

        p_Tape_library_name                        = %trimr( CartInfoDtl.Tape_library_name   );
        p_Category                                 = %trimr( CartInfoDtl.Category            );
        p_Category_system                          = %trimr( CartInfoDtl.Category_system     );
        p_Density                                  = %trimr( CartInfoDtl.Density             );
        p_Changed_timestamp                        = CvtToTimestamp( CartInfoDtl.Change_date : CartInfoDtl.Change_time );
        p_Referenced_timestamp                     = CvtToTimestamp( CartInfoDtl.Reference_date : CartInfoDtl.Reference_time );
        p_Location                                 = %triml( %trimr( CartInfoDtl.Location ) : '0' );

        select;
          when ( CartInfoDtl.Location_indicator = '0' );
            p_Location_indicator = 'DRIVE';
          when ( CartInfoDtl.Location_indicator = '1' );
            p_Location_indicator = 'SLOT';
        endsl;

        select;
          when ( CartInfoDtl.Volume_status = '01' );
            p_Volume_status = 'AVAILABLE';
          when ( CartInfoDtl.Volume_status = '02' );
            p_Volume_status = 'MOUNTED';
          when ( CartInfoDtl.Volume_status = '03' );
            p_Volume_status = 'NOT_AVAILABLE';
          when ( CartInfoDtl.Volume_status = '04' );
            p_Volume_status = 'EJECTED';
          when ( CartInfoDtl.Volume_status = '05' );
            p_Volume_status = 'ERROR_STATE';
          when ( CartInfoDtl.Volume_status = '06' );
            p_Volume_status = 'INSERTED';
          when ( CartInfoDtl.Volume_status = '07' );
            p_Volume_status = 'DUPLICATE_ID';
        endsl;


        select;
          when ( CartInfoDtl.Owner_ID = '*NL' );
            p_Owner_ID = 'NON-LABELED';
          when ( CartInfoDtl.Owner_ID = '*BLANK' );
            p_Owner_ID = 'BLANK';
          when ( CartInfoDtl.Owner_ID = '' );
            p_Owner_ID = 'UNKNOWN';
          other;
            p_Owner_ID                             = %trimr( CartInfoDtl.Owner_ID            );
        endsl;

        select;
          when ( CartInfoDtl.Write_protection = '0' );
            p_Write_protected = 'NO';
          when ( CartInfoDtl.Write_protection = '1' );
            p_Write_protected = 'YES';
          other;
            p_Write_protected = 'UNKNOWN';
        endsl;

        select;
          when ( CartInfoDtl.Code = '0' );
            p_Encoding = 'ASCII';
          when ( CartInfoDtl.Code = '1' );
            p_Encoding = 'EBCDIC';
          other;
            p_Encoding = 'UNKNOWN';
        endsl;

        select;
          when ( CartInfoDtl.Cartridge_ID_source = '0' );
            p_Cartridge_ID_source = 'VOLUME_ID';
          when ( CartInfoDtl.Cartridge_ID_source = '1' );
            p_Cartridge_ID_source = 'SYSTEM';
          when ( CartInfoDtl.Cartridge_ID_source = '2' );
            p_Cartridge_ID_source = 'BARCODE';
        endsl;

        select;
          when ( CartInfoDtl.Import_Export_slot = '0' );
            p_In_Import_Export_slot = 'NO';
          when ( CartInfoDtl.Import_Export_slot = '1' );
            p_In_Import_Export_slot = 'YES';
        endsl;

        p_Media_type                               = %trimr( CartInfoDtl.Media_type          );
      endif;

    when  CallType = CALL_CLOSE;
      if ( ptrCartInfoHdr <> *null );
        dealloc ptrCartInfoHdr;
      endif;

  endsl;

  SaveCallType  = CallType;
  SaveLoCartID  = LoCartID;
  SaveLoCatName = LoCatName;
  SaveLoCatSys  = LoCatSys;

  return;

end-proc;

//----------------------------------------------------------------
// Procedure:    CvtToTimestamp
// Description:  Convert date and time to ISO timestamp.

dcl-proc CvtToTimestamp;

  dcl-pi *n timestamp;
    date    like( Cartridge_entry_t.Change_date );
    time    like( Cartridge_entry_t.Change_time );
  end-pi;

  if ( date <> *blanks ) and
     ( time <> *blanks );
    return ( %date( date : *CYMD0 ) + %time( time : *HMS0 ) );
  else;
    return ( d'0001-01-01' + t'00.00.00' );
  endif;

end-proc;
