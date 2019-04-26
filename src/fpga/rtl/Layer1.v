`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2019 20:02:56
// Design Name: 
// Module Name: Layer1
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


module Layer1 #(parameter NN = 30) //Number of neurons in the layer
    (
    input [NN*16-1:0] w_in,
    input [NN-1:0] w_valid,
    input [NN-1:0] x_valid,
    input [NN*16-1:0] x_in,
    input clk,
    input rst,
    output [NN-1:0] o_valid,
    output [NN*16-1:0] x_out
    );
    
    genvar k;
    generate
        for (k=0; k<=29; k=k+1)
        begin: neurons 
            neuron #(.numWeight(784),.layerNo(1),.neuronNo(k))nk( .myinput(x_in[k*16+15:16*k]), 
                       .myweights(w_in[k*16+15:16*k]), 
                       .myweightValid(w_valid[k]), 
                       .myinputValid(x_valid[k]), .clk(clk), .rst(rst),
                       .out(x_out[k*16+15:16*k]), .outvalid(o_valid[k]));        
        end
    endgenerate
    
    
endmodule
