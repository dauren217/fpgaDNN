`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2019 11:21:39
// Design Name: 
// Module Name: twosComplementer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module twosComplementer(
input clk,
input sign,
input [30:0] i_multOut,
output reg [31:0] muxOut
 );
 
 wire [31:0] twosComp;
 
 assign twosComp = ~(i_multOut) + 1'b1;
 
 
 always @(posedge clk)
 begin
    if(sign == 1'b1)
        muxOut <= twosComp;
    else
        muxOut <={1'b0,i_multOut};
 end
 

endmodule
