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


module top_sim(

    );
    
    reg reset;
    reg clock;
    reg [15:0] in;
    reg in_valid;
    wire [159:0] out;
    wire [9:0] out_valid;
    reg [9:0] t;
    
    nn_top dut(
        .rst(reset),
        .clk(clock),
        .x1_in(in),
        .x1_valid(in_valid),
        .out_valid(out_valid),
        .out(out));
        
    
    reg [15:0] in_mem [783:0];
 
    
    always
        #1.7 clock = ~clock;
        
        
    initial
        begin
            clock = 1'b0;
        end
   
     initial
        begin
            $readmemb("validation_data.txt", in_mem);
            reset = 1;
            #100
            reset = 0;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            for (t=0; t <784; t=t+1) begin
                in <= in_mem[t];
                in_valid <= 1;
                @(posedge clock);
                in_valid <= 0;
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
                @(posedge clock);
            end 
        end
        
        integer maxOut=0;
        integer maxIndex=0;
        integer i;
        initial
        begin
            @(posedge out_valid[0]);
            for(i=0;i<10;i=i+1)
            begin
                //$display("%0x",out[i*16+:16]);
                if(out[i*16+:16] > maxOut)
                begin
                    maxIndex = i;
                    maxOut = out[i*16+:16];
                end
            end
            $display("Total execution time",,,,$time,,"ns");
            $display("Detected number is %d",maxIndex);
            $stop;
        end
    
endmodule
