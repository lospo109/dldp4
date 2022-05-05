module seg (BCD, seg);
input [3:0] BCD;
output [7:0] seg;
reg [7:0] seg;
always @(BCD)
begin
    case (BCD)
        4'h0:
            seg = 8'hc0;
        4'h1:
            seg = 8'hf9;
        4'h2:
            seg = 8'ha4;
        4'h3:
            seg = 8'hb0;
        4'h4:
            seg = 8'h99;
        4'h5:
            seg = 8'h92;
        4'h6:
            seg = 8'h82;
        4'h7:
            seg = 8'hf8;
        4'h8:
            seg = 8'h80;
        4'h9:
            seg = 8'h90;
        default:
            seg = 8'hff;
    endcase
end
endmodule

    module dff (clk, load, D, Din, Q);
input clk, D, Din, load;
output reg Q;
always@ (posedge clk)
begin
    if (load)
        Q = Din;
    else
        Q = D;
end
endmodule


    module BCD(clk, load, rst_syn, data, Q_out, seg_out);
input clk, rst_syn, load;
input [3:0] data;
output wire [3:0] Q_out;
reg Q0, Q1, Q2, Q3;

output wire [7:0] seg_out;

dff dff0(.clk(clk), .load(load), .D(Q0), .Din(Q0), .Q(Q_out[0]));
dff dff1(.clk(clk), .load(load), .D(Q1), .Din(Q1), .Q(Q_out[1]));
dff dff2(.clk(clk), .load(load), .D(Q2), .Din(Q2), .Q(Q_out[2]));
dff dff3(.clk(clk), .load(load), .D(Q3), .Din(Q3), .Q(Q_out[3]));

always @(posedge clk)
begin
    if (!rst_syn)
    begin
        Q0 = 0;
        Q1 = 0;
        Q2 = 0;
        Q3 = 0;
    end
    else if(load)
    begin
        Q0 <= data[0];
        Q1 <= data[1];
        Q2 <= data[2];
        Q3 <= data[3];
    end
    else
    begin
        if (Q0 == 1 && Q3 == 1)
        begin
            Q0 = 0;
            Q3 = 0;
        end
        else
        begin
            Q0 <= ~Q0;
            Q1 <= (Q1 & ~Q0) | (~Q1 & Q0);
            Q2 <= (Q2 & ~Q1) | (Q2 & ~Q0) | (~Q2 & Q1 & Q0);
            Q3 <= (Q3) | (Q0 & Q1 & Q2);
        end
    end
end

seg show_seg(Q_out, seg_out);

endmodule
