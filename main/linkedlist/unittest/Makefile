#
# Makefile for Linked List Unit Tests
#


#
# NOTE: You need the RUTESTCASE and LLIST service program in your current 
#       library to build the test cases.
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
CFLAGS=DBGVIEW(*LIST) INCDIR('$(INCLUDE)')

# LFLAGS = binding parameter
# (make sure modules and service programs are in library list)
LFLAGS=BNDDIR(QC2LE) BNDSRVPGM(LLIST)

FROM_CCSID=37

#
# User-defined part end
#-------------------------------------------------------------------------------


MODULES = llist_ut_1
OBJECTS = $(BIN_LIB)/llist_ut_1


.SUFFIXES: .rpgle .c .cpp

# suffix rules
.rpgle:
	system "CRTRPGMOD $(BIN_LIB)/$@ SRCSTMF('$<') $(CFLAGS)"
	system "crtsrvpgm $(BIN_LIB)/llist_ut_1  export(*all) bndsrvpgm(rutestcase llist)"
	
all: build

.PHONY:	

llist_ut_1:

build: $(MODULES)
		
clean:
	-system "DLTMOD $(BIN_LIB)/LLIST_UT_1"
	-system "DLTSRVPGM $(BIN_LIB)/LLIST_UT_1"
