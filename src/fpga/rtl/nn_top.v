`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2019 20:57:54
// Design Name: 
// Module Name: top_layer
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


module nn_top(
        input clk,
        input rst,
        input [31:0] config_in,
        input config_valid,
        input config_type,//0-weight, 1-bias
        input [1:0] config_layer_num,
        input [4:0] config_neuron_num,
        input [15:0] x1_in,
        input  x1_valid,
        output out_valid,
        output [3:0] out
    );
    
    wire [29:0] o1_valid;
    wire [479:0] x1_out;
    wire [29:0] o2_valid;
    wire [479:0] x2_out;
    
    Layer #(.NN(30),.numWeight(784),.layerNum(1)) l1 (
            .config_in(config_in),
            .config_valid(config_valid),
            .config_type(config_type),
            .config_layer_num(config_layer_num),
            .config_neuron_num(config_neuron_num),
            .x_valid({30{x1_valid}}),
            .x_in({30{x1_in}}),
            .clk(clk),
            .rst(rst),
            .o_valid(o1_valid),
            .x_out(x1_out) 
    );
    
    reg [479:0] holdData;
    reg [15:0] firstOutput;
    reg firstValid;
    
    
        localparam IDLE = 'd0,
               Sent = 'd1,
               Wait = 'd2,
               DELAYS = 'd3;
               
    reg [1:0] state;
    reg [9:0] count;
    reg [2:0] delay;
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            state <= IDLE;
            count <= 0;
            firstValid <=0;
            delay <= 0;          
        end
        else
        begin
            case(state)
                IDLE: begin
                    count <= 0;
                    firstValid <=0;
                    delay <=0;
                    if (o1_valid == {30{1'b1}})
                    begin
                        holdData <= x1_out;
                        state <= Sent;
                    end
                    else 
                    begin
                        holdData <= holdData;
                        state <= IDLE;
                    end
                end
                Sent: begin
                    firstOutput <= holdData[15:0];
                    count <= count +1;
                    firstValid <= 1;
                    state <= Wait;
                    delay <=0;
                end
                Wait: begin
                    firstValid <= 0;
                    holdData <= holdData>>16;
                    delay <= delay +1;
                    if (count == 30)
                    begin
                        state <= IDLE;
                    end
                    else
                    begin
                        state <= DELAYS;
                    end
                    end
               DELAYS: begin
                    delay <= delay +1;
                    if (delay > 4)
                    begin
                        state <= Sent;
                    end
                    else 
                        state <= DELAYS;
                    end
           endcase
    end
    end
    
 

    
    Layer #(.NN(30),.numWeight(30),.layerNum(2)) l2 (
            .clk(clk),
            .rst(rst),
            .config_in(config_in),
            .config_valid(config_valid),
            .config_type(config_type),
            .config_layer_num(config_layer_num),
            .config_neuron_num(config_neuron_num),
            .x_valid({30{firstValid}}),
            .x_in({30{firstOutput}}),
            .o_valid(o2_valid),
            .x_out(x2_out) 
    );
    
    
    
    reg [479:0] holdDataTwo;
    reg [15:0] secondOutput;
    reg secondValid;
    
    
        localparam IDLEtwo = 'd0,
               SentTwo = 'd1,
               WaitTwo = 'd2,
               DELAYStwo = 'd3;
               
    reg [1:0] stateTwo;
    reg [9:0] countTwo;
    reg [2:0] delayTwo;
    
    always @(posedge clk)
    begin
        if(rst)
        begin
            stateTwo <= IDLEtwo;
            countTwo <= 0;
            secondValid <=0;          
        end
        else
        begin
            case(stateTwo)
                IDLEtwo: begin
                    countTwo <= 0;
                    secondValid <=0;
                    delayTwo <=0;
                    if (o2_valid == {30{1'b1}})
                    begin
                        holdDataTwo <= x2_out;
                        stateTwo <= SentTwo;
                    end
                    else 
                    begin
                        holdDataTwo <= holdDataTwo;
                        stateTwo <= IDLEtwo;
                    end
                end
                SentTwo: begin
                    secondOutput <= holdDataTwo[15:0];
                    countTwo <= countTwo +1;
                    secondValid <= 1;
                    stateTwo <= WaitTwo;
                    delayTwo <= 0;
                end
                WaitTwo: begin
                    secondValid <= 0;
                    holdDataTwo <= holdDataTwo>>16;
                    delayTwo <= delayTwo+1;
                    if (countTwo == 30)
                    begin
                        stateTwo <= IDLEtwo;
                    end
                    else
                    begin
                        stateTwo <= DELAYStwo;
                    end
                    end
               DELAYStwo: begin
                         delayTwo <= delayTwo +1;
                         if (delayTwo > 4)
                         begin
                             stateTwo <= Sent;
                         end
                         else 
                             stateTwo <= DELAYStwo;
                    end
           endcase
    end
    end

    wire [159:0] l3out;
    wire l3dataValid;
    
    Layer #(.NN(10),.numWeight(30),.layerNum(3)) l3 (
            .clk(clk),
            .rst(rst),
            .config_in(config_in),
            .config_valid(config_valid),
            .config_type(config_type),
            .config_layer_num(config_layer_num),
            .config_neuron_num(config_neuron_num),
            .x_valid({10{secondValid}}),
            .x_in({10{secondOutput}}),
            .o_valid(l3dataValid),
            .x_out(l3out) 
    ); 
    
    maxFinder mFind(
        .i_clk(clk),
        .i_data(l3out),
        .i_valid(l3dataValid),
        .o_data(out),
        .o_data_valid(out_valid)
    );
    
    
    
    
    
endmodule
