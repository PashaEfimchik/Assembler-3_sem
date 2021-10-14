.model small
.stack 100h
 
.data
len dw 0
p db 100 dup(0)
String db 100 dup('$')
.code
 
printNum proc
    push bx
    push cx
    push dx
    xor cx,cx 
    putToStack:
        xor dx, dx
        mov bx, 10
        div bx
        add dx, '0'
        push dx
        inc cx
        cmp ax, 0
        jne putToStack
            
    printFromStack:
        pop dx
        mov ah, 02h
        int 21h
        loop printFromStack
    pop cx
    pop bx
    pop dx
    ret
printNum endp
 
readStr proc
    push ax
    push bx
    push cx
 
    lea di, String
    letter:
        mov ah, 01h
        int 21h
        cmp al, 10
        je f1
        cmp al, 13
        je f1
        cld
        stosb
        inc len
        jmp letter
    
    f1:
        pop cx
        pop bx
        pop ax
        ret
readStr endp
 
Func proc
    push ax
    push bx
    push cx
    push dx
    xor ax, ax
    xor bx, bx
 
    cld
    mov cx, 1
    l1:
        cmp cx, len
        jnl exit1
        lea si, p
        add si, cx
        sub si, 1
        lodsb
    l2:
        cmp ax, 0
        jle exit2
        lea si, String
        add si, cx
        lea di, String
        add di, ax
        cmpsb
        je exit2
        lea si, p
        add si, ax
        dec si
        lodsb
        jmp l2
    exit2:
        lea si, String
        add si, cx
        lea di, String
        add di, ax
        cmpsb
        jne s_else1
        inc ax
    s_else1:
        lea di, p
        add di, cx
        stosb
        inc cx
        jmp l1
    exit1:  
        pop dx
        pop cx
        pop bx
        pop ax
        ret
Func endp
 
main:
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    call readStr
    call Func
    xor ax, ax
    lea si, p
    add si, len
    dec si
    lodsb
 
    xor dx, dx
    mov bx, len
    sub bx, ax
    mov ax, len
    div bx
    cmp dx, 0
    jne l_else1
    mov ax, bx
    jmp l_else2
    l_else1:
    mov ax, len
    l_else2:
    call printNum

    mov ax, 4c00h
    int 21h
end main