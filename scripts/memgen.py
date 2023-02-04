import unittest

R0 = 0
R1 = 1
R2 = 2
R3 = 3
R4 = 4
R5 = 5
R6 = 6
R7 = 7


class MemGen:
    def __init__(self, save_instr=False):
        self.save_instr = save_instr
        self.memory = ''

    def clear_memory(self):
        self.memory = ''

    def print_memory(self):
        print(self.memory)

    def rtype(self, rs, rt, rd, func):
        bits = '000000' + self.bin_fill(rs) + self.bin_fill(rt) + self.bin_fill(rd) + '00000' + func
        return self.get_hex(bits)

    def add(self, rd, rs, rt):
        return self.rtype(rs, rt, rd, '100000')

    def sub(self, rd, rs, rt):
        return self.rtype(rs, rt, rd, '100010')

    def and_(self, rd, rs, rt):
        return self.rtype(rs, rt, rd, '100100')

    def or_(self, rd, rs, rt):
        return self.rtype(rs, rt, rd, '100101')

    def slt(self, rd, rt, rs):
        return self.rtype(rs, rt, rd, '101010')

    def itype(self, op, rs, rt, imm):
        bits =  op + self.bin_fill(rs) + self.bin_fill(rt) + self.bin_fill(imm, 16)
        return self.get_hex(bits)

    def addi(self, rt, rs, imm):
        return self.itype('001000', rs, rt, imm)

    def beq(self, rt, rs, imm):
        return self.itype('000100', rs, rt, imm)

    def lb(self, rt, rs, imm):
        return self.itype('100000', rs, rt, imm)

    def sb(self, rt, rs, imm):
        return self.itype('101000', rs, rt, imm)

    def j(self, addr):
        bits = '000010' + self.bin_fill(addr, 26)
        return self.get_hex(bits)

    def bin_fill(self, num, pad = 5):
        return bin(num)[2:].zfill(pad)

    def get_hex(self, bits):
        hex_instr = hex(int(bits, 2))[2:].zfill(8)
        if self.save_instr:
            self.memory += hex_instr + '\n'
        return hex_instr

    def add_garbage(self, num=1):
        for i in range(num):
            self.memory += 'FFFFFFFF\n'


class MemGenTest(unittest.TestCase):
    def setUp(self):
        self.cut = MemGen()

    def test_add(self):
        actual = self.cut.add(R3, R3, R3)
        self.assertEqual('00631820', actual)

    def test_addi(self):
        actual = self.cut.addi(R3, R0, 10)
        self.assertEqual('2003000a', actual)

    def test_fill(self):
        self.assertEqual('00000', self.cut.bin_fill(R0))
        self.assertEqual('00001', self.cut.bin_fill(R1))
        self.assertEqual('00010', self.cut.bin_fill(R2))
        self.assertEqual('00011', self.cut.bin_fill(R3))
        self.assertEqual('00100', self.cut.bin_fill(R4))
        self.assertEqual('00101', self.cut.bin_fill(R5))
        self.assertEqual('00110', self.cut.bin_fill(R6))
        self.assertEqual('00111', self.cut.bin_fill(R7))


def addiexample():
    m = MemGen(True)
    m.addi(R1, R0, 10)
    m.addi(R2, R0, 3)
    m.addi(R3, R0, 12)
    m.addi(R4, R0, 18)
    m.print_memory()

def lbexample():
    m = MemGen(True)
    m.addi(R1, R0, 120)
    m.lb(R2, R1, 2)
    m.print_memory()

def main_example():
    m = MemGen(True)
    m.j(5)
    m.add_garbage(4)

    m.addi(R1, R0, 10)
    m.addi(R2, R0, 15)
    m.add(R3, R1, R2)
    m.sub(R4, R2, R1)
    m.and_(R5, R2, R0)
    m.or_(R6, R2, R0)
    m.slt(R7, R1, R0)
    m.beq(R2, R0, 40)
    m.beq(R2, R2, 2)
    m.add_garbage(2)
    m.j(0)
    m.print_memory()

def sb_examble():
    m = MemGen(True)
    m.addi(R1, R0, 128)
    m.addi(R2, R0, 10)
    m.sb(R2, R1, 0)
    m.sb(R2, R1, 1)
    m.sb(R2, R1, 2)
    m.sb(R2, R1, 3)
    m.print_memory()

def dual_example():
    m = MemGen(True)
    m.addi(R1, R0, 10)
    m.addi(R2, R0, 10)
    m.addi(R3, R0, 10)
    m.addi(R4, R0, 10)
    m.addi(R5, R0, 10)
    m.addi(R6, R0, 10)
    m.addi(R7, R0, 10)
    m.memory += '@40 '
    m.addi(R1, R0, 85)
    m.addi(R2, R0, 85)
    m.addi(R3, R0, 85)
    m.addi(R4, R0, 85)
    m.addi(R5, R0, 85)
    m.addi(R6, R0, 85)
    m.addi(R7, R0, 85)
    m.print_memory()

def foo():
    m = MemGen(True)
    m.addi(R1, R0, 1)
    m.addi(R1, R1, 1)

def isqrt(memsize=256):
    m = MemGen(True)
    # get y
    m.addi(R1, R0, memsize-4)
    m.lb(R1, R1, 1)
    # L, a, d
    m.addi(R2, R0, 0)
    m.addi(R3, R0, 1)
    m.addi(R4, R0, 3)
    # while a <= y (not y < a)
    m.slt(R5, R3, R1) # returns 1 if (y < a) else 0
    m.beq(R5, R0, 1)  # if 0, skip the jump and continue the loop
    m.j(12)
    # in loop
    m.add(R3, R3, R4)
    m.addi(R4, R4, 2)
    m.addi(R2, R2, 1)
    m.j(5)
    # done
    m.addi(R1, R0, memsize-8)
    m.lb(R7, R1, 0)
    m.beq(R7, R2, 1)
    m.sb(R2, R1, 0)
    m.j(0)

    # # y value
    m.memory += f'@{hex(memsize//4)[2:]} 08000000'
    m.print_memory()

def fib(memsize=128):
    m = MemGen(True)
    # get y
    m.addi(R1, R0, memsize-4)
    m.lb(R1, R1, 1)

    # if y = 0 return 0
    m.addi(R3, R0, 0)
    m.beq(R1, R0, 1)
    m.beq(R0, R0, 1)
    m.j(25)

    # if y = 1 return 1
    m.addi(R3, R0, 1)
    m.beq(R1, R3, 1)
    m.beq(R0, R0, 1)
    m.j(25)

    # initial f0 = 0 f1 = 1
    m.addi(R3, R0, 0)
    m.addi(R4, R0, 1)

    # loop start
    m.addi(R2, R0, 0) # counter

    # return if counter = y
    m.beq(R2, R1, 1)
    m.beq(R0, R0, 1)
    m.j(25)

    # temp = f-1 + f-2
    m.add(R6, R4, R3)
    # f-2 = f-1
    m.add(R3, R4, R0)
    # f-1 = temp
    m.add(R4, R6, R0)

    # increment counter
    m.addi(R7, R0, 1)
    m.add(R2, R2, R7)

    # continue loop
    m.j(13)

    # store result when finished
    m.memory += '@19 '
    m.addi(R1, R0, memsize-8)
    m.sb(R3, R1, 0)

    # repeat
    m.j(0)
    m.print_memory()

if __name__ == '__main__':
    # fib(128)
    m = MemGen(True)
    m.addi(R7, R4, 189)
    m.or_(R7, R3, R2)
    m.sb(R1, R1, 148)

    m.print_memory()



    