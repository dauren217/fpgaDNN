`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2019 15:57:43
// Design Name: 
// Module Name: top_sim
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

`define numLayers 3
`define numNeurons 30

module top_sim(

    );
    
    reg reset;
    reg clock;
    reg [15:0] in;
    reg [31:0] configData;
    reg in_valid;
    reg config_valid;
    wire [3:0] out;
    wire out_valid;
    reg [15:0] in_mem [783:0];
    reg [7:0] fileName[11:0];
    reg [4:0] neuronNum;
    reg [1:0] layerNum;
    reg configType;
    
    nn_top dut(
    .rst(reset),
    .clk(clock),
    .config_in(configData),
    .config_valid(config_valid),
    .config_type(configType),
    .config_layer_num(layerNum),
    .config_neuron_num(neuronNum),
    .x1_in(in),
    .x1_valid(in_valid),
    .out_valid(out_valid),
    .out(out));
    
    function [7:0] to_ascii;
      input integer a;
      begin
        to_ascii = a+48;
      end
    endfunction
    
    task configWeights();
    integer i,j,k,t;
    integer neuronNo_int;
    reg [15:0] config_mem [783:0];
    begin
        @(posedge clock);
        config_valid <= 0;
        for(k=1;k<=`numLayers;k=k+1)
        begin
            for(j=0;j<`numNeurons;j=j+1)
            begin
                neuronNo_int = j;
                fileName[0] = "t";
                fileName[1] = "x";
                fileName[2] = "t";
                fileName[3] = ".";
                fileName[4] = 48;
                fileName[5] = 48;
                i=0;
                while(neuronNo_int != 0)
                begin
                    fileName[i+4] = to_ascii(neuronNo_int%10);
                    neuronNo_int = neuronNo_int/10;
                    i=i+1;
                end 
                fileName[6] = "_";
                fileName[7] = to_ascii(k);
                fileName[8] = "6";
                fileName[9] = "1";
                $readmemb(fileName, config_mem);
                for (t=0; t <784; t=t+1) begin
                    @(posedge clock);
                    configData <= {15'd0,config_mem[t]};
                    config_valid <= 1;
                    configType <= 0;
                    neuronNum <= j;
                    layerNum <= k;
                    @(posedge clock);
                    config_valid <= 0;
                end 
            end
        end
    end
    endtask
    
    task configBias();
    integer i,j,k,t;
    integer neuronNo_int;
    reg [31:0] bias[0:0];
    begin
        @(posedge clock);
        config_valid <= 0;
        for(k=1;k<=`numLayers;k=k+1)
        begin
            for(j=0;j<`numNeurons;j=j+1)
            begin
                neuronNo_int = j;
                fileName[0] = "t";
                fileName[1] = "x";
                fileName[2] = "t";
                fileName[3] = ".";
                fileName[4] = 48;
                fileName[5] = 48;
                i=0;
                while(neuronNo_int != 0)
                begin
                    fileName[i+4] = to_ascii(neuronNo_int%10);
                    neuronNo_int = neuronNo_int/10;
                    i=i+1;
                end 
                fileName[6] = "_";
                fileName[7] = to_ascii(k);
                fileName[8] = "_";
                fileName[9] = "6";
                fileName[10] = "1";
                fileName[11] = "b";
                $readmemb(fileName, bias);
                @(posedge clock);
                configData <= bias[0];
                config_valid <= 1;
                configType <= 1;
                neuronNum <= j;
                layerNum <= k;
                @(posedge clock);
                config_valid <= 0;
            end
        end
    end
    endtask
    
    
    task sendData();
    input [25*7:0] fileName;
    integer t;
    begin
        $readmemb(fileName, in_mem);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        for (t=0; t <784; t=t+1) begin
            @(posedge clock);
            in <= in_mem[t];
            in_valid <= 1;
        end 
        @(posedge clock);
        in_valid <= 0;
    end
    endtask
    
    
    always
        #1.7 clock = ~clock;

        
    initial
    begin
        clock = 1'b0;
    end
   
    integer i,layerNo=1;
    integer start;
   
    initial
    begin
        reset = 1;
        #100;
        reset = 0;
        #100
        start = $time;
        configWeights();
        configBias();
        $display("Configuration completed",,,,$time-start,,"ns");
        start = $time;
        sendData("validation_data_0.txt");
        @(posedge out_valid);
        $display("Total execution time",,,,$time-start,,"ns");
        $display("Detected number is %d",out);
        start = $time;
        sendData("validation_data_2.txt");
        @(posedge out_valid);
        $display("Detected number is %d",out);
        $display("Total execution time",,,,$time-start,,"ns");
        $stop;
    end


endmodule
