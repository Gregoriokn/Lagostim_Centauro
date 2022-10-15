library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;

entity codec is
    port (
        clock: in std_logic;

        interrupt: in std_logic; -- Interrupt signal
        read_signal: in std_logic; -- Read signal
        write_signal: in std_logic; -- Write signal
        valid: out std_logic; -- Valid signal

        -- Byte written to codec
        codec_data_in : in std_logic_vector(7 downto 0);
        -- Byte read from codec    
        codec_data_out : out std_logic_vector(7 downto 0)
);
end entity;

begin 

    escrita : process
        type t_arq_out is file of std_logic_vector(7 downto 0);
        file arq_dados_out : t_arq_out
            open append_mode is "dados_out.dat";
    begin
        wait on interrupt until write_signal = '1';
        write(arq_dados_out, codec_data_out);

        wait;
    end process;

    leitura : process 
     type t_arq_in is file of std_logic_vector(7 downto 0);
     file arq_pacote : t_arq_in 
        open read_mode is "dados_in.dat";

    begin
        wait on interrupt until read_signal = '1';
        read(arq_pacote,codec_data_in);

    end process;


end