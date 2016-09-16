-- Return Machine Attributes information.

create or replace function OSSILE/Machine_Attributes ()
  returns table(
      System_type                                      char(  4 )
    , System_model_number                              char(  4 )
    , Processor_group_ID                               char(  4 )
    , System_processor_feature                         char(  4 )
    , System_serial_number                             char( 10 )
    , Processor_feature                                char(  4 )
    , Interactive_feature                              char(  4 )
  )
language RPGLE
specific Machine_Attributes
deterministic
no sql
external name 'OSSILE/MACHATTR(Machine_attributes)'
parameter style SQL
no final call
;
