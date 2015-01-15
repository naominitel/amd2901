#!/usr/bin/python

from stratus import *

class amd_chip(Model):
    def Interface(self):
        self.cke   = CkIn        ("clk")
        self.cin   = SignalIn    ("cin",   1)
        self.cout  = SignalOut   ("cout",  1)
        self.np    = SignalOut   ("np",    1)
        self.ng    = SignalOut   ("ng",    1)
        self.ovr   = SignalOut   ("ovr",   1)
        self.zero  = SignalOut   ("zero",  1)
        self.f3    = SignalOut   ("f3",    1)
        self.r0    = SignalInOut ("r0",    1)
        self.r3    = SignalInOut ("r3",    1)
        self.q0    = SignalInOut ("q0",    1)
        self.q3    = SignalInOut ("q3",    1)
        self.a     = SignalIn    ("a",     4)
        self.b     = SignalIn    ("b",     4)
        self.d     = SignalIn    ("d",     4)
        self.i     = SignalIn    ("i",     9)
        self.noe   = SignalIn    ("noe",   1)
        self.y     = TriState    ("y",     4)

        self.vdd  = VddIn ("vddi")
        self.vss  = VssIn ("vssi")
        self.vdde = VddIn ("vdde")
        self.vsse = VssIn ("vsse")

    def Netlist(self):
        cin_from_pads = Signal ("cin_from_pads", 1)
        cout_to_pads  = Signal ("cout_to_pads",  1)
        np_to_pads    = Signal ("np_to_pads",    1)
        ng_to_pads    = Signal ("ng_to_pads",    1)
        ovr_to_pads   = Signal ("ovr_to_pads",   1)
        zero_to_pads  = Signal ("zero_to_pads",  1)
        shift_r       = Signal ("shift_r",       1)
        shift_l       = Signal ("shift_l",       1)
        f3_to_pads    = Signal ("f3_to_pads",    1)
        r0_to_pads    = Signal ("r0_to_pads",    1)
        r3_to_pads    = Signal ("r3_to_pads",    1)
        r0_from_pads  = Signal ("r0_from_pads",  1)
        r3_from_pads  = Signal ("r3_from_pads",  1)
        q0_to_pads    = Signal ("q0_to_pads",    1)
        q3_to_pads    = Signal ("q3_to_pads",    1)
        q0_from_pads  = Signal ("q0_from_pads",  1)
        q3_from_pads  = Signal ("q3_from_pads",  1)
        ck_ring       = Signal ("ck_ring",       1)
        a_from_pads   = Signal ("a_from_pads",   4)
        b_from_pads   = Signal ("b_from_pads",   4)
        d_from_pads   = Signal ("d_from_pads",   4)
        i_from_pads   = Signal ("i_from_pads",   9)
        y_to_pads     = Signal ("y_to_pads",     4)
        noe_from_pads = Signal ("noe_from_pads", 1)
        y_oe          = Signal ("y_oe",          1)
        self.ckc      = Signal ("ckc",           1)

        self.coeur = Inst( "core", "core0", map = {
            'cin_from_pads' : cin_from_pads,
            'cout_to_pads'  : cout_to_pads,
            'np_to_pads'    : np_to_pads,
            'ng_to_pads'    : ng_to_pads,
            'ovr_to_pads'   : ovr_to_pads,
            'f3_to_pads'    : f3_to_pads,
            'zero_to_pads'  : zero_to_pads,
            'shift_r'       : shift_r,
            'shift_l'       : shift_l,
            'r0_to_pads'    : r0_to_pads,
            'r3_to_pads'    : r3_to_pads,
            'r0_from_pads'  : r0_from_pads,
            'r3_from_pads'  : r3_from_pads,
            'q0_to_pads'    : q0_to_pads,
            'q3_to_pads'    : q3_to_pads,
            'q0_from_pads'  : q0_from_pads,
            'q3_from_pads'  : q3_from_pads,
            'ck'            : self.ckc,
            'a_from_pads'   : a_from_pads,
            'b_from_pads'   : b_from_pads,
            'd_from_pads'   : d_from_pads,
            'i_from_pads'   : i_from_pads,
            'y_to_pads'     : y_to_pads,
            'noe_from_pads' : noe_from_pads,
            'y_oe'          : y_oe,
            'vdd'           : self.vdd,
            'vss'           : self.vss
        })

        self.p_ck = Inst(
            "pck_px", "p_ck",
            map = {
                'pad'  : self.cke,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_cin = Inst(
            "pi_px", "p_cin",
            map = {
                'pad'  : self.cin,
                't'    : cin_from_pads,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_noe = Inst(
            "pi_px", "p_noe",
            map = {
                'pad'  : self.noe,
                't'    : noe_from_pads,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
                }
            )

        self.p_a = {}
        self.p_b = {}
        self.p_d = {}

        for i in range(4):
            self.p_a[i] = Inst(
                "pi_px", "p_a%d" % i,
                map = {
                    'pad'  : self.a[i],
                    't'    : a_from_pads[i],
                    'ck'   : ck_ring,
                    'vddi' : self.vdd,
                    'vssi' : self.vss,
                    'vdde' : self.vdde,
                    'vsse' : self.vsse
                }
            )

            self.p_b[i] = Inst(
                "pi_px", "p_b%d" % i,
                map = {
                    'pad'  : self.b[i],
                    't'    : b_from_pads[i],
                    'ck'   : ck_ring,
                    'vddi' : self.vdd,
                    'vssi' : self.vss,
                    'vdde' : self.vdde,
                    'vsse' : self.vsse
                }
            )

            self.p_d[i] = Inst(
                "pi_px", "p_d%d" % i,
                map = {
                    'pad'  : self.d[i],
                    't'    : d_from_pads[i],
                    'ck'   : ck_ring,
                    'vddi' : self.vdd,
                    'vssi' : self.vss,
                    'vdde' : self.vdde,
                    'vsse' : self.vsse
                }
            )

        self.p_i = {}

        for i in range(9):
            self.p_i[i] = Inst(
                "pi_px", "p_i%d" % i,
                map = {
                    'pad'  : self.i[i],
                    't'    : i_from_pads[i],
                    'ck'   : ck_ring,
                    'vddi' : self.vdd,
                    'vssi' : self.vss,
                    'vdde' : self.vdde,
                    'vsse' : self.vsse
                }
            )

        self.p_cout = Inst(
            "po_px", "p_cout",
             map = {
                'i'    : cout_to_pads,
                'pad'  : self.cout,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_np = Inst(
            "po_px", "p_np",
            map = {
                'i'    : np_to_pads,
                'pad'  : self.np,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_ng = Inst(
            "po_px", "p_ng",
            map = {
                'i'    : ng_to_pads,
                'pad'  : self.ng,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_ovr = Inst(
            "po_px", "p_ovr",
            map = {
                'i'    : ovr_to_pads,
                'pad'  : self.ovr,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_zero = Inst(
            "po_px", "p_zero",
            map = {
                'i'    : zero_to_pads,
                'pad'  : self.zero,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_f3 = Inst(
            "po_px", "p_f3",
            map = {
                'i'    : f3_to_pads,
                'pad'  : self.f3,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_y = {}

        for i in range(4):
            self.p_y[i] = Inst(
                "pot_px", "p_y%d" % i,
                map = {
                    'i'    : y_to_pads[i],
                    'b'    : y_oe,
                    'pad'  : self.y[i],
                    'ck'   : ck_ring,
                    'vddi' : self.vdd,
                    'vssi' : self.vss,
                    'vdde' : self.vdde,
                    'vsse' : self.vsse
            }
        )

        self.p_q0 = Inst(
            "piot_px", "p_q0",
            map = {
                'i'    : q0_to_pads,
                'b'    : shift_r,
                't'    : q0_from_pads,
                'pad'  : self.q0,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_q3 = Inst(
            "piot_px", "p_q3",
            map = {
                'i'    : q3_to_pads,
                'b'    : shift_l,
                't'    : q3_from_pads,
                'pad'  : self.q3,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_r0 = Inst(
            "piot_px", "p_r0",
            map = {
                'i'    : r0_to_pads,
                'b'    : shift_r,
                't'    : r0_from_pads,
                'pad'  : self.r0,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse 
            }
        )

        self.p_r3 = Inst(
            "piot_px", "p_r3",
            map = {
                'i'    : r3_to_pads,
                'b'    : shift_l,
                't'    : r3_from_pads,
                'pad'  : self.r3,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_vddick0 = Inst(
            "pvddick_px", "p_vddick0",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_vssick0 = Inst(
            "pvssick_px", "p_vssick0",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse 
            }
        )

        self.p_vddeck0 = Inst(
            "pvddeck_px", "p_vddeck0",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse
            }
        )

        self.p_vddeck1 = Inst(
            "pvddeck_px", "p_vddeck1",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse 
            }
        )

        self.p_vsseck0 = Inst(
            "pvsseck_px", "p_vsseck0",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse 
            }
        )

        self.p_vsseck1 = Inst(
            "pvsseck_px", "p_vsseck1",
            map = {
                'cko'  : self.ckc,
                'ck'   : ck_ring,
                'vddi' : self.vdd,
                'vssi' : self.vss,
                'vdde' : self.vdde,
                'vsse' : self.vsse 
            }
        )

    def Layout(self):
        ##### A COMLPETER #####
        DefAb(XY(0,0),XY(3000,3000))
        PlaceCentric(self.coeur)

        PadNorth(self.p_i[3],self.p_i[4],self.p_i[5],self.p_b[0],self.p_b[1],self.p_b[2],self.p_b[3]
            ,self.p_q0,self.p_q3,self.p_i[6],self.p_i[7])

        PadWest(self.p_ck,self.p_d[0],self.p_d[1],self.p_d[2],self.p_zero,self.p_vsseck0,self.p_ovr
            ,self.p_d[3],self.p_i[0],self.p_i[1],self.p_i[2])

        PadSouth(self.p_cin,self.p_np,self.p_ng,self.p_vssick0,self.p_vddeck0,self.p_vsseck1,self.p_vddeck1
            ,self.p_cout,self.p_y[0],self.p_y[1],self.p_y[2])

        PadEast(self.p_y[3],self.p_f3,self.p_noe,self.p_a[0],self.p_a[1],self.p_vddick0
            ,self.p_a[2],self.p_a[3],self.p_r0,self.p_r3,self.p_i[8])

        PowerRing(3)
        PlaceGlue(self.coeur)
        FillCell(self.coeur)
        RouteCk(self.ckc)

mon_chip = amd_chip("amd2901")
mon_chip.Interface()
mon_chip.Netlist()
#mon_chip.Layout()
#mon_chip.View()
mon_chip.Save()
