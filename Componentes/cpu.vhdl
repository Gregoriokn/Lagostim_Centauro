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

        mem_data_read: out std_logic; -- When '1', read data from memory
        mem_data_write: out std_logic; -- When '1', write data to memory

        -- Data address given to memory
        mem_data_addr : out std_logic_vector(addr_width-1 downto 0);
        -- Data sent to memory when mem_data_read = '0' and mem_data_write = '1' (comentário corrigido)
        mem_data_in : out std_logic_vector((data_width*2)-1 downto 0);
        -- Data sent from memory when mem_data_read = '1' and mem_data_write = '0' (comentário corrigido)
        mem_data_out : in std_logic_vector((data_width*4)-1 downto 0);
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
constant op_HLT      : std_logic_vector(7 DOWNTO 4):="0000"; --Interrompe execucao indefinidamente.--
constant op_IN       : std_logic_vector(7 DOWNTO 4):="0001"; --Empilha um byte recebido do codec.--   
constant op_OUT      : std_logic_vector(7 DOWNTO 4):="0010"; --Desempilha um byte e o envia para o codec.
constant op_PUSHIP   : std_logic_vector(7 DOWNTO 4):="0011"; --Empilha o endereço armazenado no registrador IP(2 bytes, primeiro MSB e depois LSB).
constant op_PUSH_IMM : std_logic_vector(7 DOWNTO 4):="0100"; --Empilha um byte contendo imediato (armazenado nos 4 bits menos significativos da instru¸c˜ao).
constant op_DROP     : std_logic_vector(7 DOWNTO 4):="0101"; --Elimina um elemento da pilha
constant op_DUP      : std_logic_vector(7 DOWNTO 4):="0110"; --Reempilha o elemento no topo da pilha
constant op_ADD      : std_logic_vector(7 DOWNTO 4):="1000"; --Desempilha Op1 e Op2 e empilha (Op1 + Op2).
constant op_SUB      : std_logic_vector(7 DOWNTO 4):="1001"; --Desempilha Op1 e Op2 e empilha (Op1 − Op2).
constant op_NAND     : std_logic_vector(7 DOWNTO 4):="1010"; --Desempilha Op1 e Op2 e empilha NAND(Op1, Op2).
constant op_SLT      : std_logic_vector(7 DOWNTO 4):="1011"; --Desempilha Op1 e Op2 e empilha (Op1 < Op2).
constant op_SHL      : std_logic_vector(7 DOWNTO 4):="1100"; --Desempilha Op1 e Op2 e empilha (Op1 ≪ Op2).
constant op_SHR      : std_logic_vector(7 DOWNTO 4):="1101"; --Desempilha Op1 e Op2 e empilha (Op1 ≫ Op2).
constant op_JEQ      : std_logic_vector(7 DOWNTO 4):="1110"; --Desempilha Op1(1 byte), Op2(1 byte) e Op3(2 bytes); Verifica se (Op1 = Op2), caso positivo soma Op3 no registrador IP.
constant op_JMP      : std_logic_vector(7 DOWNTO 4):="1111"; --Desempilha Op1(2 bytes) e o atribui no registrador IP

signal IP :std_logic_vector(addr_width-1 downto 0) := "0000000000000000";
signal SP :std_logic_vector(addr_width-1 downto 0) := "0000000000000000";



