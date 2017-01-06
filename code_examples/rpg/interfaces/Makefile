#
# Build script for input interface example
#

# BIN_LIB is the destination library for the program.
BIN_LIB=OSSILE
# to this library the prototype source file (copy book) is copied in the install step
INCLUDE=/usr/local/include

OBJECTS = INPUT INPUT_XML INPUTTEST

FROM_CCSID=37
        
all: clean compile

compile: $(OBJECTS)

INPUT:
	system "CRTRPGMOD MODULE($(BIN_LIB)/INPUT) SRCSTMF('input.rpgle') DBGVIEW(*ALL) INCDIR('$(INCLUDE)')"

INPUT_XML:
	system "CRTRPGMOD MODULE($(BIN_LIB)/INPUT_XML) SRCSTMF('input_xml.rpgle') DBGVIEW(*ALL) INCDIR('$(INCLUDE)')"

INPUTTEST:
	-system "CRTBNDDIR $(BIN_LIB)/INPUT"
	-system "ADDBNDDIRE BNDDIR($(BIN_LIB)/INPUT) OBJ(($(BIN_LIB)/INPUT *MODULE))"
	-system "ADDBNDDIRE BNDDIR($(BIN_LIB)/INPUT) OBJ(($(BIN_LIB)/INPUT_XML *MODULE))"
	-system "ADDBNDDIRE BNDDIR($(BIN_LIB)/INPUT) OBJ((*LIBL/LLIST *SRVPGM))"
	system "CRTBNDRPG PGM($(BIN_LIB)/INPUTTEST) SRCSTMF('inputtest.rpgle') DFTACTGRP(*NO) ACTGRP(*CALLER) DBGVIEW(*ALL) INCDIR('$(INCLUDE)') BNDDIR($(BIN_LIB)/INPUT)"

clean:
	-system "DLTMOD $(BIN_LIB)/INPUT"
	-system "DLTMOD $(BIN_LIB)/INPUT_XML"
	-system "DLTPGM $(BIN_LIB)/INPUTTEST"
	-system "DLTBNDDIR $(BIN_LIB)/INPUT"
		
.PHONY:
