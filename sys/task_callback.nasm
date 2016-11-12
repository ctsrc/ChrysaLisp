%include 'inc/func.ninc'
%include 'inc/mail.ninc'

def_func sys/task_callback
	;inputs
	;r0 = callback address
	;r1 = user data address
	;trashes
	;all but r4

	;test if we are the kernel task
	f_bind sys_task, statics, r3
	vp_cpy [r3 + tk_statics_current_tcb], r2
	if r2, ==, [r3 + tk_statics_kernel_tcb]
		;yes we can just do local call
		vp_xchg r0, r1
		vp_jmp r1
	endif

	;save task info
	vp_cpy r0, r5
	vp_cpy r1, r6

	;create temp mailbox
	ml_temp_create r0, r1

	;allocate mail message
	f_call sys_mail, alloc, {}, {r3}
	assert r0, !=, 0

	;fill in destination, reply and function
	f_call sys_cpu, id, {}, {r0}
	vp_cpy r4, [r3 + kn_msg_reply_id]
	vp_cpy r0, [r3 + kn_msg_reply_id + 8]
	vp_xor r1, r1
	vp_cpy r1, [r3 + msg_dest + id_mbox]
	vp_cpy r0, [r3 + msg_dest + id_cpu]
	vp_cpy kn_call_callback, r1
	vp_cpy r1, [r3 + kn_msg_function]
	vp_cpy r5, [r3 + kn_msg_callback_addr]
	vp_cpy r6, [r3 + kn_msg_user]
	vp_cpy kn_msg_callback_size, r1
	vp_cpy r1, [r3 + msg_length]

	;send mail to kernel then wait for reply
	f_call sys_mail, send, {r3}
	f_call sys_mail, read, {r4}, {r0}

	;free reply mail and temp mailbox
	ml_temp_destroy
	f_jmp sys_mem, free, {r0}

def_func_end