begin

    execute : process(clock)

    variable data_temp1, data_temp2 : std_logic_vector(data_width-1 downto 0);
    variable data_temp3 : std_logic_vector((data_width*2)-1 downto 0);
    variable int_temp: integer;
    variable opcode : std_logic_vector(7 downto 4);
    
    begin
  
        if rising_edge(clock) then


            --Manda valor do registrador IP pra IMEM
            instruction_addr <= IP; 
            --Pega opcode da instrucao
            opcode := instruction_in(data_width-1 downto data_width-4);
            --Executa opcode
                case opcode is
                    when op_HLT => 
                        report "HALT";

                    when op_IN => 
                        codec_read <= '1';
                        codec_write <= '0';
                        codec_interrupt <= '1','0' after 2 ns;


                    when op_OUT => 
                        codec_read <= '0';
                        codec_write <= '1';
                        codec_interrupt <= '1','0' after 2 ns;


                    when op_PUSHIP =>
                        
                        mem_data_read <= '0';
                        mem_data_write <= '1';

                        SP <= std_logic_vector(unsigned(SP) + 1); --incrementa ponteiro da pilha
                        mem_data_addr <= SP;
                        mem_data_in((data_width*2)-1 downto (data_width*2)-8) <= IP(addr_width-1 downto addr_width-8); --empilha byte mais significativo

                        
                        SP <= std_logic_vector(unsigned(SP) + 1); --incrementa ponteiro da pilha
                        mem_data_addr <= SP;
                        mem_data_in((data_width*2)-9 downto 0) <= IP(addr_width-9 downto 0); --empilha byte menos significativo

                    when op_PUSH_IMM => 
                        mem_data_read <= '0';
                        mem_data_write <= '1';

                        SP <= std_logic_vector(unsigned(SP) + 1); --incrementa ponteiro da pilha
                        mem_data_addr <= SP;
                        mem_data_in <= IP(addr_width-9 downto 0);

                    when op_DROP => 
                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        mem_data_in <= std_logic_vector(to_unsigned(0,data_width));
                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                    when op_DUP =>
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp

                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        SP <= std_logic_vector(unsigned(SP) + 1); --incrementa ponteiro da pilha
                        mem_data_addr <= SP;
                        mem_data_in <= data_temp1; --copia temp pra novo topo

                    when op_ADD => 
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp2 := mem_data_out; --copia topo da pilha pra temp2
                        data_temp1 := std_logic_vector(signed(data_temp1) + signed(data_temp2)); --realiza soma

                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        mem_data_in <= data_temp1; --copia soma pra novo topo

                    when op_SUB =>  
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp2 := mem_data_out; --copia topo da pilha pra temp2
                        data_temp1 := std_logic_vector(signed(data_temp1) - signed(data_temp2)); --realiza subtracao

                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        mem_data_in <= data_temp1; --copia soma pra novo topo

                    when op_NAND =>  
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp2 := mem_data_out; --copia topo da pilha pra temp2
                        data_temp1 := std_logic_vector(signed(data_temp1) nand signed(data_temp2)); --realiza operacao

                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        mem_data_in <= data_temp1; --copia soma pra novo topo

                    when op_SLT => -- SET LESS THAN
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp2 := mem_data_out; --copia topo da pilha pra temp2

                        mem_data_read <= '0';
                        mem_data_write <= '1';

                        if data_temp1 < data_temp2 then
                            mem_data_in <= std_logic_vector(to_unsigned(1,data_width));
                        else 
                            mem_data_in <= std_logic_vector(to_unsigned(0,data_width));
                        end if;

                    when op_SHR =>
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        int_temp := to_integer(unsigned(mem_data_out)); --copia topo da pilha, em inteiro, pra temp2
                        
                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        -- desloca n bits pra esquerda (confia)
                            mem_data_in <= data_temp1(data_width-int_temp-1 downto 0) & std_logic_vector(to_unsigned(0,int_temp));

                    when op_JEQ =>
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp1 := mem_data_out; --copia topo da pilha pra temp1

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp2 := mem_data_out; --copia topo da pilha pra temp2
                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;

                        data_temp3 := mem_data_out((data_width*2)-1 downto 0); --copia dos bytes do topo da pilha para data_temp3

                        mem_data_read <= '0';
                        mem_data_write <= '1';
                        if data_temp1 = data_temp2 then
                            mem_data_in <= data_temp3;
                        end if;

                    when op_JMP =>
                        mem_data_read <= '1';
                        mem_data_write <= '0';
                        data_temp3 := mem_data_out((data_width*2)-1 downto 0); --copia dos bytes do topo da pilha para data_temp3

                        SP <= std_logic_vector(unsigned(SP) - 1); --decrementa ponteiro da pilha
                        mem_data_addr <= SP;
                        IP <= data_temp3;
                        
                    when others =>
                        report "UNKOWN OPCODE!" severity failure;
                end case;

                IP <= std_logic_vector(unsigned(IP) + 1); --Proxima instrucao
        end if;
    end process;

end architecture;