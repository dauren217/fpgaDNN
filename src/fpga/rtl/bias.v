`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2019 05:07:53
// Design Name: 
// Module Name: bias
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


module bias #(parameter neuronNo=5,layerNo=1,FileName="layer0Neuron000.txt") (
    output [31:0] b
    );
    reg [31:0] bias[0:0];
    reg [7:0] fileName[11:0];
    integer i;
    integer neuronNo_int;
    
    //synthesis translate_off 
    
   function [7:0] to_ascii;
        input integer a;
        begin
          to_ascii = a+48;
        end
   endfunction
   
   initial
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
       fileName[8] = "_";
       fileName[9] = "6";
       fileName[10] = "1";
       fileName[11] = "b";
       $readmemb(fileName, bias);
       end
       
     //  synthesis translate_on
       
       assign b = bias[0];
    
endmodule
