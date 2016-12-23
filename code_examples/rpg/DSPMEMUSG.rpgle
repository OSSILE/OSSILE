**FREE

///
// Display Memory Usage
//
// Displays the memory usage of a job grouped by activation group. It displays
// the static memory usage, heap memory usage and number of heaps on the stack.
//
// If no parameter is passed the memory of the current job will be displayed.
//
// \author Mihael Schmidt
// \date   2016-12-14
///


ctl-opt main(main);


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('DSPMEMUSG');
  job char(26) const options(*nopass);
end-pr;

dcl-pr getActivationGroupAttr extpgm('QWVOLAGP');
  receiver char(65535) options(*varsize);
  recLength int(10) const;
  listInfo char(80);
  numberRecords int(10) const;
  format char(8) const;
  job char(26) const;
  intJobId char(16) const;
  error likeds(QUSEC) options(*varsize);
end-pr;

dcl-pr closeList extpgm('QGYCLST');
  listHandle char(4);
  error int(10);
end-pr;


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
// OS API Error Data Structure
/include QSYSINC/QRPGLESRC,QUSEC

dcl-ds raga0100 qualified template;
  actGroupName char(10);
  reserved1 char(6);
  actGroupNumber int(10);
  numberActGroups int(10);
  numberHeaps int(10);
  staticSize int(10);
  heapSize int(10);
  rootPgmName char(10);
  rootPgmLib char(10);
  rootPgmType char(1);
  actGroupState char(1);
  shrActGroupInd char(1);
  inUse char(1);
  reserved2 char(4);
  actGroupNumberLong int(20);
  reserved3 char(8);
end-ds;

dcl-ds listInfo_t qualified template;
  listTotal int(10);
  listReturned int(10);
  listHandle char(4);
  listRecLen int(10);
  listComplete char(1);
  listDate char(13);
  listStatus char(1);
  dummy1 char(1);
  listLength int(10);
  listFirst int(10);
  dummy2 char(40);
end-ds;


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;
  dcl-pi *N;
    job char(26) const options(*nopass);
  end-pi;

  dcl-s receiver char(65355);
  dcl-ds format likeds(raga0100) based(formatPtr);
  dcl-ds listInfo likeds(listInfo_t);
  dcl-s i int(10);
  dcl-s intRetVal int(10);

  clear QUSEC;

  getActivationGroupAttr( receiver :
                          %len(receiver) :
                          listInfo :
                          %len(receiver) / %size(raga0100) :
                          'RAGA0100' :
                          '*' :
                          '' :
                          QUSEC);

  for i = 0 to listInfo.listReturned - 1;
    formatPtr = %addr(receiver) + (i * listInfo.listRecLen);
    dsply %trimr(format.actGroupname + ' ' +
          %char(format.staticSize) + ' / ' +
          %char(format.heapSize) +
          '(' + %char(format.numberHeaps) + ')');
  endfor;

  // close list
  closeList(listInfo.listHandle : intRetVal);
end-proc;
