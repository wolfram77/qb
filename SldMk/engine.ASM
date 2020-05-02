;Engine for bmptocfg

=> detect mouse
#available%(seg,off)
;================================================================
push bp
mov bp,sp
xor ax,ax		;set ax to 0
int 33		;call microsoft mouse functions
mov es,[bp+8]
mov bx,[bp+6]
es:		;set es as the memory segment
mov [bx],ax	;mov mouse driver result in offfset - 0 [ffh,ffh] indicates mouse is present
pop bp
retf 4		;return to absolute which in turn returns to basic
;================================================================

=>show mouse
#no return
;================================================================
mov ax,1		;call for microsoft show mouse function
int 33		;make call to microsoft mouse routine
retf		;return to absolute which in turn returns to basic
;================================================================

=>hide mouse
#no return
;================================================================
mov ax,2		;call for microsoft hide mouse function
int 33		;make call to microsoft mouse routine
retf		;return to absolute which in turn returns to basic
;================================================================

=>set mouse range
#x1,y1,x2,y2
;================================================================
push bp
mov bp,sp
mov cx,[bp+c]	;x1
mov dx,[bp+8]	;x2
mov ax,7		;call for x boundaries setting function
int 33		;call to microsoft mouse function
mov cx,[bp+a]	;y1
mov dx,[bp+6]	;y2
mov ax,8		;call for y boundaries setting function
int 33		;call to microsoft mouse function
pop bp
retf 8		;return to absolute which in turn returns to basic
;================================================================

=>put mouse
#x,y
;================================================================
push bp
mov bp,sp
mov cx,[bp+8]	;read x pos at[0]
mov dx,[bp+6]	;read y pos at[2]
mov ax,4		;call for mouse put function
int 33		;call to microsoft mouse function
pop bp
retf 4		;return to absolute which in turn returns to basic
;================================================================

=>mouse status
#array%(3)(button,xpos,ypos)
;================================================================
push bp
mov bp,sp
push si
mov es,[bp+8]	;array
mov si,[bp+6]
mov ax,3		;call for mouse status function
int 33		;call to microsoft mouse function
es:		;use es
mov [si],bx	;write button inf at[0]
es:		;use es
mov [si+2],cx	;write x pos at[2]
es:		;use es
mov [si+4],dx	;write y pos at[4]
pop si
pop bp
retf 4		;return to absolute which in turn returns to basic
;================================================================

=>mouse relative status
#array%(3)(button,relativex,relativey)
;================================================================
push bp
mov bp,sp
push si
mov es,[bp+8]
mov si,[bp+6]
mov ax,3		;call for mouse status function
int 33		;call to microsoft mouse function
push es		;store es in stack
es:		;use es
mov [si],bx	;write button inf at[0]
mov ax,b		;call for xpos,ypos function
int 33		;call microsoft mouse handling function
es:		;use es
mov [si+2],cx	;write x pos at[2]
es:		;use es
mov [si+4],dx	;write y pos at[4]
pop si
pop bp
retf 4		;return to absolute which in turn returns to basic
;================================================================

=>set default palette
#use no param
;this program is used to set the palette as doing this task in basic would consume
;more memory. this program also uses the DAC(Digital to Analog Converter)
;to set the palette
;(r=b7-b6;g=b5-b3;b=b2-b0)
;===============================================================
xor ah,ah		;ah=colour to set
::palette1
dec ah		;first colour =255 , last=0
mov al,ah
mov dx,3c8	;write to DAC register
out dx,al		;ask DAC for writing in one of his registers
mov dx,3c9	;DAC register

mov al,ah		;get red value according to colour
and al,c0
mov cl,2
shr al,cl
test al,10
jz ::palette2
or al,3
::palette2
test al,20
jz ::palette3
or al,c
::palette3
out dx,al		;red(b7-b6)

mov al,ah		;get green value according to colour
and al,38
test al,8
jz ::palette4
or al,1
::palette4
test al,10
jz ::palette5
or al,2
::palette5
test al,20
jz ::palette6
or al,4
::palette6
out dx,al		;green(b5-b3)

inc cl		;get blue value according to colour
mov al,ah
and al,7
shl al,cl
test al,8
jz ::palette7
or al,1
::palette7
test al,10
jz ::palette8
or al,2
::palette8
test al,20
jz ::palette9
or al,4
::palette9
out dx,al		;blue(B2-b0)

cmp ah,0
jnz ::palette1
retf
;===============================================================

=>draw a pixel on the video screen
#x,y,colour
;fastest i have ever made takes 27.9 s to complete 64 000 000 pixel plots
;does shiftrights instead of direct multiplication
;===============================================================
push bp
mov bp,sp
xor bx,bx
mov ax,a000
mov es,ax
mov bh,[bp+8]	;bh=y position
mov ah,bh
shr ax,1
shr ax,1
add bx,ax
add bx,[bp+a]	;bx=offset in memory
mov ax,[bp+6]
es:
mov [bx],ax
pop bp
retf 6
;===============================================================

=>xor box
;draw a xor box
#x1,y1,x2,y2,clr
;================================================================
push bp
mov bp,sp
push si
push di
pushf
mov ax,a000
mov es,ax

mov bx,[bp+c]
mov ax,140
mul bx
mov bx,ax
add bx,[bp+e]	;bx=start position

