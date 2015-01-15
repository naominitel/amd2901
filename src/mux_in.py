from stratus import *
from hdlutils import Entity

class mux_in(Entity):
    def Interface(self):
        self.cmd = SignalIn("command", 3)

        self.a = SignalIn("a", 4)
        self.b = SignalIn("b", 4)
        self.d = SignalIn("d", 4)
        self.q = SignalIn("q", 4)

        self.r = SignalOut("r", 4)
        self.s = SignalOut("s", 4)

        self.vdd = VddIn("vdd")
        self.vss = VssIn("vss")

    def Netlist(self):
        not_cmd0 = Signal("not_cmd0", 1)
        not_cmd2 = Signal("not_cmd2", 1)

        self.inv(self.cmd[0], not_cmd0, 1)
        self.inv(self.cmd[2], not_cmd2, 4)

        # signals that tell if A and D are selected
        r_is_a = Signal("r_is_a", 1)
        r_is_d = Signal("r_is_d", 1)
        
        # same for A, B and Q for S
        s_is_a = Signal("s_is_a", 1)
        s_is_b = Signal("s_is_b", 1)
        s_is_q = Signal("s_is_q", 1)

        # R is A when !i1 . !i2 = i1 + i2
        self.nor((self.cmd[1], self.cmd[2]), r_is_a, 4)

        # R is D when i2 . (i0 + i1) = i2
        tmp = Signal("r_is_d_tmp0", 1)
        self.nor((self.cmd[0], self.cmd[1]), tmp)
        self.nor((not_cmd2, tmp), r_is_d, 4)

        # S is A when !i1 . i2 = i1 nor !i2
        self.nor((self.cmd[1], not_cmd2), s_is_a, 4)

        # S is B when i0 . !i2 = !i0 nor i2
        self.nor((not_cmd0, self.cmd[2]), s_is_b, 4)

        # S is Q when (!i0 . ((i1 . i2) + !i2)) = i0 nor (i1 nor !i2)
        tmp = Signal("s_is_q_tmp0", 1)
        self.nor((self.cmd[1], not_cmd2), tmp)
        self.nor((self.cmd[0], tmp), s_is_q, 4)

        # A and D and'd with the signal that tell if they are selected.
        # value is A (resp. D) if A (resp. D) is selected, 0 otherwise
        r_a = Signal("r_a", 4)
        r_d = Signal("r_d", 4)

        # same for S
        s_a = Signal("s_a", 4)
        s_b = Signal("s_b", 4)
        s_q = Signal("s_q", 4)

        for i in range(4):
            self.nand((self.d[i], r_is_d), r_d[i])
            self.nand((self.a[i], r_is_a), r_a[i])
            self.nand((self.a[i], s_is_a), s_a[i])
            self.nand((self.b[i], s_is_b), s_b[i])
            self.nand((self.q[i], s_is_q), s_q[i])
            self.nand((r_a[i], r_d[i]),         self.r[i])
            self.nand((s_a[i], s_b[i], s_q[i]), self.s[i])

mux = mux_in("mux_in")
mux.Interface()
mux.Netlist()
mux.Save()
