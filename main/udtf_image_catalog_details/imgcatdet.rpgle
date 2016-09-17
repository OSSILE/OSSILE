**free
/if not defined( Copying_prototypes )
//---------------------------------------------------------------/
//                                                               /
//  Brief description of collection of procedures.               /
//                                                               /
//  Procedures:                                                  /
//                                                               /
//  Image_Catalog_Details - return info about image catalog.     /
//                                                               /
//  Compilation:                                                 /
//                                                               /
//*>  CRTRPGMOD MODULE(&O/&FNR) SRCSTMF('&FP')                 <*/
//*>  CRTSRVPGM SRVPGM(&O/&FNR) EXPORT(*ALL)                 - <*/
//*>              TEXT('Image_Catalog_Details')                <*/
//                                                               /
//---------------------------------------------------------------/
//  2016-08-10 : Christian Jorgensen                             /
//               Create module.                                  /
//---------------------------------------------------------------/

ctl-opt debug;
ctl-opt option( *Srcstmt : *NoDebugIO );
ctl-opt thread( *serialize );

ctl-opt nomain;

//----------------------------------------------------------------
// Exported procedures:

/endif

/if not defined( IMGCATDET_prototype_copied )

// Procedure:    Image_Catalog_Details
// Description:  Return information about image catalog,

dcl-pr Image_Catalog_Details extproc( *dclcase );
  // Incoming parameters
  p_ImgCat      varchar( 10 ) const;
  // Returned parameters
  p_Image_catalog_type                                   varchar( 32 );
  p_Image_catalog_status                                 varchar( 32 );
  p_Reference_image_catalog_indicator                    varchar( 32 );
  p_Dependent_image_catalog_indicator                    varchar( 32 );
  p_Image_catalog_text                                   varchar( 50 );
  p_Virtual_device_name                                  char( 10 );
  p_Number_of_image_catalog_directories                  int( 10 );
  p_Number_of_image_catalog_entries                      int( 10 );
  p_Reference_image_catalog_name                         char( 10 );
  p_Reference_image_catalog_library_name                 char( 10 );
  p_Next_tape_volume                                     varchar(   6 );
  p_Image_catalog_mode                                   varchar(  32 );
  p_Image_catalog_directory                              varchar( 256 );
  // Common entry data:
  p_Image_catalog_entry_index                            int( 10 );
  p_Image_catalog_entry_status                           varchar(  32 );
  p_Image_catalog_entry_text                             varchar(  50 );
  p_Image_file_name                                      varchar( 256 );
  p_Write_protect_status                                 varchar(  32 );
  // Special for optical entries:
  p_Opt_Volume_name                                      varchar(  32 );
  p_Opt_Access_information                               varchar(  32 );
  p_Opt_Media_type                                       varchar(  32 );
  p_Opt_Image_size                                       int( 10 );
  // Special for tape entries:
  p_Tap_Volume_name                                      varchar( 6 );
  p_Tap_Maximum_volume_size                              uns( 10 );
  p_Tap_Current_number_of_bytes_available                uns( 20 );
  p_Tap_Current_number_of_bytes_used_by_volume           uns( 20 );
  p_Tap_Percent_used                                     packed( 10 : 1 );
  p_Tap_First_file_sequence_number_in_the_virtual_volume uns( 10 );
  p_Tap_Last_file_sequence_number_in_the_virtual_volume  uns( 10 );
  p_Tap_Next_volume_indicator                            char( 1 );
  p_Tap_Density                                          varchar( 10 );
  p_Tap_Type_of_volume                                   varchar( 32 );
  p_Tap_Allocated_volume_size                            uns( 10 );
  // Null indicators for incoming parameters
  n_ImgCat                                               int( 5 ) const;
  // Null indicators for returned parameters
  n_Image_catalog_type                                   int( 5 );
  n_Image_catalog_status                                 int( 5 );
  n_Reference_image_catalog_indicator                    int( 5 );
  n_Dependent_image_catalog_indicator                    int( 5 );
  n_Image_catalog_text                                   int( 5 );
  n_Virtual_device_name                                  int( 5 );
  n_Number_of_image_catalog_directories                  int( 5 );
  n_Number_of_image_catalog_entries                      int( 5 );
  n_Reference_image_catalog_name                         int( 5 );
  n_Reference_image_catalog_library_name                 int( 5 );
  n_Next_tape_volume                                     int( 5 );
  n_Image_catalog_mode                                   int( 5 );
  n_Image_catalog_directory                              int( 5 );
  // Common entry data:
  n_Image_catalog_entry_index                            int( 5 );
  n_Image_catalog_entry_status                           int( 5 );
  n_Image_catalog_entry_text                             int( 5 );
  n_Image_file_name                                      int( 5 );
  n_Write_protect_status                                 int( 5 );
  // Special for optical entries:
  n_Opt_Volume_name                                      int( 5 );
  n_Opt_Access_information                               int( 5 );
  n_Opt_Media_type                                       int( 5 );
  n_Opt_Image_size                                       int( 5 );
  // Special for tape entries:
  n_Tap_Volume_name                                      int( 5 );
  n_Tap_Maximum_volume_size                              int( 5 );
  n_Tap_Current_number_of_bytes_available                int( 5 );
  n_Tap_Current_number_of_bytes_used_by_volume           int( 5 );
  n_Tap_Percent_used                                     int( 5 );
  n_Tap_First_file_sequence_number_in_the_virtual_volume int( 5 );
  n_Tap_Last_file_sequence_number_in_the_virtual_volume  int( 5 );
  n_Tap_Next_volume_indicator                            int( 5 );
  n_Tap_Density                                          int( 5 );
  n_Tap_Type_of_volume                                   int( 5 );
  n_Tap_Allocated_volume_size                            int( 5 );

  // SQL parameters.
  Sql_State   char( 5 );
  Function    varchar( 517 ) const;
  Specific    varchar( 128 ) const;
  MsgText     varchar( 70 );
  CallType    int( 5 )       const;
end-pr;

//----------------------------------------------------------------
// Exported data:

/define IMGCATDET_prototype_copied
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

dcl-ds RCLD0100_t template qualified;
  Bytes_returned                                   int( 10 );
  Bytes_available                                  int( 10 );
  Image_catalog_type                               char( 1 );
  Image_catalog_status                             char( 1 );
  Reference_image_catalog_indicator                char( 1 );
  Dependent_image_catalog_indicator                char( 1 );
  Image_catalog_text                               char( 50 );
  Virtual_device_name                              char( 10 );
  Offset_to_image_catalog_directory                int( 10 );
  Number_of_image_catalog_directories              int( 10 );
  Length_of_image_catalog_directory                int( 10 );
  CCSID_of_image_catalog_directory                 int( 10 );
  Offset_to_first_image_catalog_entry              int( 10 );
  Number_of_image_catalog_entries_returned         int( 10 );
  Length_of_image_catalog_entry                    int( 10 );
  Number_of_image_catalog_entries                  int( 10 );
  Reference_image_catalog_name                     char( 10 );
  Reference_image_catalog_library_name             char( 10 );
  Next_tape_volume                                 char( 6 );
  Image_catalog_mode                               char( 1 );
  Image_catalog_directory                          char( 1024 );
end-ds;

dcl-ds RCLD0200_entry_t template qualified;
  Image_catalog_entry_index                        int( 10 );
  Image_catalog_entry_status                       char( 1 );
  Image_catalog_entry_text                         ucs2( 50 ) ccsid( 1200 );
  Write_protect_status                             char( 1 );
  Volume_name                                      char( 32 );
  Access_information                               char( 1 );
  Media_type                                       char( 1 );
  Image_size                                       int( 10 );
  Image_file_name_len                              int( 10 );
  Image_file_name                                  ucs2( 256 ) ccsid( 1200 );
end-ds;

dcl-ds RCLD0300_entry_t template qualified;
  Image_catalog_entry_index                        int( 10 );
  Image_catalog_entry_status                       char( 1 );
  Image_catalog_entry_text                         ucs2( 50 ) ccsid( 1200 );
  Write_protect_status                             char( 1 );
  Volume_name                                      char( 6 );
  Maximum_volume_size                              uns( 10 );
  Current_number_of_bytes_available                uns( 20 );
  Current_number_of_bytes_used_by_volume           uns( 20 );
  Percent_used                                     uns( 10 );
  First_file_sequence_number_in_the_virtual_volume uns( 10 );
  Last_file_sequence_number_in_the_virtual_volume  uns( 10 );
  Next_volume_indicator                            char( 1 );
  Density                                          char( 10 );
  Type_of_volume                                   char( 1 );
  Image_file_name_len                              int( 10 );
  Image_file_name                                  ucs2( 256 ) ccsid( 1200 );
  Allocated_volume_size                            uns( 10 );
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

/copy iconv_h.rpgle

/undefine Copying_prototypes

//----------------------------------------------------------------
// Procedure:    Image_Catalog_Details
// Description:  Return information about image catalog,

dcl-proc Image_Catalog_Details export;

  dcl-pi *n;
    // Incoming parameters
    p_ImgCat      varchar( 10 ) const;
    // Returned parameters
    p_Image_catalog_type                                   varchar( 32 );
    p_Image_catalog_status                                 varchar( 32 );
    p_Reference_image_catalog_indicator                    varchar( 32 );
    p_Dependent_image_catalog_indicator                    varchar( 32 );
    p_Image_catalog_text                                   varchar( 50 );
    p_Virtual_device_name                                  char( 10 );
    p_Number_of_image_catalog_directories                  int( 10 );
    p_Number_of_image_catalog_entries                      int( 10 );
    p_Reference_image_catalog_name                         char( 10 );
    p_Reference_image_catalog_library_name                 char( 10 );
    p_Next_tape_volume                                     varchar( 6 );
    p_Image_catalog_mode                                   varchar( 32 );
    p_Image_catalog_directory                              varchar( 256 );
    // Common entry data:
    p_Image_catalog_entry_index                            int( 10 );
    p_Image_catalog_entry_status                           varchar( 32 );
    p_Image_catalog_entry_text                             varchar( 50 );
    p_Image_file_name                                      varchar( 256 );
    p_Write_protect_status                                 varchar( 32 );
    // Special for optical entries:
    p_Opt_Volume_name                                      varchar( 32 );
    p_Opt_Access_information                               varchar( 32 );
    p_Opt_Media_type                                       varchar( 32 );
    p_Opt_Image_size                                       int( 10 );
    // Special for tape entries:
    p_Tap_Volume_name                                      varchar( 6 );
    p_Tap_Maximum_volume_size                              uns( 10 );
    p_Tap_Current_number_of_bytes_available                uns( 20 );
    p_Tap_Current_number_of_bytes_used_by_volume           uns( 20 );
    p_Tap_Percent_used                                     packed( 10 : 1 );
    p_Tap_First_file_sequence_number_in_the_virtual_volume uns( 10 );
    p_Tap_Last_file_sequence_number_in_the_virtual_volume  uns( 10 );
    p_Tap_Next_volume_indicator                            char( 1 );
    p_Tap_Density                                          varchar( 10 );
    p_Tap_Type_of_volume                                   varchar( 32 );
    p_Tap_Allocated_volume_size                            uns( 10 );
    // Null indicators for incoming parameters
    n_ImgCat                                               int( 5 ) const;
    // Null indicators for returned parameters
    n_Image_catalog_type                                   int( 5 );
    n_Image_catalog_status                                 int( 5 );
    n_Reference_image_catalog_indicator                    int( 5 );
    n_Dependent_image_catalog_indicator                    int( 5 );
    n_Image_catalog_text                                   int( 5 );
    n_Virtual_device_name                                  int( 5 );
    n_Number_of_image_catalog_directories                  int( 5 );
    n_Number_of_image_catalog_entries                      int( 5 );
    n_Reference_image_catalog_name                         int( 5 );
    n_Reference_image_catalog_library_name                 int( 5 );
    n_Next_tape_volume                                     int( 5 );
    n_Image_catalog_mode                                   int( 5 );
    n_Image_catalog_directory                              int( 5 );
    // Common entry data:
    n_Image_catalog_entry_index                            int( 5 );
    n_Image_catalog_entry_status                           int( 5 );
    n_Image_catalog_entry_text                             int( 5 );
    n_Image_file_name                                      int( 5 );
    n_Write_protect_status                                 int( 5 );
    // Special for optical entries:
    n_Opt_Volume_name                                      int( 5 );
    n_Opt_Access_information                               int( 5 );
    n_Opt_Media_type                                       int( 5 );
    n_Opt_Image_size                                       int( 5 );
    // Special for tape entries:
    n_Tap_Volume_name                                      int( 5 );
    n_Tap_Maximum_volume_size                              int( 5 );
    n_Tap_Current_number_of_bytes_available                int( 5 );
    n_Tap_Current_number_of_bytes_used_by_volume           int( 5 );
    n_Tap_Percent_used                                     int( 5 );
    n_Tap_First_file_sequence_number_in_the_virtual_volume int( 5 );
    n_Tap_Last_file_sequence_number_in_the_virtual_volume  int( 5 );
    n_Tap_Next_volume_indicator                            int( 5 );
    n_Tap_Density                                          int( 5 );
    n_Tap_Type_of_volume                                   int( 5 );
    n_Tap_Allocated_volume_size                            int( 5 );

    // SQL parameters.
    Sql_State   char( 5 );
    Function    varchar( 517 ) const;
    Specific    varchar( 128 ) const;
    MsgText     varchar( 70 );
    CallType    int( 5 )       const;
  end-pi;

  dcl-pr QVOIRCLD extpgm( 'QVOIRCLD' );
    *n likeds( RCLD0100_t );
    *n int( 10 )    const;
    *n char( 8 )    const;
    *n char( 20 )   const;
    *n char( 1024 ) const options( *varsize );
  end-pr;

  dcl-s  LoImgCat          char( 10 );
  dcl-s  SaveCallType      like( CallType ) static;  // Save CallType from previous call...
  dcl-s  SaveLoImgCat      like( LoImgCat ) static;  // Save receiver from previous call...

  dcl-ds ImgCatInf         likeds( RCLD0100_t ) based( ptrImageCatInfo );
  dcl-s  ptrImageCatInfo   pointer static;
  dcl-ds ImgCatOpt         likeds( RCLD0200_entry_t ) based( ptrImageCatEntry );
  dcl-ds ImgCatTap         likeds( RCLD0300_entry_t ) based( ptrImageCatEntry );
  dcl-s  ptrImageCatEntry  pointer static;

  dcl-s  Image_catalog_directory  varchar( 256 ) static;
  dcl-s  CurEntry                 like( RCLD0100_t.Number_of_image_catalog_entries ) static;

  dcl-s  Buffer_size         int( 10 );
  dcl-s  FmtNam              char( 10 );
  dcl-s  Image_file_name     char( 256 );
  dcl-s  Image_file_name_len like( ImgCatOpt.Image_file_name_len );

  // Start all fields at not NULL.

  n_Image_catalog_type                                   = PARM_NOTNULL;
  n_Image_catalog_status                                 = PARM_NOTNULL;
  n_Reference_image_catalog_indicator                    = PARM_NOTNULL;
  n_Dependent_image_catalog_indicator                    = PARM_NOTNULL;
  n_Image_catalog_text                                   = PARM_NOTNULL;
  n_Virtual_device_name                                  = PARM_NOTNULL;
  n_Number_of_image_catalog_directories                  = PARM_NOTNULL;
  n_Number_of_image_catalog_entries                      = PARM_NOTNULL;
  n_Reference_image_catalog_name                         = PARM_NOTNULL;
  n_Reference_image_catalog_library_name                 = PARM_NOTNULL;
  n_Next_tape_volume                                     = PARM_NOTNULL;
  n_Image_catalog_mode                                   = PARM_NOTNULL;
  n_Image_catalog_directory                              = PARM_NOTNULL;
  // Common entry data:
  n_Image_catalog_entry_index                            = PARM_NULL;
  n_Image_catalog_entry_status                           = PARM_NULL;
  n_Image_catalog_entry_text                             = PARM_NULL;
  n_Image_file_name                                      = PARM_NULL;
  n_Write_protect_status                                 = PARM_NULL;
  // Special for optical entries:
  n_Opt_Volume_name                                      = PARM_NULL;
  n_Opt_Access_information                               = PARM_NULL;
  n_Opt_Media_type                                       = PARM_NULL;
  n_Opt_Image_size                                       = PARM_NULL;
  // Special for tape entries:
  n_Tap_Volume_name                                      = PARM_NULL;
  n_Tap_Maximum_volume_size                              = PARM_NULL;
  n_Tap_Current_number_of_bytes_available                = PARM_NULL;
  n_Tap_Current_number_of_bytes_used_by_volume           = PARM_NULL;
  n_Tap_Percent_used                                     = PARM_NULL;
  n_Tap_First_file_sequence_number_in_the_virtual_volume = PARM_NULL;
  n_Tap_Last_file_sequence_number_in_the_virtual_volume  = PARM_NULL;
  n_Tap_Next_volume_indicator                            = PARM_NULL;
  n_Tap_Density                                          = PARM_NULL;
  n_Tap_Type_of_volume                                   = PARM_NULL;
  n_Tap_Allocated_volume_size                            = PARM_NULL;

  //  Open, fetch & close...

  select;
    when  CallType = CALL_OPEN;

      // Verify that image catalog was specified.

      if ( n_ImgCat = PARM_NULL ) or
         ( p_ImgCat = '' );
          SQL_State = '38999';
          MsgText = 'Image catalog must be specified';
          return;
      else;
        LoImgCat = p_ImgCat;
      endif;

      // Get image catalog basic info.

      ptrImageCatInfo = %alloc( %size( ImgCatInf ) );
      ptrImageCatEntry = *null;
      QVOIRCLD( ImgCatInf
              : %size( ImgCatInf )
              : 'RCLD0100'
              : LoImgCat + IMGCATLIB
              : ApiError
              );

      if ( AeBytAvl > 0 );
        SQL_State = '38999';
        MsgText = 'Error ' + AeExcpID + ', please check joblog.';
        return;
      endif;

      // Convert directory name using CCSID tag.

      Image_catalog_directory = CvtText( ptrImageCatInfo + ImgCatInf.Offset_to_image_catalog_directory
                                       : ImgCatInf.Length_of_image_catalog_directory
                                       : ImgCatInf.CCSID_of_image_catalog_directory
                                       : %len( Image_catalog_directory : *max )
                                       );

      // If there are image catalog entries, expand buffer and get image catalog entries.

      if ( ImgCatInf.Number_of_image_catalog_entries > 0 );

        select;
          when ( ImgCatInf.Image_catalog_type = '0' ); // Optical...
            FmtNam = 'RCLD0200';
          when ( ImgCatInf.Image_catalog_type = '1' ); // Tape...
            FmtNam = 'RCLD0300';
        endsl;

        Buffer_size = ImgCatInf.Bytes_Available + ( ImgCatInf.Number_of_image_catalog_entries * ImgCatInf.Length_of_image_catalog_entry );
        ptrImageCatInfo = %realloc( ptrImageCatInfo : Buffer_size );
        QVOIRCLD( ImgCatInf
                : Buffer_size
                : FmtNam
                : LoImgCat + IMGCATLIB
                : ApiError
                );
        if ( AeBytAvl > 0 );
          SQL_State = '38999';
          MsgText = 'Error ' + AeExcpID + ', please check joblog.';
          return;
        endif;

        ptrImageCatEntry = ptrImageCatInfo + ImgCatInf.Offset_to_first_image_catalog_entry;
      endif;

      // Reset current entry before fetching.

      CurEntry = 0;

    when  CallType = CALL_FETCH;

      // If previous call was for fetch and no more entries, return EOF.

      if ( CallType = SaveCallType ) and
         ( LoImgCat = SaveLoImgCat ) and
         ( CurEntry = ImgCatInf.Number_of_image_catalog_entries );
        SQL_State = '02000';
        return;
      endif;

      // Copy image catalog data to parameters.

      select;
        when ( ImgCatInf.Image_catalog_type = '0' );
          p_Image_catalog_type = 'OPTICAL';
        when ( ImgCatInf.Image_catalog_type = '1' );
          p_Image_catalog_type = 'TAPE';
      endsl;

      select;
        when ( ImgCatInf.Image_catalog_status = '0' );
          p_Image_catalog_status = 'NOT READY';
        when ( ImgCatInf.Image_catalog_status = '1' );
          p_Image_catalog_status = 'READY';
      endsl;

      select;
        when ( ImgCatInf.Reference_image_catalog_indicator = '0' );
          p_Reference_image_catalog_indicator = 'NO';
        when ( ImgCatInf.Reference_image_catalog_indicator = '1' );
          p_Reference_image_catalog_indicator = 'YES';
      endsl;

      select;
        when ( ImgCatInf.Dependent_image_catalog_indicator = '0' );
          p_Dependent_image_catalog_indicator = 'NO';
        when ( ImgCatInf.Dependent_image_catalog_indicator = '1' );
          p_Dependent_image_catalog_indicator = 'YES';
      endsl;

      p_Image_catalog_text                       = %trimr( ImgCatInf.Image_catalog_text );
      p_Virtual_device_name                      = ImgCatInf.Virtual_device_name;
      p_Number_of_image_catalog_directories      = ImgCatInf.Number_of_image_catalog_directories;
      p_Number_of_image_catalog_entries          = ImgCatInf.Number_of_image_catalog_entries;
      p_Reference_image_catalog_name             = ImgCatInf.Reference_image_catalog_name;
      p_Reference_image_catalog_library_name     = ImgCatInf.Reference_image_catalog_library_name;
      p_Next_tape_volume                         = ImgCatInf.Next_tape_volume;

      // Convert image catalog mode.

      select;
        when ( ImgCatInf.Image_catalog_mode = '0' );
          p_Image_catalog_mode = 'NOT READY';
        when ( ImgCatInf.Image_catalog_mode = '1' );
          p_Image_catalog_mode = 'NORMAL';
        when ( ImgCatInf.Image_catalog_mode = '2' );
          p_Image_catalog_mode = 'LIBRARY';
      endsl;

      p_Image_catalog_directory                  = Image_catalog_directory;

      // If there are image catalog entries, get next entry.

      if ( ImgCatInf.Number_of_image_catalog_entries > 0 );
        CurEntry += 1;
        ptrImageCatEntry = ptrImageCatInfo + ImgCatInf.Offset_to_first_image_catalog_entry
                                           + ( ImgCatInf.Length_of_image_catalog_entry * ( CurEntry - 1 ) );

        // Handle entry types.

        select;

          // Optical entry:

          when ( ImgCatInf.Image_catalog_type = '0' );

            // Common entry data:
            p_Image_catalog_entry_index      = ImgCatOpt.Image_catalog_entry_index;

            select;
              when ( ImgCatOpt.Image_catalog_entry_status = '0' );
                p_Image_catalog_entry_status = 'UNLOADED';
              when ( ImgCatOpt.Image_catalog_entry_status = '1' );
                p_Image_catalog_entry_status = 'LOADED';
              when ( ImgCatOpt.Image_catalog_entry_status = '2' );
                p_Image_catalog_entry_status = 'MOUNTED';
              when ( ImgCatOpt.Image_catalog_entry_status = '3' );
                p_Image_catalog_entry_status = 'ERROR';
              when ( ImgCatOpt.Image_catalog_entry_status = '4' );
                p_Image_catalog_entry_status = 'AVAILABLE';
            endsl;

            p_Image_catalog_entry_text       = %trimr( ImgCatOpt.Image_catalog_entry_text );

            Image_file_name                  = ImgCatOpt.Image_file_name;
            Image_file_name_len              = ImgCatOpt.Image_file_name_len / 2;
            p_Image_file_name                = %subst( Image_file_name : 1 : Image_file_name_len );

            select;
              when ( ImgCatOpt.Write_protect_status = '0' );
                p_Write_protect_status = 'NOT WRITE PROTECTED';
              when ( ImgCatOpt.Write_protect_status = '1' );
                p_Write_protect_status = 'WRITE PROTECTED';
              when ( ImgCatOpt.Write_protect_status = '2' );
                p_Write_protect_status = 'UNKNOWN';
            endsl;

            n_Image_catalog_entry_index      = PARM_NOTNULL;
            n_Image_catalog_entry_status     = PARM_NOTNULL;
            n_Image_catalog_entry_text       = PARM_NOTNULL;
            n_Image_file_name                = PARM_NOTNULL;
            n_Write_protect_status           = PARM_NOTNULL;

            // Special for optical entry:
            p_Opt_Volume_name                = %trimr( ImgCatOpt.Volume_name );

            select;
              when ( ImgCatOpt.Access_information = '0' );
                p_Opt_Access_information = 'READ ONLY';
              when ( ImgCatOpt.Access_information = '1' );
                p_Opt_Access_information = 'READ/WRITE';
            endsl;

            select;
              when ( ImgCatOpt.Media_type = '0' );
                p_Opt_Media_type = '*RAM';
              when ( ImgCatOpt.Media_type = '1' );
                p_Opt_Media_type = '*WORM';
              when ( ImgCatOpt.Media_type = '2' );
                p_Opt_Media_type = '*ERASE';
              when ( ImgCatOpt.Media_type = '3' );
                p_Opt_Media_type = '*ROM';
              when ( ImgCatOpt.Media_type = '4' );
                p_Opt_Media_type = '*UNKNOWN';
            endsl;

            p_Opt_Image_size                 = ImgCatOpt.Image_size;
            n_Opt_Volume_name                = PARM_NOTNULL;
            n_Opt_Access_information         = PARM_NOTNULL;
            n_Opt_Media_type                 = PARM_NOTNULL;
            n_Opt_Image_size                 = PARM_NOTNULL;

          // Tape entry:

          when ( ImgCatInf.Image_catalog_type = '1' );

            // Common entry data:
            p_Image_catalog_entry_index                        = ImgCatTap.Image_catalog_entry_index;

            select;
              when ( ImgCatOpt.Image_catalog_entry_status = '0' );
                p_Image_catalog_entry_status = 'UNLOADED';
              when ( ImgCatOpt.Image_catalog_entry_status = '1' );
                p_Image_catalog_entry_status = 'LOADED';
              when ( ImgCatOpt.Image_catalog_entry_status = '2' );
                p_Image_catalog_entry_status = 'MOUNTED';
              when ( ImgCatOpt.Image_catalog_entry_status = '3' );
                p_Image_catalog_entry_status = 'ERROR';
              when ( ImgCatOpt.Image_catalog_entry_status = '4' );
                p_Image_catalog_entry_status = 'AVAILABLE';
            endsl;

            p_Image_catalog_entry_text       = %trimr( ImgCatTap.Image_catalog_entry_text );

            Image_file_name                  = ImgCatTap.Image_file_name;
            Image_file_name_len              = ImgCatTap.Image_file_name_len / 2;
            p_Image_file_name                = %subst( Image_file_name : 1 : Image_file_name_len );

            select;
              when ( ImgCatOpt.Write_protect_status = '0' );
                p_Write_protect_status = 'NOT WRITE PROTECTED';
              when ( ImgCatOpt.Write_protect_status = '1' );
                p_Write_protect_status = 'WRITE PROTECTED';
              when ( ImgCatOpt.Write_protect_status = '2' );
                p_Write_protect_status = 'UNKNOWN';
            endsl;

            n_Image_catalog_entry_index                        = PARM_NOTNULL;
            n_Image_catalog_entry_status                       = PARM_NOTNULL;
            n_Image_catalog_entry_text                         = PARM_NOTNULL;
            n_Image_file_name                                  = PARM_NOTNULL;
            n_Write_protect_status                             = PARM_NOTNULL;

            // Special for tape entry:
            p_Tap_Volume_name                                      = %trimr( ImgCatTap.Volume_name );
            p_Tap_Maximum_volume_size                              = ImgCatTap.Maximum_volume_size;
            p_Tap_Current_number_of_bytes_available                = ImgCatTap.Current_number_of_bytes_available;
            p_Tap_Current_number_of_bytes_used_by_volume           = ImgCatTap.Current_number_of_bytes_used_by_volume;
            p_Tap_Percent_used                                     = ImgCatTap.Percent_used / 10;
            p_Tap_First_file_sequence_number_in_the_virtual_volume = ImgCatTap.First_file_sequence_number_in_the_virtual_volume;
            p_Tap_Last_file_sequence_number_in_the_virtual_volume  = ImgCatTap.Last_file_sequence_number_in_the_virtual_volume;
            p_Tap_Next_volume_indicator                            = ImgCatTap.Next_volume_indicator;
            p_Tap_Density                                          = %trimr( ImgCatTap.Density );
            p_Tap_Type_of_volume                                   = ImgCatTap.Type_of_volume;

            select;
              when ( ImgCatTap.Type_of_volume = '0' );
                p_Tap_Type_of_volume = 'NONLABELED';
              when ( ImgCatTap.Type_of_volume = '1' );
                p_Tap_Type_of_volume = 'STANDARD LABELED';
              when ( ImgCatTap.Type_of_volume = '2' );
                p_Tap_Type_of_volume = 'UNKNOWN';
            endsl;

            p_Tap_Allocated_volume_size                            = ImgCatTap.Allocated_volume_size;
            n_Tap_Volume_name                                      = PARM_NOTNULL;
            n_Tap_Maximum_volume_size                              = PARM_NOTNULL;
            n_Tap_Current_number_of_bytes_available                = PARM_NOTNULL;
            n_Tap_Current_number_of_bytes_used_by_volume           = PARM_NOTNULL;
            n_Tap_Percent_used                                     = PARM_NOTNULL;
            n_Tap_First_file_sequence_number_in_the_virtual_volume = PARM_NOTNULL;
            n_Tap_Last_file_sequence_number_in_the_virtual_volume  = PARM_NOTNULL;
            n_Tap_Next_volume_indicator                            = PARM_NOTNULL;
            n_Tap_Density                                          = PARM_NOTNULL;
            n_Tap_Type_of_volume                                   = PARM_NOTNULL;
            n_Tap_Allocated_volume_size                            = PARM_NOTNULL;
        endsl;
      endif;

    when  CallType = CALL_CLOSE;
      if ( ptrImageCatInfo <> *null );
        dealloc ptrImageCatInfo;
      endif;

  endsl;

  SaveCallType = CallType;
  SaveLoImgCat = LoImgCat;

  return;

end-proc;

//----------------------------------------------------------------
// Procedure:    CvtText
// Description:  Convert text from one CCSID to job CCSID.

dcl-proc CvtText;

  dcl-pi *n varchar( 1024 );
    input     pointer   value;
    inp_len   int( 10 ) const;
    FromCCSID int( 10 ) const;
    out_len   int( 10 ) const;
  end-pi;

  dcl-s  result      varchar( 1024 );

  dcl-s  output      char( 1024 );
  dcl-s  outputlen   uns( 10 );
  dcl-s  p_input     pointer;
  dcl-s  p_output    pointer;
  dcl-s  inputleft   uns( 10 );
  dcl-s  outputleft  uns( 10 );
  dcl-ds source      likeds( QtqCode_t ) inz( *likeds );
  dcl-ds target      likeds( QtqCode_t ) inz( *likeds );
  dcl-ds toJob       likeds( iconv_t );

  source.CCSID = FromCCSID;
  target.CCSID = 0;          // 0 = current job's CCSID

  toJob = QtqIconvOpen( target : source );

  if ( toJob.return_value = -1 );  // Error starting iconv...
    return ( '' );
  endif;

  p_input = input;
  inputleft = inp_len;
  p_output = %addr( output );
  outputleft = %size( output );

  iconv( toJob
       : p_input
       : inputleft
       : p_output
       : outputleft
       );

  outputlen = %size( output ) - outputleft;

  iconv_close( toJob );

  // Return converted text.

  if ( outputlen <= out_len );
    result = %subst( output : 1 : outputlen );
  else;
    result = %subst( output : 1 : out_len );
  endif;

  return ( result );

end-proc;
