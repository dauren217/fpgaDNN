`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2018 17:11:05
// Design Name: 
// Module Name: perceptron
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


module neuron #(parameter layerNo=0,neuronNo=0,numWeight=3)(
    input           clk,
    input           rst,
    input [15:0]    myinput,
    input           myinputValid,
    input [31:0]    config_in,
    input           config_valid,
    input           config_type,//0-weight, 1-bias
    input [1:0]     config_layer_num,
    input [4:0]     config_neuron_num,
    output[15:0]    out,
    output reg      outvalid   
    );
    
    reg         wen;
    wire        ren;
    reg [9:0]   w_addr;
    reg [9:0]   r_addr;
    reg [15:0]  w_in;
    wire [15:0] w_out;
    reg [30:0]  mul; 
    reg [31:0]  sum;
    reg [31:0]  bias;
    reg         weight_valid;
    reg         mult_valid;
    reg         mux_valid;
    reg         sigValid; 
    reg         outvalid; 
    wire        sign;
    wire [31:0] muxOut;
    wire [32:0] comboAdd;
    wire [32:0] BiasAdd;
    
   //Loading weight values into the momory
    always @(posedge clk)
    begin
        if(rst)
        begin
            w_addr <= {10{1'b1}};
            wen <=0;
        end
        else if(config_valid & !config_type & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
        begin
            w_in <= config_in[15:0];
            w_addr <= w_addr + 1;
            wen <= 1;
        end
        else
            wen <= 0;
    end
    

    
    assign comboAdd = muxOut+ sum;
    assign BiasAdd = bias + sum;
    assign sign = w_out[15];
    assign ren = myinputValid;
    
    always @(posedge clk)
    begin
        if(config_valid & config_type & (config_layer_num==layerNo) & (config_neuron_num==neuronNo))
        begin
            bias <= config_in;
        end
    end
    
    
    always @(posedge clk)
    begin
        if(rst|outvalid)
            r_addr <= 0;
        else if(myinputValid)
            r_addr <= r_addr + 1;
    end
    
    always @(posedge clk)
    begin
        mul <= myinput * w_out[14:0];
    end
    
    
    always @(posedge clk)
    begin
        if(rst|outvalid)
            sum <= 0;
        else if((r_addr == numWeight) & mux_valid)
        begin
            if(!bias[31] &!sum[31] & BiasAdd[31])
                sum <= 32'h7FFFFFFF;
            else if(bias[31] & sum[31] &  !BiasAdd[31])
                sum <= 32'h80000000;
            else
                sum <= BiasAdd[31:0]; 
        end
        else if(mux_valid)
        begin
            if(!muxOut[31] & !sum[31] & comboAdd[31])
            begin
                sum <= 32'h7FFFFFFF;
            end
            else if(muxOut[31] & sum[31] & !comboAdd[31])
                sum <= 32'h80000000;
            else
                sum <= comboAdd[31:0]; 
        end
    end
    
    always @(posedge clk)
    begin
        weight_valid <= myinputValid;
        mult_valid <= weight_valid;
        mux_valid <= mult_valid;
        sigValid <= ((r_addr == numWeight) & mux_valid) ? 1'b1 : 1'b0;
        outvalid <= sigValid;
    end
    
    
    //Instantiation of Memory for Weights
    Weight_Memory #(.numWeight(numWeight),.neuronNo(neuronNo),.layerNo(layerNo)) WM(
        .clk(clk),
        .wen(wen),
        .ren(ren),
        .wadd(w_addr),
        .radd(r_addr),
        .win(w_in),
        .wout(w_out)
    );
    
    //Instantiation of twoscomplementer
    twosComplementer t1(
        .clk(clk),
        .sign(sign),
        .i_multOut(mul[30:0]),
        .muxOut(muxOut)
    );
    
    //Instantiation of ROM for sigmoid
    Sig_ROM s1(
        .clk(clk),
        .x(sum[31:22]),
        .out(out)
    );

    `ifdef DEBUG
    always @(posedge clk)
    begin
        if(outvalid)
            $display(neuronNo,,,,"%b",out);
    end
    `endif
endmodule
