library ieee;
use ieee.std_logic_1164.all;

entity andor is
    generic (
        N: natural := 6
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        operation: in std_logic;
        S: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture behavioral of andor is
begin

    S <= A and B when operation = '0' else A or B;

end architecture;
