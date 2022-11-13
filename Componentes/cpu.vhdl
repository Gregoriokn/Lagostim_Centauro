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

        mem_data_read : out std_logic; -- When '1', read data from memory
        mem_data_write: out std_logic; -- When '1', write data to memory

        -- Data address given to memory
        mem_data_addr : out std_logic_vector(addr_width-1 downto 0);
        -- Data sent to memory when mem_data_read = '0' and mem_data_write = '1' (comentário corrigido)
        mem_data_in : out std_logic_vector((data_width*8)-1 downto 0);
        -- Data sent from memory when mem_data_read = '1' and mem_data_write = '0' (comentário corrigido)
        mem_data_out : in std_logic_vector(data_width-1 downto 0);
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

architecture behavioral of cpu is 
constant op_HLT      : std_logic_vector(3 DOWNTO 0):="0000"; --Interrompe execucao indefinidamente.--
constant op_IN       : std_logic_vector(3 DOWNTO 0):="0001"; --Empilha um byte recebido do codec.--   
constant op_OUT      : std_logic_vector(3 DOWNTO 0):="0010"; --Desempilha um byte e o envia para o codec.
constant op_PUSHIP   : std_logic_vector(3 DOWNTO 0):="0011"; --Empilha o endereço armazenado no registrador IP(2 bytes, primeiro MSB e depois LSB).
constant op_PUSH_IMM : std_logic_vector(3 DOWNTO 0):="0100"; --Empilha um byte contendo imediato (armazenado nos 4 bits menos significativos da instru¸c˜ao).
constant op_DROP     : std_logic_vector(3 DOWNTO 0):="0101"; --Elimina um elemento da pilha
constant op_DUP      : std_logic_vector(3 DOWNTO 0):="0110"; --Reempilha o elemento no topo da pilha
constant op_ADD      : std_logic_vector(3 DOWNTO 0):="1000"; --Desempilha Op1 e Op2 e empilha (Op1 + Op2).
constant op_SUB      : std_logic_vector(3 DOWNTO 0):="1001"; --Desempilha Op1 e Op2 e empilha (Op1 − Op2).
constant op_NAND     : std_logic_vector(3 DOWNTO 0):="1010"; --Desempilha Op1 e Op2 e empilha NAND(Op1, Op2).
constant op_SLT      : std_logic_vector(3 DOWNTO 0):="1011"; --Desempilha Op1 e Op2 e empilha (Op1 < Op2).
constant op_SHL      : std_logic_vector(3 DOWNTO 0):="1100"; --Desempilha Op1 e Op2 e empilha (Op1 ≪ Op2).
constant op_SHR      : std_logic_vector(3 DOWNTO 0):="1101"; --Desempilha Op1 e Op2 e empilha (Op1 ≫ Op2).
constant op_JEQ      : std_logic_vector(3 DOWNTO 0):="1110"; --Desempilha Op1(1 byte), Op2(1 byte) e Op3(2 bytes); Verifica se (Op1 = Op2), caso positivo soma Op3 no registrador IP.
constant op_JMP      : std_logic_vector(3 DOWNTO 0):="1111"; --Desempilha Op1(2 bytes) e o atribui no registrador IP

signal IP :std_logic_vector(addr_width-1 downto 0) := "0000000000000000";
signal SP :std_logic_vector(addr_width-1 downto 0) := "0000000000000000";

--signal instruction : in std_logic_vector(addr_width-1 downto 0);
signal opcode : std_logic_vector(3 downto 0);

begin

    execute : process(clock)
    begin
        if rising_edge(clock) then
            --Manda valor do registrador IP pra IMEM
            instruction_addr <= IP; 
            --Pega opcode da instrucao
            opcode <= instruction_in(addr_width-1 downto addr_width-4); 
            --Executa opcode
                case opcode is
                    when op_HLT => 

                    when op_IN => 

                    when op_OUT => 

                    when op_PUSHIP => 

                    when op_PUSH_IMM => 

                    when op_DROP => 

                    when op_DUP => 

                    when op_ADD => 

                    when op_SUB => 

                    when op_NAND => 

                    when op_SLT => 

                    when op_SHR => 

                    when op_JEQ => 

                    when op_JMP => 

                    when others =>
                end case;
        end if;
    end process;
end architecture;


-- lembrar passos, fetch , decode, execute, write-back(buscar instrucoes, decodificar, executar, escrever na memoria resultado)