module test();

reg clk = 0;
always
    #1 clk = ~clk;

initial
    #10000 $finish;

main #() m(
    .clk(clk)
);

endmodule