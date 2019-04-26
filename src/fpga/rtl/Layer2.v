`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2019 21:09:23
// Design Name: 
// Module Name: Layer2
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


module Layer2 #(parameter NN2 = 30,//Number of Neurons in the layer
                numWeights = 30 )//Number of weights of each neuron
    (
    input [NN2*16-1:0] w_in,
    input [NN2-1:0] w_valid,
    input [NN2-1:0] x_valid,
    input [NN2*16-1:0] x_in,
    input clk,
    input rst,
    output [NN2-1:0] o_valid,
    output [NN2*16-1:0] x_out
    );
    
     genvar k;
     generate
         for (k=0; k<=NN2-1; k=k+1)
         begin: neurons
             neuron #(.numWeight(30),.layerNo(2),.neuronNo(k))nk2(.myinput(x_in[k*16+15:16*k]), 
                        .myweights(w_in[k*16+15:k*16]), //change
                        .myweightValid(w_valid[k]), 
                        .myinputValid(x_valid[k]), .clk(clk), .rst(rst),
                        .out(x_out[k*16+15:16*k]), .outvalid(o_valid[k]));        
         end
     endgenerate
    
    
    
endmodule
