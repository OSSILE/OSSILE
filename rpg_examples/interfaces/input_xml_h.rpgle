**FREE

/if not defined (INPUT_XML_H)
/define INPUT_XML_H

///
// \brief XML Input Provider : Prototypes
// 
// \author Mihael Schmidt
// \date 20.11.2016
///

//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------


///
// Create XML Input Provider instance
//
// The data structure for the XML input provider is created, initialized and
// returned (or at least a pointer to the data structure).
//
// The caller to this procedure must call the finalize procedure to free the
// allocated memory.
//
// \param null-terminated path to the XML file
//
// \return Returns a pointer to the XML input provider data structure
///
dcl-pr input_xml_create pointer extproc('input_xml_create');
  userData pointer const options(*string);
end-pr;

dcl-pr input_xml_load likeds(item_t) extproc('input_xml_load');
  inputProvider pointer const;
end-pr;
  
dcl-pr input_xml_finalize extproc('input_xml_finalize');
  inputProvider pointer;
end-pr;
  
/endif