mov ax,[bp+a]	;ax=horiz count
sub ax,[bp+e]
inc ax

mov dx,[bp+8]	;dx=vert count
sub dx,[bp+c]
inc dx

mov cl,[bp+6]

::xorbox2
mov di,ax
mov si,bx
::xorbox1
es:
xor [si],cl
inc si
dec di
jnz ::xorbox1
add bx,140
dec dx
jnz ::xorbox2

popf
pop di
pop si
pop bp
retf a
;================================================================
=>Get 3ds files to work
#x,y,sld,x1,y1,x2,y2,array(seg,off),filename(seg,off)
;1a18 16 14 12 10 e         c   a             8   6
;================================================================
push bp
mov bp,sp
push si
push di
push ds
pushf

mov es,[bp+c]	;es:si=temporary data storage
mov si,[bp+a]
mov ds,[bp+8]	;ds:dx=filename
mov dx,[bp+6]

mov ax,3d00	;open the file
int 21
mov [bp+8],ax	;si=file handle

mov bx,ax
mov cx,4		;read xres,yres from file
mov ax,es		;si+2=xres,si+4=yres
mov ds,ax
lea dx,[si+2]
mov ax,3f00
int 21

es:		;x=xstart position,y=ystart position
mov ax,[si+2]
inc ax
shr ax,1
sub [bp+1a],ax
es:
mov ax,[si+4]
inc ax
shr ax,1
sub [bp+18],ax

mov ax,[bp+14]	;if(x<x1)then xdata add = x1-x,xstart=x1 else xdata add=0 , xstart=x
cmp [bp+1a],ax	;xdata add=si+6
jge ::waa11
sub ax,[bp+1a]
mov [bp+6],ax
mov ax,[bp+14]
mov [bp+1a],ax
jmp near ::waa12
::waa11
mov word ptr [bp+6],0
::waa12

mov ax,[bp+12]	;if(y<y1)then ydata add = y1-y,ystart=y1 else ydata add=0 , ystart=y
cmp [bp+18],ax	;ydata add=si+8
jge ::waa21
sub ax,[bp+18]
es:
mov [si+8],ax
mov ax,[bp+12]
mov [bp+18],ax
jmp near ::waa22
::waa21
es:
mov word ptr [si+8],0
::waa22

mov ax,[bp+1a]	;x22=xstart+xres.-xdata add
es:		;if(x22>x2)then xdata adde = x22-x2 else xdata adde = 0
add ax,[si+2]	;xdata adde = si+a
sub ax,[bp+6]
cmp ax,[bp+10]
jle ::waa31
sub ax,[bp+10]
es:
mov [si+a],ax 
jmp near ::waa32
::waa31
es:
mov word ptr [si+a],0
::waa32

mov ax,[bp+18]	;y22=ystart+yres.-ydata add
es:		;if(y22>y2)then ydata adde = y22-y2 else ydata adde = 0
add ax,[si+4]	;ydata adde = si+c
es:
sub ax,[si+8]
cmp ax,[bp+e]
jle ::waa41
sub ax,[bp+e]
es:
mov [si+c],ax 
jmp near ::waa42
::waa41
es:
mov word ptr [si+c],0
::waa42

es:		;count for x = xres-xdata add-xdata adde+1
mov ax,[si+2]	;count for x = si+e
sub ax,[bp+6]
es:
sub ax,[si+a]
inc ax
es:
mov [si+e],ax

es:		;count for y = yres-ydata add-ydata adde+1
mov ax,[si+4]	;count for y = si+10
es:
sub ax,[si+8]
es:
sub ax,[si+c]
inc ax
es:
mov [si+10],ax

es:
cmp word ptr [si+e],0
jle ::waastop
es:
cmp word ptr [si+10],0
jle ::waastop

jmp near ::waa61
::waastop
mov bx,[bp+8]
jmp near ::waaend
::waa61

es:		;slide bytes add=slide*(xres+1)*(yres+1)
mov ax,[si+2]
inc ax
mov bx,[bp+16]
dec bx
mul bx
es:
mov bx,[si+4]
inc bx
mul bx
es:
mov [si+12],ax
es:
mov [si+14],dx

es:		;y bytes add=ydata add*(xres+1)
mov ax,[si+2]	;total bytes add=slide bytes add+y bytes add+6
inc ax		;total bytes add=cx:dx
es:
mov bx,[si+8]
mul bx
es:
add ax,[si+12]
es:
adc dx,[si+14]
add ax,2
adc dx,0
mov cx,dx
mov dx,ax

mov bx,[bp+8]	;seek current data
mov ax,4201
int 21

mov ax,140	;ds:di=screen area
mov di,[bp+18]
mul di
mov di,ax
add di,[bp+1a]
mov ax,a000
mov ds,ax


xor cx,cx
::waa51

mov dx,[bp+6]	;do xdata add
mov ax,4201
int 21

es:		;write to screen
mov cx,[si+e]
mov dx,di
mov ax,3f00
int 21

xor cx,cx		;do xdata adde
es:
mov dx,[si+a]
mov ax,4201
int 21

add di,140	;move to next line

es:
dec word ptr [si+10]
jnz ::waa51

::waaend

mov ax,3e00	;close file
int 21

popf
pop ds
pop di
pop si
pop bp
retf 16
;================================================================
;happy ending ^_^.