//module LimitOrderBook(input clk, input rst, input [2:0]type, input start, input side, input [15:0]id, input [15:0]size, input [15:0]limit, output reg [15:0]out, output reg busy);
//
//reg start_add;
//reg start_execute;
//reg start_cancel;
//reg start_delete;
//reg start_best_limit;
//reg start_volume_at_limit;
//
//wire [15:0]out_add;
//wire [15:0]out_execute;
//wire [15:0]out_cancel;
//wire [15:0]out_delete;
//wire [15:0]out_best_limit;
//wire [15:0]out_volume_at_limit;
//
//wire done_add;
//wire done_execute;
//wire done_cancel;
//wire done_delete;
//wire done_best_limit;
//wire done_volume_at_limit;
//
//reg [2:0]S;
//reg [2:0]NS;
//reg [11:0]i;
//
//parameter IDLE = 3'b000, BUSY = 3'b001, HANDLE_MESSAGE = 3'b010, WAIT_DONE = 3'b011, DONE = 3'b100;
//
//AddOrder lob_add_order(clk, rst, start_add, side, id, size, limit, out_add, done_add);
//
//ExecuteOrder lob_execute_orer(clk, rst, start_execute, id, out_execute, done_execute);
//CancelOrder lob_cancel_order(clk, rst, start_cancel, id, size, out_cancel, done_cancel);
//DeleteOrder lob_delete_order(clk, rst, start_delete, id, out_delete, done_delete);
//
//GetBestLimit lob_get_best_limit(clk, rst, start_best_limit, side, out_best_limit, done_best_limit);
//GetVolumeAtLimit lob_get_volume_at_limit(clk, rst, start_volume_at_limit, side, limit, out_volume_at_limit, done_volume_at_limit);
//
//// FSM transitions
//always @(*)
//begin
//	case (S)
//		IDLE: 
//		begin
//			if (start == 1'b1)
//				NS = BUSY;
//			else
//				NS = IDLE;
//		end
//		BUSY: NS = HANDLE_MESSAGE;
//		HANDLE_MESSAGE: NS = WAIT_DONE;
//		WAIT_DONE: NS = (done_add == 1'b0 && done_execute == 1'b0 && done_cancel == 1'b0 && done_delete == 1'b0 && done_best_limit == 1'b0 && done_volume_at_limit == 1'b0) ? WAIT_DONE : DONE;
//		DONE: NS = IDLE;
//	endcase
//end
//
//// FSM logic
//always @(posedge clk or negedge rst)
//begin
//	if (rst == 1'b0)
//	begin
//		busy <= 1'b0;
//		
//		start_add <= 1'b0;
//		start_execute <= 1'b0;
//		start_cancel <= 1'b0;
//		start_delete <= 1'b0;
//		start_best_limit <= 1'b0;
//		start_volume_at_limit <= 1'b0;
//	end
//	else
//		case (S)
//			IDLE:
//			begin
//				start_add <= 1'b0;
//				start_execute <= 1'b0;
//				start_cancel <= 1'b0;
//				start_delete <= 1'b0;
//				start_best_limit <= 1'b0;
//				start_volume_at_limit <= 1'b0;
//			end
//			BUSY: busy <= 1'b1;
//			HANDLE_MESSAGE:
//			begin
//				$write("Module: LimitOrderBook State: HANDLE_MESSAGE Busy: 1\n");
//				$write("Module: LimitOrderBook State: HANDLE_MESSAGE Type: %d\n", type);
//				case (type)
//					3'b000: start_add <= 1'b1;
//					3'b001: start_execute <= 1'b1;
//					3'b010: start_cancel <= 1'b1;
//					3'b011: start_delete <= 1'b1;
//					
//					3'b100: start_best_limit <= 1'b1;
//					3'b101: start_volume_at_limit <= 1'b1;
//				endcase
//			end
//			WAIT_DONE:
//			begin
//				case (type)
//					3'b000: start_add <= 1'b0;
//					3'b001: start_execute <= 1'b0;
//					3'b010: start_cancel <= 1'b0;
//					3'b011: start_delete <= 1'b0;
//					
//					3'b100: start_best_limit <= 1'b0;
//					3'b101: start_volume_at_limit <= 1'b0;
//				endcase
//			end
//			DONE:
//			begin
//				if (done_add == 1'b1)
//					out <= out_add;
//					
//				if (done_execute == 1'b1)
//					out <= out_execute;
//					
//				if (done_cancel == 1'b1)
//					out <= out_cancel;
//					
//				if (done_delete == 1'b1)
//					out <= out_delete;
//					
//				if (done_best_limit == 1'b1)
//					out <= out_best_limit;
//					
//				if (done_volume_at_limit == 1'b1)
//					out <= out_volume_at_limit;
//				
//				busy <= 1'b0;
//			end
//	endcase
//end
//
//// FSM init, set next state
//always @(posedge clk or negedge rst)
//begin
//	if (rst == 1'b0)
//	begin
//		S <= IDLE;
//	end
//	else
//	begin
//		S <= NS;
//	end
//end
//	
//endmodule

