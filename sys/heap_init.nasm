%include 'inc/func.ninc'
%include 'inc/heap.ninc'

def_func sys/heap_init
	;inputs
	;r0 = heap
	;r1 = cell size
	;r2 = block size
	;outputs
	;r0 = heap
	;r1 = cell size
	;r2 = block size
	;trashes
	;r2

	vp_add ptr_size - 1, r1
	vp_and -ptr_size, r1
	vp_cpy r1, [r0 + hp_heap_cellsize]
	vp_cpy r2, [r0 + hp_heap_blocksize]
	vp_xor r2, r2
	vp_cpy r2, [r0 + hp_heap_free_flist]
	vp_cpy r2, [r0 + hp_heap_block_flist]
	vp_ret

def_func_end
