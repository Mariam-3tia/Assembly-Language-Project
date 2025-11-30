.model small
.stack 100h
.data

type            db 13,10,'Monoalphabetic Substitution - Enter text : $'
original        db 13,10,'Original: $'
encrypted       db 13,10,'Encrypted: $'
decrypted       db 13,10,'Decrypted: $'

input           db 255      
                db 0        
                db 255 dup(0) 

string          db 256 dup('$')

enc_table_lower db 'qwertyuiopasdfghjklzxcvbnm'  
dec_table_lower db 'kxvmcnophqrszyijadlegwbuft'  

enc_table_upper db 'QWERTYUIOPASDFGHJKLZXCVBNM'  
dec_table_upper db 'KXVMCNOPHQRSZYIJADLEGWBUFT'  

.code
main:

    mov ax,@data
    mov ds,ax

    mov dx, offset type
    mov ah, 09h
    int 21h

    mov dx, offset input
    mov ah, 0Ah
    int 21h

    mov cl, [input+1]        
    xor ch, ch                   
    mov si, offset input+2   
    mov di, offset string      
    mov cx, cx                   
    cmp cx, 0
    je put$
    
copy_input:
    
    mov al, [si]
    cmp al, 13                    
    je put$
    mov [di], al
    inc si
    inc di
    dec cx
    jnz copy_input

put$:

    mov byte ptr [di], '$'        

    mov dx, offset original
    mov ah, 09h
    int 21h
    mov dx, offset string
    mov ah, 09h
    int 21h

    mov si, offset string
    
encryption:
    
    mov al, [si]
    cmp al, '$'
    je encrypted_done
    cmp al, 'a'
    jb check_enc_upper
    cmp al, 'z'
    ja check_enc_upper

    mov bl, al
    sub bl, 'a'

    push si
    mov si, offset enc_table_lower
    mov al, [si + bx]    
    pop si

    mov [si], al 
    
check_enc_upper:
    
    cmp al, 'A'
    jb skip_enc_char
    cmp al, 'Z'
    ja skip_enc_char
    
    mov bl, al
    sub bl, 'A'
    
    push si
    mov si, offset enc_table_upper
    mov al, [si + bx]
    pop si
    
    mov [si], al
    
skip_enc_char:
    
    inc si
    jmp encryption
    
encrypted_done:

    mov dx, offset encrypted
    mov ah, 09h
    int 21h
    mov dx, offset string
    mov ah, 09h
    int 21h

    mov si, offset string
    
decryption:
    
    mov al, [si]
    cmp al, '$'
    je decrypted_done
    cmp al, 'a'
    jb check_dec_upper
    cmp al, 'z'
    ja check_dec_upper

    mov bl, al
    sub bl, 'a'

    push si
    mov si, offset dec_table_lower
    mov al, [si + bx]
    pop si

    mov [si], al
    
check_dec_upper:
    
    cmp al, 'A'
    jb skip_dec_char
    cmp al, 'Z'
    ja skip_dec_char
    
    mov bl, al
    sub bl, 'A'
    
    push si
    mov si, offset dec_table_upper
    mov al, [si + bx]
    pop si
    
    mov [si], al
    
skip_dec_char:
    
    inc si
    jmp decryption
    
decrypted_done:

    mov dx, offset decrypted
    mov ah, 09h
    int 21h
    mov dx, offset string
    mov ah, 09h
    int 21h

    .exit

end main
