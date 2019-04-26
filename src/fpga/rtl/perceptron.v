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
    input [15:0] myinput,
    input [15:0] myweights,
    input myweightValid,
    input myinputValid,
    input clk,
    input rst,
    output reg [15:0] out,
    output reg outvalid   
    );
    
    reg [1:0] i;
    reg wen;
    reg ren;
    reg [9:0] w_addr;
    reg [9:0] r_addr;
    reg [15:0] w_in;
    wire [15:0] w_out;
    reg [30:0] mul; 
    reg [31:0] sum;
    reg [9:0] rdCounter;
    wire [31:0] biasOut;
    
    bias #(.neuronNo(neuronNo),.layerNo(layerNo)) b1(
        .b(biasOut));
  
  //Instantiation of Memory for Weights
   Weight_Memory #(.numWeight(numWeight),.neuronNo(neuronNo),.layerNo(layerNo)) W1(
   .clk(clk),
   .wen(wen),
   .ren(ren),
   .wadd(w_addr),
   .radd(r_addr),
   .win(w_in),
   .wout(w_out));
   
   //Loading weight values into the momory
  /* always @(posedge clk)
   begin
         if(rst)
         begin
             w_addr <= 3;
             i <= 0;
             wen <=0;
         end
         else if(myweightValid)
         begin
            w_in <= myweights;
            w_addr <= w_addr + 1;
            wen <= 1;
         end
         else
            wen <= 0;
   end*/
    
    wire sign;
    wire [31:0] muxOut;
    wire [32:0] comboAdd;
    wire [32:0] BiasAdd;
    
    assign comboAdd = muxOut+ sum;
    assign BiasAdd = biasOut + sum;
    //Instantiation of twoscomplementer
    twosComplementer t1(
    .clk(clk),
    .sign(sign),
    .i_multOut(mul[30:0]),
    .muxOut(muxOut)
    );
    
    wire [15:0] sig_out;
    
    //Instantiation of ROM for sigmoid
    Sig_ROM s1(
    .clk(clk),
    .x(sum[31:22]),
    .out(sig_out)
    );
    
    localparam IDLE = 'd0,
               WAIT = 'd1,
               MULT = 'd2,
               ADD = 'd3,
               OUT = 'd4,
               WAIT1 = 'd5,
               WAIT2 = 'd6;
               
    reg [2:0] state;
    
    assign sign = w_out[15];
    
    //Computation for perceptron
    always @(posedge clk)
    begin
        if(rst)
        begin
            state <= IDLE;
            rdCounter <= 0;
            r_addr <= 0;
            ren <= 0;
            out <= 0;
            sum <= 0;
            outvalid <= 0;
            mul <= 0;
        end
        else
        begin
            case(state)
                IDLE:begin
                    outvalid <= 0;
                    out <= 0;
                    if(myinputValid)
                    begin
                        ren <= 1;  
                        state <= WAIT;
                    end
                end
               WAIT:begin
                    state <= MULT;
                    ren <= 0;
                    r_addr <= r_addr + 1;
                    rdCounter <= rdCounter+1;
                end
                MULT:begin
                    //outvalid <= 0;
                    mul <= myinput * w_out[14:0];
                    state <= WAIT1;
                end
                WAIT1:begin
                     state <= ADD;//MULT;
                     //rdCounter <= rdCounter+1;
                 end
                ADD:begin
                    //sum <= $signed(muxOut)+ $signed(sum); 
                    if(!muxOut[31] & !sum[31] & comboAdd[31])
                    begin
                         sum <= 32'h7FFFFFFF;
                    end
                    else if(muxOut[31] & sum[31] & !comboAdd[31])
                         sum <= 32'h80000000;
                    else
                         sum <= comboAdd[31:0]; 
                    if(rdCounter == numWeight)
                        begin
                            state <= WAIT2;
                            if(!biasOut[31] &!sum[31] & BiasAdd[31])
                                    sum <= 32'h7FFFFFFF;
                             else if(biasOut[31] & sum[31] &  !BiasAdd[31])
                                    sum <= 32'h80000000;
                             else
                                    sum <= BiasAdd[31:0]; 
                        end
                    else state <= IDLE;
                    end
                WAIT2:begin
                    state <= OUT;
                    rdCounter <= 0;
                end
                OUT:begin
                        sum <= 0;
                        out <= sig_out;
                        r_addr <=0;
                        outvalid <= 1;
                        state <= IDLE;
                    end
            endcase      
        end   
    end    
    
    `ifdef DEBUG
    always @(posedge clk)
    begin
        if(outvalid)
            $display(neuronNo,,,,"%b",out);
    end
    `endif
endmodule
