entry:
    addi a2, zero, 4    # load parameter for fib (x12)
    jal  fib            # jump to fib(3)
    jal  idle           # idle loop
idle:
    jal  x0, idle
fib: # pc = 16
    addi sp, sp, -12    # declare stack space (x2)
    sw   ra, 8(sp)      # ra is saved by callee (x1)
    sw   s0, 4(sp)      # sX is saved by callee (x8)
fib_if_zero_or_one: # pc = 28
    addi a0, zero, 0        # set return value a0 = 0 (x10)
    beq  a2, zero, fib_fin  # n is a2, if a2 == 0, goto fib_fin
    addi a0, a0, 1          # set return value a0 = 1
    beq  a2, a0, fib_fin    # n is a2, if a2 == 1, goto fib_fin
fib_call_n_1: # pc = 44
    addi a2, a2, -1     # prepare for fib(n-1) call
    sw   a2, 0(sp)      # save n-1 to memory 
    jal  fib            # call fib(n-1)
    add  s0, a0, zero   # mov fib(n-1) to s0
fib_call_n_2: # pc = 60
    lw   a2, 0(sp)      # load n-1 from memory
    addi a2, a2, -1     # prepare for fib(n-2) call
    jal  fib            # call fib(n-2)
    add  a0, a0, s0     # a0 = fib(n-1) + fib(n-2)
fib_fin: # pc = 76
    lw   s0, 4(sp)      # restore s0
    lw   ra, 8(sp)      # restore ra
    addi sp, sp, 12     # restore sp
    jr   ra             # pseudo-asm === jalr x0, ra, 0