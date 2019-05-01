`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.02.2019 17:25:12
// Design Name: 
// Module Name: Weight_Memory
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


module Weight_Memory #(parameter numWeight = 3, neuronNo=5,layerNo=1,FileName="layer0Neuron000.txt") 
    ( 
    input clk,
    input wen,
    input ren,
    input [9:0] wadd,
    input [9:0] radd,
    input [15:0] win,
    output reg [15:0] wout);
    
    reg [15:0] mem [numWeight-1:0];
    reg [7:0] fileName[10:0];
    integer i;
    integer neuronNo_int;
    
   // synthesis translate_off
    
    /*function [7:0] to_ascii;
        input integer a;
        begin
          to_ascii = a+48;
        end
      endfunction*/
    
  /*  function [23:0] to_ascii_integer;
        input integer a;
        begin:myfunction
            integer i;
            reg [7:0] b;
            to_ascii_integer[7:0] = 48;
            to_ascii_integer[15:8] = 48;
            to_ascii_integer[23:16] = 48;
            i=0;
            while(a != 0)
            begin
                b = to_ascii(a%10);
                a = a/10;
                to_ascii_integer[8*i+:8] = b;
                i=i+1;
                $display("Value of i is %d",i);
                $display("Value of ascii int is %0x",to_ascii_integer);
                $display("Value of a %0d",a);
            end
            $display("Value of to ascii int %0x",to_ascii_integer);
        end
    endfunction*/
    
    
    /*initial
    begin
     neuronNo_int = neuronNo;
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
            //$display("Value of i is %d",i);
    end 
    fileName[6] = "_";
    fileName[7] = to_ascii(layerNo);
    fileName[8] = "6";
    fileName[9] = "1";
    $readmemb(fileName, mem);
    end*/
    
   // synthesis translate_on
    
   always @(posedge clk)
    begin
        if (wen)
        begin
            mem[wadd] <= win;
        end
        if (ren)
        begin
            wout <= mem[radd];
        end
    end 
endmodule
