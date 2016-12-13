**free
/if not defined( Copying_prototypes )
//---------------------------------------------------------------/
//                                                               /
//  Brief description of collection of procedures.               /
//                                                               /
//  Procedures:                                                  /
//                                                               /
//  History_Log_Info      - return info from history log.        /
//                                                               /
//  Compilation:                                                 /
//                                                               /
//*>  CRTRPGMOD MODULE(&FCN3/&FNR) SRCSTMF('&FP')              <*/
//*>  CRTSRVPGM SRVPGM(&FCN3/&FNR) EXPORT(*ALL)              - <*/
//*>              TEXT('History_Log_Info UDTF')                <*/
//*>  DLTMOD    MODULE(&FCN3/&FNR)                             <*/
//                                                               /
//---------------------------------------------------------------/
//  2016-11-03 : Christian Jorgensen                             /
//               Create module.                                  /
//  2016-11-30 : Christian Jorgensen                             /
//               Include format control characters in the        /
//                 second level text like the IBM version.       /
//               Remove module after service program creation.   /
//---------------------------------------------------------------/

ctl-opt debug;
ctl-opt option( *Srcstmt : *NoDebugIO );
ctl-opt thread( *serialize );

ctl-opt nomain;

//----------------------------------------------------------------
// Exported procedures:

/endif

/if not defined( HSTLOGINF_prototype_copied )

// Procedure:    History_Log_Info
// Description:  Return info from history log

dcl-pr History_Log_Info extproc( *dclcase );
  // Incoming parameters
  p_StartTime                                            timestamp const;
  p_EndTime                                              timestamp const;
  // Returned parameters
  p_Ordinal_Position                                     int( 10 );
  p_Message_Id                                           varchar(    7 );
  p_Message_Type                                         varchar(   13 );
  p_Message_Subtype                                      varchar(   22 );
  p_Severity                                             int(  5 );
  p_Message_Timestamp                                    timestamp;
  p_From_User                                            varchar(   10 );
  p_From_Job                                             varchar(   28 );
  p_From_Program                                         varchar(   10 );
  p_Message_Library                                      varchar(   10 );
  p_Message_File                                         varchar(   10 );
  p_Message_Tokens                                       varchar( 4096 );
  p_Message_Text                                         varucs2( 1024 ) ccsid( 1200 );
  p_Message_Second_Level_Text                            varucs2( 4096 ) ccsid( 1200 );
  // Null indicators for incoming parameters
  n_StartTime                                            int( 5 ) const;
  n_EndTime                                              int( 5 ) const;
  // Null indicators for returned parameters
  n_Ordinal_Position                                     int( 5 );
  n_Message_Id                                           int( 5 );
  n_Message_Type                                         int( 5 );
  n_Message_Subtype                                      int( 5 );
  n_Severity                                             int( 5 );
  n_Message_Timestamp                                    int( 5 );
  n_From_User                                            int( 5 );
  n_From_Job                                             int( 5 );
  n_From_Program                                         int( 5 );
  n_Message_Library                                      int( 5 );
  n_Message_File                                         int( 5 );
  n_Message_Tokens                                       int( 5 );
  n_Message_Text                                         int( 5 );
  n_Message_Second_Level_Text                            int( 5 );

  // SQL parameters.
  Sql_State   char( 5 );
  Function    varchar( 517 ) const;
  Specific    varchar( 128 ) const;
  MsgText     varchar( 70 );
  CallType    int( 5 )       const;
end-pr;

//----------------------------------------------------------------
// Exported data:

/define HSTLOGINF_prototype_copied
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

dcl-ds MsgSltInf_t template qualified;
  Length                                           int( 10 );
  Start_date                                       char( 10 );
  Start_time                                       char( 10 );
  Start_microsec                                   char(  6 );
  End_date                                         char( 10 );
  End_time                                         char( 10 );
  End_microsec                                     char(  6 );
  MsgID_list_content                               int( 10 );
  MsgID_list_offset                                int( 10 );
  MsgID_list_number                                int( 10 );
  Job_list_offset                                  int( 10 );
  Job_list_number                                  int( 10 );
  MsgSeverity                                      int( 10 );
  MsgTyp_list_content                              int( 10 );
  MsgTyp_list_offset                               int( 10 );
  MsgTyp_list_number                               int( 10 );
