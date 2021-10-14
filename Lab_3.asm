.model small
 
.stack 100h
 
.data 
        X dw 0
        Y dw 0
        negative db 0
        msgErr db 'Bad input', 0Dh, 0Ah, '$'
        zeroErr db 'Zero division', 0Dh, 0Ah, '$'
        a               dw      ?
        b               dw      ?
        c               dw      ?
        d               dw      ?
        .code
 
printD proc
    push ax
    mov ah, 02h
    int 21h
    pop ax
    ret
printD endp

readD proc
    mov X,0
    
    cycle:
    mov ah, 01h
    int 21h
    
    cmp al, 10
    jz entert
    
    cmp al, 08
    jz backspacet
    
    cmp al, 45
    jz minuss
    
    cmp al, '9' + 1
    jnc endpr
    
    cmp al, '0' - 1
    jc endpr
    
    push ax
    
    xor dx, dx
    inc X
    jmp cycle
    
    backspacet:
    pop ax
    
    dec X
    mov dl, 20h
    
    call printD
    mov dl, 08
    
    call printD
    jmp cycle
    
    entert:
    mov cx, X
    mov Y, cx
    
    numl:
    cmp X, 0
    jz f0
    
    mov cx, Y
    sub cx, X
    mov ax, 1
    
    mov bx, 10
    cmp cx, 0
    
    jz zerot
    push dx
    
    power:
    mul bx
    loop power
    pop dx
    
    zerot:
    pop cx
    xor ch, ch
    sub cx, '0'
    push dx
    
    mul cx
    pop dx
    add dx, ax
    mov ax, dx
    dec X
    jmp numl
    
    minuss:
    cmp X, 0
    jnz endpr
    
    cmp negative, 1
    jz endpr
    
    inc negative
    jmp cycle
    
    endpr:
    mov dx, offset msgErr
    mov ah, 09
    int 21h
    
    mov ah, 76
    int 21h
    
    f0:
    cmp negative, 1
    jnz endproc
    
    mov negative, 0
    mov ax, dx
    mov cx, -1
    mul cx
    mov dx, ax
    
    endproc:
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
    
        cmp dx, 0
        jnz notzero1
        mov dx, offset zeroErr
        mov ah, 09
        int 21h
        jmp f1
        
        notzero1:
        cmp bx, 0
        jnz notzero2
        mov dx, offset zeroErr
        mov ah, 09
        int 21h
        
        jmp f1
        
        notzero2:
        ;///////////////////////////////////////
        add ax, bx
        sub dx, cx                  ;if (b + a) == (d - c)
        cmp ax, dx
        ;/////////////////////////////////
        jne label_else
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d

        mov ax, a
        mov bx, b
        imul bx
        mov cx, ax

        mov dx, 0
        mov ax, c               
        mov bx, d
        cbw                     ;print((a * b) + (c / d))
        cwd
        idiv bx

        add ax, cx

        call ShowInt
        jmp f1
        ;////////////////////////////////////////
label_else:
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d 
        
        add cx, dx
        ;/////////////////
        mov dx, 0
        mov ax, a               
        mov bx, b
        cbw                     ;(a % b)
        cwd
        idiv bx
        ;/////////////////////
                              ;if (a % b) == (c + d)
            cmp dx, cx
        
        ;//////////////////////////////////////
        jne label_else2
        mov ax, a
        mov bx, b
        mov cx, c
        mov dx, d
        
        add bx, ax
        mov cx, bx    ;cx = (a + b)
        
        xor dx, dx
        mov ax, c               
        mov bx, d
        cbw                     ;dx = (c % d)
        cwd
        idiv bx
 
        mov ax, cx
        mov bx, dx
        cbw
        cwd
        idiv bx 
                                ;print((b + a) / (c % d))
        call ShowInt
        jmp f1
        ;////////////////////////////////
label_else2:
mov ax, a
mov bx, b
mov cx, c
mov dx, d                       ;print((a + d) - (b + c))
        add ax, dx
        add bx, cx
        sub ax, bx
        
        call ShowInt
        ;/////////////////////////////////
    f1:
    mov ah, 4Ch
    int 21h
main    endp
 
ShowInt proc
        push ax
        push dx
        push cx
        push bx
        
        test ax, ax
          jns posPrint
        
        mov cx, -1
        mul cx
        push ax
        push dx
        
        mov ah, 02h
        mov dl, '-'
        int 21h
        
        pop dx
        pop ax
        
        posPrint:
        xor cx, cx
        xor bl, bl
        mov bx, 10
        
        divis:
        xor dx, dx
        div bx
        push dx
        inc cx
        cmp ax, 0
        mov dx, 0
        jnz divis
        
        print:
        pop dx
        mov ah, dl
        xor dx, dx
        mov dl, ah
        add dl, '0'
        mov ah, 02h
        int 21h
        loop print
        pop bx
        pop cx
        pop dx
        pop ax
        ret
ShowInt endp
end main