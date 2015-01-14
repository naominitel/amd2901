library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is port (
    -- controls the ALU function
    fun : in std_logic_vector (2 downto 0);

    -- 4-bits operands
    r : in std_logic_vector (3 downto 0);
    s : in std_logic_vector (3 downto 0);

    -- carry in
    cin : in  std_logic;
    cn4 : out std_logic;

    -- 4-bits output
    output : out std_logic_vector (3 downto 0);

    -- for carry-lookahead chaining, NP, NG and OVR
    np  : out std_logic;
    ng  : out std_logic;
    ovr : out std_logic;

    vdd : in std_logic;
    vss : in std_logic
); end alu;

architecture behavioural of alu is
    component inv_x1 port (      i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component a2_x2  port ( i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component o2_x2  port ( i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component na2_x1 port ( i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component no2_x1 port ( i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component xr2_x1 port ( i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;

    -- not'd function (for input-selection multiplexers)
    signal inv_f0 : std_logic;
    signal inv_f1 : std_logic;
    signal inv_f2 : std_logic;

    signal n_cin : std_logic;

    -- input-selection multiplexers internal signals
    signal muxra0, muxra1, muxr_c : std_logic;
    signal muxsa0, muxs_c : std_logic;

    -- final operands after (maybe) inversion
    signal op_r : std_logic_vector (3 downto 0);
    signal op_s : std_logic_vector (3 downto 0);

    -- propagate and generate signals
    -- a 4 bits CLA requires 3 stages of it
    signal pi  : std_logic_vector (3 downto 0);
    signal gi  : std_logic_vector (3 downto 0);
    signal p1  : std_logic_vector (3 downto 1);
    signal g1  : std_logic_vector (3 downto 1);
    signal g1a : std_logic_vector (3 downto 1);
    signal p2  : std_logic_vector (3 downto 2);
    signal g2  : std_logic_vector (3 downto 2);
    signal g2a : std_logic_vector (3 downto 2);
    signal cout  : std_logic_vector (4 downto 1);
    signal couta : std_logic_vector (4 downto 1);

    -- adder signals
    signal add_np  : std_logic;
    signal add_ng  : std_logic;
    signal add_ovr : std_logic;
    signal add_res : std_logic_vector (3 downto 0);

    -- xorer signals
    signal xor_ga0, xor_ga1, xor_ga2, xor_ga3, xor_ga4 : std_logic;
    signal xor_go0, xor_go1, xor_go2 : std_logic;
    signal xor_po0, xor_po1 : std_logic;
    signal xor_np  : std_logic;
    signal xor_ng  : std_logic;
    signal xor_cn4 : std_logic;
    signal xor_res : std_logic_vector (3 downto 0);

    -- ander signals
    signal and_ng  : std_logic;
    signal and_cn4 : std_logic;
    signal and_ovr : std_logic;

    -- orer signals
    signal or_cn4 : std_logic;

    -- output multiplexer signals

    -- temporaries for signal selection
    signal mux_ad0, mux_ad1, mux_ad2 : std_logic;
    signal mux_or0 : std_logic;

    -- signals that tell wether each
    -- operation is selected or not
    signal mux_add, mux_or, mux_and, mux_xor : std_logic;

    -- signals for each operation, anded with
    -- wether they are selected or not
    signal mux_addr, mux_orr, mux_andr, mux_xorr : std_logic_vector (3 downto 0);
    signal mux_addp, mux_orp, mux_andp, mux_xorp : std_logic;
    signal mux_addg, mux_org, mux_andg, mux_xorg : std_logic;
    signal mux_addc, mux_orc, mux_andc, mux_xorc : std_logic;
    signal mux_addo, mux_oro, mux_ando, mux_xoro : std_logic;

    -- temporary signals for final oring
    -- of the signals of each operation
    signal mux_ro0, mux_ro1 : std_logic_vector (3 downto 0);
    signal mux_go0, mux_go1 : std_logic;
    signal mux_co0, mux_co1 : std_logic;
    signal mux_oo0, mux_oo1 : std_logic;
begin
    -- input selection multiplexers --

    -- inverted command
    f_inv0 : inv_x1 port map (i => fun(0), nq => inv_f0, vdd => vdd, vss => vss);
    f_inv1 : inv_x1 port map (i => fun(1), nq => inv_f1, vdd => vdd, vss => vss);
    f_inv2 : inv_x1 port map (i => fun(2), nq => inv_f2, vdd => vdd, vss => vss);

    cin_inv : inv_x1 port map (i => cin, nq => n_cin, vdd => vdd, vss => vss);

    -- invert operand r for fun = 001, 101 or 111
    muxr_na0 : na2_x1 port map (i0 => fun(0), i1 => inv_f1, nq => muxra0, vdd => vdd, vss => vss);
    muxr_na1 : na2_x1 port map (i0 => fun(0), i1 => fun(2), nq => muxra1, vdd => vdd, vss => vss);
    muxr_na2 : na2_x1 port map (i0 => muxra0, i1 => muxra1, nq => muxr_c, vdd => vdd, vss => vss);
    muxr_xr0 : xr2_x1 port map (i0 => r(0), i1 => muxr_c, q => op_r(0), vdd => vdd, vss => vss);
    muxr_xr1 : xr2_x1 port map (i0 => r(1), i1 => muxr_c, q => op_r(1), vdd => vdd, vss => vss);
    muxr_xr2 : xr2_x1 port map (i0 => r(2), i1 => muxr_c, q => op_r(2), vdd => vdd, vss => vss);
    muxr_xr3 : xr2_x1 port map (i0 => r(3), i1 => muxr_c, q => op_r(3), vdd => vdd, vss => vss);

    -- inver operand s for fun = 010
    muxs_na0 : na2_x1 port map (i0 => inv_f0, i1 => fun(1), nq => muxsa0, vdd => vdd, vss => vss);
    muxs_no1 : no2_x1 port map (i0 => fun(2), i1 => muxsa0, nq => muxs_c, vdd => vdd, vss => vss);
    muxs_xr0 : xr2_x1 port map (i0 => s(0), i1 => muxs_c, q => op_s(0), vdd => vdd, vss => vss);
    muxs_xr1 : xr2_x1 port map (i0 => s(1), i1 => muxs_c, q => op_s(1), vdd => vdd, vss => vss);
    muxs_xr2 : xr2_x1 port map (i0 => s(2), i1 => muxs_c, q => op_s(2), vdd => vdd, vss => vss);
    muxs_xr3 : xr2_x1 port map (i0 => s(3), i1 => muxs_c, q => op_s(3), vdd => vdd, vss => vss);

    -- CLA propagate/generate tree --

    -- first stage of propagate gates. PI_i = a_n XOR b_n
    pi_or0 : o2_x2 port map (i0 => op_r(0), i1 => op_s(0), q => pi(0), vdd => vdd, vss => vss);
    pi_or1 : o2_x2 port map (i0 => op_r(1), i1 => op_s(1), q => pi(1), vdd => vdd, vss => vss);
    pi_or2 : o2_x2 port map (i0 => op_r(2), i1 => op_s(2), q => pi(2), vdd => vdd, vss => vss);
    pi_or3 : o2_x2 port map (i0 => op_r(3), i1 => op_s(3), q => pi(3), vdd => vdd, vss => vss);

    -- first stage of generate gates. GI_i = a_n AND b_n
    gi_and0 : a2_x2 port map (i0 => op_r(0), i1 => op_s(0), q => gi(0), vdd => vdd, vss => vss);
    gi_and1 : a2_x2 port map (i0 => op_r(1), i1 => op_s(1), q => gi(1), vdd => vdd, vss => vss);
    gi_and2 : a2_x2 port map (i0 => op_r(2), i1 => op_s(2), q => gi(2), vdd => vdd, vss => vss);
    gi_and3 : a2_x2 port map (i0 => op_r(3), i1 => op_s(3), q => gi(3), vdd => vdd, vss => vss);

    -- second stage that conbines propagates two by two. P1_i = PI_i AND PI_i-1
    p1_or1 : a2_x2 port map (i0 => pi(1), i1 => pi(0), q => p1(1), vdd => vdd, vss => vss);
    p1_or2 : a2_x2 port map (i0 => pi(2), i1 => pi(1), q => p1(2), vdd => vdd, vss => vss);
    p1_or3 : a2_x2 port map (i0 => pi(3), i1 => pi(2), q => p1(3), vdd => vdd, vss => vss);

    -- second stage that combines generates two by two. G1_i = GI_i OR PI_i.GI_i-1
    g1_and1 : a2_x2 port map (i0 => pi(1), i1 => gi(0), q => g1a(1), vdd => vdd, vss => vss);
    g1_and2 : a2_x2 port map (i0 => pi(2), i1 => gi(1), q => g1a(2), vdd => vdd, vss => vss);
    g1_and3 : a2_x2 port map (i0 => pi(3), i1 => gi(2), q => g1a(3), vdd => vdd, vss => vss);
    g1_or1 : o2_x2 port map (i0 => gi(1), i1 => g1a(1), q => g1(1), vdd => vdd, vss => vss);
    g1_or2 : o2_x2 port map (i0 => gi(2), i1 => g1a(2), q => g1(2), vdd => vdd, vss => vss);
    g1_or3 : o2_x2 port map (i0 => gi(3), i1 => g1a(3), q => g1(3), vdd => vdd, vss => vss);

    -- third stage that combines propagates four by four. P2_i = P2_i AND P2_i-2
    p2_and2 : a2_x2 port map (i0 => p1(2), i1 => pi(0), q => p2(2), vdd => vdd, vss => vss);
    p2_and3 : a2_x2 port map (i0 => p1(3), i1 => p1(1), q => p2(3), vdd => vdd, vss => vss);

    -- third stage that combines generates four by four. G2_i = G1_i OR P2_i.G2_i-2
    g2_and2 : a2_x2 port map (i0 => p1(2), i1 => gi(0), q => g2a(2), vdd => vdd, vss => vss);
    g2_and3 : a2_x2 port map (i0 => p1(3), i1 => g1(1), q => g2a(3), vdd => vdd, vss => vss);
    g2_or2 : o2_x2 port map (i0 => g1(2), i1 => g2a(2), q => g2(2), vdd => vdd, vss => vss);
    g2_or3 : o2_x2 port map (i0 => g1(3), i1 => g2a(3), q => g2(3), vdd => vdd, vss => vss);

    -- carry out. cout_n = G2_n-1 OR P2_n-1 . c_in (cout_0 = cin)
    cout_and1 : a2_x2 port map (i0 => pi(0), i1 => cin, q => couta(1), vdd => vdd, vss => vss);
    cout_and2 : a2_x2 port map (i0 => p1(1), i1 => cin, q => couta(2), vdd => vdd, vss => vss);
    cout_and3 : a2_x2 port map (i0 => p2(2), i1 => cin, q => couta(3), vdd => vdd, vss => vss);
    cout_and4 : a2_x2 port map (i0 => p2(3), i1 => cin, q => couta(4), vdd => vdd, vss => vss);
    cout_or1 : o2_x2 port map (i0 => gi(0), i1 => couta(1), q => cout(1), vdd => vdd, vss => vss);
    cout_or2 : o2_x2 port map (i0 => g1(1), i1 => couta(2), q => cout(2), vdd => vdd, vss => vss);
    cout_or3 : o2_x2 port map (i0 => g2(2), i1 => couta(3), q => cout(3), vdd => vdd, vss => vss);
    cout_or4 : o2_x2 port map (i0 => g2(3), i1 => couta(4), q => cout(4), vdd => vdd, vss => vss);

    -- xorer --

    xor_g_a0 : a2_x2 port map (i0 =>  pi (3), i1 =>  gi (3), q => xor_ga0, vdd => vdd, vss => vss);
    xor_g_a1 : a2_x2 port map (i0 =>  p1 (3), i1 =>  gi (2), q => xor_ga1, vdd => vdd, vss => vss);
    xor_g_a2 : a2_x2 port map (i0 =>  p1 (3), i1 =>  pi (1), q => xor_ga2, vdd => vdd, vss => vss);
    xor_g_a3 : a2_x2 port map (i0 => xor_ga2, i1 =>  gi (1), q => xor_ga3, vdd => vdd, vss => vss);
    xor_g_o0 : o2_x2 port map (i0 => xor_ga0, i1 => xor_ga1, q => xor_go0, vdd => vdd, vss => vss);
    xor_g_o1 : o2_x2 port map (i0 => xor_go0, i1 => xor_ga3, q => xor_go1, vdd => vdd, vss => vss);
    xor_g_o2 : o2_x2 port map (i0 =>  gi (0), i1 =>   n_cin, q => xor_go2, vdd => vdd, vss => vss);
    xor_g_a4 : a2_x2 port map (i0 => xor_go2, i1 =>  p2 (3), q => xor_ga4, vdd => vdd, vss => vss);
    xor_g_o3 : o2_x2 port map (i0 => xor_go1, i1 => xor_ga4, q => xor_cn4, vdd => vdd, vss => vss);
    xor_g_o4 : o2_x2 port map (i0 => xor_go1, i1 =>  p2 (3), q =>  xor_ng, vdd => vdd, vss => vss);

    xor_p_a0 : o2_x2 port map (i0 =>  gi (3), i1 =>  gi (2), q => xor_po0, vdd => vdd, vss => vss);
    xor_p_a1 : o2_x2 port map (i0 =>  gi (1), i1 =>  gi (0), q => xor_po1, vdd => vdd, vss => vss);
    xor_p_a2 : o2_x2 port map (i0 => xor_po0, i1 => xor_po1, q =>  xor_np, vdd => vdd, vss => vss);

    xor_xr0 : xr2_x1 port map (i0 => op_r(0), i1 => op_s(0), q => xor_res(0), vdd => vdd, vss => vss);
    xor_xr1 : xr2_x1 port map (i0 => op_r(1), i1 => op_s(1), q => xor_res(1), vdd => vdd, vss => vss);
    xor_xr2 : xr2_x1 port map (i0 => op_r(2), i1 => op_s(2), q => xor_res(2), vdd => vdd, vss => vss);
    xor_xr3 : xr2_x1 port map (i0 => op_r(3), i1 => op_s(3), q => xor_res(3), vdd => vdd, vss => vss);

    -- ander --

    and_inv0 : inv_x1 port map (i => xor_np, nq => and_ng, vdd => vdd, vss => vss);
    and_o0 : o2_x2 port map (i0 => xor_np, i1 =>   cin, q => and_cn4, vdd => vdd, vss => vss);
    and_o1 : o2_x2 port map (i0 => and_ng, i1 => n_cin, q => and_ovr, vdd => vdd, vss => vss);

    -- orer --

    or_o0 : o2_x2 port map (i0 => add_np, i1 => cin, q => or_cn4, vdd => vdd, vss => vss);

    -- additionner --

    add_inv0 : inv_x1 port map (i => p2 (3), nq => add_np, vdd => vdd, vss => vss);
    add_inv1 : inv_x1 port map (i => g2 (3), nq => add_ng, vdd => vdd, vss => vss);
    add_o_xr : xr2_x1 port map (i0 => cout (3), i1 => cout (4), q => add_ovr, vdd => vdd, vss => vss);

    add_xr0 : xr2_x1 port map (i0 => xor_res(0), i1 =>     cin, q => add_res(0), vdd => vdd, vss => vss);
    add_xr1 : xr2_x1 port map (i0 => xor_res(1), i1 => cout(1), q => add_res(1), vdd => vdd, vss => vss);
    add_xr2 : xr2_x1 port map (i0 => xor_res(2), i1 => cout(2), q => add_res(2), vdd => vdd, vss => vss);
    add_xr3 : xr2_x1 port map (i0 => xor_res(3), i1 => cout(3), q => add_res(3), vdd => vdd, vss => vss);

    -- output multiplexer --

    mux_add_a0 : a2_x2 port map (i0 =>  inv_f1, i1 =>  inv_f2, q => mux_ad0, vdd => vdd, vss => vss);
    mux_add_a1 : a2_x2 port map (i0 =>  inv_f0, i1 => fun (1), q => mux_ad1, vdd => vdd, vss => vss);
    mux_add_a2 : a2_x2 port map (i0 => mux_ad1, i1 =>  inv_f2, q => mux_ad2, vdd => vdd, vss => vss);
    mux_add_o0 : o2_x2 port map (i0 => mux_ad0, i1 => mux_ad2, q => mux_add, vdd => vdd, vss => vss);
    mux_or_a0  : a2_x2 port map (i0 => fun (0), i1 => fun (1), q => mux_or0, vdd => vdd, vss => vss);
    mux_or_a1  : a2_x2 port map (i0 => mux_or0, i1 =>  inv_f2, q =>  mux_or, vdd => vdd, vss => vss);
    mux_and_a0 : a2_x2 port map (i0 =>  inv_f1, i1 => fun (2), q => mux_and, vdd => vdd, vss => vss);
    mux_xor_a0 : a2_x2 port map (i0 => fun (1), i1 => fun (2), q => mux_xor, vdd => vdd, vss => vss);

    mux_add_r0 : a2_x2 port map (i0 => mux_add, i1 => add_res (0), q => mux_addr (0), vdd => vdd, vss => vss);
    mux_add_r1 : a2_x2 port map (i0 => mux_add, i1 => add_res (1), q => mux_addr (1), vdd => vdd, vss => vss);
    mux_add_r2 : a2_x2 port map (i0 => mux_add, i1 => add_res (2), q => mux_addr (2), vdd => vdd, vss => vss);
    mux_add_r3 : a2_x2 port map (i0 => mux_add, i1 => add_res (3), q => mux_addr (3), vdd => vdd, vss => vss);
    mux_add_p  : a2_x2 port map (i0 => mux_add, i1 =>  add_np, q => mux_addp, vdd => vdd, vss => vss);
    mux_add_g  : a2_x2 port map (i0 => mux_add, i1 =>  add_ng, q => mux_addg, vdd => vdd, vss => vss);
    mux_add_c  : a2_x2 port map (i0 => mux_add, i1 => cout(4), q => mux_addc, vdd => vdd, vss => vss);
    mux_add_o  : a2_x2 port map (i0 => mux_add, i1 => add_ovr, q => mux_addo, vdd => vdd, vss => vss);

    mux_or_r0 : a2_x2 port map (i0 => mux_or, i1 =>     pi (0), q => mux_orr (0), vdd => vdd, vss => vss);
    mux_or_r1 : a2_x2 port map (i0 => mux_or, i1 =>     pi (1), q => mux_orr (1), vdd => vdd, vss => vss);
    mux_or_r2 : a2_x2 port map (i0 => mux_or, i1 =>     pi (2), q => mux_orr (2), vdd => vdd, vss => vss);
    mux_or_r3 : a2_x2 port map (i0 => mux_or, i1 =>     pi (3), q => mux_orr (3), vdd => vdd, vss => vss);
    mux_or_g  : a2_x2 port map (i0 => mux_or, i1 => p2 (3), q => mux_org, vdd => vdd, vss => vss);
    mux_or_c  : a2_x2 port map (i0 => mux_or, i1 => or_cn4, q => mux_orc, vdd => vdd, vss => vss);
    mux_or_o  : a2_x2 port map (i0 => mux_or, i1 => or_cn4, q => mux_oro, vdd => vdd, vss => vss);

    mux_and_r0 : a2_x2 port map (i0 => mux_and, i1 =>      gi (0), q => mux_andr (0), vdd => vdd, vss => vss);
    mux_and_r1 : a2_x2 port map (i0 => mux_and, i1 =>      gi (1), q => mux_andr (1), vdd => vdd, vss => vss);
    mux_and_r2 : a2_x2 port map (i0 => mux_and, i1 =>      gi (2), q => mux_andr (2), vdd => vdd, vss => vss);
    mux_and_r3 : a2_x2 port map (i0 => mux_and, i1 =>      gi (3), q => mux_andr (3), vdd => vdd, vss => vss);
    mux_and_g  : a2_x2 port map (i0 => mux_and, i1 =>  and_ng, q => mux_andg, vdd => vdd, vss => vss);
    mux_and_c  : a2_x2 port map (i0 => mux_and, i1 => and_cn4, q => mux_andc, vdd => vdd, vss => vss);
    mux_and_o  : a2_x2 port map (i0 => mux_and, i1 => and_ovr, q => mux_ando, vdd => vdd, vss => vss);

    mux_xor_r0 : a2_x2 port map (i0 => mux_xor, i1 => xor_res (0), q => mux_xorr (0), vdd => vdd, vss => vss);
    mux_xor_r1 : a2_x2 port map (i0 => mux_xor, i1 => xor_res (1), q => mux_xorr (1), vdd => vdd, vss => vss);
    mux_xor_r2 : a2_x2 port map (i0 => mux_xor, i1 => xor_res (2), q => mux_xorr (2), vdd => vdd, vss => vss);
    mux_xor_r3 : a2_x2 port map (i0 => mux_xor, i1 => xor_res (3), q => mux_xorr (3), vdd => vdd, vss => vss);
    mux_xor_p  : a2_x2 port map (i0 => mux_xor, i1 =>  xor_np, q => mux_xorp, vdd => vdd, vss => vss);
    mux_xor_g  : a2_x2 port map (i0 => mux_xor, i1 =>  xor_ng, q => mux_xorg, vdd => vdd, vss => vss);
    mux_xor_c  : a2_x2 port map (i0 => mux_xor, i1 => xor_cn4, q => mux_xorc, vdd => vdd, vss => vss);
    mux_xor_o  : a2_x2 port map (i0 => mux_xor, i1 => xor_cn4, q => mux_xoro, vdd => vdd, vss => vss);

    mux_ro00 : o2_x2 port map (i0 => mux_addr (0), i1 =>  mux_orr (0), q => mux_ro0 (0), vdd => vdd, vss => vss);
    mux_ro01 : o2_x2 port map (i0 => mux_addr (1), i1 =>  mux_orr (1), q => mux_ro0 (1), vdd => vdd, vss => vss);
    mux_ro02 : o2_x2 port map (i0 => mux_addr (2), i1 =>  mux_orr (2), q => mux_ro0 (2), vdd => vdd, vss => vss);
    mux_ro03 : o2_x2 port map (i0 => mux_addr (3), i1 =>  mux_orr (3), q => mux_ro0 (3), vdd => vdd, vss => vss);
    mux_ro10 : o2_x2 port map (i0 => mux_andr (0), i1 => mux_xorr (0), q => mux_ro1 (0), vdd => vdd, vss => vss);
    mux_ro11 : o2_x2 port map (i0 => mux_andr (1), i1 => mux_xorr (1), q => mux_ro1 (1), vdd => vdd, vss => vss);
    mux_ro12 : o2_x2 port map (i0 => mux_andr (2), i1 => mux_xorr (2), q => mux_ro1 (2), vdd => vdd, vss => vss);
    mux_ro13 : o2_x2 port map (i0 => mux_andr (3), i1 => mux_xorr (3), q => mux_ro1 (3), vdd => vdd, vss => vss);
    mux_ro20 : o2_x2 port map (i0 =>  mux_ro0 (0), i1 =>  mux_ro1 (0), q =>  output (0), vdd => vdd, vss => vss);
    mux_ro21 : o2_x2 port map (i0 =>  mux_ro0 (1), i1 =>  mux_ro1 (1), q =>  output (1), vdd => vdd, vss => vss);
    mux_ro22 : o2_x2 port map (i0 =>  mux_ro0 (2), i1 =>  mux_ro1 (2), q =>  output (2), vdd => vdd, vss => vss);
    mux_ro23 : o2_x2 port map (i0 =>  mux_ro0 (3), i1 =>  mux_ro1 (3), q =>  output (3), vdd => vdd, vss => vss);

    mux_p_o : o2_x2 port map (i0 => mux_addp, i1 => mux_xorp, q => np, vdd => vdd, vss => vss);

    mux_g_o0 : o2_x2 port map (i0 => mux_addg, i1 =>  mux_org, q => mux_go0, vdd => vdd, vss => vss);
    mux_g_o1 : o2_x2 port map (i0 => mux_andg, i1 => mux_xorg, q => mux_go1, vdd => vdd, vss => vss);
    mux_g_o2 : o2_x2 port map (i0 =>  mux_go0, i1 =>  mux_go1, q =>      ng, vdd => vdd, vss => vss);

    mux_c_o0 : o2_x2 port map (i0 => mux_addc, i1 =>  mux_orc, q => mux_co0, vdd => vdd, vss => vss);
    mux_c_o1 : o2_x2 port map (i0 => mux_andc, i1 => mux_xorc, q => mux_co1, vdd => vdd, vss => vss);
    mux_c_o2 : o2_x2 port map (i0 =>  mux_co0, i1 =>  mux_co1, q =>     cn4, vdd => vdd, vss => vss);

    mux_o_o0 : o2_x2 port map (i0 => mux_addo, i1 =>  mux_oro, q => mux_oo0, vdd => vdd, vss => vss);
    mux_o_o1 : o2_x2 port map (i0 => mux_ando, i1 => mux_xoro, q => mux_oo1, vdd => vdd, vss => vss);
    mux_o_o2 : o2_x2 port map (i0 =>  mux_oo0, i1 =>  mux_oo1, q =>     ovr, vdd => vdd, vss => vss);
end behavioural;
