
# ------------------------------------------------------------------------------
# lua-mpi build instructions
# ------------------------------------------------------------------------------
#
# 1. Make sure you have the MPI sources installed.
#
#
# 2. Optionally, you may install local Lua sources by typing `make lua`.
#
#
# 3. Create a file called Makefile.in which contains macros like these:
#
#    CC = mpicc
#    LUA_HOME = /path/to/lua-5.2.1
#
#    # Additional compile flags are optional:
#
#    CFLAGS = -Wall -O2
#    LVER = lua-5.2.1 # can be lua-5.1 or other
#
#
# 4. Run `python readspec.py` in order to generate wrapper code.
#
#
# 5. Run `make`.
#
# ------------------------------------------------------------------------------

include Makefile.in

CFLAGS ?= -Wall
CURL ?= curl
UNTAR ?= tar -xvf
CD ?= cd
RM ?= rm
OS ?= generic
LVER ?= lua-5.2.1

LUA_I ?= -I$(LUA_HOME)/include
LUA_A ?= -L$(LUA_HOME)/lib -llua


default : main

lua : $(LVER)

$(LVER) :
	$(CURL) http://www.lua.org/ftp/$(LVER).tar.gz -o $(LVER).tar.gz
	$(UNTAR) $(LVER).tar.gz
	$(CD) $(LVER); $(MAKE) $(OS) CC=$(CC); \
		$(MAKE) install INSTALL_TOP=$(PWD)/$(LVER)
	$(RM) $(LVER).tar.gz

main.o : main.c
	$(CC) $(CFLAGS) -c -o $@ $< $(LUA_I)

buffer.o : buffer.c
	$(CC) $(CFLAGS) -c -o $@ $< $(LUA_I)

main : main.o buffer.o
	$(CC) $(CFLAGS) -o $@ $^ $(LUA_I) $(LUA_A)

clean :
	$(RM) *.o main

# Also remove local Lua sources
realclean : clean
	$(RM) -r $(LVER)