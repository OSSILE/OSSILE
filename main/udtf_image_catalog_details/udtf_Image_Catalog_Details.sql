-- Return Image Catalog Details.

create or replace function OSSILE/Image_Catalog_Details ( ImgCat varchar(10) )
  returns table(
      Image_catalog_type                                   varchar(32)
    , Image_catalog_status                                 varchar(32)
    , Reference_image_catalog_indicator                    varchar(32)
    , Dependent_image_catalog_indicator                    varchar(32)
    , Image_catalog_text                                   varchar(50)
    , Virtual_device_name                                  char(10)
    , Number_of_image_catalog_directories                  integer
    , Number_of_image_catalog_entries                      integer
    , Reference_image_catalog_name                         char(10)
    , Reference_image_catalog_library_name                 char(10)
    , Next_tape_volume                                     varchar(6)
    , Image_catalog_mode                                   varchar(32)
    , Image_catalog_directory                              varchar(256)
      -- Common entry data:
    , Image_catalog_entry_index                            integer
    , Image_catalog_entry_status                           varchar(32)
    , Image_catalog_entry_text                             varchar(50)
    , Image_file_name                                      varchar(256)
    , Write_protect_status                                 varchar(32)
      -- Special for optical entries:
    , Opt_Volume_name                                      varchar(32)
    , Opt_Access_information                               varchar(32)
    , Opt_Media_type                                       varchar(32)
    , Opt_Image_size_MB                                    integer
      -- Special for tape entries:
    , Tap_Volume_name                                      varchar(6)
    , Tap_Maximum_volume_size_MB                           integer
    , Tap_Current_number_of_bytes_available                bigint
    , Tap_Current_number_of_bytes_used_by_volume           bigint
    , Tap_Percent_used                                     decimal( 10, 1 )
    , Tap_First_file_sequence_number_in_the_virtual_volume integer
    , Tap_Last_file_sequence_number_in_the_virtual_volume  integer
    , Tap_Next_volume_indicator                            char(1)
    , Tap_Density                                          varchar(10)
    , Tap_Type_of_volume                                   varchar(32)
    , Tap_Allocated_volume_size_MB                         integer
  )
specific Image_Catalog_Details
language RPGLE
deterministic
no sql
external name 'OSSILE/IMGCATDET(Image_Catalog_Details)'
parameter style SQL
no final call
;
