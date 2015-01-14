	.file	"amd_iss_c.c"
	.section	.rodata
.LC0:
	.string	"ZZZZ"
.LC1:
	.string	"%s"
.LC2:
	.string	"%u"
	.text
.globl amd_run
	.type	amd_run, @function
amd_run:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$88, %rsp
	movq	%rdi, -88(%rbp)
	movq	-88(%rbp), %rax
	movl	$4, %esi
	movq	%rax, %rdi
	.cfi_offset 3, -24
	call	std2ui
	movl	%eax, -32(%rbp)
	movq	-88(%rbp), %rax
	addq	$4, %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -36(%rbp)
	movq	-88(%rbp), %rax
	addq	$8, %rax
	movl	$4, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -40(%rbp)
	movq	-88(%rbp), %rax
	addq	$12, %rax
	movl	$9, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -44(%rbp)
	movq	-88(%rbp), %rax
	addq	$21, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -48(%rbp)
	movl	-44(%rbp), %eax
	andl	$7, %eax
	cmpl	$7, %eax
	ja	.L2
	mov	%eax, %eax
	movq	.L11(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L11:
	.quad	.L3
	.quad	.L4
	.quad	.L5
	.quad	.L6
	.quad	.L7
	.quad	.L8
	.quad	.L9
	.quad	.L10
	.text
.L3:
	movl	-32(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -20(%rbp)
	movl	accu.1626(%rip), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L4:
	movl	-32(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -20(%rbp)
	movl	-36(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L5:
	movl	$0, -20(%rbp)
	movl	accu.1626(%rip), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L6:
	movl	$0, -20(%rbp)
	movl	-36(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L7:
	movl	$0, -20(%rbp)
	movl	-32(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L8:
	movl	-40(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-32(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L9:
	movl	-40(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	accu.1626(%rip), %eax
	movl	%eax, -24(%rbp)
	jmp	.L2
.L10:
	movl	-40(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$0, -24(%rbp)
.L2:
	movl	-44(%rbp), %eax
	shrl	$3, %eax
	andl	$7, %eax
	cmpl	$7, %eax
	ja	.L12
	mov	%eax, %eax
	movq	.L21(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L21:
	.quad	.L13
	.quad	.L14
	.quad	.L15
	.quad	.L16
	.quad	.L17
	.quad	.L18
	.quad	.L19
	.quad	.L20
	.text
.L13:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	leal	(%rdx,%rax), %eax
	addl	-48(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L22
	movl	$3, %eax
	jmp	.L23
.L22:
	movl	$2, %eax
.L23:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	jmp	.L12
.L14:
	cmpl	$0, -48(%rbp)
	je	.L24
	movl	-20(%rbp), %eax
	movl	-24(%rbp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	jmp	.L25
.L24:
	movl	-20(%rbp), %eax
	movl	-24(%rbp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	subl	$1, %eax
.L25:
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L26
	movl	$2, %eax
	jmp	.L27
.L26:
	movl	$3, %eax
.L27:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	jmp	.L12
.L15:
	cmpl	$0, -48(%rbp)
	je	.L28
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	jmp	.L29
.L28:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	subl	$1, %eax
.L29:
	movl	%eax, -28(%rbp)
	movl	-28(%rbp), %eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L30
	movl	$2, %eax
	jmp	.L31
.L30:
	movl	$3, %eax
.L31:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	jmp	.L12
.L16:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	orl	%edx, %eax
	movl	%eax, -28(%rbp)
	jmp	.L12
.L17:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	andl	%edx, %eax
	movl	%eax, -28(%rbp)
	jmp	.L12
.L18:
	movl	-20(%rbp), %eax
	notl	%eax
	andl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)
	jmp	.L12
.L19:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	xorl	%edx, %eax
	movl	%eax, -28(%rbp)
	jmp	.L12
.L20:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	xorl	%edx, %eax
	notl	%eax
	movl	%eax, -28(%rbp)
.L12:
	movl	-44(%rbp), %eax
	shrl	$3, %eax
	andl	$7, %eax
	cmpl	$7, %eax
	ja	.L32
	mov	%eax, %eax
	movq	.L41(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L41:
	.quad	.L33
	.quad	.L34
	.quad	.L35
	.quad	.L36
	.quad	.L37
	.quad	.L38
	.quad	.L39
	.quad	.L40
	.text
.L33:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	orl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	cmpl	$15, -68(%rbp)
	jne	.L42
	movl	$2, %eax
	jmp	.L43
.L42:
	movl	$3, %eax
.L43:
	movq	-88(%rbp), %rdx
	movb	%al, 32(%rdx)
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	andl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L44
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L45
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L44
.L45:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L46
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L46
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L44
.L46:
	movl	-72(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L47
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L47
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L47
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L47
.L44:
	movl	$2, %eax
	jmp	.L48
.L47:
	movl	$3, %eax
.L48:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	xorl	%edx, %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L49
	movl	-20(%rbp), %eax
	movl	-28(%rbp), %edx
	xorl	%edx, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L49
	movl	$3, %eax
	jmp	.L50
.L49:
	movl	$2, %eax
.L50:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L34:
	movl	-20(%rbp), %eax
	notl	%eax
	orl	-24(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	cmpl	$15, -68(%rbp)
	jne	.L51
	movl	$2, %eax
	jmp	.L52
.L51:
	movl	$3, %eax
.L52:
	movq	-88(%rbp), %rdx
	movb	%al, 32(%rdx)
	movl	-20(%rbp), %eax
	notl	%eax
	andl	-24(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L53
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L54
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L53
.L54:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L55
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L55
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L53
.L55:
	movl	-72(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L56
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L56
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L56
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L56
.L53:
	movl	$2, %eax
	jmp	.L57
.L56:
	movl	$3, %eax
.L57:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	movl	-20(%rbp), %eax
	notl	%eax
	xorl	-24(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L58
	movl	-24(%rbp), %eax
	movl	-28(%rbp), %edx
	xorl	%edx, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L58
	movl	$3, %eax
	jmp	.L59
.L58:
	movl	$2, %eax
.L59:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L35:
	movl	-24(%rbp), %eax
	notl	%eax
	orl	-20(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	cmpl	$15, -68(%rbp)
	jne	.L60
	movl	$2, %eax
	jmp	.L61
.L60:
	movl	$3, %eax
.L61:
	movq	-88(%rbp), %rdx
	movb	%al, 32(%rdx)
	movl	-24(%rbp), %eax
	notl	%eax
	andl	-20(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L62
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L63
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L62
.L63:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L64
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L64
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L62
.L64:
	movl	-72(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L65
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L65
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L65
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L65
.L62:
	movl	$2, %eax
	jmp	.L66
.L65:
	movl	$3, %eax
.L66:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	movl	-24(%rbp), %eax
	notl	%eax
	xorl	-20(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L67
	movl	-20(%rbp), %eax
	movl	-28(%rbp), %edx
	xorl	%edx, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L67
	movl	$3, %eax
	jmp	.L68
.L67:
	movl	$2, %eax
.L68:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L36:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	orl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	movq	-88(%rbp), %rax
	movb	$2, 32(%rax)
	cmpl	$15, -68(%rbp)
	jne	.L69
	movl	$3, %eax
	jmp	.L70
.L69:
	movl	$2, %eax
.L70:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	cmpl	$15, -68(%rbp)
	jne	.L71
	cmpl	$0, -48(%rbp)
	je	.L72
.L71:
	movl	$3, %eax
	jmp	.L73
.L72:
	movl	$2, %eax
.L73:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	cmpl	$15, -68(%rbp)
	jne	.L74
	cmpl	$0, -48(%rbp)
	je	.L75
.L74:
	movl	$3, %eax
	jmp	.L76
.L75:
	movl	$2, %eax
.L76:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L37:
	movq	-88(%rbp), %rax
	movb	$2, 32(%rax)
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	andl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	je	.L77
	movl	$2, %eax
	jmp	.L78
.L77:
	movl	$3, %eax
.L78:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	cmpl	$0, -72(%rbp)
	jne	.L79
	cmpl	$0, -48(%rbp)
	je	.L80
.L79:
	movl	$3, %eax
	jmp	.L81
.L80:
	movl	$2, %eax
.L81:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	cmpl	$0, -72(%rbp)
	je	.L82
	cmpl	$0, -48(%rbp)
	jne	.L83
.L82:
	movl	$3, %eax
	jmp	.L84
.L83:
	movl	$2, %eax
.L84:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L38:
	movq	-88(%rbp), %rax
	movb	$2, 32(%rax)
	movl	-20(%rbp), %eax
	notl	%eax
	andl	-24(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	je	.L85
	movl	$2, %eax
	jmp	.L86
.L85:
	movl	$3, %eax
.L86:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	cmpl	$0, -72(%rbp)
	jne	.L87
	cmpl	$0, -48(%rbp)
	je	.L88
.L87:
	movl	$3, %eax
	jmp	.L89
.L88:
	movl	$2, %eax
.L89:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	cmpl	$0, -72(%rbp)
	je	.L90
	cmpl	$0, -48(%rbp)
	jne	.L91
.L90:
	movl	$3, %eax
	jmp	.L92
.L91:
	movl	$2, %eax
.L92:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L39:
	movl	-20(%rbp), %eax
	notl	%eax
	orl	-24(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	movl	-20(%rbp), %eax
	notl	%eax
	andl	-24(%rbp), %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	je	.L93
	movl	$3, %eax
	jmp	.L94
.L93:
	movl	$2, %eax
.L94:
	movq	-88(%rbp), %rdx
	movb	%al, 32(%rdx)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L95
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L96
.L95:
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L97
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L97
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L96
.L97:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L98
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L98
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L98
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	jne	.L96
.L98:
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L99
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L99
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L99
	movl	-68(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L99
.L96:
	movl	$3, %eax
	jmp	.L100
.L99:
	movl	$2, %eax
.L100:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L101
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L102
.L101:
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L103
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L103
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L102
.L103:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L104
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L104
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L104
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	jne	.L102
.L104:
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L105
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L105
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L105
	movl	-68(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L105
	movl	-72(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	jne	.L102
	cmpl	$0, -48(%rbp)
	jne	.L105
.L102:
	movl	$3, %eax
	jmp	.L106
.L105:
	movl	$2, %eax
.L106:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	movq	-88(%rbp), %rax
	movzbl	31(%rax), %eax
	cmpb	$2, %al
	jne	.L107
	movl	$3, %eax
	jmp	.L108
.L107:
	movl	$2, %eax
.L108:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
	jmp	.L32
.L40:
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	orl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -68(%rbp)
	movl	-24(%rbp), %eax
	movl	-20(%rbp), %edx
	andl	%edx, %eax
	andl	$15, %eax
	movl	%eax, -72(%rbp)
	cmpl	$0, -72(%rbp)
	je	.L109
	movl	$3, %eax
	jmp	.L110
.L109:
	movl	$2, %eax
.L110:
	movq	-88(%rbp), %rdx
	movb	%al, 32(%rdx)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L111
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L112
.L111:
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L113
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L113
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L112
.L113:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L114
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L114
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L114
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	jne	.L112
.L114:
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L115
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L115
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L115
	movl	-68(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L115
.L112:
	movl	$3, %eax
	jmp	.L116
.L115:
	movl	$2, %eax
.L116:
	movq	-88(%rbp), %rdx
	movb	%al, 33(%rdx)
	movl	-72(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L117
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L118
.L117:
	movl	-72(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L119
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L119
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	jne	.L118
.L119:
	movl	-72(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L120
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L120
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L120
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	jne	.L118
.L120:
	movl	-68(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L121
	movl	-68(%rbp), %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L121
	movl	-68(%rbp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L121
	movl	-68(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L121
	movl	-72(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	jne	.L118
	cmpl	$0, -48(%rbp)
	jne	.L121
.L118:
	movl	$3, %eax
	jmp	.L122
.L121:
	movl	$2, %eax
.L122:
	movq	-88(%rbp), %rdx
	movb	%al, 31(%rdx)
	movq	-88(%rbp), %rax
	movzbl	31(%rax), %eax
	cmpb	$2, %al
	jne	.L123
	movl	$3, %eax
	jmp	.L124
.L123:
	movl	$2, %eax
.L124:
	movq	-88(%rbp), %rdx
	movb	%al, 36(%rdx)
.L32:
	andl	$15, -28(%rbp)
	movl	-28(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L125
	movl	$3, %eax
	jmp	.L126
.L125:
	movl	$2, %eax
.L126:
	movq	-88(%rbp), %rdx
	movb	%al, 34(%rdx)
	cmpl	$0, -28(%rbp)
	je	.L127
	movl	$2, %eax
	jmp	.L128
.L127:
	movl	$3, %eax
.L128:
	movq	-88(%rbp), %rdx
	movb	%al, 35(%rdx)
	movq	-88(%rbp), %rax
	movzbl	26(%rax), %eax
	cmpb	$3, %al
	jne	.L129
	movq	-88(%rbp), %rax
	addq	$27, %rax
	movl	$.LC0, %ecx
	movl	$.LC1, %edx
	movl	$4, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	slv_setv
	jmp	.L130
.L129:
	movl	-44(%rbp), %eax
	shrl	$6, %eax
	andl	$7, %eax
	cmpl	$2, %eax
	jne	.L131
	movl	-32(%rbp), %eax
	mov	%eax, %eax
	movl	ram.1625(,%rax,4), %eax
	movq	-88(%rbp), %rdx
	leaq	27(%rdx), %rbx
	movl	%eax, %ecx
	movl	$.LC2, %edx
	movl	$4, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	slv_setv
	jmp	.L130
.L131:
	movq	-88(%rbp), %rax
	leaq	27(%rax), %rbx
	movl	-28(%rbp), %eax
	movl	%eax, %ecx
	movl	$.LC2, %edx
	movl	$4, %esi
	movq	%rbx, %rdi
	movl	$0, %eax
	call	slv_setv
.L130:
	movl	-44(%rbp), %eax
	shrl	$6, %eax
	andl	$7, %eax
	cmpl	$7, %eax
	ja	.L156
	mov	%eax, %eax
	movq	.L139(,%rax,8), %rax
	jmp	*%rax
	.section	.rodata
	.align 8
	.align 4
.L139:
	.quad	.L133
	.quad	.L156
	.quad	.L134
	.quad	.L134
	.quad	.L135
	.quad	.L136
	.quad	.L137
	.quad	.L138
	.text
.L133:
	movl	-28(%rbp), %eax
	movl	%eax, accu.1626(%rip)
	jmp	.L156
.L134:
	movl	-36(%rbp), %eax
	mov	%eax, %eax
	movl	-28(%rbp), %edx
	movl	%edx, ram.1625(,%rax,4)
	jmp	.L156
.L135:
	movq	-88(%rbp), %rax
	addq	$25, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -60(%rbp)
	movq	-88(%rbp), %rax
	addq	$23, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -64(%rbp)
	movl	accu.1626(%rip), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L140
	movl	$3, %eax
	jmp	.L141
.L140:
	movl	$2, %eax
.L141:
	movq	-88(%rbp), %rdx
	movb	%al, 24(%rdx)
	movl	-28(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L142
	movl	$3, %eax
	jmp	.L143
.L142:
	movl	$2, %eax
.L143:
	movq	-88(%rbp), %rdx
	movb	%al, 22(%rdx)
	movl	accu.1626(%rip), %eax
	movl	%eax, %edx
	shrl	%edx
	movl	-60(%rbp), %eax
	sall	$3, %eax
	orl	%edx, %eax
	andl	$15, %eax
	movl	%eax, accu.1626(%rip)
	movl	-36(%rbp), %eax
	movl	-28(%rbp), %edx
	movl	%edx, %ecx
	shrl	%ecx
	movl	-64(%rbp), %edx
	sall	$3, %edx
	orl	%ecx, %edx
	andl	$15, %edx
	mov	%eax, %eax
	movl	%edx, ram.1625(,%rax,4)
	jmp	.L156
.L136:
	movq	-88(%rbp), %rax
	addq	$23, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -64(%rbp)
	movl	accu.1626(%rip), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L144
	movl	$3, %eax
	jmp	.L145
.L144:
	movl	$2, %eax
.L145:
	movq	-88(%rbp), %rdx
	movb	%al, 24(%rdx)
	movl	-28(%rbp), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L146
	movl	$3, %eax
	jmp	.L147
.L146:
	movl	$2, %eax
.L147:
	movq	-88(%rbp), %rdx
	movb	%al, 22(%rdx)
	movl	-36(%rbp), %eax
	movl	-28(%rbp), %edx
	movl	%edx, %ecx
	shrl	%ecx
	movl	-64(%rbp), %edx
	sall	$3, %edx
	orl	%ecx, %edx
	andl	$15, %edx
	mov	%eax, %eax
	movl	%edx, ram.1625(,%rax,4)
	jmp	.L156
.L137:
	movq	-88(%rbp), %rax
	addq	$24, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -52(%rbp)
	movq	-88(%rbp), %rax
	addq	$22, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -56(%rbp)
	movl	accu.1626(%rip), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L148
	movl	$3, %eax
	jmp	.L149
.L148:
	movl	$2, %eax
.L149:
	movq	-88(%rbp), %rdx
	movb	%al, 25(%rdx)
	movl	-28(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L150
	movl	$3, %eax
	jmp	.L151
.L150:
	movl	$2, %eax
.L151:
	movq	-88(%rbp), %rdx
	movb	%al, 23(%rdx)
	movl	accu.1626(%rip), %eax
	addl	%eax, %eax
	orl	-52(%rbp), %eax
	andl	$15, %eax
	movl	%eax, accu.1626(%rip)
	movl	-36(%rbp), %eax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	orl	-56(%rbp), %edx
	andl	$15, %edx
	mov	%eax, %eax
	movl	%edx, ram.1625(,%rax,4)
	jmp	.L156
.L138:
	movq	-88(%rbp), %rax
	addq	$22, %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	std2ui
	movl	%eax, -56(%rbp)
	movl	accu.1626(%rip), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L152
	movl	$3, %eax
	jmp	.L153
.L152:
	movl	$2, %eax
.L153:
	movq	-88(%rbp), %rdx
	movb	%al, 25(%rdx)
	movl	-28(%rbp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L154
	movl	$3, %eax
	jmp	.L155
.L154:
	movl	$2, %eax
.L155:
	movq	-88(%rbp), %rdx
	movb	%al, 23(%rdx)
	movl	-36(%rbp), %eax
	movl	-28(%rbp), %edx
	addl	%edx, %edx
	orl	-56(%rbp), %edx
	andl	$15, %edx
	mov	%eax, %eax
	movl	%edx, ram.1625(,%rax,4)
.L156:
	addq	$88, %rsp
	popq	%rbx
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	amd_run, .-amd_run
	.data
	.align 32
	.type	ram.1625, @object
	.size	ram.1625, 64
ram.1625:
	.long	0
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.long	9
	.long	10
	.long	11
	.long	12
	.long	13
	.long	14
	.long	15
	.align 4
	.type	accu.1626, @object
	.size	accu.1626, 4
accu.1626:
	.long	15
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5.1) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
