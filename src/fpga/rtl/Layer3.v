`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2019 21:40:16
// Design Name: 
// Module Name: Layer3
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


module Layer3 #(parameter NN3 = 10, //Number of Neurons in the layer
                numWeights = 30) //Number of weights of each neuron
     (
      input [NN3*16-1:0] w_in,
      input [NN3-1:0] w_valid,
      input [NN3-1:0] x_valid,
      input [NN3*16-1:0] x_in,
      input clk,
      input rst,
      output [NN3-1:0] o_valid,
      output [NN3*16-1:0] x_out  
       );
       
        genvar k;
           generate
               for (k=0; k<=NN3-1; k=k+1)
               begin: neurons
                   neuron #(.numWeight(30),.layerNo(3),.neuronNo(k)) nk2(.myinput(x_in[k*16+15:16*k]), 
                              .myweights(w_in[k*16+15:k*16]), 
                              .myweightValid(w_valid[k]), 
                              .myinputValid(x_valid[k]), .clk(clk), .rst(rst),
                              .out(x_out[k*16+15:16*k]), .outvalid(o_valid[k]));        
               end
           endgenerate
endmodule
