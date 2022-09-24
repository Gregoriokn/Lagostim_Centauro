library ieee;
use ieee.std_logic_1164.all;

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

architecture strutural of soc is 





begin 

-- compartilhar codec com cpu signal --

signal Codec_D_In




-- compartilhar dados da men com cpu --

signal 



-- instanciar 2 memorias
Imem  : entity work.memory(behavioral)
            generic map(addr_width => 16, data_width => 8)
            port map (clock => clock, data_read => data_read, data_write=> data_write, data_addr =>data_addr, data_in=> data_in , data_out =>data_out);
Dmem  : entity work.memory(behavioral)
            generic map(addr_width => 16, data_width => 8)
            port map (clock => clock, data_read => data_read, data_write=> data_write, data_addr =>data_addr, data_in=> data_in , data_out =>data_out);

-- usar a cpu--
Cpu   :  entity work.cpu(Behavioral)
            generic map()
            port map (clock => ,halt => , instruction_in => , instruction_addr=> ,data_read=> ,data_write=> ,data_addr=> , data_in => , data_out=> ,codec_interrupt=>,codec_read=>,codec_write=>,codec_valid=>,codec_data_out=>,codec_data_in=>);
-- usar codec--
Codec :  entity work.codec(Behavioral)
            port map (clock => clock, interrupt=> , read_signal=> , write_signal=> , valid=>, codec_data_in=> , codec_data_out=>);



end architecture;


--As entidades mem, codec e soc possuem sinais relativos aos presentes
--na entidade cpu e que devem ser interligados entre si.