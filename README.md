# 65(C)02 Assembler Demo
This repository contains the 65C02 source for a partial implementation of the Linux 'sl' command that draws an animated train on the screen when the user mistypes 'ls'.

The code uses the structured programming facilities of my assembler.

This implementation serves as an example of how to build a simple application using my portable Dev65 assembler tool suite and has been tested under Windows 10 and Ubuntu 18.04. It should build on other *NIX systems provided you have a Java 1.8 compatible runtime installed.

The NMAKE.* and *.BAT files are only needed on a Windows system.

More documentation for the assembler and tools can be found here http://www.obelisk.me.uk/dev65/index.html

If you want to use this as the starting point for your own application then remember to update the definitions in the Makefile.

Notes:

- Linker addresses can only be defined in hexadecimal. Don't prefix them with '$'.
