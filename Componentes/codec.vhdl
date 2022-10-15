library ieee, std;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity codec is
  port (
    interrupt : in std_logic; -- Interrupt signal
    read_signal : in std_logic; -- Read signal
    write_signal : in std_logic; -- Write signal
    valid : out std_logic; -- Valid signal
    -- Byte written to codec
    codec_data_in : in std_logic_vector(7 downto 0);
    -- Byte read from codec
    codec_data_out : out std_logic_vector(7 downto 0)
  );
end entity;

architecture behavior of codec is
  constant Aquivo_entrada : string := "DadosIn.dat";
  constant Aquivo_saida : string := "DadosOut.dat";
  file fptrd : text;
  file fptrwr : text;
begin
  process (interrupt) is
    variable statrd : file_open_status;
    variable statwr : file_open_status;
    variable file_line_rd : line;
    variable file_line_wr : line;
    variable lido_out : integer;
    variable escrito_in : integer;
  begin

    if (read_signal = '1' and write_signal = '0') then
      file_open(statrd, fptrd, Aquivo_entrada, read_mode);
      if (statrd = open_ok) then
        while not endfile(fptrd) loop
          readline(fptrd, file_line_rd);
          read(file_line_rd, lido_out);
        end loop;
        codec_data_out <= std_logic_vector(to_signed(lido_out, 8));
        file_close(fptrd);
      end if;
    elsif (read_signal = '0' and write_signal = '1') then
      file_open(statwr, fptrwr, Aquivo_saida, write_mode);
      if (statwr = open_ok) then
        write(file_line_wr, to_integer(unsigned(codec_data_in)));
        writeline(fptrwr, file_line_wr);
        file_close(fptrwr);
      end if;
    end if;
    valid <= '1';
  end process;
end architecture;