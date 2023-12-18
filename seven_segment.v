module seven_segment (
	input [3:0]i,
	output reg [6:0]o
);


always @(*)
begin
	case (i)	    // abcdefg
		4'd0: o = 7'b0000001;
		4'd1: o = 7'b1001111;
		4'd2: o = 7'b0010010;
		4'd3: o = 7'b0000110;
		4'd4: o = 7'b1001100;
		4'd5: o = 7'b0100100;
		4'd6: o = 7'b0100000;
		4'd7: o = 7'b0001111;
		4'd8: o = 7'b0000000;
		4'd9: o = 7'b0001100;
	endcase
end

endmodule
