library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_out is port (
    command : in std_logic_vector (2 downto 0);
    noe : in std_logic;

    ram : in std_logic_vector (3 downto 0);
    alu : in std_logic_vector (3 downto 0);
    output : out std_logic_vector (3 downto 0);

    vdd : in std_logic;
    vss : in std_logic
); end mux_out;

architecture dataflow of mux_out is
    component inv_x1 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component inv_x4 port (          i, vdd, vss: in std_logic; nq: out std_logic); end component;
    component a2_x2  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component o2_x2  port (     i0, i1, vdd, vss: in std_logic;  q: out std_logic); end component;
    component a3_x4  port ( i0, i1, i2, vdd, vss: in std_logic;  q: out std_logic); end component;

    signal noe_inv_s  : std_logic;
    signal cmd_inv0_s : std_logic;
    signal cmd_inv1_s : std_logic;
    signal ram_inv_s  : std_logic;
    signal ram_and_s  : std_logic;

    signal y_ram : std_logic_vector (3 downto 0);
    signal y_alu : std_logic_vector (3 downto 0);
begin
    cmd_inv0 : inv_x1 port map (i => command(0), nq => cmd_inv0_s, vdd => vdd, vss => vss);
    cmd_inv1 : inv_x1 port map (i => command(2), nq => cmd_inv1_s, vdd => vdd, vss => vss);
    ram_and : a3_x4 port map (
        i0 => cmd_inv0_s, i1 => command(1), i2 => cmd_inv1_s,
        q => ram_and_s, vdd => vdd, vss => vss
    );
    ram_inv : inv_x4 port map (i => ram_and_s, nq => ram_inv_s, vdd => vdd, vss => vss);

    y_ram_and0 : a2_x2 port map (i0 => ram_and_s, i1 => ram(0), q => y_ram(0), vdd => vdd, vss => vss);
    y_ram_and1 : a2_x2 port map (i0 => ram_and_s, i1 => ram(1), q => y_ram(1), vdd => vdd, vss => vss);
    y_ram_and2 : a2_x2 port map (i0 => ram_and_s, i1 => ram(2), q => y_ram(2), vdd => vdd, vss => vss);
    y_ram_and3 : a2_x2 port map (i0 => ram_and_s, i1 => ram(3), q => y_ram(3), vdd => vdd, vss => vss);

    y_alu_and0 : a2_x2 port map (i0 => ram_inv_s, i1 => alu(0), q => y_alu(0), vdd => vdd, vss => vss);
    y_alu_and1 : a2_x2 port map (i0 => ram_inv_s, i1 => alu(1), q => y_alu(1), vdd => vdd, vss => vss);
    y_alu_and2 : a2_x2 port map (i0 => ram_inv_s, i1 => alu(2), q => y_alu(2), vdd => vdd, vss => vss);
    y_alu_and3 : a2_x2 port map (i0 => ram_inv_s, i1 => alu(3), q => y_alu(3), vdd => vdd, vss => vss);

    y_or0 : o2_x2 port map (i0 => y_ram(0), i1 => y_alu(0), q => output(0), vdd => vdd, vss => vss);
    y_or1 : o2_x2 port map (i0 => y_ram(1), i1 => y_alu(1), q => output(1), vdd => vdd, vss => vss);
    y_or2 : o2_x2 port map (i0 => y_ram(2), i1 => y_alu(2), q => output(2), vdd => vdd, vss => vss);
    y_or3 : o2_x2 port map (i0 => y_ram(3), i1 => y_alu(3), q => output(3), vdd => vdd, vss => vss);

    noe_inv : inv_x1 port map (i => noe, nq => noe_inv_s, vdd => vdd, vss => vss);
end dataflow;
