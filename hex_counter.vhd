library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_counter is
    port (
        clk : in std_logic;         -- 1Hz clock input
        reset : in std_logic;       -- Reset button
		  change: in std_logic;
        leds : out std_logic_vector(5 downto 0);    -- 4 LEDs output
        an : out std_logic_vector(3 downto 0);      -- AN signals for selecting active 7-segment display unit
        seg : out std_logic_vector(6 downto 0)       -- 7-segment display output
    );
end entity hex_counter;

architecture rtl of hex_counter is
	 signal counter1 :integer range 1 to 4 := 1;
	 signal hours : integer range 0 to 23 := 0;
    signal minutes : integer range 0 to 59 := 0;
	 signal tens : integer range 0 to 5 := 0;
	 signal ones : integer range 0 to 9 := 0;
	 signal sec_counter : integer range 0 to 60 := 0;
	 signal cycles : integer range 0 to 50000000 := 50000000;
begin

    -- Clock divider process generates 1Hz clock pulse from the 50MHz clock input
    process(reset,clk)
        variable count : integer range 0 to 50000000;     -- 50MHz
    begin
        if rising_edge(clk) then
            count := count + 1;
            if count = cycles then    
                count := 0;
					 sec_counter <= sec_counter + 1;
					 if (sec_counter = 60) then
                            sec_counter <= 0;
                            minutes <= minutes + 1;
                            if (minutes = 60) then
                                minutes <= 0;
                                hours <= hours + 1;
                                if (hours = 24) then
                                    hours <= 0;
                                end if;
                            end if;
                        end if;
							end if;
					if change = '1' then
					cycles <= 250000;
					elsif change = '0' then
				  cycles <= 50000000;
				end if;
            end if;
		
			if reset = '1' then
            count := 0;
				sec_counter <= 0;
            hours <= 0;
            minutes <= 0;
				tens <= 0;
				ones <= 0;
				cycles <= 50000000; 
        end if;
            --an_sel <= 0;
			
				
		  
		  
    end process;

    -- LED output process converts counter value to binary and outputs on 4 LEDs
    process(sec_counter)
    begin
        leds <= std_logic_vector(to_unsigned(sec_counter, 6));
    end process;

    -- 7-segment display output process converts counter value to hex and outputs on 7-segment display
    process(counter1, clk, reset)
	 variable count : integer range 0 to 50000000;
	 variable count2 : integer range 0 to 500000;
	 variable hours : integer range 0 to 23 := 0;
    variable minutes : integer range 0 to 59 := 0;
	 variable tens : integer range 0 to 15 := 0;
	 variable ones : integer range 0 to 15 := 0;
	 variable thousands : integer range 0 to 15 := 0;
	 variable hundreds : integer range 0 to 15 := 0;
	 variable sec_counter : integer range 0 to 60 := 0;
	 variable cycles : integer range 0 to 50000000 := 50000000;
    begin

			   if rising_edge(clk) then
            count := count + 1;
				count2 := count2 + 1;
            if count2 = 50000 then    
                count2 := 0;
                counter1 <= counter1 + 1;     -- Counter process increments counter on rising edge of 1Hz clock, and resets counter when reset signal is asserted
					 end if;
				if count = cycles then
					 sec_counter := sec_counter + 1;
					 count := 0;
					 if (sec_counter = 60) then
                            sec_counter := 0;
                            minutes := minutes + 1;
									 ones := ones + 1;
										if (minutes = 10) then
											ones := 0;
											tens := tens + 1;
										elsif (minutes = 20) then
											ones := 0;
											tens := tens + 1;
										elsif (minutes = 30) then
											ones := 0;
											tens := tens + 1;
										elsif (minutes = 40) then
											ones := 0;
											tens := tens + 1;
										elsif (minutes = 50) then
											ones := 0;
											tens := tens + 1;
										elsif (minutes = 60) then
											ones := 0;
											tens := 0;
													minutes := 0;
												  hours := hours + 1;
												  hundreds := hundreds + 1;
												  if (hours = 10) then
													hundreds := 0;
													thousands := thousands + 1;
												elsif (hours = 20) then
													hundreds := 0;
													thousands := thousands + 1;
												elsif (hours = 24) then
													hundreds := 0;
													thousands := 0;
												end if;
										end if;
										
                        end if;

            end if;
				if change = '1' then
				  cycles := 250000;
				  elsif change = '0' then
				  cycles := 50000000;
				  end if;

        end if;
		  if reset = '1' then
            count := 0;
				sec_counter := 0;
            hours := 0;
            minutes := 0;
				tens := 0;
				ones := 0;
				hundreds := 0;
				thousands := 0;
				cycles := 50000000;
        end if;
		  
		  
		  if(counter1 mod 4 = 0) then
			an<="0111";
         case ones is
            when 0 => seg <= "0000001";   -- hex 0
            when 1 => seg <= "1001111";   -- hex 1
            when 2 => seg <= "0010010";   -- hex 2
            when 3 => seg <= "0000110";   -- hex 3
            when 4 => seg <= "1001100";   -- hex 4
            when 5 => seg <= "0100100";   -- hex 5
            when 6 => seg <= "0100000";   -- hex 6
            when 7 => seg <= "0001111";   -- hex 7
            when 8 => seg <= "0000000";   -- hex 8
            when 9 => seg <= "0001100";   -- hex 9
            when 10 => seg <= "0000001";  -- hex A
            when 11 => seg <= "1001111";  -- hex B
            when 12 => seg <= "0010010";  -- hex C
            when 13 => seg <= "0000110";  -- hex D
            when 14 => seg <= "1001100";  -- hex E
            when 15 => seg <= "0100100";  -- hex F
            when others => seg <= "-------";  -- invalid input
        end case;
		  elsif (counter1 mod 4 = 1) then
		  		an<="1011";
         case tens is
            when 0 => seg <= "0000001";   -- hex 0
            when 1 => seg <= "1001111";   -- hex 1
            when 2 => seg <= "0010010";   -- hex 2
            when 3 => seg <= "0000110";   -- hex 3
            when 4 => seg <= "1001100";   -- hex 4
            when 5 => seg <= "0100100";   -- hex 5
            when 6 => seg <= "0100000";   -- hex 6
            when 7 => seg <= "0001111";   -- hex 7
            when 8 => seg <= "0000000";   -- hex 8
            when 9 => seg <= "0001100";   -- hex 9
            when 10 => seg <= "0000001";  -- hex A
            when 11 => seg <= "1001111";  -- hex B
            when 12 => seg <= "0010010";  -- hex C
            when 13 => seg <= "0000110";  -- hex D
            when 14 => seg <= "1001100";  -- hex E
            when 15 => seg <= "0100100";  -- hex F
            when others => seg <= "-------";  -- invalid input
        end case;
		  elsif (counter1 mod 4 = 2) then
		  		an<="1101";
         case hundreds is
            when 0 => seg <= "0000001";   -- hex 0
            when 1 => seg <= "1001111";   -- hex 1
            when 2 => seg <= "0010010";   -- hex 2
            when 3 => seg <= "0000110";   -- hex 3
            when 4 => seg <= "1001100";   -- hex 4
            when 5 => seg <= "0100100";   -- hex 5
            when 6 => seg <= "0100000";   -- hex 6
            when 7 => seg <= "0001111";   -- hex 7
            when 8 => seg <= "0000000";   -- hex 8
            when 9 => seg <= "0001100";   -- hex 9
            when 10 => seg <= "0000001";  -- hex A
            when 11 => seg <= "1001111";  -- hex B
            when 12 => seg <= "0010010";  -- hex C
            when 13 => seg <= "0000110";  -- hex D
            when 14 => seg <= "1001100";  -- hex E
            when 15 => seg <= "0100100";  -- hex F
            when others => seg <= "-------";  -- invalid input
        end case;
		  else
		  an<="1110";
         case thousands is
            when 0 => seg <= "0000001";   -- hex 0
            when 1 => seg <= "1001111";   -- hex 1
            when 2 => seg <= "0010010";   -- hex 2
            when 3 => seg <= "0000110";   -- hex 3
            when 4 => seg <= "1001100";   -- hex 4
            when 5 => seg <= "0100100";   -- hex 5
            when 6 => seg <= "0100000";   -- hex 6
            when 7 => seg <= "0001111";   -- hex 7
            when 8 => seg <= "0000000";   -- hex 8
            when 9 => seg <= "0001100";   -- hex 9
            when 10 => seg <= "0000001";  -- hex A
            when 11 => seg <= "1001111";  -- hex B
            when 12 => seg <= "0010010";  -- hex C
            when 13 => seg <= "0000110";  -- hex D
            when 14 => seg <= "1001100";  -- hex E
            when 15 => seg <= "0100100";  -- hex F
            when others => seg <= "-------";  -- invalid input
        end case;
		  
		  end if;
	end process;
	
end architecture rtl;

