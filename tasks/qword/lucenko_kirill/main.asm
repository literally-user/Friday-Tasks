n dq 35                   ; Число, которое нужно разложить (например, 35)
    a dq 0                    ; Значения для a, b, c, d
    b dq 0
    c dq 0
    d dq 0
    found db 0                ; Флаг, указывающий, что разложение найдено

section .text
    global _start

_start:
    mov rax, [n]              ; Загрузить n в rax

    ; Внешний цикл по a
    xor rdi, rdi              ; rdi = a = 0
next_a:
    mov rsi, rdi              ; rsi = a^2
    imul rsi, rdi
    cmp rsi, rax              ; если a^2 > n, прерываем цикл
    jae end                   ; Конец, если не нашли разложения

    ; Цикл по b
    xor rbx, rbx              ; rbx = b = 0
next_b:
    mov rcx, rbx              ; rcx = b^2
    imul rcx, rbx
    add rcx, rsi              ; rcx = a^2 + b^2
    cmp rcx, rax              ; если a^2 + b^2 > n, перейти к next_a
    jae next_a

    ; Цикл по c
    xor rdx, rdx              ; rdx = c = 0
next_c:
    mov r8, rdx               ; r8 = c^2
    imul r8, rdx
    add r8, rcx               ; r8 = a^2 + b^2 + c^2
    cmp r8, rax               ; если a^2 + b^2 + c^2 > n, перейти к next_b
    jae next_b

    ; Цикл по d
    xor r9, r9                ; r9 = d = 0
next_d:
    mov r10, r9               ; r10 = d^2
    imul r10, r9
    add r10, r8               ; r10 = a^2 + b^2 + c^2 + d^2
    cmp r10, rax              ; Проверить, совпадает ли с n
    je solution_found         ; Если совпало, то решение найдено
    inc r9                    ; d = d + 1
    jmp next_d

    inc rdx                   ; c = c + 1
    jmp next_c

    inc rbx                   ; b = b + 1
    jmp next_b

    inc rdi                   ; a = a + 1
    jmp next_a

solution_found:
    mov [a], rdi              ; Сохранить a, b, c, d в памяти
    mov [b], rbx
    mov [c], rdx
    mov [d], r9
    mov byte [found], 1       ; Установить флаг found

end:
    ; Здесь программа завершится, или можно добавить код для вывода ответа
    mov rax, 60               ; sys_exit
    xor rdi, rdi              ; Статус завершения = 0
    syscall


; Комментарий от DVLT: Нейро-говно не принимаем
