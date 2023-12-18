module ExecuteOrder(input clk, input rst, input start, input [15:0]id, output reg [15:0]success, output reg done);

wire [47:0]buy_order;
wire [47:0]sell_order;

reg [47:0]new_buy_order;
reg [47:0]new_sell_order;
reg write_buy_order;
reg write_sell_order;

reg [2:0]S;
reg [2:0]NS;
reg [11:0]i;

parameter IDLE = 3'b000, SELECT_SIDE = 3'b001, QUERY_BUY = 3'b010, QUERY_SELL = 3'b011, DELAY_BUY = 3'b100, DELAY_SELL = 3'b101, DONE = 3'b110;

reg [15:0] MAX_BOOK_SIZE = 16'd10; //16'd4096;

buy_orders_ram buy_orders(i, clk, new_buy_order, write_buy_order, buy_order);
sell_orders_ram sell_orders(i, clk, new_sell_order, write_sell_order, sell_order);

// FSM transitions 
always @(*)
begin
	case (S)
		IDLE: 
		begin
			if (start == 1'b1)
				NS = QUERY_BUY;
			else
				NS = IDLE;
		end
		//SELECT_SIDE: NS = (side == 1'b0) ? QUERY_BUY : QUERY_SELL;
		QUERY_BUY: NS = (i < MAX_BOOK_SIZE && buy_order != 48'b0 && success != 16'b1) ? DELAY_BUY : QUERY_SELL; // No side is given in the message so chain the states and query both sides
		DELAY_BUY: NS = QUERY_BUY;
		QUERY_SELL: NS = (i < MAX_BOOK_SIZE && sell_order != 48'b0 && success != 16'b1) ? DELAY_SELL : DONE;
		DELAY_SELL: NS = QUERY_SELL;
		DONE: NS = (start == 1'b0)? IDLE : DONE;
	endcase
end

// FSM logic
always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		new_buy_order <= 48'd18446744073709551615; // Value of a deleted RAM word
		new_sell_order <= 48'd18446744073709551615;
		write_buy_order <= 1'b0;
		write_sell_order <= 1'b0;
		
		i <= 12'b0;
		
		success <= 16'b0;
		done <= 1'b0;
	end
	else
		case (S)
			IDLE:
			begin
				i <= 12'b0;
				success <= 16'b0;
				done <= 1'b0;
			end
			QUERY_BUY:
			begin
				if (buy_order[47:32] == id && buy_order != 48'd18446744073709551615) // Don't query deleted RAM words
				begin
					write_buy_order <= 1'b1;
					success <= 16'b1;
				end
				i <= i + 12'b1;
			end
			QUERY_SELL:
			begin
				if (sell_order[47:32] == id && sell_order != 48'd18446744073709551615)
				begin
					write_sell_order <= 1'b1;
					success <= 16'b1;	
				end
				i <= i + 12'b1;
			end
			DONE: done <= 1'b1;
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
