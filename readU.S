.globl main
.text

main:
    push    {lr}
    mov	r1, #4098
	mov		r7, #5
	ldr		r0,	=file
	svc		#0

    cmp     r0, #0
    blt     er

    ldr     r5,=#0x01c20000
    lsr     r5,r5,#12
    mov     r4,r0
    mov     r0, #0
    mov     r1, #4096
    mov     r2, #3
    mov     r3, #1
    mov     r7 ,#192
    svc     #0


    ldr     r1, [r0, #0x006C]
    ldr     r2, =#1 << 18
    orr     r1, r2
    str     r1, [r0, #0x006C]

    ldr     r1, [r0, #0x02D8]
    orr     r1, r2
    str     r1, [r0, #0x02D8]

    ldr     r5,=#0x01c28000
    lsr     r5,r5,#12
    mov     r1, #4096
    mov     r2, #3
    svc     #0
    
    ldr     r1, =mem_save
    str     r0, [r1]

    ldr     r1, [r0, #0x0800 + 0x0C]
    mov     r2, #0b10000011
    orr     r1, r2
    str     r1, [r0, #0x0800 + 0x0C]
    mov     r1, #13
    str     r1, [r0, #0x0800]
    mov     r1, #0
    str     r1, [r0, #0x0800 + 0x04]
    ldr     r1, [r0, #0x0800 + 0x0C]
    ldr     r2, =~0b10000000
    and     r1, r2
    str     r1, [r0, #0x0800 + 0x0C]


    ldr     r5, =mem_save
    ldr     r5, [r5]

    mov     r6,#0
get:
    ldr     r0, [r5, #0x0800 + 0x14]
    and     r0, #1
    cmp     r0, #0
    beq     get
    ldr     r0, [r5, #0x0800]
    cmp     r0, #0x65
    beq     ex
    b      compr

print_hex:
    mov     r3,#0
    mov     r4,r0
    add     r3,r0,lsr #4
    and     r4,#15
    ldr     r1, =hex
    mov     r0,r3
    mov     r2,#2
    bl      compl_hex
    mov     r0,r4
    mov     r2,#3
    bl      compl_hex
    mov     r2, #6
    bl      print_r
    cmp     r6,#4
    beq     nl
    ldr     r1,=space
    mov     r2,#3
    bl      print_r
    add     r6,#1
    b       get
compl_hex:
    add     r0,#48
    cmp     r0,#57
    addhi   r0,#7
    str     r0, [r1,r2]
    MOV     PC,R14
        
nl:
    mov     r6,#0
    ldr     r1,=new_line
    mov     r2,#1
    bl      print_r
    b       get
print_r:
    push    {r7}
    push    {r0}
    mov     r0, #1
    mov     r7, #4
    svc     #0
    pop     {r0}
    pop     {r7}
    MOV     PC,R14
er:
    ldr     r1, =error
    mov     r2,#50
    bl      print_r
    mov     r0, #1
    pop     {pc}

compr:
    push    {r5}
    push    {r6}
    ldr     r6,=new_year
    ldr     r7,=counter
    ldr     r5,[r7]
    ldrb    r6,[r6,r5]
    cmp     r6,r0
    
    bne     nul
    add     r5,#1
    str     r5,[r7]
    cmp     r5,#4
    bne     end
    ldr     r1,=congratulation
    mov     r2,#22
    bl      print_r
    pop     {r6} @можно сделать лучше
    mov     r6,#0
    push    {r6}
nul:
    mov     r5,#0
    str     r5,[r7] 
end:    
    pop     {r6}
    pop     {r5}
    b       print_hex

ex:
    ldr     r1,=new_line
    mov     r2,#1
    bl      print_r
    pop     {pc}



.data
counter:    .int    0
new_year:   .asciz  "asvt"
congratulation: .asciz "\n!!!HAPPY NEW YEAR!!!\n"
file:        .asciz  "/dev/mem"
hex:        .asciz  "0x  "
error:  .asciz  "Ошибка открытия файла /dev/mem\n"
mem_save:       .word    0
space:      .asciz  "   "
new_line:    .asciz  "\n"

