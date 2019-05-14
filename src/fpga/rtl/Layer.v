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


module Layer #(parameter NN = 30,numWeight=784,layerNum=1) //Number of neurons in the layer
    (
    input           clk,
    input           rst,
    input           weightValid,
    input           biasValid,
    input [31:0]    weightValue,
    input [31:0]    biasValue,
    input [1:0]     config_layer_num,
    input [4:0]     config_neuron_num,
    input [NN-1:0]  x_valid,
    input [NN*16-1:0] x_in,
    output [NN-1:0]     o_valid,
    output [NN*16-1:0]  x_out
    );
    
    genvar k;
    generate
        for (k=0; k<=NN-1; k=k+1)
        begin: neurons 
            neuron #(.numWeight(numWeight),.layerNo(layerNum),.neuronNo(k))nk( .myinput(x_in[k*16+15:16*k]), 
                       .weightValid(weightValid),
                       .biasValid(biasValid),
                       .weightValue(weightValue),
                       .biasValue(biasValue),
                       .config_layer_num(config_layer_num),
                       .config_neuron_num(config_neuron_num),
                       .myinputValid(x_valid[k]), .clk(clk), .rst(rst),
                       .out(x_out[k*16+15:16*k]), .outvalid(o_valid[k]));        
        end
    endgenerate
    
    
endmodule
