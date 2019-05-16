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


module Layer #(parameter NN = 30,numWeight=784,dataWidth=16,layerNum=1,sigmoidSize=10) //Number of neurons in the layer
    (
    input           clk,
    input           rst,
    input           weightValid,
    input           biasValid,
    input [31:0]    weightValue,
    input [31:0]    biasValue,
    input [31:0]    config_layer_num,
    input [31:0]    config_neuron_num,
    input           x_valid,
    input [dataWidth-1:0]    x_in,
    output [NN-1:0]     o_valid,
    output [NN*dataWidth-1:0]  x_out
    );
    
    genvar k;
    generate
        for (k=0; k<=NN-1; k=k+1)
        begin: neurons 
            neuron #(.numWeight(numWeight),.layerNo(layerNum),.neuronNo(k),.dataWidth(dataWidth),.sigmoidSize(sigmoidSize))nk( 
                       .clk(clk), 
                       .rst(rst),
                       .myinput(x_in), 
                       .weightValid(weightValid),
                       .biasValid(biasValid),
                       .weightValue(weightValue),
                       .biasValue(biasValue),
                       .config_layer_num(config_layer_num),
                       .config_neuron_num(config_neuron_num),
                       .myinputValid(x_valid),
                       .out(x_out[k*dataWidth+:dataWidth]), 
                       .outvalid(o_valid[k])
                       );        
        end
    endgenerate
    
    
endmodule
