    lui   x1, 0xFEDCC           # x1 = 0xFEDCC000
    addi  x1, x1, 0xA98         # x1 = 0xFEDCBA98
    srli  x2, x1, 4             # x2 = 0x0FEDCBA9
    srai  x3, x1, 4             # x3 = 0xFFEDCBA9
    xori  x4, x3, -1            # x4 = 0x00123456
    addi  x5, x0, 2             # x5 = 2
    add   x6, x5, x4            # x6 = 0x00123458
    sub   x7, x6, x4            # x7 = 2
    sll   x8, x4, x5            # x8 = 0x0048D158
    ori   x9, x8, 7             # x9 = 0x0048D15F
    auipc x10, 0x12345          # x10 ≈ 0x12345028
    slt   x11, x3, x4           # x11 = 1
    sltu  x12, x3, x4           # x12 = 0
    jal   x13, 0x28             # x13 = return addr 0x38
    addi  x15, x0, 10           # loop counter
    beq   x15, x0, 12           # skip if zero
    addi  x15, x15, -1
    jal   x16, -8
    bltu  x3, x4, 8
    blt   x3, x4, 20
                                # 
                                # 
                                # 
    jalr  x14, 0(x13)           # x14 = 0x60
    addi  x17, x0, 0xC0         # x17 = 0xC0
    addi  x24, x0, 0x1000        # x24 = safe base pointer = 0x1000
    sb    x17, -4(x24)          # store to 0x100 - 4 = 0xFC
    sb    x17, -3(x24)          # store to 0xFD
    sb    x17, -2(x24)          # store to 0xFE
    sb    x17, -1(x24)          # store to 0xFF
    lw    x18, -4(x24)          # load word from 0xFC
    lw    x19, -12(x24)         # load word from 0x100 - 12 = 0xF4
    lh    x20, -4(x24)          # load halfword from 0xFC
    lhu   x21, -4(x24)          # load halfword un-signed
    lb    x22, -4(x24)          # load byte from 0xFC (signed)
    lbu   x23, -4(x24)          # load byte from 0xFC (unsigned)
