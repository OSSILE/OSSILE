#
# Build script for Arraylist
#

#-----------------------------------------------------------
# User-defined part start
#

# BIN_LIB is the destination library for the service program.
# the rpg modules and the binder source file are also created in BIN_LIB.
# binder source file and rpg module can be remove with the clean step (make clean)
BIN_LIB=QGPLE

# to this library the prototype source file (copy book) is copied in the install step
INCLUDE=/usr/local/include

# RCFLAGS = RPG compile parameter
RCFLAGS=OPTION(*SRCSTMT) DBGVIEW(*LIST) INCDIR('$(INCLUDE)') OPTIMIZE(*BASIC) STGMDL(*INHERIT)

# CCFLAGS = C compiler parameter
CCFLAGS=OPTIMIZE(30) DBGVIEW(*LIST)

# LFLAGS = binding parameter
LFLAGS=BNDDIR(QC2LE) OPTION(*DUPPROC) STGMDL(*INHERIT)

FROM_CCSID=37

#
# User-defined part end
#-----------------------------------------------------------


OBJECTS = arraylist
 
 
.SUFFIXES: .rpgle .c .cpp
 
# suffix rules
.rpgle:
	system "CRTRPGMOD $(BIN_LIB)/$@ SRCSTMF('$<') $(RCFLAGS)"
        
all: clean compile
 
arraylist:

 
compile: arraylist.bnd $(OBJECTS)
	system "CRTSRVPGM $(BIN_LIB)/ARRAYLIST MODULE($(BIN_LIB)/ARRAYLIST) $(LFLAGS) EXPORT(*SRCFILE) SRCFILE($(BIN_LIB)/ALISTSRV) TEXT('Arraylist')" 
	
arraylist.bnd: .PHONY
	-system "CRTSRCPF $(BIN_LIB)/ALISTSRV RCDLEN(112)"
	-system "CPYFRMIMPF FROMSTMF('$@') TOFILE($(BIN_LIB)/ALISTSRV ARRAYLIST) RCDDLM(*ALL) STRDLM(*NONE) RPLNULLVAL(*FLDDFT)    

install: arraylist.bnd
	cp arraylist_h.rpgle $(INCLUDE)
	setccsid $(FROM_CCSID) $(INCLUDE)/arraylist_h.rpgle

clean:
	-system "DLTMOD $(BIN_LIB)/ARRAYLIST"
	-system "DLTF $(BIN_LIB)/ALISTSRV"

dist-clean: clean
	-system "DLTSRVPGM $(BIN_LIB)/ARRAYLIST"
	
.PHONY:
