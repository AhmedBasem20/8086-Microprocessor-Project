CODE	SEGMENT
	ASSUME	CS:CODE,DS:CODE,ES:CODE,SS:CODE	

command	equ	00
key		equ	01h 
stat	equ 02
data	equ	04

 
		org 1000h  
		call init
		
.data  

list dw ? ;get length of array from input
arr db list dup (0) 
n1 db 0
n2 db 0
count dw 0


call scan ;entering the length of the list
mov list,ax ;store array length
mov si, 0 ;initialize si for addressing
start:	call scan  
        mov arr[si], al ;store entered number in arr[si]  
        
        inc si ;move si to address the next number or operation
        
        cmp si, list ; check if si exceeded the array length
        je next      ;go to the next operation then  
        
		int 3
		jmp start  
		
next:
mov si,0  ;initialize si to read array elements
;mov cx,0  ;initialize cx to remove garbage numbers
mov cx,list ;loop array length times, now cx = cl

read:
mov count, cx ;store loop counter in 'count'
mov al, arr[si]
mov n1,al
mov n2,al
sub n2,1

cmp al, 2 ;if number is below 2
jb skip   ;skip to the next number without printing

mov bx,0  ;initialize cx to remove garbage numbers
mov bl,2 


;-----------------check if a number is a prime or not-----------
;bl = 2                                                        -
;divide the number by bl                                       -
;check if there is a remainder stored in dl                    -
;if so, increment bl and continue                              -
;if not then skip this number (not prime)                      -
;repeat this process length-2 times                            -
;---------------------------------------------------------------
mov cx,0  
mov cl,al
sub cl,bl ;loop counter = number-2

l1:
   cmp bl,n2 ;if no<2
   jge l3    ;jump to print
   
   mov dl,0
   div bl  ;divide number(al) by bl
   inc bl
   
   cmp dl,00 ;check if there is a remainder stored in dl or not
   je skip   ;if dl = 0 then skip this number
   
   mov al,n1 ;restore the number value in al
   loop l1
   
  jmp skip
  
l3: mov al, arr[si]
	call output
	lm:
    out data,al ;print the prime number
    call busy
    jmp comma   ;print comma
    
skip:
    inc si
    mov cx,count
    
loop read
		
comma: 
     
     mov al,','
     out data,al 
     jmp l3

ret


	
	
;------------------------keypad scan procedure---------------------	
scan:	IN AL,key					;read from keypad register
		TEST AL,10000000b			;test status flag of keypad register
		JNZ Scan
		AND al,00011111b			;mask the valid bits for code
		int 3
		OUT key,AL					;get the keypad ready to read another key
		ret
		
busy:   IN AL,Stat
        test AL,10000000b
        jnz busy
        ret 
        
;---------------Display initialization procedure--------
init:	call busy      	    ;Check if KIT is busy
		mov al,30h          ;8-bits mode, one line & 5x7 dots
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,0fh          ;Turn the display and cursor ON, and set cursor to blink
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,06h          ;cursor is to be moved to right
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,02           ;Return cursor to home
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		mov al,01           ;Clear the display
		out command,al      ;Execute the command above.
		call busy           ;Check if KIT is busy
		ret     
		
;---------Declaring kit kays----------------------------

output:
     cmp al, 01h
     jne f2
  f1:
  mov al, '1'
  jmp lm
  
 f2:
 cmp al,02h
 jne n3        
 mov al,'2'
 jmp lm
 
 n3:
 cmp al,03h
 jne n4        
 mov al,'3'
 jmp lm
 
 n4:
 cmp al,04h
 jne n5        
 mov al,'4'
 jmp lm
 
 n5:
 cmp al,05h
 jne n6        
 mov al,'5'
 jmp lm
 
 n6:
 cmp al,06h
 jne n7        
 mov al,'6'
 jmp lm
 
 
 n7:
 cmp al,07h
 jne n8        
 mov al,'7'
 jmp lm
 
 n8:
 cmp al,08h
 jne n9        
 mov al,'8'
 jmp lm       
            		
 n9:
 cmp al,09h
 jne n0        
 mov al,'9'
 jmp lm
 
 n0:
 cmp al,00h        
 mov al,'0'
 jmp lm
 ret

		
		
END