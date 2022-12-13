

# Nicholas Trambitas
# Lab 6 makefile
#
all:  tags headers 


headers: *.c tags
	headers.sh

tags: *.c
	ctags -R .

atest: atest.o analyze.s a_shim.o evaluate.o
	gcc -g -m64  -o $@ $^ 

lab6: lab6.o analyze.s search.s a_shim.o s_shim.o print.o evaluate.o
	gcc -g -m64  -o $@ $^ 

# create your own entry to build your lab 6 zipfile

# Don't use this - it was used to create the zipfile full of lab 6
# materials and stuff you use in lab 6.
l6_files.zip: lab6.c atest.c *.h a_shim.o s_shim.o makefile *.txt print.o evaluate.o
	# make the lab 6 tools zip
	zip $@ $^ 


# this is our master compiler rule to generate .o files.
# It needs all 4 warnings

%.o:%.c *.h
	gcc -ansi -pedantic -Wimplicit-function-declaration -Wreturn-type -g -c $< -o $@


