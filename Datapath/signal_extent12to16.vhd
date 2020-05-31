library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signal_extent12to16 is

	port
	(  signal_extent_in	   : in std_logic_vector(12-1 downto 0);
		signal_extent_out	   : out std_logic_vector(16-1 downto 0)
	);
end signal_extent12to16;

architecture comportamento of signal_extent12to16 is
begin
    signal_extent_out <= std_logic_vector(resize(signed(signal_extent_in), signal_extent_out'length));
end architecture;