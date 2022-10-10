library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

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
        data_in : out std_logic_vector((data_width*4)-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out : out std_logic_vector(data_width-1 downto 0)
 );
end entity;

architecture behavioral of memory is 

--cria matriz de 2^16 pos com cada uma de tamanho 8 bits--
type mem_type is array (0 to 2**addr_width) of std_logic_vector(data_width-1 downto 0);
signal mem: mem_type
    := := (others => (others => 0));  -- Inicializa toda a memória com 0;

begin
    process(clock)
    begin
        if(falling_edge(clock)) then
            if(data_read='1') and (data_write'0') then
                mem(to_integer(unsigned(data_addr))) <= data_in;
            elsif(data_write'1') and (data_read='0') then
                dataout <= mem(to_integer(unsigned(data_addr)));
            end if;
        end if;
    end process;
end behavioral;





    
    process(clock)
        
 
    begin
        loop
            wait on clock;
            if data_read = '1' then 
                data_out <= mem(data_addr);
            end if;
            if data_write = '1' then
                mem(data_addr) := data_in;
            end if ;
        end loop;
    end process;


-- architecture behavioral of memory is 

-- begin
--     process(clock)
--         --cria matriz de 2^16 pos com cada uma de tamanho 8 bits--
--         type mem_t is array (2^addr_width) of std_logic_vector(data_width-1 downto 0);
--         signal mem : mem_t;
 
--     begin
--         loop
--             wait on clock;
--             if data_read = '1' then 
--                 data_out <= mem(data_addr);
--             end if;
--             if data_write = '1' then
--                 mem(data_addr) := data_in;
--             end if ;
--         end loop;
--     end process;
end;