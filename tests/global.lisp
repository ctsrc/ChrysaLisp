;import system settings
(run 'apps/sys.lisp)

;open farm of children, create multicast msg
(defq ids (slot open_farm nil "tests/global_child" (mul (slot cpu_total nil) 3) kn_call_open)
	msg (apply cat (map (lambda (_)
		(char (mul _ long_size) long_size)) (range 0 (div (mul lk_data_size 10) long_size)))))

(while (defq cpu (pop ids) mbox (pop ids))
	(if (ne mbox 0) (slot mail_send nil msg mbox cpu)))
