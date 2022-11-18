library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_cpu is
end entity;

architecture behavioral of tb_cpu is
    constant addr_width: natural := 16; -- Memory Address Width (in bits)
    constant data_width: natural := 8; -- Data Width (in bits)

    signal clock: std_logic := '0';
    signal halt: std_logic := '0';  -- Halt processor execution when '1'
    
    ---- Begin Memory Signals ---
     -- Instruction byte received from memory
    signal instruction_in: std_logic_vector(data_width-1 downto 0) := (others => '0');
    -- Instruction address given to memory
    signal instruction_addr: std_logic_vector(addr_width-1 downto 0);

    signal mem_data_read : std_logic; -- When '1', read data from memory
    signal mem_data_write: std_logic; -- When '1', write data to memory

    -- Data address given to memory
    signal mem_data_addr: std_logic_vector(addr_width-1 downto 0);
    -- Data sent to memory when mem_data_read = '0' and mem_data_write = '1' (comentário corrigido)
    signal mem_data_in: std_logic_vector((data_width*2)-1 downto 0);
    -- Data sent from memory when mem_data_read = '1' and mem_data_write = '0' (comentário corrigido)
    signal mem_data_out: std_logic_vector((data_width*4)-1 downto 0) := (others => '0');
    ---- End Memory Signals ---

    ---- Begin Codec Signals ---
    signal codec_interrupt: std_logic; -- Interrupt signal
    signal codec_read: std_logic; -- Read signal
    signal codec_write: std_logic; -- Write signal
    signal codec_valid: std_logic := '0'; -- Valid signal

    -- Byte written to codec
    signal codec_data_out: std_logic_vector(7 downto 0) := (others => '0');
    -- Byte read from codec
    signal codec_data_in: std_logic_vector(7 downto 0);
    ---- End Codec Signals ---

begin

    cpu: entity work.cpu(behavioral)
        generic map (addr_width, data_width)
        port map(clock, halt,
        instruction_in, instruction_addr,
        mem_data_read,mem_data_write, mem_data_addr, mem_data_in, mem_data_out,
        codec_interrupt, codec_read, codec_write, codec_valid,
        codec_data_out, codec_data_in);

    processo_do_clock: process is
    begin
        for i in 0 to (2**addr_width)*2 loop
            clock <= '0';
            wait for 5 ns;
            clock <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    estimulo_de_checagem: process
        
    begin

        -- op_PUSHIP

            instruction_in <= "00110000";

        wait for 25
         ns;

        -- assert mem_data_read = '0' report "ERRO" & std_logic'image(mem_data_read);
        -- assert mem_data_write = '1' report "ERRO";
        -- assert mem_data_addr = "0000000000000010" report "ERRO";
        -- assert mem_data_in = "00000000" report "ERRO";

        wait;

        -- -- op_PUSH_IMM
        -- instruction_in <= "00111010";
        -- wait for 5 ns;
        -- assert mem_data_read = '0' report "ERRO" severity failure;
        -- assert mem_data_write = '1' report "ERRO" severity failure;
        -- assert mem_data_addr = "000000000000011" report "ERRO" severity failure;
        -- assert mem_data_in = "00001010" report "ERRO" severity failure;





        
    end process;



end behavioral;