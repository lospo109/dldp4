`timescale 1ns/10ps
module BCD_tb;
reg clk;
reg rst_syn, load;
reg [3:0] data;
wire [3:0] Q_out;
wire [7:0] seg_out;

BCD BCD_tb(
        .clk(clk),
        .load(load),
        .rst_syn(rst_syn),
        .data(data),
        .Q_out(Q_out),
        .seg_out(seg_out)
    );

initial
begin
    clk = 1;
    rst_syn = 1;
    load = 1;
    data = 4'b0101;
end

always #50 clk = ~clk;


initial
    #50 load = 1'b0;
initial
    #400 load = 1'b1;
initial
    #500 load = 1'b0;
initial
    #300 rst_syn  = 1'b0;
initial
    #400 rst_syn  = 1'b1;
initial
    #2000 $finish;


initial
begin
    $dumpfile("BCD.vcd");
    $dumpvars(0, BCD_tb);
end

endmodule
