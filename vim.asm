section .data
formatString: DB "%ld",0
formatString2: DB "%ld ",0

section .bss 
firstArr: resb 8
tempArr: resb 8
secondArr: resb 8
numberOfElements: resb 8

section .text
	extern scanf
	extern calloc
	extern free
	extern printf
	global main
	extern exit

%macro getInput 0
	mov rdi,4096
	mov rsi,8
	call calloc
	mov [firstArr], rax
	mov r15,0
	mov r14,0
	mov rsi, qword[firstArr]
	mov rdi, formatString
	
	loop:
	
	mov rdi, formatString
	push rsi
	push r14
	mov rax,0
	call scanf
	pop r14
	pop rsi
	add rsi,8
	inc r14
	cmp eax,-1
	jne loop

	;Post scanf, r14 holds number of elements+1, firstArr is full of elements.
	mov [numberOfElements],r14
	mov rdi,r14
	mov rsi,8
	push r14
	call calloc
	mov [secondArr], rax
	pop r14
	mov r13,r14				

	mov rcx,qword[numberOfElements]
	mov r14,qword[secondArr]
	mov r15,qword[firstArr]
	assignmentLoop:
	mov r8,qword[r15]
	mov qword[r14],r8
	add r15,8
	add r14,8
	loop assignmentLoop,rcx



%endmacro
main:
	getInput
 	mov r14,8

 	mov r15,qword[secondArr] ;r15=IP
 	mov r11,r15					
 	loopStart:
 	mov r8,qword[r15] 		 ;r8 = M[0] = first
 	add r15,8
 	mov r9,qword[r15]		 ;r9 = M[1] = second
 	add r15,8
 	mov r10,qword[r15]		 ;r10 = M[2] = third

 	cmp r8,0				;if [m0].. == 0
 	je firstZero
 
 CalcLabel:
 	mov rax,r8				;RAX = M[0]
 	mov r14,8
 	mul r14				;RAX = M[0]*8
 	mov r15,qword[secondArr];r15 = P[0]
 	add r15,rax				;r15=P[M[0]] 
 	push r15
 	mov r8,qword[r15]		;r8= M[M[0]]

 	mov rax,r9
 	mov r14,8
 	mul r14
 	mov r15,qword[secondArr]
 	add r15,rax
 	mov r9,qword[r15]

 	; mov rax,r10
 	; mov r14,8
 	; mul r14
 	; mov r15,qword[secondArr]
 	; add r15,rax
 	; mov r10,qword[r15]

	


 	sub r8,r9
 	pop r15				;r15 = P[M[0]]

 	mov qword[r15],r8   ;M[M[0]] = M[M[0]]-M[M[1]]

 	cmp r8,0
 	JGE caseNotNegative
 	mov rax,r10				;RAX = M[2]
 	mov r14,8
 	mul r14
 	mov r15,qword[secondArr]
 	add r15,rax
 	mov r11,r15
 	JMP loopStart
 	caseNotNegative:
 	mov r15,r11
 	add r15,24
 	add r11,24
 	JMP loopStart

 firstZero:
 	cmp r9,0
 	JE secondZero
 	JMP CalcLabel
 	secondZero:
 	cmp r10,0
 	JE end
 	jmp CalcLabel

 end:
	mov rcx, qword[numberOfElements]
	mov r15, qword[secondArr]
	mov rsi, qword[r15]
	mov rdi, formatString
	dec rcx


	loop2:
	mov rdi, formatString2
	mov rsi, qword[r15]
	push r15
	push rcx
	mov rax,0
	call printf
	pop rcx
	pop r15
	add r15,8
	loop loop2,rcx

	mov rdi, qword[firstArr]
	mov rax, 0
	call free
	mov rdi, qword[secondArr]
	mov rax, 0
	call free


	call exit
	

