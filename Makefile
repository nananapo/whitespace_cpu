run:
	iverilog -g2005-sv test.sv main.sv mem.sv
	vvp a.out
