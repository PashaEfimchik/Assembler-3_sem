.model small
 
.stack 100h
 
.data 
        X dw 0
        Y dw 0
        msg db 'Bad input', 0Dh, 0Ah, '$'
 
        a               dw      ?
        b               dw      ?
        c               dw      ?
        d               dw      ?
        .code
 
printD proc
    push AX
    mov AH, 02h
    int 21h
    pop AX
    ret
printD endp

readD proc
    mov X,0
    
    cycle:
    mov AH, 01h
    int 21h
    cmp AL, 13
    
    jz entert
    cmp AL, 08
    
    jz backspacet
    cmp AL, '9' + 1
    
    jnc endpr
    cmp AL, '0' - 1
    
    jc endpr
    push AX
    
    xor DX,DX
    inc X
    jmp cycle
    
    backspacet:
    pop AX
    
    dec X
    mov DL, 20h
    
    call printD
    mov DL, 08
    
    call printD
    jmp cycle
    
    entert:
    mov CX, X
    mov Y, CX
    
    numl:
    cmp X, 0
    jz final
    
    mov CX, Y
    sub CX, X
    mov AX, 1
    
    mov BL, 10
    cmp CX, 0
    
    jz zerot
    push DX
    
    power:
    mul BX
    loop power
    pop DX
    
    zerot:
    pop CX
    xor CH, CH
    sub CX, '0'
    push DX
    
    mul CX
    pop DX
    add DX, AX
    
    dec X
    jmp numl
    
    endpr:
    mov DX, offset msg
    mov AH, 09
    int 21h
    
    mov AH, 76
    int 21h
    
    final:
    ret
readD endp

main proc
        mov ax, @data
        mov ds, ax
               
        call readD
        mov a, dx
        
        call readD
        mov b, dx
        
        call readD
        mov c, dx
        
        call readD
        mov d, dx
        
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d
    
        add ax, bx
        add dx, cx       
        cmp ax, dx
    
        jne label_else
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d
        xor ax, bx
        and cx, dx
        add ax, cx
        
        call ShowInt
        jmp f1
    
label_else:
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d        
        or ax, bx
        and cx, dx        
        cmp ax, cx
        jne label_else2
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d
        add ax, bx
        xor cx, dx
        and ax, cx
        
        call ShowInt
        jmp f1
    
label_else2:
mov ax, a
mov bx, b
mov cx, c
mov dx, d
        add ax, dx
        add bx, cx
        or ax, bx
        
        call ShowInt
    
    f1:
    mov ah, 4Ch
    int 21h
main    endp
 
ShowInt proc
        push ax
        push bx
        push cx
        push dx
        mov bx, 10              
        mov cx, 0               
divis:
        xor dx, dx 
        div bx
        add dl, '0'
        push dx
        inc cx     
        test ax, ax
        jnz divis  
        show:
        mov ah, 02h
        pop dx
        int 21h
        loop show
    pop dx
    pop cx
    pop bx
    pop ax
        ret
ShowInt endp
end main