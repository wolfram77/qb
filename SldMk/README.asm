+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++3DS File Handler+++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Version 1.3

Hello Friends(or Jigdi dost),
It must have been a difficult task to make sprites for your games.
So, here you get a program that can build an easy file format 
for sprites. i liked to call it a 3ds file. 
Warning: You can load only 24-bit bitamp files!!
There are many more features that you will discover as you
make use of it.

Instructions
==========
1. rename 3dsMake.exx as 3dsMake.exe(if exe isn't present)
3. for anything mail me at :: qbasic40@gmail.com
4. 3dsMake.txt contains the source code.(Microsoft QuickBasic 4.0)
5. engine.asm contains the assembly program for engine.dll
(engine.asm format is the format of my own 8086 ASM compiler
that uses DEBUG.COM for converting to machine code)
5.5. You can mail me for asmdebug which i used to make the asm programs
6. please mail me your programs...
7. hey wait, read some more

MENU
All menus are located on the top-left corner of the screen.You can make
plenty of use of them. I hope you will feel them easy to use.
(Don't mind, but they are little slow)

BUTTON AREA
The button area is located just after the menu.
button 1 = Save to 3ds file (circular one)
button 2 = Previous Slide
button 3 = Next Slide
button 4 = Slide Extend  (increase the no. of slide)

SLIDE NUMBER AREA
box 1 = Current Slide number being used
box 2 = Total Slides

BUTTON AREA 2
The buttons are below the menu in the left.
button 1 = Open a 24-bit BMP file (to the current slide)
button 2 = Open a 3ds file (Completely, or a specific slide)
button 3 = Slide paste (paste current slide to another slide)

COLOUR BOX
The colour box is located at the left bottom corner.
Just click to choose colour.

FILE NAME
Below the menu is a box which displays the file name.

MESSAGE BOX
Beside the colour box is a long message box which displays several
messages.

RESOLUTION
The box below the message box is the resolution which displays the
current resolution (X * Y)

SCROLL BAR
The scroll bar is located at the rightmost and the bottommost
The scroll bar moves only when you click at the
small circles at the ends.
Right Click= scroll 1  pixel
Left  click= scroll 2 pixels
Left+Right click = scroll 5 pixels

The windows that ask for input can take input only when you
click at the blank boxes.

Please dont choose a wrong file as a 3ds file or bmp file
This may cause the program to stop abruptly or cause wrong
results.

I am sorry for the heavy flickering of the mouse (screen flickering
problem was sloved).First follow these instructions to start it.

The file 'Display.asm' contains source code for displaying a 3ds file
on the screen (13).The file 'Display.dll' contains the machine code
for displaying a 3ds file. You can use it by loading it in a string
and the using CALL ABSOLUTE(...)
The syntax is .
[All Integers]
def seg=varseg(Display$)
CALL ABSOLUTE(	byval Xcentre position,
		byval Ycentre position,
		byval Slide number,
		byval x1 limit,  (display area)
		byval y1 limit,  (display area)
		byval x2 limit,  (display area)
		byval y2 limit,  (display area)
		byval varseg(FreeArray%(0)),  (Used for calculation)
		byval varptr(FreeArray%(0)),  (Used for calculation)
		byval varseg(FileName$),  (FileName)
		byval sadd(FileName$),  (FileName)
		sadd(Display$))
def seg

An array must be created which is required by it for storing some
calculations.  Ex-FreeArray%(9) [Reserve 10 bytes]
FileName$=ASCIIZ FileName Ex-"sprite.3ds"+chr$(0) 'Must end with 0

Wait ... before using any graphics on your screen, you must first set
the default palette. You can do this by 
CALL ABSOLUTE ( sadd(Display$)+337)

Any problem, just mail me.(qbasic40@gmail.com)
I would also like to recieve your complaints.

(Could anybody give me the web address of a good free AntiVirus
i, need it a lot)
(Not a trial versin one which allows only a fixed no. of errors)
(Please help out)
