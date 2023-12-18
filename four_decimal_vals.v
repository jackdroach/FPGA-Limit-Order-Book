module four_decimal_vals(
	input [15:0]val,
	output [6:0]seg7_dig4,
	output [6:0]seg7_dig3,
	output [6:0]seg7_dig2,
	output [6:0]seg7_dig1,
	output [6:0]seg7_dig0);

reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hun_digit;
reg [3:0] result_thu_digit;
reg [3:0] result_tth_digit;

always @(*)
begin
	result_one_digit = val % 16'd10;
	result_ten_digit = (val / 16'd10) % 16'd10;
	result_hun_digit = (val / 16'd100) % 16'd10;
	result_thu_digit = (val / 16'd1000) % 16'd10;
	result_tth_digit = (val / 16'd10000) % 16'd10;
end

seven_segment one(result_one_digit, seg7_dig0);
seven_segment ten(result_ten_digit, seg7_dig1);
seven_segment hun(result_hun_digit, seg7_dig2);
seven_segment thu(result_thu_digit, seg7_dig3);
seven_segment tth(result_tth_digit, seg7_dig4);

endmodule
