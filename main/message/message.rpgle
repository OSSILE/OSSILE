**FREE

///
// Messages
//
// Wrapper for OS message API for making it easier to send and receive
// program messages.
//
// This module has been split up from the RPGUnit framework so that other
// applications can also use it.
//
// Refactored by Mihael Schmidt.
//
// \link http://rpgunit.sourceforge.net RPGUnit
///


ctl-opt nomain;


//
// Prototypes
//
/include 'message_h.rpgle'

dcl-pr QMHRCVPM extpgm('QMHRCVPM');
  msgInfo char(32565) options(*varsize);
  msgInfoLen int(10) const;
  fmtNm char(8) const;
  callStkEnt char(10) const;
  callStkCnt int(10) const;
  msgType char(10) const;
  msgKey char(4) const;
  waitTime int(10) const;
  msgAction char(10) const;
  errorCode char(32565) options(*varsize) noopt;
end-pr;

dcl-pr QMHRMVPM extpgm('QMHRMVPM');
  callStkEnt char(10) const;
  callStkCnt int(10) const;
  msgKey char(4) const;
  msgToRemove char(10) const;
  errorCode char(32565) options(*varsize) noopt;
end-pr;

dcl-pr QMHSNDPM extpgm('QMHSNDPM');
  msgID char(7) const;
  qlfMsgF char(20) const;
  msgData char(256) const;
  msgDataLen int(10) const;
  msgType char(10) const;
  callStkEnt char(10) const;
  callStkCnt int(10) const;
  msgKey char(4);
  error char(1024) options(*varsize) noopt;
end-pr;


//
// Constants
//
// Format Name (most detailed format for QMHRCVPM API)
dcl-c ALL_MSG_INFO_WITH_SENDER_INFO 'RCVM0300';
// The current call stack entry
dcl-c THIS_CALL_STACK_ENTRY '*';
// No message key
dcl-c NO_MSG_KEY const(*blank);
// By message key
dcl-c MSG_KEY '*BYKEY';
// Do not wait for receiving the message.
dcl-c NO_WAIT 0;
// Message action (keep the message in the message queue and mark it as an old message)
dcl-c MARK_AS_OLD '*OLD';
// remove the message after receiving it
dcl-c REMOVE_MSG '*REMOVE';


//
// Templates
//
dcl-ds qusec qualified template;
  bytesProvided int(10);
  bytesAvailable int(10);
  exceptionId char(7);
  reserved char(1);
end-ds;

dcl-ds RCVM0200Hdr qualified template;
  bytesR int(10);
  bytesA int(10);
  msgSev int(10);
  msgId char(7);
  msgType char(2);
  msgKey char(4);
  msgFileNm char(10);
  msgFileLibS char(10);
  msgFileLibU char(10);
  sendingJob char(10);
  sendingUsr char(10);
  sendingJobNb char(6);
  sendingPgmNm char(12);
  sendingPgmSttNb char(4);
  dateSent char(7);
  timeSent char(6);
  rcvPgmNm char(10);
  rcvPgmSttNb char(4);
  sendingType char(1);
  rcvType char(1);
  reserverd1 char(1);
  CCSIDCnvStsIndForTxt int(10);
  CCSIDCnvStsIndForData int(10);
  alertOpt char(9);
  CCSIDMsgAndMsgHlp int(10);
  CCSIDRplData int(10);
  rplDataLenR int(10);
  rplDataLenA int(10);
  msgLenR int(10);
  msgLenA int(10);
  msgHlpLenR int(10);
  msgHlpLenA int(10);
end-ds;

dcl-ds RCVM0300Hdr qualified template;
  bytesR int(10);
  bytesA int(10);
  msgSev int(10);
  msgId char(7);
  msgType char(2);
  msgKey char(4);
  msgFileNm char(10);
  msgFileLibS char(10);
  msgFileLibU char(10);
  alertOpt char(9);
  CCSIDCnvStsIndOfMsg int(10);
  CCSIDCnvStsIndForData int(10);
  CCSIDRplData int(10);
  CCSIDRplDataMsgHlp int(10);
  rplDataLenR int(10);
  rplDataLenA int(10);
  msgLenR int(10);
  msgLenA int(10);
  msgHlpLenR int(10);
  msgHlpLenA int(10);
  sndInfoLenR int(10);
  sndInfoLenA int(10);
end-ds;

dcl-ds RCVM0300Sender qualified template;
  sndJob char(10);
  sndUsrPrf char(10);
  sndJobNb char(6);
  dateSent char(7);
  timeSent char(6);
  sndType char(1);
  rcvType char(1);
  sndPgmNm char(12);
  sndModNm char(10);
  sndProcNm char(256);
  reserved1 char(1);
  sndPgmSttCnt int(10);
  sndPgmSttNb char(30);
  rcvPgmNm char(10);
  rcvModNm char(10);
  rcvProcNm char(256);
  reserved2 char(10);
  rcvPgmSttCnt int(10);
  rcvPgmSttNb char(30);
  reserved3 char(2);
// ...last fields omitted.
end-ds;


//
// Procedures
//
dcl-proc message_receiveMessageInfo export;
  dcl-pi *N likeds(messageInfo_t) end-pi;

  dcl-ds message likeds(message_t);
  dcl-ds messageInfo likeds(messageInfo_t);

  message = message_receiveMessage('*EXCP' : MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE);

  messageInfo.messageId  = message.id;
  messageInfo.message    = message.text;
  messageInfo.programName  = message.sender.programName;
  messageInfo.procedureName = message.sender.procedureName;
  messageInfo.statement  = message.sender.statement;

  return messageInfo;
end-proc;


dcl-proc message_receiveMessageData export;
  dcl-pi *N char(256);
    type char(10) const;
  end-pi;

  dcl-ds message likeds(message_t);

   message = message_receiveMessage(type : MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE);
   return message.replacementData;
end-proc;


dcl-proc message_receiveMessageText export;
  dcl-pi *N char(256);
     type char(10) const;
  end-pi;

  dcl-ds message likeds(message_t);

  message = message_receiveMessage(type : MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE );
  return message.text;
end-proc;


dcl-proc message_receiveMessage export;
  dcl-pi *N likeds(message_t);
    type char(10) const;
    callStackLevelAbove int(10) const options(*nopass);
  end-pi;

  if ( %parms() > 1 );
    return getMessage( MARK_AS_OLD : type : callStackLevelAbove );
  else;
    return getMessage( MARK_AS_OLD : type );
  endIf;

end-proc;


dcl-proc message_removeMessage export;
  dcl-pi *N likeds(message_t);
    type char(10) const;
    callStackLevelAbove int(10) const options(*nopass);
  end-pi;

  if ( %parms() > 1 );
    return getMessage( REMOVE_MSG : type : callStackLevelAbove );
  else;
    return getMessage( REMOVE_MSG : type );
  endIf;

end-proc;


dcl-proc message_removeMessageByKey export;
  dcl-pi *N;
    key char(4) const;
  end-pi;

  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHRMVPM( MESSAGE_CURRENT_CALL_STACK_ENTRY :
            0 :
            key :
            MSG_KEY :
            errorCode );

end-proc;


dcl-proc getMessage;

  dcl-pi *N likeds(message_t);
    action char(10) const;
    type char(10) const;
    callStackLevelAbove int(10) const options(*nopass);
  end-pi;

  // Safe value for the NoPass parameter callStackLevelAbove
  dcl-s safeCallStackLevelAbove int(10);
  // Buffer for message info
  dcl-s rawMsgBuf char(32767);
  dcl-ds rawMsgHdr likeds(RCVM0300Hdr) based(rawMsgHdr_p); // TODO
  // Position in buffer (starting at 1)
  dcl-s bufPos int(10);
  // Buffer for message sender info
  dcl-ds senderInfo likeds(RCVM0300Sender) based(senderInfo_p); // TODO
  // The received message
  dcl-ds message likeds(message_t);

  dcl-ds errorCode likeds(qusec);

  if (%parms() > 2);
    safeCallStackLevelAbove = callStackLevelAbove;
  else;
    safeCallStackLevelAbove = 0;
  endif;

  // another stack entry was added when this logic was refactored to an internal sub-procedure
  safeCallStackLevelAbove += 1;

  clear errorCode;

  QMHRCVPM(rawMsgBuf :
           %size(rawMsgBuf) :
           ALL_MSG_INFO_WITH_SENDER_INFO :
           THIS_CALL_STACK_ENTRY : // TODOO ???
           MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE + safeCallStackLevelAbove :
           type :
           NO_MSG_KEY :
           NO_WAIT :
           action :
           errorCode);
  rawMsgHdr_p = %addr( rawMsgBuf );

  if (rawMsgHdr.bytesA = 0);
      message_sendEscapeMessageToCaller(%trim(type) + ' message not found');
  endif;

  message.id = rawMsgHdr.msgId;
  message.key = rawMsgHdr.msgKey;

  bufPos = %size(rawMsgHdr) + 1;
  message.replacementData = %subst(rawMsgBuf : bufPos : rawMsgHdr.rplDataLenR);

  bufPos += rawMsgHdr.rplDataLenR;
  message.text = %subst(rawMsgBuf : bufPos : rawMsgHdr.msgLenR);

  bufPos += rawMsgHdr.msgLenR;
  bufPos += rawMsgHdr.msgHlpLenR;
  senderInfo_p = %addr(rawMsgBuf) + bufPos - 1;
  message.sender.programName  = senderInfo.sndPgmNm;
  message.sender.procedureName = senderInfo.sndProcNm;
  message.sender.statement  = senderInfo.sndPgmSttNb;

  return message;
