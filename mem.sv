module memory (
    input wire clk,
    input wire [9:0] addr,
    input wire wen,
    input wire [7:0] wdata,
    output logic [7:0] rdata
);

localparam ASCII_SP = 8'h20;
localparam ASCII_TAB = 8'h9;
localparam ASCII_LF = 8'h0a;

logic [7:0] mem [1023:0];

integer i = 0;
initial begin
    $readmemh("pg.bin", mem);
end

always @(posedge clk) begin
    if (wen) begin
        mem[addr] <= wdata;
    end
    rdata <= mem[addr];
end

endmodule