LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pwm_tb IS
END pwm_tb;

ARCHITECTURE behavior OF pwm_tb IS 

    -- Composant à tester (DUT - Device Under Test)
    COMPONENT pwm
        GENERIC (
            pwm_bits : integer := 8;
            clk_cnt_len : positive := 1
        );
        PORT(
            clk : IN  std_logic;
            rst : IN  std_logic;
            duty_cycle : IN  std_logic_vector (pwm_bits - 1 downto 0);
            pwm_out : OUT std_logic
        );
    END COMPONENT;
    
    -- Signaux de test
    CONSTANT clk_period : time := 10 ns; -- Période d'horloge (100 MHz)
    
    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '1';
    SIGNAL duty_cycle : std_logic_vector(7 downto 0) := (others => '0');
    SIGNAL pwm_out : std_logic;

BEGIN

    -- Instanciation du module PWM
    uut: pwm 
        GENERIC MAP (
            pwm_bits => 8,
            clk_cnt_len => 1
        )
        PORT MAP (
            clk => clk,
            rst => rst,
            duty_cycle => duty_cycle,
            pwm_out => pwm_out
        );

    -- Processus d'horloge
    clk_process : process
    begin
        while now < 2 ms loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Processus de stimulation (test)
    stim_proc: process
    begin        
        -- Réinitialisation
        rst <= '1';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;

        -- Test 1 : 25% Duty Cycle (64/256)
        duty_cycle <= "01000000"; -- 64
        wait for 1 ms;

        -- Test 2 : 50% Duty Cycle (128/256)
        duty_cycle <= "10000000"; -- 128
        wait for 1 ms;

        -- Test 3 : 75% Duty Cycle (192/256)
        duty_cycle <= "11000000"; -- 192
        wait for 1 ms;

        -- Test 4 : 100% Duty Cycle (255/256)
        duty_cycle <= "11111111"; -- 255
        wait for 1 ms;

        -- Fin du test
        wait;
    end process;

END behavior;
