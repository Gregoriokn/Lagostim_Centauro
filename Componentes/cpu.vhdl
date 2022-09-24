library ieee;
use ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu is 
    generic (
        addr_width: natural := 16; -- Memory Address Width (in bits)
        data_width: natural := 8 -- Data Width (in bits)
    );
    port (
        clock: in std_logic; -- Clock signal
        halt : in std_logic; -- Halt processor execution when '1'
        ---- Begin Memory Signals ---

         -- Instruction byte received from memory
        instruction_in : in std_logic_vector(data_width-1 downto 0);
        -- Instruction address given to memory
        instruction_addr: out std_logic_vector(addr_width-1 downto 0);

        data_read : out std_logic; -- When '1', read data from memory
        data_write: out std_logic; -- When '1', write data to memory

        -- Data address given to memory
        data_addr : out std_logic_vector(addr_width-1 downto 0);
        -- Data sent from memory when data_read = '1' and data_write = '0'
        data_in : out std_logic_vector((data_width*4)-1 downto 0);
        -- Data sent to memory when data_read = '0' and data_write = '1'
        data_out : in std_logic_vector(data_width-1 downto 0);
        ---- End Memory Signals ---

        ---- Begin Codec Signals ---
        codec_interrupt: out std_logic; -- Interrupt signal
        codec_read: out std_logic; -- Read signal
        codec_write: out std_logic; -- Write signal
        codec_valid: in std_logic; -- Valid signal

        -- Byte written to codec
        codec_data_out : in std_logic_vector(7 downto 0);
        -- Byte read from codec
        codec_data_in : out std_logic_vector(7 downto 0)
        ---- End Codec Signals ---
);
end entity;    

architecture Behavioral of cpu is 
constant HLT      : std_logic_vector(3 DOWNTO 0):="0000"; --Interrompe execu¸c˜ao indefinidamente.--
constant IN_      : std_logic_vector(3 DOWNTO 0):="0001"; --Empilha um byte recebido do codec.--   
constant OUT_     : std_logic_vector(3 DOWNTO 0):="0010"; --Desempilha um byte e o envia para o codec.
constant PUSHIP   : std_logic_vector(3 DOWNTO 0):="0011"; --Empilha o endere¸co armazenado no registrador IP(2 bytes, primeiro MSB e depois LSB).
constant PUSH_IMM : std_logic_vector(3 DOWNTO 0):="0100"; --Empilha um byte contendo imediato (armazenado nos 4 bits menos significativos da instru¸c˜ao).
constant DROP     : std_logic_vector(3 DOWNTO 0):="0101"; --Elimina um elemento da pilha
constant DUP      : std_logic_vector(3 DOWNTO 0):="0110"; --Reempilha o elemento no topo da pilha
constant ADD      : std_logic_vector(3 DOWNTO 0):="0111"; --Desempilha Op1 e Op2 e empilha (Op1 + Op2).
constant SUB      : std_logic_vector(3 DOWNTO 0):="1000"; --Desempilha Op1 e Op2 e empilha (Op1 − Op2).
constant NAND_    : std_logic_vector(3 DOWNTO 0):="1001"; --Desempilha Op1 e Op2 e empilha NAND(Op1, Op2).
constant SLT      : std_logic_vector(3 DOWNTO 0):="1010"; --Desempilha Op1 e Op2 e empilha (Op1 < Op2).
constant SHL      : std_logic_vector(3 DOWNTO 0):="1011"; --Desempilha Op1 e Op2 e empilha (Op1 ≪ Op2).
constant SHR      : std_logic_vector(3 DOWNTO 0):="1100"; --Desempilha Op1 e Op2 e empilha (Op1 ≫ Op2).
constant JEQ      : std_logic_vector(3 DOWNTO 0):="1101"; --Desempilha Op1(1 byte), Op2(1 byte) e Op3(2 bytes); Verifica se (Op1 = Op2), caso positivo soma Op3 no registrador IP.
constant JMP      : std_logic_vector(3 DOWNTO 0):="1111"; --Desempilha Op1(2 bytes) e o atribui no registrador IP

signal IP :std_logic_vector(2^addr_width) := "0000000000000000"
signal SP :std_logic_vector(data_width)

signal ir : in std_logic_vector(data_width-1 downto 0);

--flags--

--flag para operar na memoria--

--flag para operar na alu--

--flag para decode--

--flag para codec--






begin

    prog_addr    <= std_logic_vector(IP);
    mem_addr     <= ir(3 downto 0) & prog_data;
    io_addr      <= ir(3 downto 0);
    io_data_out  <= a;
    mem_data_out <= a;

fetch : process(clock,)
            begin
                if rising_edge(clk) and phase = FETCH_PHASE then
                    ir <= instruction_in;
              end if;
            end process;



decode: process()
            begin






            end decode;







execute : process()
            begin

                    case instruction_in(7 downto 4) is
                        when HLT

                        WHEN IN_                
                        halt <= '1';
                        read_signal <= '1';
                        write_signal <= '0';
                        --fazer pulso--
                        interrupt <=

                        when OUT_

                        when PUSHIP 

                        when PUSH_IMM

                        when DROP

                        when DUP

                        when ADD 
                        -- recebe da mem--
                        op1 <= data_in(addr)
                        op2  <= data_in(addr+1)

                        -- desempilha da DMEM--
                        drop(addr)
                        drop(addr+1)

                        --opera--
                        aux <= std_logic_vector(to_signed( (to_integer(signed(A)) + to_integer(signed(B)) ),N) );
                        --empilha--
                        data_out(addr) <= aux;

                        when SUB
                         -- recebe da mem--
                         op1 <= data_in(addr)
                         op  <= data_in(addr+1)
 
                         -- desempilha da DMEM--
                         drop(addr)
                         drop(addr+1)
 
                         --opera--
                         aux <= std_logic_vector(to_signed( (to_integer(signed(A)) - to_integer(signed(B)) ),N) )
                         --empilha--
                         data_out(addr) <= aux;

                        when NAND_

                        when SLT 

                        when SHR

                        when JEQ

                        when JMP 
        end execute;

Write_back :process()
                begin





                end Write_back;








end;


-- lembrar passos, fetch , decode, execute, write-back(buscar instrucoes, decodificar, executar, escrever na memoria resultado)