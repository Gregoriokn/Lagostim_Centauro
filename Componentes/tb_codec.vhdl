library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_codec is
end entity;

architecture behavioral of tb_codec is

  signal interrupt : std_logic := '0';
  signal read_signal : std_logic := '0'; -- Read signal
  signal write_signal : std_logic := '0'; -- Write signal
  signal valid : std_logic := '0'; -- Valid signal
  -- Byte written to codec
  signal codec_data_in : std_logic_vector(7 downto 0);
  -- Byte read from codec
  signal codec_data_out : std_logic_vector(7 downto 0);

begin
  codec : entity  work.codec(behavioral)
    port map (interrupt, read_signal, write_signal,valid,codec_data_in,codec_data_out);


    estimulo_de_checagem : process is
        variable aux : std_logic_vector(7 downto 0) := "00100010";
        variable aux1 : std_logic_vector(7 downto 0);
        variable valid_aux : std_logic := '1';

    begin   
     -- ESCRITA
        write_signal <= '1';
        read_signal <= '0';
        interrupt <= '1';
        codec_data_in <= aux;
        wait for 5 ns;
        assert valid_aux = valid report "ERRO valid" severity failure;
        interrupt <= '0';
        wait for 2 ns;
        

    -- -- LEITURA
        write_signal <= '0';
        read_signal <= '1';
        interrupt <= '1';
        wait for 5 ns;
        assert aux = codec_data_out report "ERRO" severity failure;
        assert valid_aux = valid report "ERRO valid" severity failure;
        wait for 5 ns;
        interrupt <= '0';
        wait for 2 ns;
      wait;   
    end process;
end architecture;