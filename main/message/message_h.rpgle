**FREE

/if not defined (MESSAGE)
/define MESSAGE       

//----------------------------------------------------------------------
// Message Constants
//----------------------------------------------------------------------

// Call stack levels.
dcl-c MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE 1;
dcl-c MESSAGE_TWO_CALL_STACK_LEVEL_ABOVE 2;

// To resend the last new escape message
dcl-c MESSAGE_LAST_NEW_ESCAPE_MESSAGE const(*blank);

// Call stack entry (current call stack entry)
dcl-c MESSAGE_CURRENT_CALL_STACK_ENTRY '*';
// Control boundary
dcl-c MESSAGE_CONTROL_BOUNDARY '*CTLBDY';


//----------------------------------------------------------------------
// Message Data Structures (Templates)
//----------------------------------------------------------------------
dcl-ds messageInfo_t qualified template;
  messageId char(7);
  message char(256);
  // Sending Program Name
  programName char(12);
  // Sending Procedure Name
  procedureName char(256);
  // Sending Statement Number
  statement char(10);
end-ds;

// Program Message
dcl-ds message_t qualified template;
  id char(7);
  text varchar(254);
  replacementData varchar(254);
  sender likeds(messageSender_t);
end-ds;

// Program Message Sender
dcl-ds messageSender_t qualified template;
  programName char(12);
  procedureName char(256);
  statement char(6);
end-ds;


//-------------------------------------------------------------------------------------------------
// Message Prototypes
//-------------------------------------------------------------------------------------------------

// Receive exception message
dcl-pr message_receiveMessageInfo likeds(messageInfo_t) extproc(*dclcase) end-pr;

// Receive a program message replacement data
dcl-pr message_receiveMessageData char(256) extproc(*dclcase);
  // Message type: *ANY, *COMP, *EXCP...
  type char(10) const;
end-pr;

// Receive a program message text.
dcl-pr message_receiveMessageText char(256) extproc(*dclcase);
  // Message type: *ANY, *COMP, *EXCP...
  type char(10) const;
end-pr;

// Receive a program message.
dcl-pr message_receiveMessage likeds(message_t) extproc(*dclcase);
  // Message type: *ANY, *COMP, *EXCP...
  type char(10) const;
  // If the message was sent to a procedure above in the call stack,
  // indicate how many level above it is.
  callStackLevelAbove int(10) const options(*nopass);
end-pr;

// Resend an escape message that was monitored in a monitor block.
dcl-pr message_resendEscapeMessage extpgm('QMHRSNEM');
  messageKey char(4) const;
  errorCode char(32565) const options(*varsize) noopt;
end-pr;

// Send a completion message
dcl-pr message_sendCompletionMessage extproc(*dclcase);
  message char(256) const;
end-pr;

// Send an escape message...
// ...to any call stack entry.
dcl-pr message_sendEscapeMessage extproc(*dclcase);
  message char(256) const;
  callStackLevel int(10) const;
end-pr;

// Send an escape message...
// ...to the procedure's caller.
dcl-pr message_sendEscapeMessageToCaller extproc(*dclcase);
  message char(256) const;
end-pr;

// Send an escape message...
// ...to the call stack entry just above the Control Boundary.
// Useful to terminate a program.
dcl-pr message_sendEscapeMessageAboveControlBody extproc(*dclcase);
  message char(256) const;
end-pr;

// Send an information message.
dcl-pr message_sendInfoMessage extproc(*dclcase);
  message char(256) const;
end-pr;

// Send a status message.
dcl-pr message_sendStatusMessage extproc(*dclcase);
  message char(256) const;
end-pr;

/endif