end-ds;

dcl-ds HSTL0100_t template qualified;
  Length_of_this_entry                                          int( 10 );
  Message_severity                                              int( 10 );
  Message_identifier                                            char(  7 );
  Message_type                                                  char(  2 );
  Message_file_name                                             char( 10 );
  Message_file_library                                          char( 10 );
  Date_sent                                                     char(  7 );
  Time_sent                                                     char(  6 );
  Microseconds                                                  char(  6 );
  From_job                                                      char( 10 );
  From_job_user                                                 char( 10 );
  From_job_number                                               char(  6 );
  From_user                                                     char( 10 );
  Status_of_data                                                char(  1 );
  Reserved                                                      char(  3 );
  Displacement_to_the_first_level_message_or_immediate_text     int( 10 );
  Length_of_the_first_level_message_or_immediate_text           int( 10 );
  Displacement_to_the_message_replacement_data                  int( 10 );
  Length_of_the_message_replacement_data                        int( 10 );
  CCSID_for_text                                                int( 10 );
  CCSID_conversion_status_indicator_for_text                    int( 10 );
  CCSID_for_data                                                int( 10 );
  CCSID_conversion_status_indicator_for_data                    int( 10 );
end-ds;

dcl-ds ListInfo_t len( 80 ) template qualified;
  LiRcdNbrTot  int( 10 );
  LiRcdNbrRtn  int( 10 );
  LiHandle     char( 4 );
  LiRcdLen     int( 10 );
  LiInfSts     char( 1 );
  LiDts        char( 13 );
  LiLstSts     char( 1 );
  *n           char( 1 );
  LiInfLen     int( 10 );
  LiRcd1       int( 10 );
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
// Procedure:    History_Log_Info
// Description:  Return info from history log

