**free
/if not defined( Copying_prototypes )
//---------------------------------------------------------------/
//                                                               /
//  Brief description of collection of procedures.               /
//                                                               /
//  Procedures:                                                  /
//                                                               /
//  Machine_attributes    - return info about machine attr.      /
//                                                               /
//  Compilation:                                                 /
//                                                               /
//*>  CRTRPGMOD MODULE(&O/&FNR) SRCSTMF('&FP')                 <*/
//*>  CRTSRVPGM SRVPGM(&O/&FNR) EXPORT(*ALL)                 - <*/
//*>              TEXT('Machine_attributes')                   <*/
//                                                               /
//---------------------------------------------------------------/
//  2016-06-29 : Christian Jorgensen                             /
//               Create module.                                  /
//---------------------------------------------------------------/

ctl-opt debug;
ctl-opt option( *Srcstmt : *NoDebugIO );
ctl-opt thread( *serialize );

ctl-opt nomain;

//----------------------------------------------------------------
// Exported procedures:

/endif

/if not defined( MACHATTR_prototype_copied )

// Procedure:    Machine_attributes
// Description:  Return information about machine attributes.

dcl-pr Machine_attributes extproc( *dclcase );
  // Returned parameters
  p_System_type                char(  4 );
  p_System_model_number        char(  4 );
  p_Processor_group_ID         char(  4 );
  p_System_processor_feature   char(  4 );
  p_System_serial_number       char( 10 );
  p_Processor_feature          char(  4 );
  p_Interactive_feature        char(  4 );
  // Null indicators for returned parameters
  n_System_type                int( 5 );
  n_System_model_number        int( 5 );
  n_Processor_group_ID         int( 5 );
  n_System_processor_feature   int( 5 );
  n_System_serial_number       int( 5 );
  n_Processor_feature          int( 5 );
  n_Interactive_feature        int( 5 );
  // SQL parameters.
  Sql_State                    char(5);
  Function                     varchar( 517 ) const;
  Specific                     varchar( 128 ) const;
  MsgText                      varchar( 70 );
  CallType                     int( 5 )       const;
end-pr;

/define MACHATTR_prototype_copied
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

//----------------------------------------------------------------
// Data types:

dcl-ds MATMATR_VPD_t template qualified;
  Bytes_provided               int(  10 )  inz( %size( MATMATR_VPD_t ) );
  Bytes_available              int(  10 );
  System_type                  char(  4 )  pos( 2509 );
  System_model_number          char(  4 )  pos( 2513 );
  Processor_group_ID           char(  4 )  pos( 2521 );
  System_processor_feature     char(  4 )  pos( 2530 );
  System_serial_number         char( 10 )  pos( 2534 );
  Processor_feature            char(  4 )  pos( 2609 );
  Interactive_feature          char(  4 )  pos( 2613 );
end-ds;

//----------------------------------------------------------------
// Procedure:    Machine_attributes
// Description:  Return information about machine attributes.

dcl-proc Machine_attributes export;

  dcl-pi *n;
    // Returned parameters
    p_System_type                char(  4 );
    p_System_model_number        char(  4 );
    p_Processor_group_ID         char(  4 );
    p_System_processor_feature   char(  4 );
    p_System_serial_number       char( 10 );
    p_Processor_feature          char(  4 );
    p_Interactive_feature        char(  4 );
    // Null indicators for returned parameters
    n_System_type                int( 5 );
    n_System_model_number        int( 5 );
    n_Processor_group_ID         int( 5 );
    n_System_processor_feature   int( 5 );
    n_System_serial_number       int( 5 );
    n_Processor_feature          int( 5 );
    n_Interactive_feature        int( 5 );
    // SQL parameters.
    Sql_State                    char(5);
    Function                     varchar( 517 ) const;
    Specific                     varchar( 128 ) const;
    MsgText                      varchar( 70 );
    CallType                     int( 5 )       const;
  end-pi;

  dcl-pr Materialize_Machine_Attributes extproc( '_MATMATR1' );
    *n likeds( MATMATR_VPD_t );
    *n char( 2 ) const;
  end-pr;

  dcl-s  SaveCallType     like( CallType ) static;  // Save CallType from previous call...

  dcl-ds MATMATR_VPD_info likeds( MATMATR_VPD_t );

  dcl-c  MATMATR_SEL_VPD  x'012C';

  //   Start all fields at not NULL.

  n_System_type              = PARM_NOTNULL;
  n_System_model_number      = PARM_NOTNULL;
  n_Processor_group_ID       = PARM_NOTNULL;
  n_System_processor_feature = PARM_NOTNULL;
  n_System_serial_number     = PARM_NOTNULL;
  n_Processor_feature        = PARM_NOTNULL;
  n_Interactive_feature      = PARM_NOTNULL;

  //  Open, fetch & close...

  select;
    when  CallType = CALL_FETCH;

      // If previous call was for fetch, return EOF.

      if ( CallType = SaveCallType );
        SQL_State = '02000';
        return;
      endif;

      // Get machine attributes.

      monitor;
        Materialize_Machine_Attributes( MATMATR_VPD_info : MATMATR_SEL_VPD );

        p_System_type              = MATMATR_VPD_info.System_type             ;
        p_System_model_number      = MATMATR_VPD_info.System_model_number     ;
        p_Processor_group_ID       = MATMATR_VPD_info.Processor_group_ID      ;
        p_System_processor_feature = MATMATR_VPD_info.System_processor_feature;
        p_System_serial_number     = MATMATR_VPD_info.System_serial_number    ;
        p_Processor_feature        = MATMATR_VPD_info.Processor_feature       ;
        p_Interactive_feature      = MATMATR_VPD_info.Interactive_feature     ;

      on-error *all;
        SQL_State = '38999';
        MsgText = 'Error occurred, please check joblog.';
        return;
      endmon;

  endsl;

  SaveCallType = CallType;

  return;

end-proc;
