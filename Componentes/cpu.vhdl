library ieee;
use ieee.std_logic_1164;

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
        data_in : in std_logic_vector(data_width-1 downto 0);
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
constant HLT      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000001"; --Interrompe execu¸c˜ao indefinidamente.--
constant IN_      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000010"; --Empilha um byte recebido do codec.--   
constant OUT_     : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000011"; --Desempilha um byte e o envia para o codec.
constant PUSHIP   : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000100"; --Empilha o endere¸co armazenado no registrador IP(2 bytes, primeiro MSB e depois LSB).
constant PUSH_IMM : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000101"; --Empilha um byte contendo imediato (armazenado nos 4 bits menos significativos da instru¸c˜ao).
constant DROP     : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000110"; --Elimina um elemento da pilha
constant DUP      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000111"; --Reempilha o elemento no topo da pilha
constant ADD      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00001000"; --Desempilha Op1 e Op2 e empilha (Op1 + Op2).
constant SUB      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00001001"; --Desempilha Op1 e Op2 e empilha (Op1 − Op2).
constant NAND_    : STD_LOGIC_VECTOR(15 DOWNTO 0):="00001011"; --Desempilha Op1 e Op2 e empilha NAND(Op1, Op2).
constant SLT      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00001111"; --Desempilha Op1 e Op2 e empilha (Op1 < Op2).
constant SHL      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00010000"; --Desempilha Op1 e Op2 e empilha (Op1 ≪ Op2).
constant SHR      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00010001"; --Desempilha Op1 e Op2 e empilha (Op1 ≫ Op2).
constant JEQ      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00010010"; --Desempilha Op1(1 byte), Op2(1 byte) e Op3(2 bytes); Verifica se (Op1 = Op2), caso positivo soma Op3 no registrador IP.
constant JMP      : STD_LOGIC_VECTOR(15 DOWNTO 0):="00000000"; --Desempilha Op1(2 bytes) e o atribui no registrador IP

 
begin





end architecture;