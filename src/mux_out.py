from stratus import *
from hdlutils import Entity

class mux_out(Entity):
    def Interface(self):
        self.cmd = SignalIn("command", 3)

        self.ram = SignalIn("ram", 4)
        self.alu = SignalIn("alu", 4)
        
        self.output = SignalOut("output", 4)

        self.vdd = VddIn("vdd")
        self.vss = VssIn("vss")

    def Netlist(self):
        not_cmd = Signal("not_cmd", 3)
        for i in range(3):
            self.inv(self.cmd[i], not_cmd[i])

        # output is RAM when !c2 . c1 . !c0 = !(c2 + !c1 + c0)
        # and ALU otherwise, i.e. !(!c2 . c1 + !c0)
        out_is_ram = Signal("out_is_ram", 1)
        out_is_alu = Signal("out_is_alu", 1)

        self.nor((self.cmd[2], not_cmd[1], self.cmd[0]), out_is_ram, 4)
        self.nand((not_cmd[2], self.cmd[1], not_cmd[0]), out_is_alu, 4)

        # inputs and'd with the signals that tell if they
        # are selected value is RAM (resp. ALU) if out_is_ram
        # (resp. out_is_alu) is '1', or 0 otherwise
        out_ram = Signal("out_ram", 4)
        out_alu = Signal("out_alu", 4)

        for i in range(4):
            self.nand((self.ram[i], out_is_ram), out_ram[i])
            self.nand((self.alu[i], out_is_alu), out_alu[i])
            self.nand((out_ram[i], out_alu[i]), self.output[i])

mux = mux_out("mux_out")
mux.Interface()
mux.Netlist()
mux.Save()
