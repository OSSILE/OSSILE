-- Return Cartridge Info Details. 

create or replace function OSSILE/Cartridge_Info ( TapMlb varchar( 10 ), CartID varchar( 6 ), CatName varchar( 10 ), CatSys varchar( 8 ) )
  returns table(
      Cartridge_ID                                         varchar(  6 )
    , Volume_ID                                            varchar( 10 )
    , Tape_library_name                                    varchar( 10 )
    , Category                                             varchar( 10 )
    , Category_system                                      varchar(  8 )
    , Density                                              varchar( 10 )
    , Changed_timestamp                                    timestamp
    , Referenced_timestamp                                 timestamp
    , Location                                             varchar( 10 )
    , Location_indicator                                   varchar( 32 )
    , Volume_status                                        varchar( 32 )
    , Owner_ID                                             varchar( 32 )
    , Write_protected                                      varchar( 32 )
    , Encoding                                             varchar( 32 )
    , Cartridge_ID_source                                  varchar( 32 )
    , In_Import_Export_slot                                varchar( 32 )
    , Media_type                                           varchar( 32 )
  )
specific Cartridge_Info_all
language RPGLE
deterministic
no sql
external name 'OSSILE/CARTINFO(Cartridge_Info)'
parameter style SQL
not fenced
no final call
;

-- Return Cartridge Info Details - no category system.

create or replace function OSSILE/Cartridge_Info ( TapMlb varchar( 10 ), CartID varchar( 6 ), CatName varchar( 10 ) )
  returns table(
      Cartridge_ID                                         varchar(  6 )
    , Volume_ID                                            varchar( 10 )
    , Tape_library_name                                    varchar( 10 )
    , Category                                             varchar( 10 )
    , Category_system                                      varchar(  8 )
    , Density                                              varchar( 10 )
    , Changed_timestamp                                    timestamp
    , Referenced_timestamp                                 timestamp
    , Location                                             varchar( 10 )
    , Location_indicator                                   varchar( 32 )
    , Volume_status                                        varchar( 32 )
    , Owner_ID                                             varchar( 32 )
    , Write_protected                                      varchar( 32 )
    , Encoding                                             varchar( 32 )
    , Cartridge_ID_source                                  varchar( 32 )
    , In_Import_Export_slot                                varchar( 32 )
    , Media_type                                           varchar( 32 )
  )
specific Cartridge_Info_no_cat_sys
language SQL
modifies SQL data
not fenced
set option commit=*none
begin
  return select * from table(OSSILE/Cartridge_Info ( TapMlb, CartID, CatName, '*ALL' )) x;
end;

-- Return Cartridge Info Details - no category name or system.

create or replace function OSSILE/Cartridge_Info ( TapMlb varchar( 10 ), CartID varchar( 6 ) )
  returns table(
      Cartridge_ID                                         varchar(  6 )
    , Volume_ID                                            varchar( 10 )
    , Tape_library_name                                    varchar( 10 )
    , Category                                             varchar( 10 )
    , Category_system                                      varchar(  8 )
    , Density                                              varchar( 10 )
    , Changed_timestamp                                    timestamp
    , Referenced_timestamp                                 timestamp
    , Location                                             varchar( 10 )
    , Location_indicator                                   varchar( 32 )
    , Volume_status                                        varchar( 32 )
    , Owner_ID                                             varchar( 32 )
    , Write_protected                                      varchar( 32 )
    , Encoding                                             varchar( 32 )
    , Cartridge_ID_source                                  varchar( 32 )
    , In_Import_Export_slot                                varchar( 32 )
    , Media_type                                           varchar( 32 )
  )
specific Cartridge_Info_no_cat_name
language SQL
modifies SQL data
not fenced
set option commit=*none
begin
  return select * from table(OSSILE/Cartridge_Info ( TapMlb, CartID, '*ALL', '*ALL' )) x;
end;

-- Return Cartridge Info Details - no cartridge or category name or system.

create or replace function OSSILE/Cartridge_Info ( TapMlb varchar( 10 ) )
  returns table(
      Cartridge_ID                                         varchar(  6 )
    , Volume_ID                                            varchar( 10 )
    , Tape_library_name                                    varchar( 10 )
    , Category                                             varchar( 10 )
    , Category_system                                      varchar(  8 )
    , Density                                              varchar( 10 )
    , Changed_timestamp                                    timestamp
    , Referenced_timestamp                                 timestamp
    , Location                                             varchar( 10 )
    , Location_indicator                                   varchar( 32 )
    , Volume_status                                        varchar( 32 )
    , Owner_ID                                             varchar( 32 )
    , Write_protected                                      varchar( 32 )
    , Encoding                                             varchar( 32 )
    , Cartridge_ID_source                                  varchar( 32 )
    , In_Import_Export_slot                                varchar( 32 )
    , Media_type                                           varchar( 32 )
  )
specific Cartridge_Info_no_cartID
language SQL
modifies SQL data
not fenced
set option commit=*none
begin
  return select * from table(OSSILE/Cartridge_Info ( TapMlb, '*ALL', '*ALL', '*ALL' )) x;
end;
