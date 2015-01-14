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
    component inv_x1 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component a2_x2  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component a2_x4  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component o2_x2  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component na2_x1 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component no2_x1 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component no2_x4 port (     i0, i1, vdd, vss: in std_logic; nq: out std_logic); end component;
    component o3_x2  port ( i0, i1, i2, vdd, vss: in std_logic;  q: out std_logic); end component;

    -- signals for R
    signal r_a : std_logic_vector (3 downto 0);
    signal r_d : std_logic_vector (3 downto 0);
    signal r_a_nor_s : std_logic;
    signal r_d_or_s  : std_logic;
    signal r_d_and_s : std_logic;

    -- signals for S
    signal s_a : std_logic_vector (3 downto 0);
    signal s_b : std_logic_vector (3 downto 0);
    signal s_d : std_logic_vector (3 downto 0);
    signal s_q : std_logic_vector (3 downto 0);
    signal s_a_inv_s  : std_logic;
    signal s_b_inv_s  : std_logic;
    signal s_a_and_s  : std_logic;
    signal s_b_and_s  : std_logic;
    signal s_q_nor_s  : std_logic;
    signal s_q_and_s  : std_logic;
    signal s_q_nand_s : std_logic;
begin
    -- r = a . (i2 nor i1) + d . i2 . (i1 + i0)
    r_a_nor  : no2_x4 port map (i0 => command(1), i1 => command(2), nq => r_a_nor_s, vdd => vdd, vss => vss);
    r_d_or   :  o2_x2 port map (i0 => command(1), i1 => command(0), q => r_d_or_s, vdd => vdd, vss => vss);
    r_d_and  :  a2_x4 port map (i0 => command(2), i1 => r_d_or_s,   q => r_d_and_s, vdd => vdd, vss => vss);
    r_a_and0 :  a2_x2 port map (i0 => a(0), i1 => r_a_nor_s, q => r_a(0), vdd => vdd, vss => vss);
    r_a_and1 :  a2_x2 port map (i0 => a(1), i1 => r_a_nor_s, q => r_a(1), vdd => vdd, vss => vss);
    r_a_and2 :  a2_x2 port map (i0 => a(2), i1 => r_a_nor_s, q => r_a(2), vdd => vdd, vss => vss);
    r_a_and3 :  a2_x2 port map (i0 => a(3), i1 => r_a_nor_s, q => r_a(3), vdd => vdd, vss => vss);
    r_d_and0 :  a2_x2 port map (i0 => d(0), i1 => r_d_and_s, q => r_d(0), vdd => vdd, vss => vss);
    r_d_and1 :  a2_x2 port map (i0 => d(1), i1 => r_d_and_s, q => r_d(1), vdd => vdd, vss => vss);
    r_d_and2 :  a2_x2 port map (i0 => d(2), i1 => r_d_and_s, q => r_d(2), vdd => vdd, vss => vss);
    r_d_and3 :  a2_x2 port map (i0 => d(3), i1 => r_d_and_s, q => r_d(3), vdd => vdd, vss => vss);
    r_or0    :  o2_x2 port map (i0 => r_a(0), i1 => r_d(0), q => r(0), vdd => vdd, vss => vss);
    r_or1    :  o2_x2 port map (i0 => r_a(1), i1 => r_d(1), q => r(1), vdd => vdd, vss => vss);
    r_or2    :  o2_x2 port map (i0 => r_a(2), i1 => r_d(2), q => r(2), vdd => vdd, vss => vss);
    r_or3    :  o2_x2 port map (i0 => r_a(3), i1 => r_d(3), q => r(3), vdd => vdd, vss => vss);

    -- s = q . (!i2 . i0) + a . (!i1 . i2) + q . (!i0 . ((i1 . i2) + !i2))
    s_a_inv  : inv_x1 port map (i => command(1),  nq => s_a_inv_s, vdd => vdd, vss => vss);
    s_b_inv  : inv_x1 port map (i => command(2),  nq => s_b_inv_s, vdd => vdd, vss => vss);
    s_a_and  : a2_x4  port map (i0 => s_a_inv_s,  i1 => command(2), q => s_a_and_s, vdd => vdd, vss => vss);
    s_b_and  : a2_x4  port map (i0 => s_b_inv_s,  i1 => command(0), q => s_b_and_s, vdd => vdd, vss => vss);
    s_q_nand : na2_x1 port map (i0 => command(2), i1 => command(1), nq => s_q_nand_s, vdd => vdd, vss => vss);
    s_q_and  : a2_x2  port map (i0 => s_q_nand_s, i1 => command(2), q => s_q_and_s, vdd => vdd, vss => vss);
    s_q_nor  : no2_x4 port map (i0 => command(0), i1 => s_q_and_s,  nq => s_q_nor_s, vdd => vdd, vss => vss);
    s_a_and0 : a2_x2  port map (i0 => a(0), i1 => s_a_and_s, q => s_a(0), vdd => vdd, vss => vss);
    s_a_and1 : a2_x2  port map (i0 => a(1), i1 => s_a_and_s, q => s_a(1), vdd => vdd, vss => vss);
    s_a_and2 : a2_x2  port map (i0 => a(2), i1 => s_a_and_s, q => s_a(2), vdd => vdd, vss => vss);
    s_a_and3 : a2_x2  port map (i0 => a(3), i1 => s_a_and_s, q => s_a(3), vdd => vdd, vss => vss);
    s_b_and0 : a2_x2  port map (i0 => b(0), i1 => s_b_and_s, q => s_b(0), vdd => vdd, vss => vss);
    s_b_and1 : a2_x2  port map (i0 => b(1), i1 => s_b_and_s, q => s_b(1), vdd => vdd, vss => vss);
    s_b_and2 : a2_x2  port map (i0 => b(2), i1 => s_b_and_s, q => s_b(2), vdd => vdd, vss => vss);
    s_b_and3 : a2_x2  port map (i0 => b(3), i1 => s_b_and_s, q => s_b(3), vdd => vdd, vss => vss);
    s_q_and0 : a2_x2  port map (i0 => q(0), i1 => s_q_nor_s, q => s_q(0), vdd => vdd, vss => vss);
    s_q_and1 : a2_x2  port map (i0 => q(1), i1 => s_q_nor_s, q => s_q(1), vdd => vdd, vss => vss);
    s_q_and2 : a2_x2  port map (i0 => q(2), i1 => s_q_nor_s, q => s_q(2), vdd => vdd, vss => vss);
    s_q_and3 : a2_x2  port map (i0 => q(3), i1 => s_q_nor_s, q => s_q(3), vdd => vdd, vss => vss);
    s_q_or0  : o3_x2  port map (i0 => s_a(0), i1 => s_b(0), i2 => s_q(0), q => s(0), vdd => vdd, vss => vss);
    s_q_or1  : o3_x2  port map (i0 => s_a(1), i1 => s_b(1), i2 => s_q(1), q => s(1), vdd => vdd, vss => vss);
    s_q_or2  : o3_x2  port map (i0 => s_a(2), i1 => s_b(2), i2 => s_q(2), q => s(2), vdd => vdd, vss => vss);
    s_q_or3  : o3_x2  port map (i0 => s_a(3), i1 => s_b(3), i2 => s_q(3), q => s(3), vdd => vdd, vss => vss);
end dataflow;
