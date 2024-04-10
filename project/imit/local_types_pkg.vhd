
--library ieee;
--use ieee.numeric_std.all;

package local_types_pkg is
    
    type quart is
		record
			n_4 : integer;
			n_2 : integer;
			n_3_4 : integer;
		end record;
		
	type quartes_array is array (natural range <>) of quart;	
	
	type t_signal is
		record 
			name : string (1 to 10);
			fd	 : real;
			fdev : real;
			N	 : integer;
			pts  : integer;
		end record;
	
	type signal_array is array (natural range <>) of t_signal;
    
end package local_types_pkg;
