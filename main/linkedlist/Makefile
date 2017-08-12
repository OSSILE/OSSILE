#
# Build script for Linked List
#

#-------------------------------------------------------------------------------
# User-defined part start
#

# BIN_LIB is the destination library for the service program.
# the rpg modules and the binder source file are also created in BIN_LIB.
# binder source file and rpg module can be remove with the clean step (make clean)
BIN_LIB=QGPL

# to this library the prototype source file (copy book) is copied in the install step
INCLUDE=/usr/local/include

# CFLAGS = RPG compile parameter
RCFLAGS=OPTION(*SRCSTMT) DBGVIEW(*LIST) INCDIR('$(INCLUDE)') OPTIMIZE(*BASIC) STGMDL(*INHERIT)

# CCFLAGS = C compiler parameter
CCFLAGS=OPTIMIZE(30) DBGVIEW(*LIST)

# LFLAGS = binding parameter
LFLAGS=BNDDIR(QC2LE) STGMDL(*INHERIT)

FROM_CCSID=37

#
# User-defined part end
#-------------------------------------------------------------------------------


OBJECTS = llist llist_sort
 
 
.SUFFIXES: .rpgle .c .cpp
 
# suffix rules
.rpgle:
	system "CRTRPGMOD $(BIN_LIB)/$@ SRCSTMF('$<') $(RCFLAGS)"
        
all: clean compile
 
llist:
llist_sort:

 
compile: llist.bnd $(OBJECTS)
	system "CRTSRVPGM $(BIN_LIB)/LLIST MODULE($(BIN_LIB)/LLIST $(BIN_LIB)/LLIST_SORT) $(LFLAGS) EXPORT(*SRCFILE) SRCFILE($(BIN_LIB)/LLISTSRV) TEXT('Linked List')" 
	
llist.bnd: .PHONY
	-system "CRTSRCPF $(BIN_LIB)/LLISTSRV RCDLEN(112)"
	-system "CPYFRMIMPF FROMSTMF('$@') TOFILE($(BIN_LIB)/LLISTSRV LLIST) RCDDLM(*ALL) STRDLM(*NONE) RPLNULLVAL(*FLDDFT)    

install: llist.bnd
	cp llist_h.rpgle $(INCLUDE)
	cp llist_so_h.rpgle $(INCLUDE)
	setccsid $(FROM_CCSID) $(INCLUDE)/llist_*

clean:
	-system "DLTMOD $(BIN_LIB)/LLIST"
	-system "DLTMOD $(BIN_LIB)/LLIST_SORT"
	-system "DLTF $(BIN_LIB)/LLISTSRV"

dist-clean: clean
	-system "DLTSRVPGM $(BIN_LIB)/LLIST"
	
.PHONY:
