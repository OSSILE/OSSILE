**FREE

///
// \brief XML Input Provider
// 
// This module implements the input provider procedures and parses the passed
// XML file for item entries via the XML built-in functions.
//
// The xml handler procedure looks for an XML entry "item" which should contain
// the XML entries id, description and manufacturer. All item values should be
// XML characters (not XML attributes).
// 
// \author Mihael Schmidt
// \date 20.11.2016
///


ctl-opt nomain;


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
/include 'input_t.rpgle'

dcl-ds input_xml_t qualified template;
  path char(1024);
  loaded ind;
  items likeds(item_t) dim(100);
  itemCount int(10);
  currentItemIndex int(10);
end-ds;

dcl-ds xmldata_t qualified template;
  itemCount int(10);
  items likeds(item_t) dim(100);
  lastElement char(100);
end-ds;


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
/include 'input_xml_h.rpgle'

dcl-pr xmlHandler int(10);
  commArea likeds(xmldata_t);
  event int(10) value;
  string pointer value;
  stringLen int(20) value;
  exceptionId int(10) value;
end-pr;

dcl-pr getNextItem likeds(item_t);
  userData likeds(input_xml_t);
end-pr;


//-------------------------------------------------------------------------------------------------
// Procedures
//-------------------------------------------------------------------------------------------------
dcl-proc input_xml_load export;
  dcl-pi *N likeds(item_t);
    inputProvider pointer const;
  end-pi;

  dcl-ds inputDs likeds(input_t) based(inputProvider);
  dcl-ds userData likeds(input_xml_t) based(inputDs.userData);
  dcl-ds item likeds(item_t);

  item = getNextItem(userData);

  return item;
end-proc;


dcl-proc input_xml_finalize export;
  dcl-pi *N;
    inputProvider pointer;
  end-pi;

  dcl-ds inputDs likeds(input_t) based(inputProvider);
  dcl-ds userDataDs likeds(input_xml_t) based(inputDs.userData);

  // clean up allocated memory for the input provider
  dealloc inputDs.userData;
  dealloc(n) inputProvider;
end-proc;

dcl-proc input_xml_create export;
  dcl-pi *N pointer;
    userData pointer const options(*string);
  end-pi;

  dcl-s ptr pointer;
  dcl-ds inputDs likeds(input_t) based(ptr);
  dcl-s userDataPtr pointer;
  dcl-ds userDataDs likeds(input_xml_t) based(userDataPtr);

  ptr = %alloc(%size(input_t));

  userDataPtr = %alloc(%size(input_xml_t));
  clear userDataDs;
  userDataDs.path = %str(userData);
  userDataDs.loaded = *off;
   
  inputDs.userData = userDataPtr;
  inputDs.proc_load = %paddr('input_xml_load');
  inputDs.proc_finalize = %paddr('input_xml_finalize');

  return ptr;
end-proc;

///
// Get next item from XML file
//
// This procedure loads the data from the XML file if it has not been loaded yet.
// 
// It returns the next item. The current item index is stored in the passed
// user data data structure.
//
// \param Input provider user data
//
// \return next item or an empty item data structure if no more items has been loaded
///
dcl-proc getNextItem;
  dcl-pi *N likeds(item_t);
    userData likeds(input_xml_t);
  end-pi;
  
  dcl-ds xmlCommArea likeds(xmldata_t) static;
  dcl-ds item likeds(item_t);
  
  clear item;
  
  if (userData.loaded = *off);
    clear xmlCommArea;
    xml-sax %handler(xmlHandler : xmlCommArea) %xml(%trimr(userData.path) : 'doc=file');
    userData.loaded = *on;
    userData.itemCount = xmlCommArea.itemCount;
    userData.items = xmlCommArea.items;
  endif;
  
  userData.currentItemIndex += 1;
  if (userData.currentItemIndex > userData.itemCount);
    userData.currentItemIndex = 0;
    userData.loaded = *off;
    clear userData.items;
    userData.itemCount = 0;
  else;
    item = userData.items(userData.currentItemIndex);
  endif;
  
  return item;
end-proc;

///
// XML handler procedure for loading xml item data
//
// All item data and item count is stored in the communication area data
// structure.
///
dcl-proc xmlHandler;
  dcl-pi *N int(10);
    commArea likeds(xmldata_t);
    event int(10) value;
    string pointer value;
    stringLen int(20) value;
    exceptionId int(10) value;
  end-pi;

  dcl-s value char(1000) based(string);
  dcl-s tmp char(100);
  dcl-s retVal int(10);
  dcl-s fieldLength uns(10);

  select;
    when (event = *XML_START_ELEMENT);
      commArea.lastElement = %subst(value : 1 : stringLen);

      if (commArea.lastElement = 'item');
        commArea.itemCount += 1;
      endif;

    when (event = *XML_CHARS);
      if (commArea.lastElement = 'id');
        commArea.items(commArea.itemCount).id = %trim(%subst(value : 1 : stringLen));
      elseif (commArea.lastElement = 'description');
        commArea.items(commArea.itemCount).description = %trim(%subst(value : 1 : stringLen));
      elseif (commArea.lastElement = 'manufacturer');
        commArea.items(commArea.itemCount).vendor = %trim(%subst(value : 1 : stringLen));
      endif;

    when (event = *XML_END_ELEMENT);
      commArea.lastElement = *blank;

  endsl;

  return retVal;
end-proc;
