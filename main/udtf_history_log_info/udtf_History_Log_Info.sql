-- Return History Log information.

create or replace function History_Log_Info ( StartTime timestamp, EndTime timestamp )
  returns table (
                  Ordinal_Position           integer                        -- A unique number for each row
                , Message_Id                 varchar(    7 )                -- The message ID for this message
                , Message_Type               varchar(   13 )                -- Type of message
                , Message_Subtype            varchar(   22 )                -- Subtype of message
                , Severity                   smallint                       -- The severity assigned to the message
                , Message_Timestamp          timestamp                      -- The timestamp when the message was sent
                , From_User                  varchar(   10 )                -- The current user of the job when the message was sent
                , From_Job                   varchar(   28 )                -- The qualified job name when the message was sent
                , From_Program               varchar(   10 )                -- The program that sent the message
                , Message_Library            varchar(   10 )                -- The name of the library containing the message file
                , Message_File               varchar(   10 )                -- The message file containing the message
                , Message_Tokens             varchar( 4096 ) for bit data   -- The message token string
                , Message_Text               vargraphic( 1024 ) ccsid 1200  -- The first level text of the message including tokens, or the impromptu message text
                , Message_Second_Level_Text  vargraphic( 4096 ) ccsid 1200  -- The second level text of the message including tokens
                )
  external name 'OSSILE/HSTLOGINF(History_Log_Info)'
  specific      HISTORY_LOG_INFO
  language rpgle
  parameter style sql
  no sql
  not deterministic
  no external action
  not fenced
  no scratchpad
  no final call
  disallow parallel
  cardinality 1
;

label on specific routine HISTORY_LOG_INFO is 'Return one row for each message in the history log'
;

create or replace function History_Log_Info ( StartTime timestamp )
  returns table (
                  Ordinal_Position           integer                        -- A unique number for each row
                , Message_Id                 varchar(    7 )                -- The message ID for this message
                , Message_Type               varchar(   13 )                -- Type of message
                , Message_Subtype            varchar(   22 )                -- Subtype of message
                , Severity                   smallint                       -- The severity assigned to the message
                , Message_Timestamp          timestamp                      -- The timestamp when the message was sent
                , From_User                  varchar(   10 )                -- The current user of the job when the message was sent
                , From_Job                   varchar(   28 )                -- The qualified job name when the message was sent
                , From_Program               varchar(   10 )                -- The program that sent the message
                , Message_Library            varchar(   10 )                -- The name of the library containing the message file
                , Message_File               varchar(   10 )                -- The message file containing the message
                , Message_Tokens             varchar( 4096 ) for bit data   -- The message token string
                , Message_Text               vargraphic( 1024 ) ccsid 1200  -- The first level text of the message including tokens, or the impromptu message text
                , Message_Second_Level_Text  vargraphic( 4096 ) ccsid 1200  -- The second level text of the message including tokens
                )
  specific      HISTORY_LOG_INFO_no_end
  language SQL
  modifies SQL data
  not fenced
  set option commit=*none, dbgview = *source

  begin
    declare EndTime timestamp;

    set EndTime = current_timestamp;

    return select * from table( OSSILE.History_Log_Info ( StartTime, EndTime )) x;
  end
;

label on specific routine HISTORY_LOG_INFO_no_end is 'Return one row for each message in the history log'
;

create or replace function History_Log_Info ( )
  returns table (
                  Ordinal_Position           integer                        -- A unique number for each row
                , Message_Id                 varchar(    7 )                -- The message ID for this message
                , Message_Type               varchar(   13 )                -- Type of message
                , Message_Subtype            varchar(   22 )                -- Subtype of message
                , Severity                   smallint                       -- The severity assigned to the message
                , Message_Timestamp          timestamp                      -- The timestamp when the message was sent
                , From_User                  varchar(   10 )                -- The current user of the job when the message was sent
                , From_Job                   varchar(   28 )                -- The qualified job name when the message was sent
                , From_Program               varchar(   10 )                -- The program that sent the message
                , Message_Library            varchar(   10 )                -- The name of the library containing the message file
                , Message_File               varchar(   10 )                -- The message file containing the message
                , Message_Tokens             varchar( 4096 ) for bit data   -- The message token string
                , Message_Text               vargraphic( 1024 ) ccsid 1200  -- The first level text of the message including tokens, or the impromptu message text
                , Message_Second_Level_Text  vargraphic( 4096 ) ccsid 1200  -- The second level text of the message including tokens
                )
  specific      HISTORY_LOG_INFO_no_start_no_end
  language SQL
  modifies SQL data
  not fenced
  set option commit=*none, dbgview = *source

  begin
    declare StartTime timestamp;
    declare EndTime   timestamp;

    set StartTime = timestamp_iso( current_date );
    set EndTime   = current_timestamp;

    return select * from table( OSSILE.History_Log_Info( StartTime, EndTime )) x;
  end
;

label on specific routine HISTORY_LOG_INFO_no_start_no_end is 'Return one row for each message in the history log'
;
