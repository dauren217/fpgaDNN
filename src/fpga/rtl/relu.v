module ReLU  #(parameter dataWidth=16) (
    input           clk,
    input   [dataWidth-1:0]   x,
    output  reg [dataWidth-1:0]  out
);


always @(posedge clk)
begin
    if($signed(x) >= 0)
        out <= x;
    else 
        out <= 0;      
end

endmodule