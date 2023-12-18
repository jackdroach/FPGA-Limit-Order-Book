`timescale 1 ps / 1 ps

module tb;

	reg[7:0] step_val;
	
	task step();
	begin
		$write("%d: ", step_val);
		step_val = step_val + 1;
	end
	endtask

	reg clk;
	reg rst;
	reg start;
	reg side;
	reg [15:0]limit;
	
	wire [15:0]volume;
	wire done;
	
	parameter simdelay = 20;
	parameter clock_delay = 5;
	
	GetVolumeAtLimit DUT(
	clk,
	rst,
	start,
	side,
	limit,
	volume,
	done
	);
		
	initial
	begin
		
		#(simdelay) clk = 1'b0; rst = 1'b0;
		#(simdelay) rst = 1'b1;
		
		#(simdelay) side = 1'b0; limit = 16'b1; start = 1'b1;
		#(simdelay) start = 1'b0; // start the algorithm				
						
		#100; // let simulation finish
	
	end

/* this checks done every clock and when it goes high ends the simulation */
	always @(clk)
	begin
		if (done == 1'b1)
		begin
			$write("DONE"); $write("Volume: %d Done: %d\n", volume, done);
			$stop;
		end
		else
		begin
			step(); $write("Volume: %d Done: %d\n", volume, done);
		end
	end

//	reg clk;
//	reg rst;
//	reg start;
//	reg [15:0]id;
//	
//	wire success;
//	wire done;
//	
//	parameter simdelay = 20;
//	parameter clock_delay = 5;
//	
//	DeleteOrder DUT(
//	clk,
//	rst,
//	start,
//	id,
//	success,
//	done
//	);
//		
//	initial
//	begin
//		
//		#(simdelay) clk = 1'b0; rst = 1'b0;
//		#(simdelay) rst = 1'b1;
//		
//		#(simdelay) id = 16'b1; start = 1'b1;
//		#(simdelay) start = 1'b0; // start the algorithm				
//						
//		#100; // let simulation finish
//	
//	end
//
///* this checks done every clock and when it goes high ends the simulation */
//	always @(clk)
//	begin
//		if (done == 1'b1)
//		begin
//			$write("DONE"); $write("Success: %d Done: %d\n", success, done);
//			$stop;
//		end
//		else
//		begin
//			step(); $write("Success: %d Done: %d\n", success, done);
//		end
//	end

//	reg clk;
//	reg rst;
//	reg en;
//	reg display;
//	wire [6:0]seg7_dig4;
//	wire [6:0]seg7_dig3;
//	wire [6:0]seg7_dig2;
//	wire [6:0]seg7_dig1;
//	wire [6:0]seg7_dig0;
//	
//	parameter simdelay = 20;
//	parameter clock_delay = 5;
//	
//	ParseMessage DUT(
//	clk,
//	rst,
//	en,
//	display,
//	seg7_dig4,
//	seg7_dig3,
//	seg7_dig2,
//	seg7_dig1,
//	seg7_dig0);
//		
//	initial
//	begin
//		
//		#(simdelay) clk = 1'b0; rst = 1'b0; display = 1'b0;
//		#(simdelay) rst = 1'b1;
//		
//		#(simdelay) en = 1'b1;
//		#(simdelay) en = 1'b0; // start the algorithm				
//						
//		#100; // let simulation finish
//	
//	end
//
///* this checks done every clock and when it goes high ends the simulation */
//	always @(clk)
//	begin
//		if (seg7_dig0 != 1'b0)
//		begin
//			display = !display; display = !display; $write("Out: %d\n", seg7_dig0);
//		end
//		else
//		begin
//			step(); $write("Out: %d\n", seg7_dig0);
//	end
//	end
	
//	reg clk;
//	reg rst;
//	reg start;
//	reg side;
//	reg [15:0]id;
//	reg [15:0]size;
//	reg [15:0]limit;
//	wire success;
//	wire done;
//	
//	parameter simdelay = 20;
//	parameter clock_delay = 5;
//	
//	AddOrder DUT(
//	clk,
//	rst,
//	start,
//	side,
//	id,
//	size,
//	limit,
//	success,
//	done
//	);
//		
//	initial
//	begin
//		
//		#(simdelay) clk = 1'b0; rst = 1'b0;
//		#(simdelay) rst = 1'b1;
//		
//		#(simdelay) side = 1'b0; id = 16'b1; size = 16'b1; limit = 16'b1; start = 1'b1;
//		#(simdelay) start = 1'b0; // start the algorithm				
//						
//		#100; // let simulation finish
//	
//	end

///* this checks done every clock and when it goes high ends the simulation */
//	always @(clk)
//	begin
//		if (done == 1'b1)
//		begin
//			$write("DONE "); $write("%d %d\n", success, done);
//			$stop;
//		end
//		else
//		begin
//			step(); $write("%d %d\n", success, done);
//		end
//	end
	
	// this generates a clock
	always
	begin
		#(clock_delay) clk = !clk;
	end
	
	// this makes the simulation go for 1000 steps
	initial
		#1000 $stop;

endmodule

