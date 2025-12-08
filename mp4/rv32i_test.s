    lui   x1, 0xFEDCC            # pc = 0x00, x1 = 0xFEDCC000
    addi  x1, x1, 0xA98         # pc = 0x04, x1 = 0xFEDCBA98
    srli  x2, x1, 4              # pc = 0x08, x2 = 0x0FEDCBA9
    srai  x3, x1, 4              # pc = 0x0C, x3 = 0xFFEDCBA9
    xori  x4, x3, -1             # pc = 0x10, x4 = 0x00123456
    addi  x5, x0, 2              # pc = 0x14, x5 = 0x00000002
    add   x6, x5, x4             # pc = 0x18, x6 = 0x00123458
    sub   x7, x6, x4             # pc = 0x1C, x7 = 0x00000002
    sll   x8, x4, x5             # pc = 0x20, x8 = 0x0048D158
    ori   x9, x8, 7              # pc = 0x24, x9 = 0x0048D15F
    lui   x24, 1                 # pc = 0x28, x24 = 0x00001000
    auipc x10, 0x12345           # pc = 0x2C, x10 ≈ 0x1234502C
    slt   x11, x3, x4            # pc = 0x30, x11 = 0x00000001
    sltu  x12, x3, x4            # pc = 0x34, x12 = 0x00000000

    jal   x13, 0x2C              # pc = 0x38, x13 = 0x0000002C (jump to 0x64)

    addi  x15, x0, 10            # pc = 0x3C, x15 = 0x0000000A
    beq   x15, x0, 12            # pc = 0x40 should not branch the first time because 10 != 0
    addi  x15, x15, -1           # pc = 0x44
    jal   x16, -8                # pc = 0x48, x16 = 0x00000040
    bltu  x3, x4, 8              # pc = 0x4C wont branch bc x3 is neg
    blt   x3, x4, 20             # pc = 0x50 will branch bc x3 is read as big number
                                  # pc = 0x54
                                  # pc = 0x58
                                  # pc = 0x5C
    jalr  x14, 0(x13)            # pc = 0x60, x14 = 0x0000003C (return)

    # ========== STORE BLOCK (jumped to FIRST) ==========
    addi  x17, x0, 0xC0          # pc = 0x64, x17 = 0x000000C0
    sb    x17, -4(x24)           # pc = 0x68  writes 0xC0 to 0x0FFC
    sb    x17, -3(x24)           # pc = 0x6C  writes 0xC0 to 0x0FFD
    sb    x17, -2(x24)           # pc = 0x70  writes 0xC0 to 0x0FFE
    sb    x17, -1(x24)           # pc = 0x74  writes 0xC0 to 0x0FFF

    # ========== LOAD BLOCK (happens AFTER stores) ==========
    lw    x18, -4(x24)           # pc = 0x78, x18 = 0xC0C0C0C0
    lw    x19, -12(x24)          # pc = 0x7C, x19 = unknown/uninitialized
    lh    x20, -4(x24)           # pc = 0x80, x20 = 0xFFFFC0C0
    lhu   x21, -4(x24)           # pc = 0x84, x21 = 0x0000C0C0
    lb    x22, -4(x24)           # pc = 0x88, x22 = 0xFFFFFFC0
    lbu   x23, -4(x24)           # pc = 0x8C, x23 = 0x000000C0

    jalr  x0, 0(x13)             # pc = 0x90, jump back to 0x3C (no link)
