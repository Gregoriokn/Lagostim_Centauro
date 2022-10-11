library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_memory is
end tb_memory;

architecture behavioral of tb_memory is

    signal     addr_width: natural := 16; -- Memory Address Width (in bits)
    signal    data_width: natural := 8; -- Data Width (in bits)

    signal clock: std_logic := '0';
    signal data_read: std_logic := '0';
    signal data_write: std_logic := '0';
    signal data_addr: std_logic_vector(addr_width-1 downto 0) := (others => '0');
    signal data_in: std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal data_out: std_logic_vector((data_width*4)-1 downto 0);

begin
    mem: entity work.memory(behavioral)
        port map(clock, data_read, data_write, data_addr, data_in, data_out);

        processo_do_clock: process
        begin
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end process;

        estimulo_de_checagem: process
        begin
            data_write <= '0';
            data_read <= '0';
            data_addr <= (others => '0');
            data_in <= x"AF";

            data_write <= '0';
            data_read <= '1';
            wait for 100 ns;
            -- LEITURA
            for i in 0 to 10 loop
                data_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(data_addr)) + 1, 16));
                wait for 50 ns;
            end loop;

            data_write <= '1';
            data_read <= '0';
            wait for 100 ns;
            -- ESCRITA
            for i in 0 to 10 loop
                data_addr <= std_logic_vector(to_unsigned(to_integer(unsigned(data_addr)) + 1, 16));
                data_in <= std_logic_vector(to_unsigned(to_integer(unsigned(data_addr)) - 1, 8));
                wait for 50 ns;
            end loop;

            data_write <= '0';
            data_read <= '0';

            wait;

        end process;
end behavioral;