dcl-proc History_Log_Info export;

  dcl-pi *n;
    // Incoming parameters
    p_StartTime                                            timestamp const;
    p_EndTime                                              timestamp const;
    // Returned parameters
    p_Ordinal_Position                                     int( 10 );
    p_Message_Id                                           varchar(    7 );
    p_Message_Type                                         varchar(   13 );
    p_Message_Subtype                                      varchar(   22 );
    p_Severity                                             int(  5 );
    p_Message_Timestamp                                    timestamp;
    p_From_User                                            varchar(   10 );
    p_From_Job                                             varchar(   28 );
    p_From_Program                                         varchar(   10 );
    p_Message_Library                                      varchar(   10 );
    p_Message_File                                         varchar(   10 );
    p_Message_Tokens                                       varchar( 4096 );
    p_Message_Text                                         varucs2( 1024 ) ccsid( 1200 );
    p_Message_Second_Level_Text                            varucs2( 4096 ) ccsid( 1200 );
    // Null indicators for incoming parameters
    n_StartTime                                            int( 5 ) const;
    n_EndTime                                              int( 5 ) const;
    // Null indicators for returned parameters
    n_Ordinal_Position                                     int( 5 );
    n_Message_Id                                           int( 5 );
    n_Message_Type                                         int( 5 );
    n_Message_Subtype                                      int( 5 );
    n_Severity                                             int( 5 );
    n_Message_Timestamp                                    int( 5 );
    n_From_User                                            int( 5 );
    n_From_Job                                             int( 5 );
    n_From_Program                                         int( 5 );
    n_Message_Library                                      int( 5 );
    n_Message_File                                         int( 5 );
    n_Message_Tokens                                       int( 5 );
    n_Message_Text                                         int( 5 );
    n_Message_Second_Level_Text                            int( 5 );

    // SQL parameters.
    Sql_State   char( 5 );
    Function    varchar( 517 ) const;
    Specific    varchar( 128 ) const;
    MsgText     varchar( 70 );
    CallType    int( 5 )       const;
  end-pi;

  dcl-pr QMHOLHST extpgm( 'QMHOLHST' );
    *n char( 65535 ) options( *varsize );                  // Receiver variable
    *n int( 10 )    const;                                 // Length of receiver variable
    *n char( 8 )    const;                                 // Format Name
    *n char( 80 );                                         // List information
    *n int( 10 )    const;                                 // Number of records to return
    *n char( 1024 ) const options( *varsize );             // Message selection information
    *n int( 10 )    const;                                 // CCSID
    *n char( 10 )   const;                                 // Time zone
    *n char( 1024 )       options( *varsize );             // Error code
  end-pr;

  // Get list entry:
  dcl-pr GetLstEnt extpgm( 'QGYGTLE' );
    GlRcvVar        char( 65535 ) options( *varsize );
    GlRcvVarLen     int( 10 ) const;
    GlHandle        char( 4 ) const;
    GlLstInf        char( 80 );
    GlNbrRcdRtn     int( 10 ) const;
    GlRtnRcdNbr     int( 10 ) const;
    GlError         char( 1024 ) options( *varsize );
  end-pr;

  // Close list:
  dcl-pr CloseLst extpgm( 'QGYCLST' );
    ClHandle        char( 4 ) const;
    ClError         char( 1024 ) options( *varsize );
  end-pr;

  dcl-ds ListInfo          likeds( ListInfo_t ) static;
  dcl-ds MsgSltInf         likeds( MsgSltInf_t ) inz;
  dcl-ds HSTL0100          likeds( HSTL0100_t ) based( ptrHistLogEntry );
  dcl-s  ptrHistLogEntry   pointer static;
  dcl-s  ptrHistLogList    pointer static;

  dcl-s  CurEntry          like( ListInfo_t.LiRcdNbrRtn ) static;
  dcl-s  CharTimestamp     char( 26 );

  dcl-s  MsgTxt            char( 4096 ) based( ptrMsgTxt );
  dcl-s  ptrMsgTxt         pointer;
  dcl-s  MsgDta            char( 4096 ) based( ptrMsgDta );
  dcl-s  ptrMsgDta         pointer;

  // Start all fields at not NULL.

  n_Ordinal_Position                                     = PARM_NOTNULL;
  n_Message_Id                                           = PARM_NOTNULL;
  n_Message_Type                                         = PARM_NOTNULL;
  n_Message_Subtype                                      = PARM_NOTNULL;
  n_Severity                                             = PARM_NOTNULL;
  n_Message_Timestamp                                    = PARM_NOTNULL;
  n_From_User                                            = PARM_NOTNULL;
  n_From_Job                                             = PARM_NOTNULL;
  n_From_Program                                         = PARM_NOTNULL;
  n_Message_Library                                      = PARM_NOTNULL;
  n_Message_File                                         = PARM_NOTNULL;
  n_Message_Tokens                                       = PARM_NOTNULL;
  n_Message_Text                                         = PARM_NOTNULL;
  n_Message_Second_Level_Text                            = PARM_NOTNULL;

  //  Open, fetch & close...

  select;
    when  CallType = CALL_OPEN;

      // Get history log info.

      ptrHistLogEntry = %alloc( 65535 );
      CharTimestamp = %char( p_StartTime );

      MsgSltInf.Length     =  %size( MsgSltInf );
      MsgSltInf.Start_date = %char( %date( p_StartTime ) : *CYMD0 );
      MsgSltInf.Start_time = %char( %time( p_StartTime ) : *HMS0 );
      MsgSltInf.Start_microsec = %subst( CharTimestamp : 21 : 6 );
      MsgSltInf.End_date   = %char( %date( p_EndTime ) : *CYMD0 );
      MsgSltInf.End_time   = %char( %time( p_EndTime ) : *HMS0 );
      MsgSltInf.End_microsec = %subst( %char( p_EndTime ) : 21 : 6 );

      clear ListInfo;

      QMHOLHST( HSTL0100
              : 65535
              : 'HSTL0100'
              : ListInfo
              : 0
              : MsgSltInf
              : 0
              : '*JOB'
              : ApiError
              );

      if ( AeBytAvl > 0 );
        SQL_State = '38999';
        MsgText = 'Error ' + AeExcpID + ', please check joblog.';
        return;
      endif;

      // Reset current entry before fetching.

      CurEntry = 0;

    when  CallType = CALL_FETCH;

      // Read next list entry.

      select;
        when ( ListInfo.LiLstSts <> '2' ) or
             ( ListInfo.LiRcdNbrTot > CurEntry );
          CurEntry += 1;

          GetLstEnt( HSTL0100
                   : 65535
                   : ListInfo.LiHandle
                   : ListInfo
                   : 1
                   : CurEntry
                   : ApiError
                   );
          if ( AeBytAvl > *ZERO );
            SQL_State = '02000';
            return;
          endif;

          ptrMsgTxt = ptrHistLogEntry + HSTL0100.Displacement_to_the_first_level_message_or_immediate_text;
          ptrMsgDta = ptrHistLogEntry + HSTL0100.Displacement_to_the_message_replacement_data;

          // Copy history log into to parameters.

          p_Ordinal_position = CurEntry;
          p_Message_Id       = HSTL0100.Message_identifier;

          clear p_Message_Subtype;

          select;
            when ( HSTL0100.Message_type = '01' );
              p_Message_Type = 'COMPLETION';
            when ( HSTL0100.Message_type = '02' );
              p_Message_Type = 'DIAGNOSTIC';
            when ( HSTL0100.Message_type = '04' );
              p_Message_Type = 'INFORMATIONAL';
            when ( HSTL0100.Message_type = '05' );
              p_Message_Type = 'INQUIRY';
            when ( HSTL0100.Message_type = '06' );
              p_Message_Type = 'SENDER';
            when ( HSTL0100.Message_type = '08' );
              p_Message_Type = 'REQUEST';
            when ( HSTL0100.Message_type = '10' );
              p_Message_Type = 'REQUEST';
              p_Message_Subtype = 'WITH PROMPTING';
            when ( HSTL0100.Message_type = '14' );
              p_Message_Type = 'NOTIFY';
            when ( HSTL0100.Message_type = '15' );
              p_Message_Type = 'ESCAPE';
            when ( HSTL0100.Message_type = '21' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'NOT VALIDITY CHECKED';
            when ( HSTL0100.Message_type = '22' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'VALIDITY CHECKED';
            when ( HSTL0100.Message_type = '23' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'MESSAGE DEFAULT USED';
            when ( HSTL0100.Message_type = '24' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'SYSTEM DEFAULT USED';
            when ( HSTL0100.Message_type = '25' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'FROM SYSTEM REPLY LIST';
            when ( HSTL0100.Message_type = '26' );
              p_Message_Type = 'REPLY';
              p_Message_Subtype = 'FROM EXIT PROGRAM';
          endsl;

          if ( p_Message_Subtype = '' );
            n_Message_Subtype = PARM_NULL;
          endif;


          p_Severity          = HSTL0100.Message_severity;
          p_Message_Timestamp = RtvTimestamp( HSTL0100.Date_sent : HSTL0100.Time_sent : HSTL0100.Microseconds );

          p_From_User         = %trim( HSTL0100.From_User );
          p_From_Job          = %trim( HSTL0100.From_job_number ) + '/'
                              + %trim( HSTL0100.From_job_user ) + '/'
                              + %trim( HSTL0100.From_Job);
          // p_From_Program      = HSTL0100.From_Program;
          n_From_Program      = PARM_NULL; // Always null - info not returned by QMHOLHST! :-(
          p_Message_Library   = %trim( HSTL0100.Message_file_library );
          p_Message_File      = %trim( HSTL0100.Message_file_name );
          p_Message_Tokens    = %subst( MsgDta : 1 : HSTL0100.Length_of_the_message_replacement_data );
          p_Message_Text      = %subst( MsgTxt : 1 : HSTL0100.Length_of_the_first_level_message_or_immediate_text );
          p_Message_Second_Level_Text = RtvAddMsgText( HSTL0100.Message_identifier
                                                     : HSTL0100.Message_file_name + HSTL0100.Message_file_library
                                                     : MsgDta
                                                     : HSTL0100.Length_of_the_message_replacement_data
                                                     );

        when ( ListInfo.LiRcdNbrTot <= CurEntry );
          SQL_State = '02000';
          return;

        other;
          SQL_State = '38999';
          MsgText = 'Unknown error reading history log info';
          return;
      endsl;

    when  CallType = CALL_CLOSE;
      CloseLst( ListInfo.LiHandle : ApiError );
      if ( ptrHistLogEntry <> *null );
        dealloc ptrHistLogEntry;
      endif;

  endsl;

  return;

end-proc;

// Procedure:    RtvTimestamp
// Description:  Retrieve timestamp from date, time and microseconds.

dcl-proc RtvTimestamp;
  dcl-pi *n timestamp;
    InDate       char( 7 );
    InTime       char( 6 );
    InMicroSec   char( 6 );
  end-pi;

  dcl-s  Result  timestamp;

  Result = %date( InDate : *CYMD0 ) + %time( InTime : *HMS0 ) + %mseconds( %int( InMicrosec ) ) ;

  return ( Result );

end-proc;

// Procedure:    RtvAddMsgText
// Description:  Retrieve additional (2nd level) message text.

dcl-proc RtvAddMsgText;
  dcl-pi *n varchar( 4096 );
    MsgID       char(    7 ) const;
    QMsgFile    char(   20 ) const;
    MsgDta      char( 4096 ) const;
    MsgDtaLen   int( 10 )    const;
  end-pi;

  dcl-pr QMHRTVM extpgm( 'QMHRTVM' );
    *n char( 65535 ) options( *varsize );                  // Receiver variable
    *n int( 10 )    const;                                 // Length of message information
    *n char(    8 ) const;                                 // Format Name
    *n char(    7 ) const;                                 // Message identifier
    *n char(   20 ) const;                                 // Qualified message file name
    *n char( 4096 ) const options( *varsize );             // Replacement data
    *n int( 10 )    const;                                 // Length of replacement data
    *n char(   10 ) const;                                 // Replace substitution values
    *n char(   10 ) const;                                 // Return format control characters
    *n char( 1024 )       options( *varsize );             // Error code
  end-pr;

  dcl-ds RTVM0100 len( 65535 ) qualified;
    Bytes_returned                    int( 10 );
    Bytes_available                   int( 10 );
    Length_of_message_returned        int( 10 );
    Length_of_message_available       int( 10 );
    Length_of_message_help_returned   int( 10 );
    Length_of_message_help_available  int( 10 );
    Message                           char( 4096 );
  end-ds;

  dcl-s  MessageHelp     char( 4096 ) based( ptrMessageHelp );
  dcl-s  ptrMessageHelp  pointer;

  dcl-s  Result  varchar( 4096 );

  if ( MsgID <> '' );
    QMHRTVM( RTVM0100 : %size( RTVM0100 ) : 'RTVM0100' : MsgID : QMsgFile : MsgDta : MsgDtaLen : '*YES' : '*YES' : ApiError );
    if ( AeBytAvl = *ZERO );
      ptrMessageHelp = %addr( RTVM0100.Message ) + RTVM0100.Length_of_message_returned;
      Result = %subst( MessageHelp : 1 : RTVM0100.Length_of_message_help_returned );
    endif;
  endif;

  return ( Result );

end-proc;
