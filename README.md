# Instruction guide in setting up the building environment for stm32f103c8t6

## This guide is the combination of multiple online resources that helps you build a bare-bone environment for building stm32f1 executables. This outube tutorial [Bare metal embedded](https://www.youtube.com/watch?v=qWqlkCLmZoE&list=PLERTijJOmYrDiiWd10iRHY0VRHdJwUH4g), gives an overview of the mechanics of the arm cross-compiler, and how to build a makefile that generates the .elf file. This guide, however, does not 100% follow the youtube tutorial, instead, this guide looks into the [libopencm3-miniblink](https://github.com/libopencm3/libopencm3-miniblink) environment, tries to understand it, and shortens it to suit our required needs, which is the stm32f103c8t6 in this case.

Documents that are usefull in setting up this environment: [Using the GNU Compiler Collection](https://gcc.gnu.org/onlinedocs/gcc/)

---


> ### The Build Process overview:  
> The compiling process of a computer is not an easy task, the source code goes through multiple stages before it is readable to the computer.  
> In general, the compiler has three stages, which includes the *preprocessing stage*, the *code generation stage*, and the *assembler stage*, after these three stages, the .c file was converted in to the .i, .s, and finally .o file. The .o file is called the **relocatable object file**, which is essentially the opcodes of that the computer is able to interprete, however, the object files has not been specified its memory location, which means that it does not know where in the flash memory of stm32 should the instructions be placed. To assign the instructions to our desired location, which is often dependent on which microcontroller we're using, the .o files has to go through a *linking stage* to produce an **executable and linkable file**, or .elf file. Finally, using the *objcopy tool*, the .elf files can be converted into .bin or .ihex format, which can be used flashed into the microcontroller.  
> All these complicated steps can be achieved by using the arm cross compiler, in this case, arm-none-eabi-gcc.

Now lets look into the important files in the miniblink repository.  

  * libopencm3-miniblink
    * libopencm3
    * cortex-m-generic.ld
    * ld.stm32.basic
    * Makefile
    * boards.stm32.mk
    * template_stm32.c
    * bin
      * stm32

These files listed above are the necessary files to build a stm32f1 executable, of course, with some minor modifications in the content.  

The libopencm3 file is the library for arm cortex m series microcontrollers, our main program could include necessary header files from this library.  

The ld.stm32.basic and cortex-m-generic.ld files are linker scripts, the cortex-m-generic.ld file is included inside the ld.stm32.basic. the generic linker script need no changes when switching between different controllers, while the starting address and the size of ROM and RAM is defined inside ld.stm32.basic. In therory, they can be combined in a single file, however in miniblink's case, it is generating multiple executable for various types of microcontrollers, therefore it was delibrately divided into two files.  
One thing I don't personally yet understand is where the startup file containing the vector table is.  

The boards.stm32.mk and Makefile contains all commands executed when we type `make` in the terminal, which uses the `arm-none-eabi-gcc` command to compile the source file to .elf, then using `objcopy` to further generate .bin and .hex files in the bin folder. These two files are quite complex as they are designed to generate multiple files for different variants of stm32 boards, I have eliminated most commands that are responsible for the unwanted files. If I had the time, I may rewrite a Makefile that is cleaner and easier to read.  
Note that before compiling, you would need to change the variable `SRC_FILE_NAME` in boards.stm32.mk to the name of the source file that you want to compile.  

Finally the template_stm32.c is where the source file is, which is simply the c code that we want to compile, simply put the source file in this directory, modify `SRC_FILE_NAME` inside boards.stm32.mk and type `make`, and the binarys would pop up inside bin/stm32/.  
