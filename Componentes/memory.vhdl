library ieee;
use ieee.std_logic_1164.all;

entity memory is
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
);
    port (
        clock: in std_logic; -- Clock signal; Write on Falling-Edge

        data_read : in std_logic; -- When '1', read data from memory
        data_write: in std_logic; -- When '1', write data to memory
        -- Data address given to memory
        data_addr : in std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        data_in : in std_logic_vector(data_width-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out : out std_logic_vector(data_width-1 downto 0)
 );
end entity;

architecture Behavioral of memory is 

begin
    process
        type mem_t is array (2^addr_width) of bit_vector(data_width-1 downto 0);
        signal mem : mem_t;

    begin

        for i in address loop
            mem(i) <= data_in;
        end loop;
        loop
            wait on clock, data_read, data_write, data_in;
            if data_read = '1' then
                data_out <= mem(data_addr);
            end if;
            if data_write then
                mem(data_addr) := data_in;
            end if ;
        end loop;
    end process;
end;