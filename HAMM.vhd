--------------------------------------------------------------------------------
-- File: HAMM_accumulator.vhd
-- Author: 
-- Date: November 11, 2025
-- Description: 
-- 
-- Revision History:
-- Date          Version     Description
-- 11/11/2025    1.0         Initial creation
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HAMM_accumulator is
    port

    (
    clk         : in  STD_LOGIC; -- Clock input
    reset       : in  STD_LOGIC; -- Reset input to clear accumulator
    Load        : in  STD_LOGIC; -- Load signal from control
    export      : in  STD_LOGIC; -- Export signal from control
    A_data_in   : in  STD_LOGIC; -- Input A data from Class HV
    B_data_in   : in  STD_LOGIC; -- Input B data from Test Hv
    sum_out     : out STD_LOGIC_VECTOR(10 downto 0) -- Accumulated sum output

);
end HAMM_accumulator;
architecture Behavioral of HAMM_accumulator is
signal accumulator : STD_LOGIC_VECTOR(10 downto 0);
begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                accumulator <= (others => '0'); -- Clear accumulator on reset
            elsif(Load = '1') then --load signal active from controller
            --this is active when we want to compare inputs for inference
                if(A_data_in = B_data_in) then --if inputs match
                --increment accumulator
                    accumulator <= std_logic_vector(unsigned(accumulator) + 1);
                end if;
            end if;
            if(export = '1') then -- Export signal active from controller when
            --we want to output the accumulated sum to the guess module
                    sum_out <= accumulator;
            end if;
        end if;
    end process;
end Behavioral;