module LimitOrderBook(input clk, input rst, input [2:0]type, input start, input side, input [15:0]id, input [15:0]size, input [15:0]limit, output reg [15:0]out, output reg busy);

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
reg [11:0]i;

parameter IDLE = 3'b000, BUSY = 3'b001, HANDLE_MESSAGE = 3'b010, WAIT_DONE = 3'b011, DONE = 3'b100;

AddOrder lob_add_order(clk, rst, start_add, side, id, size, limit, out_add, done_add);

ExecuteOrder lob_execute_orer(clk, rst, start_execute, id, out_execute, done_execute);
CancelOrder lob_cancel_order(clk, rst, start_cancel, id, size, out_cancel, done_cancel);
DeleteOrder lob_delete_order(clk, rst, start_delete, id, out_delete, done_delete);

GetBestLimit lob_get_best_limit(clk, rst, start_best_limit, side, out_best_limit, done_best_limit);
GetVolumeAtLimit lob_get_volume_at_limit(clk, rst, start_volume_at_limit, side, limit, out_volume_at_limit, done_volume_at_limit);

// FSM transitions
always @(*)
begin
	case (S)
		IDLE: 
		begin
			if (start == 1'b1)
				NS = BUSY;
			else
				NS = IDLE;
		end
		BUSY: NS = HANDLE_MESSAGE;
		HANDLE_MESSAGE: NS = WAIT_DONE;
		WAIT_DONE: NS = (done_add == 1'b0 && done_execute == 1'b0 && done_cancel == 1'b0 && done_delete == 1'b0 && done_best_limit == 1'b0 && done_volume_at_limit == 1'b0) ? WAIT_DONE : DONE;
		DONE: NS = IDLE;
	endcase
end

// FSM logic
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		busy <= 1'b0;
		
		start_add <= 1'b0;
		start_execute <= 1'b0;
		start_cancel <= 1'b0;
		start_delete <= 1'b0;
		start_best_limit <= 1'b0;
		start_volume_at_limit <= 1'b0;
	end
	else
		case (S)
			IDLE:
			begin
				start_add <= 1'b0;
				start_execute <= 1'b0;
				start_cancel <= 1'b0;
				start_delete <= 1'b0;
				start_best_limit <= 1'b0;
				start_volume_at_limit <= 1'b0;
			end
			BUSY: busy <= 1'b1;
			HANDLE_MESSAGE:
			begin
				$write("Module: LimitOrderBook State: HANDLE_MESSAGE Busy: 1\n");
				$write("Module: LimitOrderBook State: HANDLE_MESSAGE Type: %d\n", type);
				case (type)
					3'b000: start_add <= 1'b1;
					3'b001: start_execute <= 1'b1;
					3'b010: start_cancel <= 1'b1;
					3'b011: start_delete <= 1'b1;
					
					3'b100: start_best_limit <= 1'b1;
					3'b101: start_volume_at_limit <= 1'b1;
				endcase
			end
			WAIT_DONE:
			begin
				case (type)
					3'b000: start_add <= 1'b0;
					3'b001: start_execute <= 1'b0;
					3'b010: start_cancel <= 1'b0;
					3'b011: start_delete <= 1'b0;
					
					3'b100: start_best_limit <= 1'b0;
					3'b101: start_volume_at_limit <= 1'b0;
				endcase
			end
			DONE:
			begin
				if (done_add == 1'b1)
					out <= out_add;
					
				if (done_execute == 1'b1)
					out <= out_execute;
					
				if (done_cancel == 1'b1)
					out <= out_cancel;
					
				if (done_delete == 1'b1)
					out <= out_delete;
					
				if (done_best_limit == 1'b1)
					out <= out_best_limit;
					
				if (done_volume_at_limit == 1'b1)
					out <= out_volume_at_limit;
				
				busy <= 1'b0;
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
