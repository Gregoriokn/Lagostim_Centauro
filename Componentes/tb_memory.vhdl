library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_memory is
end tb_memory;

architecture behavioral of tb_memory is

    constant addr_width: natural := 16; -- Memory Address Width (in bits)
    constant data_width: natural := 8; -- Data Width (in bits)

    signal clock: std_logic := '0';
    signal data_read: std_logic := '0';
    signal data_write: std_logic := '0';
    signal data_addr: std_logic_vector(addr_width-1 downto 0) := (others => '0');
    signal data_in: std_logic_vector(data_width-1 downto 0) := (others => '0');
    signal data_out: std_logic_vector((data_width*4)-1 downto 0);

begin
    mem: entity work.memory(behavioral)
        generic map (addr_width, data_width)
        port map(clock, data_read, data_write, data_addr, data_in, data_out);

    processo_do_clock: process is
    begin
        for i in 0 to (2**addr_width)+15 loop
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    estimulo_de_checagem: process is
        type mem_type is array(0 to 2**addr_width-1) of std_logic_vector(data_width-1 downto 0);
        variable resultado: mem_type
            := (others => (others => '1'));
    begin
        -- ESCRITA
        data_write <= '1';
        data_read <= '0';
        wait for 5 ns;
        for i in 0 to 2**addr_width-1 loop
            data_addr <= std_logic_vector(to_unsigned(i, addr_width));
            data_in <= std_logic_vector(to_unsigned(255, data_width));
            wait for 5 ns;
        end loop;
        
        -- -- LEITURA
        -- data_write <= '0';
        -- data_read <= '1';
        -- wait for 5 ns;
        -- for i in 0 to 2**addr_width-1 loop
        --     data_addr <= std_logic_vector(to_unsigned(i, addr_width));
            
        --     wait for 5 ns;
        -- end loop;


        
        wait;

    end process;
end behavioral;