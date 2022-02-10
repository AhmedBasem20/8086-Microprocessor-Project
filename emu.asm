org 100h 

include emu8086.inc

.data      

newLine DB 0dh,0ah
list dw ? ;get length of array from input
arr dw list dup (0) 
      
             
.code
mov si,0 ;initialize si for addressing
print 'List Length:'
call scan_num 
mov list, cx  ;store array length

PUTC newLine[0] ;print new   
PUTC newLine[1] ;line



scan:
mov bx,cx ;store loop counter in bx
    
call scan_num

mov arr[si],cx ;store entered numbers in arr
add si,2 ;move si to address the next number or operation

mov cx,bx ;get loop count from bx again

loop scan 

mov si,0 ;initialize si to read array elements 

mov cx,list ;loop array length times
print '('
read:
mov count,cx ;store loop counter in 'count'
    mov ax, arr[si] 
    mov n1,ax
    mov n2,ax
    sub n2,1
    
    cmp ax, 2 ;if number is below 2
    jb skip   ;go for the next number without printing
    
    mov bx,2  
       
       mov cx,ax
       sub cx,bx ;loop counter = number-2  
       
  ; check prime for arr[si]
 l1:  
    cmp bx,n2 ;if no<2
    jge l3    ;jump to print 
    
    mov dl,0
    div bx    ;divide number(ax) by bx
    inc bx
    
    
    cmp dl,00 ;compare dl to zero (if ax%bx = 0)
    je skip   ;skip without printing
    
    
    mov ax,n1 ;restore the number value in ax
    
    loop l1 
    jmp skip



l3:
 mov ax,arr[si]
call print_num ; print the prime number
print ','

skip:
add si,2
mov cx, count

loop read  


print ')' 

exit:   


ret

n1 dw 0 
n2 dw 0

count dw 0
          
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_SCAN_NUM  
end