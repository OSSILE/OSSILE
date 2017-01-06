**FREE

///
// \brief Input Interface : Main Program
//
// This the main program which call/uses the input interface. In this example
// it will first create the xml input provider and then use the interface
// procedures to read the data from an xml file.
//
// The program expects the XML file to have the name "data.xml" and should be 
// in the current directory. The current directory can be set with the command
// CHGCURDIR '/my/path/to/the/data/file' .
//
// \author Mihael Schmidt
// \date 21.11.2016
///


ctl-opt main(main);


//-------------------------------------------------------------------------------------------------
// Data Structures
//-------------------------------------------------------------------------------------------------
/include 'input_t.rpgle'


//-------------------------------------------------------------------------------------------------
// Prototypes
//-------------------------------------------------------------------------------------------------
dcl-pr main extpgm('INPUTTEST') end-pr;

/include 'input_h.rpgle'
/include 'input_xml_h.rpgle'


//-------------------------------------------------------------------------------------------------
// Program Entry Point
//-------------------------------------------------------------------------------------------------
dcl-proc main;

  dcl-s input pointer;
  dcl-s inputProvider pointer;
  dcl-ds item likeds(item_t);

  // creates the instance of the xml input provider
  inputProvider = input_xml_create('data.xml');

  // load the data via the input provider
  item = input_load(inputProvider);
  dow (item.id <> *blank);
    dsply item.id;      
    item = input_load(inputProvider);
  enddo;

  // cleanup the input provider
  input_finalize(inputProvider);
end-proc;
