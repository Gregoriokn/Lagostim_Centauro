library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addsub is
    generic (
        N: natural := 8
    );
    port (
        A, B: in std_logic_vector(N-1 downto 0);
        operation: in std_logic;
        S: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture behavioral of addsub is
    signal s1, s2: std_logic_vector(N-1 downto 0);
begin

    s1 <= std_logic_vector(to_signed(to_integer(signed(A))+to_integer(signed(B)),N));
    s2 <= std_logic_vector(to_signed(to_integer(signed(A))-to_integer(signed(B)),N));
 
    S <=  s1 when operation = '0' else s2;


end architecture;
