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

`define numLayers 4

module top_sim(

    );
    
    reg reset;
    reg clock;
    reg [15:0] in;
    reg in_valid;
    reg [15:0] in_mem [783:0];
    reg [7:0] fileName[11:0];
    reg s_axi_awvalid;
    reg [31:0] s_axi_awaddr;
    wire s_axi_awready;
    reg [31:0] s_axi_wdata;
    reg s_axi_wvalid;
    wire s_axi_wready;
    wire s_axi_bvalid;
    reg s_axi_bready;
    wire intr;
    reg [31:0] axiRdData;
    reg [31:0] s_axi_araddr;
    wire [31:0] s_axi_rdata;
    reg s_axi_arvalid;
    wire s_axi_arready;
    wire s_axi_rvalid;
    reg s_axi_rready;
    
    wire [31:0] numNeurons[31:1];
    wire [31:0] numWeights[31:1];
    
    assign numNeurons[1] = 30;
    assign numNeurons[2] = 30;
    assign numNeurons[3] = 10;
    assign numNeurons[4] = 10;
    
    assign numWeights[1] = 784;
    assign numWeights[2] = 30;
    assign numWeights[3] = 30;
     assign numWeights[4] = 10;
       
    nn_autoGen_top dut(
    .s_axi_aclk(clock),
    .s_axi_aresetn(reset),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awprot(0),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awready(s_axi_awready),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(4'hF),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wready(s_axi_wready),
    .s_axi_bresp(),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bready(s_axi_bready),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arprot(0),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arready(s_axi_arready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .axis_in_data(in),
    .axis_in_data_valid(in_valid),
    .axis_in_data_ready(),
    .intr(intr)
    );
    
            
    initial
    begin
        clock = 1'b0;
        s_axi_awvalid = 1'b0;
        s_axi_bready = 1'b0;
        s_axi_wvalid = 1'b0;
        s_axi_arvalid = 1'b0;
    end
        
    always
        #5 clock = ~clock;
    
    function [7:0] to_ascii;
      input integer a;
      begin
        to_ascii = a+48;
      end
    endfunction
    
    always @(posedge clock)
    begin
        s_axi_bready <= s_axi_bvalid;
        s_axi_rready <= s_axi_rvalid;
    end
    
    task writeAxi();
    input [31:0] address;
    input [31:0] data;
    begin
        @(posedge clock);
        s_axi_awvalid <= 1'b1;
        s_axi_awaddr <= address;
        s_axi_wdata <= data;
        s_axi_wvalid <= 1'b1;
        wait(s_axi_wready);
        @(posedge clock);
        s_axi_awvalid <= 1'b0;
        s_axi_wvalid <= 1'b0;
        @(posedge clock);
    end
    endtask
    
    task readAxi();
    input [31:0] address;
    begin
        @(posedge clock);
        s_axi_arvalid <= 1'b1;
        s_axi_araddr <= address;
        wait(s_axi_arready);
        @(posedge clock);
        s_axi_arvalid <= 1'b0;
        wait(s_axi_rvalid);
        @(posedge clock);
        axiRdData <= s_axi_rdata;
        @(posedge clock);
    end
    endtask
    
    task configWeights();
    integer i,j,k,t;
    integer neuronNo_int;
    reg [15:0] config_mem [783:0];
    begin
        @(posedge clock);
        for(k=1;k<=`numLayers;k=k+1)
        begin
            writeAxi(12,k);//Write layer number
            for(j=0;j<numNeurons[k];j=j+1)
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
                fileName[9] = "w";
                $readmemb(fileName, config_mem);
                writeAxi(16,j);//Write neuron number
                for (t=0; t<numWeights[k]; t=t+1) begin
                    writeAxi(0,{15'd0,config_mem[t]});
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
        for(k=1;k<=`numLayers;k=k+1)
        begin
            writeAxi(12,k);//Write layer number
            for(j=0;j<numNeurons[k];j=j+1)
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
                fileName[9] = "b";
                $readmemb(fileName, bias);
                writeAxi(16,j);//Write neuron number
                writeAxi(4,{15'd0,bias[0]});
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
   
    integer i,layerNo=1;
    integer start;
   
    initial
    begin
        reset = 0;
        in_valid = 0;
        #100;
        reset = 1;
        #100
        start = $time;
        configWeights();
        configBias();
        $display("Configuration completed",,,,$time-start,,"ns");
        start = $time;
        sendData("validation_data_0.txt");
        @(posedge intr);
        readAxi(8);
        $display("Expected number: 0 Detected number: %0x",axiRdData);
        $display("Total execution time",,,,$time-start,,"ns");
        i=0;
        repeat(10)
        begin
            readAxi(20);
            $display("Output of Neuron %d: %0x",i,axiRdData);
            i=i+1;
        end
        start = $time;
        sendData("validation_data_1.txt");
        @(posedge intr);
        readAxi(8);
        $display("Expected number: 1 Detected number: %0x",axiRdData);
        $display("Total execution time",,,,$time-start,,"ns");
        i=0;
        repeat(10)
        begin
            readAxi(20);
            $display("Output of Neuron %d: %0x",i,axiRdData);
            i=i+1;
        end
        start = $time;
        sendData("validation_data_2.txt");
        @(posedge intr);
        readAxi(8);
        $display("Expected number: 2 Detected number: %0x",axiRdData);
        $display("Total execution time",,,,$time-start,,"ns");
        $display("Neuron outputs");
        i=0;
        repeat(10)
        begin
            readAxi(20);
            $display("Output of Neuron %d: %0x",i,axiRdData);
            i=i+1;
        end
        $stop;
    end


endmodule
