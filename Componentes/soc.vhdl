library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity soc is
    generic (
        firmware_filename: string := "firmware.bin"
    );
    port (
        clock: in std_logic; -- Clock signal
        started: in std_logic -- Start execution when '1'
);
end entity;

--criar sinais aux para conectar entidades--

architecture behavioral of soc is 
-- compartilhar codec com cpu signal --
signal codec_interrupt_aux : std_logic := '0';
signal codec_read_aux      : std_logic := '0';
signal codec_write_aux     : std_logic := '0';
signal codec_valid_aux     : std_logic := '0';
signal codec_data_in_aux   : std_logic_vector(7 downto 0) := (others => '0');
signal codec_data_out_aux  : std_logic_vector(7 downto 0) := (others => '0');
-- constanstes para generic map--
constant addr_width: natural := 16;
constant data_width: natural := 8;
-- compartilhar dados da men com cpu --
signal mem_data_read            : std_logic := '0';
signal mem_data_write           : std_logic := '0';
signal instruction_in_aux       : std_logic_vector(data_width-1 downto 0)       := (others => '0');
signal instruction_addr         : std_logic_vector(addr_width-1 downto 0)       := (others => '0');
signal mem_data_addr            : std_logic_vector(addr_width-1 downto 0)       := (others => '0');
signal mem_data_in_aux          : std_logic_vector((data_width*2)-1 downto 0)   := (others => '0');
signal mem_data_out_aux         : std_logic_vector((data_width*4)-1 downto 0)   := (others => '0');
--para carregar imen--
signal load_aux : std_logic_vector((data_width*2)-1 downto 0) := (others => '0');
--comando para pausar cpu--
signal halt_aux : std_logic := '0';

begin 

-- instanciar 2 memorias
Imem  : entity work.memory(behavioral)
            generic map(addr_width => addr_width, data_width => data_width)
            port map (clock => clock, data_read => mem_data_read, data_write => mem_data_write, data_addr => mem_data_addr, data_in => mem_data_in_aux , data_out => mem_data_out_aux);
Dmem  : entity work.memory(behavioral)
            generic map(addr_width => addr_width, data_width => data_width)
            port map (clock => clock, data_read => mem_data_read, data_write => mem_data_write, data_addr => mem_data_addr, data_in => mem_data_in_aux , data_out => mem_data_out_aux);
-- usar a cpu--
Cpu   :  entity work.cpu(behavioral)
            generic map(addr_width => addr_width, data_width => data_width)
            port map (clock => clock ,halt => halt_aux, instruction_in =>instruction_in_aux, instruction_addr =>instruction_addr, mem_data_read =>mem_data_read, mem_data_write =>mem_data_write, mem_data_addr => mem_data_addr, mem_data_in => mem_data_in_aux, mem_data_out => mem_data_out_aux, codec_interrupt =>codec_interrupt_aux,codec_read =>codec_read_aux,codec_write =>codec_write_aux,codec_valid =>codec_valid_aux,codec_data_out =>codec_data_out_aux,codec_data_in =>codec_data_in_aux);
-- usar codec--
Codec :  entity work.codec(behavioral)
            port map (clock => clock, interrupt=>codec_interrupt_aux, read_signal=> codec_read_aux, write_signal=>codec_write_aux, valid=>codec_valid_aux, codec_data_in=>codec_data_in_aux, codec_data_out=>codec_data_out_aux);
--carregar firmware na imem--
load: process 
        file arq : text open read_mode is firmware_filename;
        variable text_line: line;
        variable auxiliar: bit_vector(7 downto 0);
        variable endereco: std_logic_vector(addr_width-1 downto 0) := (others => '0');
    begin
        if started = '0' then
            readline(arq,text_line);
            read(text_line,auxiliar);
            load_aux(15 downto 8) <= to_stdlogicvector(auxiliar);
            instruction_addr <= endereco;
            --report "teste  " & integer'image(to_integer(signed(load_aux)));
            endereco := std_logic_vector(unsigned(endereco) + 1);
        end if;
        wait on clock;
    end process load;

end architecture;

--As entidades mem, codec e soc possuem sinais relativos aos presentes
--na entidade cpu e que devem ser interligados entre si.