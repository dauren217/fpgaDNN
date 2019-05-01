module maxFinder(
input           i_clk,
input [159:0]   i_data,
input           i_valid,
output reg [3:0]o_data,
output  reg     o_data_valid
);

reg [15:0] maxValue;
reg [159:0] inDataBuffer;
reg [3:0] counter;

always @(posedge i_clk)
begin
    o_data_valid <= 1'b0;
    if(i_valid)
    begin
        maxValue <= i_data[15:0];
        counter <= 1;
        inDataBuffer <= i_data;
        o_data <= 0;
    end
    else if(counter == 9)
    begin
        counter <= 0;
        o_data_valid <= 1'b1;
    end
    else if(counter != 0)
    begin
        counter <= counter + 1;
        if(inDataBuffer[counter*16+:16] > maxValue)
        begin
            maxValue <= inDataBuffer[counter*16+:16];
            o_data <= counter;
        end
    end
end

endmodule