end-proc;


dcl-proc message_sendCompletionMessage export;
  dcl-pi *N;
    message char(256) const;
  end-pi;

  // The message reference key.
  dcl-s messageKey char(4);
  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHSNDPM('CPF9897' :
           'QCPFMSG   *LIBL' :
           %trimr(message) :
           %len(%trimr(message)) :
           MESSAGE_TYPE_COMPLETION :
           MESSAGE_CONTROL_BOUNDARY :
           MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE :
           messageKey :
           errorCode);
end-proc;


dcl-proc message_sendEscapeMessage export;
  dcl-pi *N;
    message char(256) const;
    callStackLevelAbove int(10) const;
  end-pi;

  // The message reference key.
  dcl-s messageKey char(4);
  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHSNDPM('CPF9897' :
           'QCPFMSG   *LIBL' :
           %trimr(message) :
           %len(%trimr(message)) :
           MESSAGE_TYPE_ESCAPE :
           MESSAGE_CURRENT_CALL_STACK_ENTRY :
           MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE + callStackLevelAbove :
           messageKey :
           errorCode);
end-proc;


dcl-proc message_sendEscapeMessageToCaller export;
  dcl-pi *N;
    message char(256) const;
  end-pi;

  message_sendEscapeMessage(message : MESSAGE_TWO_CALL_STACK_LEVEL_ABOVE);
end-proc;


dcl-proc message_sendEscapeMessageAboveControlBody export;
  dcl-pi *N;
    message char(256) const;
  end-pi;

  // The message reference key
  dcl-s messageKey char(4);
  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHSNDPM('CPF9897' :
           'QCPFMSG   *LIBL' :
           %trimr(message) :
           %len(%trimr(message)) :
           MESSAGE_TYPE_ESCAPE :
           MESSAGE_CONTROL_BOUNDARY :
           MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE :
           messageKey :
           errorCode);
end-proc;


dcl-proc message_sendInfoMessage export;
  dcl-pi *N;
    message char(256) const;
  end-pi;

  // The message reference key
  dcl-s messageKey char(4);
  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHSNDPM(*blank :    // TODO Create generic identifier.
           'QCPFMSG   *LIBL' :
           %trimr(message) :
           %len(%trimr(message)) :
           MESSAGE_TYPE_INFORMATION :
           MESSAGE_CURRENT_CALL_STACK_ENTRY :
           MESSAGE_ONE_CALL_STACK_LEVEL_ABOVE :
           messageKey :
           errorCode);
end-proc;


dcl-proc message_sendStatusMessage export;
  dcl-pi *N;
    message char(256) const;
  end-pi;

  // The message reference key
  dcl-s messageKey char(4);
  dcl-ds errorCode likeds(qusec);

  clear errorCode;

  QMHSNDPM('CPF9897' :
           'QCPFMSG   *LIBL' :
           %trimr(message) :
           %len(%trimr(message)) :
           MESSAGE_TYPE_STATUS :
           '*EXT' :
           *zero :
           messageKey :
           errorCode);
end-proc;
