library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_in is port (
    command  : in  std_logic_vector (2 downto 0);
    a   : in  std_logic_vector (3 downto 0);
    b   : in  std_logic_vector (3 downto 0);
    d   : in  std_logic_vector (3 downto 0);
    q   : in  std_logic_vector (3 downto 0);
    r   : out std_logic_vector (3 downto 0);
    s   : out std_logic_vector (3 downto 0);
    vdd : in std_logic;
    vss : in std_logic
); end mux_in;

architecture dataflow of mux_in is
    component inv_x2 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component inv_x4 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component no2_x1 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component no2_x4 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component na2_x1 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component na3_x1 port ( i0, i1, i2, vdd, vss: in std_logic; nq: out std_logic); end component;

    signal not_cmd0  : std_logic;
    signal not_cmd2  : std_logic;

    -- signals for R
    signal r_a : std_logic_vector (3 downto 0);
    signal r_d : std_logic_vector (3 downto 0);
    signal r_a_nor  : std_logic;
    signal r_d_nor0 : std_logic;
    signal r_d_nor1 : std_logic;

    -- signals for S
    signal s_a : std_logic_vector (3 downto 0);
    signal s_b : std_logic_vector (3 downto 0);
    signal s_d : std_logic_vector (3 downto 0);
    signal s_q : std_logic_vector (3 downto 0);
    signal s_a_nor  : std_logic;
    signal s_b_nor  : std_logic;
    signal s_q_nor0 : std_logic;
    signal s_q_nor1 : std_logic;
begin
    inv_c0  : inv_x2 port map (i => command(0),  nq => not_cmd0, vdd => vdd, vss => vss);
    inv_c2  : inv_x4 port map (i => command(2),  nq => not_cmd2, vdd => vdd, vss => vss);

    -- r = a . (i2 nor i1) + d . i2 . (i1 + i0)
    rd_nor0  : no2_x1 port map (i0 => command(1), i1 => command(0), nq => r_d_nor0, vdd => vdd, vss => vss);
    rd_nor1  : no2_x4 port map (i0 =>  not_cmd2,  i1 => r_d_nor0,   nq => r_d_nor1, vdd => vdd, vss => vss);
    ra_nor0  : no2_x4 port map (i0 => command(1), i1 => command(2), nq =>  r_a_nor, vdd => vdd, vss => vss);
    ra_nand0 : na2_x1 port map (i0 => a(0), i1 =>  r_a_nor, nq => r_a(0), vdd => vdd, vss => vss);
    ra_nand1 : na2_x1 port map (i0 => a(1), i1 =>  r_a_nor, nq => r_a(1), vdd => vdd, vss => vss);
    ra_nand2 : na2_x1 port map (i0 => a(2), i1 =>  r_a_nor, nq => r_a(2), vdd => vdd, vss => vss);
    ra_nand3 : na2_x1 port map (i0 => a(3), i1 =>  r_a_nor, nq => r_a(3), vdd => vdd, vss => vss);
    rd_nand0 : na2_x1 port map (i0 => d(0), i1 => r_d_nor1, nq => r_d(0), vdd => vdd, vss => vss);
    rd_nand1 : na2_x1 port map (i0 => d(1), i1 => r_d_nor1, nq => r_d(1), vdd => vdd, vss => vss);
    rd_nand2 : na2_x1 port map (i0 => d(2), i1 => r_d_nor1, nq => r_d(2), vdd => vdd, vss => vss);
    rd_nand3 : na2_x1 port map (i0 => d(3), i1 => r_d_nor1, nq => r_d(3), vdd => vdd, vss => vss);
    r_nand0  : na2_x1 port map (i0 => r_a(0), i1 => r_d(0), nq => r(0), vdd => vdd, vss => vss);
    r_nand1  : na2_x1 port map (i0 => r_a(1), i1 => r_d(1), nq => r(1), vdd => vdd, vss => vss);
    r_nand2  : na2_x1 port map (i0 => r_a(2), i1 => r_d(2), nq => r(2), vdd => vdd, vss => vss);
    r_nand3  : na2_x1 port map (i0 => r_a(3), i1 => r_d(3), nq => r(3), vdd => vdd, vss => vss);

    -- s = q . (!i2 . i0) + a . (!i1 . i2) + q . (!i0 . ((i1 . i2) + !i2))
    sa_nor0  : no2_x4 port map (i0 =>   not_cmd2, i1 => command(1), nq => s_a_nor,  vdd => vdd, vss => vss);
    sb_nor0  : no2_x4 port map (i0 =>   not_cmd0, i1 => command(2), nq => s_b_nor,  vdd => vdd, vss => vss);
    sq_nor0  : no2_x1 port map (i0 =>   not_cmd2, i1 => command(1), nq => s_q_nor0, vdd => vdd, vss => vss);
    s_q_nor  : no2_x4 port map (i0 => command(0), i1 =>   s_q_nor0, nq => s_q_nor1, vdd => vdd, vss => vss);
    sa_nand0 : na2_x1 port map (i0 => a(0), i1 =>  s_a_nor, nq => s_a(0), vdd => vdd, vss => vss);
    sa_nand1 : na2_x1 port map (i0 => a(1), i1 =>  s_a_nor, nq => s_a(1), vdd => vdd, vss => vss);
    sa_nand2 : na2_x1 port map (i0 => a(2), i1 =>  s_a_nor, nq => s_a(2), vdd => vdd, vss => vss);
    sa_nand3 : na2_x1 port map (i0 => a(3), i1 =>  s_a_nor, nq => s_a(3), vdd => vdd, vss => vss);
    sb_nand0 : na2_x1 port map (i0 => b(0), i1 =>  s_b_nor, nq => s_b(0), vdd => vdd, vss => vss);
    sb_nand1 : na2_x1 port map (i0 => b(1), i1 =>  s_b_nor, nq => s_b(1), vdd => vdd, vss => vss);
    sb_nand2 : na2_x1 port map (i0 => b(2), i1 =>  s_b_nor, nq => s_b(2), vdd => vdd, vss => vss);
    sb_nand3 : na2_x1 port map (i0 => b(3), i1 =>  s_b_nor, nq => s_b(3), vdd => vdd, vss => vss);
    sq_nand0 : na2_x1 port map (i0 => q(0), i1 => s_q_nor1, nq => s_q(0), vdd => vdd, vss => vss);
    sq_nand1 : na2_x1 port map (i0 => q(1), i1 => s_q_nor1, nq => s_q(1), vdd => vdd, vss => vss);
    sq_nand2 : na2_x1 port map (i0 => q(2), i1 => s_q_nor1, nq => s_q(2), vdd => vdd, vss => vss);
    sq_nand3 : na2_x1 port map (i0 => q(3), i1 => s_q_nor1, nq => s_q(3), vdd => vdd, vss => vss);
    s_nand0  : na3_x1 port map (i0 => s_a(0), i1 => s_b(0), i2 => s_q(0), nq => s(0), vdd => vdd, vss => vss);
    s_nand1  : na3_x1 port map (i0 => s_a(1), i1 => s_b(1), i2 => s_q(1), nq => s(1), vdd => vdd, vss => vss);
    s_nand2  : na3_x1 port map (i0 => s_a(2), i1 => s_b(2), i2 => s_q(2), nq => s(2), vdd => vdd, vss => vss);
    s_nand3  : na3_x1 port map (i0 => s_a(3), i1 => s_b(3), i2 => s_q(3), nq => s(3), vdd => vdd, vss => vss);
end dataflow;
