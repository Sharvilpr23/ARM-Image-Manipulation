


# "make" and "make bigfact" are the same thing: build the factorial program
# "make clean" cleans up
# "make realclean" cleans even better
# "make depend" Creates the dependencies to help make know what needs to be
#               rebuilt. You only need to run this once after unpacking.
# "make tarfile" Does a "make realclean" then creates a compressed tar file.

# Change the following two lines to your first and last name, ALL LOWERCASE.

FIRST_NAME=program1
LAST_NAME=CSC314

# You can add more assembly files as you go.  Just edit the C code and
# put #ifdef around the function you want to change to assembly (look
# at bigint_adc() for an example), then create the new assembly (.S)
# file and add it to the ASMOBJS list.  Use .o instead of .S in the
# ASMOBJS list, and make will find the .S file. Do "make clean" to
# force a complete rebuild.


CC = gcc

COBJS = main.o helpers.o blendImage.o \
	readwriteImage.o sharpenImage.o \
	contrastImage.o subsampleImage.o \
	smoothImage.o negateImage.o \
	brightenImage.o grayscaleImage.o 
ASMOBJS = 
INCLUDES = -I.
LIBDIRS = 
LIBS = 
DEFINES = 
CFLAGS = -g -Wall 
LFLAGS = -g 
DEPENDFLAGS = -M 



imagetool: $(COBJS) $(ASMOBJS)
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $(COBJS) $(ASMOBJS) $(LIBDIRS) $(LIBS)

.c.o:
	$(CC) -c $(DEFINES) $(CFLAGS) $(INCLUDES) $<

.s.o:
	$(CC) -c $(DEFINES) $(CFLAGS) $(INCLUDES) $<

.S.o:
	$(CC) -c $(DEFINES) $(CFLAGS) $(INCLUDES) $<

tarfile: realclean
	rm -f $(LAST_NAME)_$(FIRST_NAME).tgz
	cp -rp .. /tmp/$(LAST_NAME)_$(FIRST_NAME)
	cd /tmp; tar cfz $(LAST_NAME)_$(FIRST_NAME).tgz $(LAST_NAME)_$(FIRST_NAME)
	mv /tmp/$(LAST_NAME)_$(FIRST_NAME).tgz ../..
	rm -rf /tmp/$(LAST_NAME)_$(FIRST_NAME)
	make depend


clean:
	rm -f *.o imagetool

realclean: clean
	rm -f *~ .depend

# make depend will create a file ".depend" with all the dependencies
depend:
	rm -f .depend
	$(CC) $(DEFINES) $(INCLUDES) $(DEPENDFLAGS) $(COBJS:.o=.c) > .depend

# if we have a .depend file, include it

ifeq (.depend,$(wildcard .depend))
include .depend
endif
