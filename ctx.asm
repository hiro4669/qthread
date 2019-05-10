extern _current
extern _dispatch

GLOBAL _thrun,_thwait,_thresume,_thfin

SECTION .text
_thrun:
    mov rax, _current
    mov rax, [rax]
    mov rsp, [rax]
;    mov rbx, [rax + 64] ; flagqをrbxに代入
;    push rbx            ; スタックに積む
;    mov rbx, [rax + 56] ; raxをrbxに代入
;    push rbx            ; スタックに積む
;    add rsp, 16         ; spを戻す
;    mov rbp, [rax +   8]
;    mov rdi, [rax +  16]
;    mov rsi, [rax +  24]
;    mov rdx, [rax +  32]
;    mov rcx, [rax +  40]
;    mov rbx, [rax +  48]
;    mov r8,  [rax +  72]
;    mov r9,  [rax +  80]
;    mov r10, [rax +  88]
;    mov r11, [rax +  96]
;    mov r12, [rax + 104]
;    mov r13, [rax + 112]
;    mov r14, [rax + 120]
;    mov r15, [rax + 128]
;    mov rax, [rsp - 16] ; raxを復元
;    sub rsp, 8          ; flagqを復元
;    popfq
    ret

_thresume:
    mov rax, _current
    mov rax, [rax]
    mov rsp, [rax]
    mov rbx, [rax + 64] ; flagqをrbxに代入
    push rbx            ; スタックに積む
    mov rbx, [rax + 56] ; raxをrbxに代入
    push rbx            ; スタックに積む
    add rsp, 16         ; spを戻す
    mov rbp, [rax +   8]
    mov rdi, [rax +  16]
    mov rsi, [rax +  24]
    mov rdx, [rax +  32]
    mov rcx, [rax +  40]
    mov rbx, [rax +  48]
    mov r8,  [rax +  72]
    mov r9,  [rax +  80]
    mov r10, [rax +  88]
    mov r11, [rax +  96]
    mov r12, [rax + 104]
    mov r13, [rax + 112]
    mov r14, [rax + 120]
    mov r15, [rax + 128]
    mov rax, [rsp - 16] ; raxを復元
    sub rsp, 8          ; flagqを復元
    popfq
    ret

_thfin:
    mov rax, 0x2000001      ; Set system call to exit=1.
    mov rdi, 0              ; Set success value of exit.
    syscall                 ; Call system call.

; old context switch
_thwait_old:
    mov rax, _current
    mov rax, [rax]
    mov [rax], rsp       ;save sp
    mov [rax + 8], rbp   ;save bp
    mov [rax + 16], rdi
    mov [rax + 24], rsi
    mov [rax + 32], rbx
    mov [rax + 40], rcx
    mov [rax + 48], rdx
    call _dispatch
    mov rax, _current
    mov rax, [rax]
    mov rsp, [rax] ; raxにspが入るはず
    mov rbp, [rax + 8]
    mov rdi, [rax + 16]
    mov rsi, [rax + 24]
    mov rbx, [rax + 32]
    mov rcx, [rax + 40]
    mov rdx, [rax + 48]
    ret

;context switch 
_thwaitold:
    mov rax, _current
    mov rax, [rax]
    mov [rax], rsp       ;save sp
    mov [rax +   8], rbp   ;save bp
    mov [rax +  16], rdi
    mov [rax +  24], rsi
    mov [rax +  32], rbx
    mov [rax +  40], rcx
    mov [rax +  48], rdx
    mov [rax +  56], r8
    mov [rax +  64], r9
    mov [rax +  72], r10
    mov [rax +  80], r11
    mov [rax +  88], r12
    mov [rax +  96], r13
    mov [rax + 104], r14
    mov [rax + 112], r15
    call _dispatch
    mov rax, _current
    mov rax, [rax]
    mov rsp, [rax] ; raxにspが入るはず
    mov rbp, [rax +   8]
    mov rdi, [rax +  16]
    mov rsi, [rax +  24]
    mov rbx, [rax +  32]
    mov rcx, [rax +  40]
    mov rdx, [rax +  48]
    mov r8,  [rax +  56]
    mov r9,  [rax +  64]
    mov r10, [rax +  72]
    mov r11, [rax +  80]
    mov r12, [rax +  88]
    mov r13, [rax +  96]
    mov r14, [rax + 104]
    mov r15, [rax + 112]
    ret

; context switch
_thwait:
    push rax
    pushfq
    mov rax, _current
    mov rax, [rax]
    add rsp, 16
    mov [rax], rsp         ;save sp
    mov [rax +   8], rbp   ;save bp
    mov [rax +  16], rdi
    mov [rax +  24], rsi
    mov [rax +  32], rdx
    mov [rax +  40], rcx
    mov [rax +  48], rbx   ;rbxを保存．以降，rbxは自由に使える
    mov rbx, [rsp - 16]
    mov [rax +  56], rbx   ;save rax
    mov rbx, [rsp - 8]     
    mov [rax +  64], rbx   ;save flagq
    mov [rax +  72], r8
    mov [rax +  80], r9
    mov [rax +  88], r10
    mov [rax +  96], r11
    mov [rax + 104], r12
    mov [rax + 112], r13
    mov [rax + 120], r14
    mov [rax + 128], r15
    call _dispatch
    mov rax, _current
    mov rax, [rax]
    mov rsp, [rax]      ; raxにspが入るはず
    mov rbx, [rax + 64] ; flagqをrbxに代入
    push rbx            ; スタックに積む
    mov rbx, [rax + 56] ; raxをrbxに代入
    push rbx            ; スタックに積む
    add rsp, 16         ; spを戻す
    mov rbp, [rax +   8]
    mov rdi, [rax +  16]
    mov rsi, [rax +  24]
    mov rdx, [rax +  32]
    mov rcx, [rax +  40]
    mov rbx, [rax +  48]
    mov r8,  [rax +  72]
    mov r9,  [rax +  80]
    mov r10, [rax +  88]
    mov r11, [rax +  96]
    mov r12, [rax + 104]
    mov r13, [rax + 112]
    mov r14, [rax + 120]
    mov r15, [rax + 128]
    mov rax, [rsp - 16] ; raxを復元
    sub rsp, 8          ; flagqを復元
    popfq
    ret