-------------------s---------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.02.2025 11:11:23
-- Design Name: 
-- Module Name: pwm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: PWM signal generator with configurable duty cycle
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
    generic (
        pwm_bits : integer := 8;  -- Nombre de bits pour le compteur PWM
        clk_cnt_len : positive := 1
    );
    Port ( 
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        duty_cycle : in STD_LOGIC_VECTOR (pwm_bits - 1 downto 0);
        pwm_out : out STD_LOGIC
    );
end pwm;

architecture Behavioral of pwm is

    signal pwm_cnt : unsigned(pwm_bits - 1 downto 0) := (others => '0');
    signal clk_cnt : natural range 0 to clk_cnt_len - 1 := 0;

begin

    -- Processus de comptage d'horloge
    CLK_CNT_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_cnt <= 0;
            else
                if clk_cnt < clk_cnt_len - 1 then
                    clk_cnt <= clk_cnt + 1;
                else
                    clk_cnt <= 0;
                end if;
            end if;
        end if;
    end process;

    -- Processus de génération du signal PWM
    PWM_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pwm_cnt <= (others => '0');
                pwm_out <= '0';
            else
                if clk_cnt_len = 1 or clk_cnt = 0 then
                    pwm_cnt <= pwm_cnt + 1;
                    
                    if pwm_cnt < unsigned(duty_cycle) then
                        pwm_out <= '1';
                    else
                        pwm_out <= '0';
                    end if;
                    
                    -- Remise à zéro du compteur PWM si nécessaire
                    if pwm_cnt = (2**pwm_bits - 1) then
                        pwm_cnt <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
