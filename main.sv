module main(
    input wire clk,
    input wire uart_rx,
    output wire uart_tx
);

`include "type.svh"

memory #() imem (
    .clk(clk),
    .addr(pc),
    .wen(1'b0),
    .wdata(8'b0),
    .rdata(idata)
);

memory #() dmem (
    .clk(clk),
    .addr(daddr),
    .wen(dwen),
    .wdata(dwdata),
    .rdata(drdata)
);

wire [7:0]  idata;
logic [9:0] pc = 0;

logic [7:0] stack [1024];
logic [9:0] sp = 0;

statetype state = INIT;
logic [7:0] number;

logic [9:0] daddr;
wire        dwen;
logic [7:0] dwdata;
wire [7:0]  drdata;

assign dwen = state == HEAP_MEM_STORE_2;

integer cnt = 0;
always @(posedge clk) begin
// $display("s: %d, %h(%d)", state, idata, pc);
case (state)
    INIT: begin
        state <= FETCH_IMP;
        number <= 0;
        pc <= pc + 1;
    end
    FETCH_IMP: begin
        case (idata)
            ASCII_SP: state <= CHECK_IMP_STACK;
            ASCII_TAB: state <= CHECK_IMP_TAB;
            ASCII_LF: state <= CHECK_IMP_FLOW;
            default: begin
                $display("not impl imp %d", idata);
                $finish;
            end
        endcase
        pc <= pc + 1;
    end
    CHECK_IMP_STACK: begin
        case (idata)
            ASCII_SP: state <= STACK_STACKINT_READ_INT;
            default: begin
                $display("not impl imp stack %d", idata);
                $finish;
            end
        endcase
        pc <= pc + 1;
    end
    CHECK_IMP_TAB: begin
        case (idata)
            ASCII_SP: state <= CHECK_IMP_INT;
            ASCII_TAB: state <= CHECK_IMP_HEAP;
            ASCII_LF: state <= CHECK_IMP_INOUT;
            default: begin
                $display("not impl imp tab %d", idata);
                $finish;
            end
        endcase
        pc <= pc + 1;
    end
    CHECK_IMP_INT: begin
        $display("not impl imp int %d", idata);
        $finish;
    end
    CHECK_IMP_FLOW: begin
        case (idata)
            ASCII_LF: begin
                $display("finish");
                $finish;
            end
        endcase
        $display("not impl imp lf %d", idata);
        $finish;
    end
    CHECK_IMP_HEAP: begin
        case (idata)
            ASCII_SP: state <= HEAP_MEM_STORE_1;
            ASCII_TAB: state <= HEAP_MEM_READ_1;
            default: begin
                $display("not impl imp heap %d", idata);
                $finish;
            end
        endcase
        pc <= pc + 1;
    end
    CHECK_IMP_INOUT: begin
        case (idata)
            ASCII_SP: state <= CHECK_CMD_OUTPUT;
            default: begin
                $display("not impl cmd inout %d", idata);
                $finish;
            end
        endcase
        pc <= pc + 1;
    end
    CHECK_CMD_OUTPUT: begin
        case (idata)
            ASCII_SP: begin
                $display("output : %c", stack[sp - 1]);
                sp <= sp - 1;
                state <= INIT;
            end
            default: begin
                $display("not impl cmd output %d", idata);
                $finish;
            end
        endcase
    end
    HEAP_MEM_READ_1: begin
        state <= HEAP_MEM_READ_2;
        daddr <= stack[sp - 1];
    end
    HEAP_MEM_READ_2: begin
        state <= INIT;
        stack[sp - 1] <= drdata;
        $display("read [%d], %d", daddr, drdata);
    end
    HEAP_MEM_STORE_1: begin
        state <= HEAP_MEM_STORE_2;
        // $display("storei sp:%d %d %d", sp, stack[sp-1], stack[sp-2]);
        daddr <= stack[sp - 1];
        dwdata <= stack[sp - 2];
        sp <= sp - 2;
    end
    HEAP_MEM_STORE_2: begin
        state <= INIT;
        $display("store [%d] , %d", daddr, dwdata);
    end
    STACK_STACKINT_READ_INT: begin
        // $display("idata : %d, num %d %b", idata, number, number);
        case (idata)
            ASCII_SP: begin
                number <= {number[6:0], 1'b0};
                pc <= pc + 1;
            end
            ASCII_TAB: begin
                number <= {number[6:0], 1'b1};
                pc <= pc + 1;
            end
            ASCII_LF:  state <= PUSH_NUMBER;
            default: begin
                // TODO error
            end
        endcase
    end
    PUSH_NUMBER: begin
        stack[sp] <= number;
        sp <= sp + 1;
        state <= INIT;
        $display("stack num : %d %c, pc: %d", number, number, pc);
        // $finish;
    end
endcase
end

endmodule;