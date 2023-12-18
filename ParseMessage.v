module ParseMessage(input clk, input rst, input display, input [2:0]type, input side, input [15:0]id, input [15:0]size, input [15:0]limit, output [6:0]seg7_dig4, output [6:0]seg7_dig3, output [6:0]seg7_dig2, output [6:0]seg7_dig1, output [6:0]seg7_dig0);

reg [15:0]out;

reg start_add;
reg start_execute;
reg start_cancel;
reg start_delete;
reg start_best_limit;
reg start_volume_at_limit;

wire [15:0]out_add;
wire [15:0]out_execute;
wire [15:0]out_cancel;
wire [15:0]out_delete;
wire [15:0]out_best_limit;
wire [15:0]out_volume_at_limit;

wire done_add;
wire done_execute;
wire done_cancel;
wire done_delete;
wire done_best_limit;
wire done_volume_at_limit;

reg [2:0]S;
reg [2:0]NS;
//reg [63:0]i;

parameter IDLE = 3'd0, HANDLE_MESSAGE = 3'd1, AWAIT_RESPONSE = 3'd2, DISPLAY = 3'd3, DISPLAY_2 = 3'd4;

AddOrder lob_add_order(clk, rst, start_add, side, id, size, limit, out_add, done_add);
ExecuteOrder lob_execute_orer(clk, rst, start_execute, id, out_execute, done_execute);
CancelOrder lob_cancel_order(clk, rst, start_cancel, id, size, out_cancel, done_cancel);
DeleteOrder lob_delete_order(clk, rst, start_delete, id, out_delete, done_delete);
GetBestLimit lob_get_best_limit(clk, rst, start_best_limit, side, out_best_limit, done_best_limit);
GetVolumeAtLimit lob_get_volume_at_limit(clk, rst, start_volume_at_limit, side, limit, out_volume_at_limit, done_volume_at_limit);

four_decimal_vals segment_display(out, seg7_dig4, seg7_dig3, seg7_dig2, seg7_dig1, seg7_dig0);

// FSM transitions
always @(*)
begin
	case (S)
		IDLE:
		begin
			if (display == 1'b1)
				NS = HANDLE_MESSAGE;
			else
				NS = IDLE;
		end
		HANDLE_MESSAGE: NS = DISPLAY;
		//AWAIT_RESPONSE: NS = (i < 64'd50000) ? DISPLAY : AWAIT_RESPONSE;
		DISPLAY: NS = (out == 16'b0) ? DISPLAY : DISPLAY_2;
		DISPLAY_2: NS = (display == 1'b0) ? IDLE : DISPLAY_2;
	endcase
end

// FSM logic
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		out <= 16'b0000000000000000;
		
		start_add <= 1'b0;
		start_execute <= 1'b0;
		start_cancel <= 1'b0;
		start_delete <= 1'b0;
		start_best_limit <= 1'b0;
		start_volume_at_limit <= 1'b0;
	end
	else
		case (S)
			IDLE: out <= 16'b0000000000000000;
			HANDLE_MESSAGE:
			begin
				out <= 16'b0000000000000000;
				case (type)
					3'b000: start_add <= 1'b1;
					3'b001: start_execute <= 1'b1;
					3'b010: start_cancel <= 1'b1;
					3'b011: start_delete <= 1'b1;
					3'b100: start_best_limit <= 1'b1;
					3'b101: start_volume_at_limit <= 1'b1;
				endcase
			end
			//AWAIT_RESPONSE: i <= i + 64'b1;
			DISPLAY:
			begin
				if (start_add == 1'b1 && done_add == 1'b1)
				begin
					out <= out_add;
					start_add <= 1'b0;
				end
				if (start_execute == 1'b1 && done_execute == 1'b1)
				begin
					out <= out_execute;
					start_execute <= 1'b0;
				end
				if (start_cancel == 1'b1 && done_cancel == 1'b1)
				begin
					out <= out_cancel;
					start_cancel <= 1'b0;
				end
				if (start_delete == 1'b1 && done_delete == 1'b1)
				begin
					out <= out_delete;
					start_delete <= 1'b0;
				end
				if (start_best_limit == 1'b1 && done_best_limit == 1'b1)
				begin
					out <= out_best_limit;
					start_best_limit <= 1'b0;
				end
				if (start_volume_at_limit == 1'b1 && done_volume_at_limit == 1'b1)
				begin
					out <= out_volume_at_limit;
					start_volume_at_limit <= 1'b0;
				end
			end
	endcase
end

// FSM init, set next state
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		S <= IDLE;
	end
	else
	begin
		S <= NS;
	end
end
	
endmodule
