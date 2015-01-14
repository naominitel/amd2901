library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is Port (
    -- alu function
    i_from_pads    : in std_logic_vector (8 downto 0);

    -- data in
    d_from_pads    : in std_logic_vector (3 downto 0);

    -- address
    a_from_pads    : in std_logic_vector (3 downto 0);
    b_from_pads    : in std_logic_vector (3 downto 0);

    -- main output
    y_to_pads    : out std_logic_vector (3 downto 0);

    -- output enable
    noe_from_pads  : in  std_logic;

    -- clock
    ck  : in  std_logic;

    -- carry in
    cin_from_pads  : in   std_logic;

    -- PiGi out for CLA
    ng_to_pads   : out  std_logic;
    np_to_pads   : out  std_logic;

    -- carry out
    cout_to_pads : out  std_logic;

    -- overflow
    ovr_to_pads  : out  std_logic;

    zero_to_pads : out  std_logic;
    f3_to_pads   : out  std_logic;

    -- additional bits (in and out) when shifting the accu
    q0_from_pads : in  std_logic;
    q3_from_pads : in  std_logic;
    q0_to_pads   : out  std_logic;
    q3_to_pads   : out  std_logic;

    -- additional bits (in and out) when shifting the RAM
    r0_from_pads  : in  std_logic;
    r3_from_pads  : in  std_logic;
    r0_to_pads    : out  std_logic;
    r3_to_pads    : out  std_logic;
    
    shift_l : out std_logic;
    shift_r : out std_logic;
    y_oe : out std_logic;

    -- power
    vdd  : in  std_logic;
    vss  : in  std_logic
); end cpu;

architecture structural of cpu is
    component ram port (
        ram_shift : in std_logic_vector (1 downto 0);
        a_addr    : in std_logic_vector (3 downto 0);
        b_addr    : in std_logic_vector (3 downto 0);
        ram_input : in std_logic_vector (3 downto 0);
        a_output  : out std_logic_vector (3 downto 0);
        b_output  : out std_logic_vector (3 downto 0);
        r0_in     : in std_logic;
        r3_in     : in std_logic;
        r0_out    : out std_logic;
        r3_out    : out std_logic;
        clk       : in std_logic;
        vdd       : in std_logic;
        vss       : in std_logic
    ); end component;

    component accu port (
        q_shift  : in std_logic_vector (2 downto 0);
        q_input  : in std_logic_vector (3 downto 0);
        q_output : out std_logic_vector (3 downto 0);
        q0_in    : in std_logic;
        q3_in    : in std_logic;
        q0_out   : out std_logic;
        q3_out   : out std_logic;
        clk      : in std_logic;
        vdd      : in std_logic;
        vss      : in std_logic
    ); end component;

    component mux_in port (
        vdd     : in std_logic;
        vss     : in std_logic;
        q       : in std_logic_vector (3 downto 0);
        a       : in std_logic_vector (3 downto 0);
        b       : in std_logic_vector (3 downto 0);
        d       : in std_logic_vector (3 downto 0);
        command : in std_logic_vector (2 downto 0);
        r       : out std_logic_vector (3 downto 0);
        s       : out std_logic_vector (3 downto 0)
    ); end component;

    component alu port (
        fun    : in std_logic_vector (2 downto 0);
        r      : in std_logic_vector (3 downto 0);
        s      : in std_logic_vector (3 downto 0);
        cin    : in std_logic;
        cn4    : out std_logic;
        np     : out std_logic;
        ng     : out std_logic;
        ovr    : out std_logic;
        output : out std_logic_vector (3 downto 0);
        vdd    : in std_logic;
        vss    : in std_logic
    ); end component;

    component mux_out port (
        command : in std_logic_vector (2 downto 0);
        noe     : in std_logic;
        ram     : in std_logic_vector (3 downto 0);
        alu     : in std_logic_vector (3 downto 0);
        output  : out std_logic_vector (3 downto 0);
        vdd     : in std_logic;
        vss     : in std_logic
    ); end component;

    component a2_x2  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component inv_x1 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;

    -- The 3 subparts of the ALU instruction:
    -- * Destination selection
    -- * Function selection
    -- * Source selection

    -- RAM output latches
    signal ram_a : std_logic_vector (3 downto 0);
    signal ram_b : std_logic_vector (3 downto 0);

    -- the Q register (aka accumulator)
    signal accu_out : std_logic_vector (3 downto 0);

    -- ALU pins
    signal alu_out2 : std_logic_vector (3 downto 0);
    signal alu_out : std_logic_vector (3 downto 0);
    signal alu_op_s : std_logic_vector (3 downto 0);
    signal alu_op_r : std_logic_vector (3 downto 0);

    signal n_i7 : std_logic;
begin
    -- split the ALU instruction into its 3 subparts
    ram0: ram port map (
        ram_shift   => i_from_pads (8 downto 7),
        a_addr      => a_from_pads,
        b_addr      => b_from_pads,
        ram_input   => alu_out,
        a_output    => ram_a,
        b_output    => ram_b,
        r0_in       => r0_from_pads,
        r3_in       => r3_from_pads,
        r0_out      => r0_to_pads,
        r3_out      => r3_to_pads,
        clk         => ck,
        vdd         => vdd,
        vss         => vss
    );

    accu0: accu port map (
        q_shift     => i_from_pads (8 downto 6),
        q_input     => alu_out,
        q_output    => accu_out,
        q0_in       => q0_from_pads,
        q3_in       => q3_from_pads,
        q0_out      => q0_to_pads,
        q3_out      => q3_to_pads,
        clk         => ck,
        vdd         => vdd,
        vss         => vss
    );

    mux_e: mux_in port map (
        vdd         => vdd,
        vss         => vss,
        q           => accu_out,
        a           => ram_a,
        b           => ram_b,
        d           => d_from_pads,
        command     => i_from_pads (2 downto 0),
        r           => alu_op_r,
        s           => alu_op_s
    );

    alu0: alu port map (
        fun         => i_from_pads (5 downto 3),
        r           => alu_op_r,
        s           => alu_op_s,
        cin         => cin_from_pads,
        cn4         => cout_to_pads,
        np          => np_to_pads,
        ng          => ng_to_pads,
        ovr         => ovr_to_pads,
        output      => alu_out,
        vdd         => vdd,
        vss         => vss
    );

     mux_s: mux_out port map (
        command     => i_from_pads (8 downto 6),
        noe         => noe_from_pads,
        ram         => ram_a,
        alu         => alu_out,
        output      => y_to_pads,
        vdd         => vdd,
        vss         => vss
    );

    sl: a2_x2 port map (
        i0 => i_from_pads(8),
        i1 => i_from_pads(7),
        q  => shift_l,
        vdd => vdd,
        vss => vss
    );

    -- FIXME
    nf3: inv_x1 port map (
        i => cin_from_pads,
        nq => f3_to_pads,
        vdd => vdd,
        vss => vss
    );

    -- FIXME
    nzero: inv_x1 port map (
        i => cin_from_pads,
        nq => zero_to_pads,
        vdd => vdd,
        vss => vss
    );

    noe: inv_x1 port map (
        i => noe_from_pads,
        nq => y_oe,
        vdd => vdd,
        vss => vss
    );

    ni7: inv_x1 port map (
        i => i_from_pads(7),
        nq => n_i7,
        vdd => vdd,
        vss => vss
    );

    sr: a2_x2 port map (
        i0 => i_from_pads(8),
        i1 => i_from_pads(7),
        q  => shift_r,
        vdd => vdd,
        vss => vss
    );

end structural;
