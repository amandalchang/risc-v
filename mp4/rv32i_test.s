    lui   x1, 0xFEDCC            # pc = 0x1000, x1 = 0xFEDCC000
    addi  x1, x1, 0xA98          # pc = 0x1004, x1 = 0xFEDCBA98
    srli  x2, x1, 4              # pc = 0x1008, x2 = 0x0FEDCBA9
    srai  x3, x1, 4              # pc = 0x100C, x3 = 0xFFEDCBA9
    xori  x4, x3, -1             # pc = 0x1010, x4 = 0x00123456
    addi  x5, x0, 2              # pc = 0x1014, x5 = 0x00000002
    add   x6, x5, x4             # pc = 0x1018, x6 = 0x00123458
    sub   x7, x6, x4             # pc = 0x101C, x7 = 0x00000002
    sll   x8, x4, x5             # pc = 0x1020, x8 = 0x0048D158
    ori   x9, x8, 7              # pc = 0x1024, x9 = 0x0048D15F
    lui   x24, 1                 # pc = 0x1028, x24 = 0x00001000
    auipc x10, 0x12345           # pc = 0x102C, x10 ≈ 0x1234602C
    slt   x11, x3, x4            # pc = 0x1030, x11 = 0x00000001
    sltu  x12, x3, x4            # pc = 0x1034, x12 = 0x00000000
    jal   x13, 44                # pc = 0x1038, x13 = 0x0000103C (jump to 0x1064)
    addi  x15, x0, 10            # pc = 0x103C, x15 = 0x0000000A
    beq   x15, x0, 12            # pc = 0x1040 should not branch the first time because 10 != 0
    addi  x15, x15, -1           # pc = 0x1044
    jal   x16, -8                # pc = 0x1048, x16 = 0x00000040
    bltu  x3, x4, 8              # pc = 0x104C wont branch bc x3 is neg
    blt   x3, x4, 20             # pc = 0x1050 will branch bc x3 is read as big number
                                 # pc = 0x1054
                                 # pc = 0x1058
                                 # pc = 0x105C
    jalr  x14, 0(x13)            # pc = 0x1060, x14 = 0x0000003C (return)
    addi  x17, x0, 0xC0          # pc = 0x1064, x17 = 0x000000C0 # store block (jumped to first)
    sb    x17, -4(x24)           # pc = 0x1068  writes 0xC0 to 0x0FFC
    sb    x17, -3(x24)           # pc = 0x106C  writes 0xC0 to 0x0FFD
    sb    x17, -2(x24)           # pc = 0x1070  writes 0xC0 to 0x0FFE
    sb    x17, -1(x24)           # pc = 0x1074  writes 0xC0 to 0x0FFF # end of store block
    lw    x18, -4(x24)           # pc = 0x1078, x18 = 0xC0C0C0C0 # load block
    lw    x19, -12(x24)          # pc = 0x107C, x19 = unknown/uninitialized
    lh    x20, -4(x24)           # pc = 0x1080, x20 = 0xFFFFC0C0
    lhu   x21, -4(x24)           # pc = 0x1084, x21 = 0x0000C0C0
    lb    x22, -4(x24)           # pc = 0x1088, x22 = 0xFFFFFFC0
    lbu   x23, -4(x24)           # pc = 0x108C, x23 = 0x000000C0 # end of load block
    jalr  x25, 0(x13)             # pc = 0x1090, jump back to 0x3C (no link)
