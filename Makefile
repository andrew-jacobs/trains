#===============================================================================
#
#                                                                                                                                                   
#-------------------------------------------------------------------------------
# Copyright (C),2020 Andrew John Jacobs.
# All rights reserved.
#
# This work is licensed under a Creative Commons Attribution NonCommercial-
# ShareAlike 4.0 International License.
#
# See here for details:
#
#	https://creativecommons.org/licenses/by-nc-sa/4.0/
#
#===============================================================================

JAVA	=	java -classpath Dev65.jar

AS	=	$(JAVA) uk.co.demon.obelisk.w65xx.As65

LN	=	$(JAVA) uk.co.demon.obelisk.w65xx.Lk65

#===============================================================================
# Rules
#-------------------------------------------------------------------------------

.SUFFIXES:	.asm .obj

.asm.obj:
	$(AS) $<

#===============================================================================
# Targets
#-------------------------------------------------------------------------------

AS_SRCS	= trains.asm

OBJS	= $(AS_SRCS:.asm=.obj)

all:	trains.s19

clean:
	$(RM) *.rom
	$(RM) *.s19
	$(RM) *.obj
	$(RM) *.lst
	$(RM) *.map

trains.s19:	$(OBJS)
	$(LN) -code "0300-1fff" -s19 -output $@ $(OBJS)	

#===============================================================================
# Dependencies
#-------------------------------------------------------------------------------

trains.obj: \
	trains.asm sb-6502.inc ascii.inc
