module TopModule(
	input wire clk, reset,
    	input wire a,b, 
    	//output [7:0] counter //To be used for simulation
	output [7:0] sseg,
    	output [3:0]an
    );
	 
	 wire increment;
	 wire decrement;
	 wire sw0; 
	 wire sw1;
	 wire [7:0] counter;
	  
                 //The Next 2 lines for simulation Only
	 //ParkingFinal PF (.a(a),.b(b),.clk(clk),.reset(reset),.increment(increment),.decrement(decrement));
	// Counter CNT (.clk(clk),.reset(reset),.increment(increment),.decrement(decrement),.q(counter));


	 db_fsm DB1 (.sw(a),.db(sw0),.clk(clk),.reset(reset));
	 db_fsm DB2 (.sw(b),.db(sw1),.clk(clk),.reset(reset));
   	 ParkingFinal PF (.a(sw0),.b(sw1),.clk(clk),.reset(reset),.increment(increment),.decrement(decrement));
	 counter CNT (.clk(clk),.reset(reset),.inc(increment),.dec(decrement),.occupancy(counter));
	 MultiplexingCircuit hex(.sseg(sseg), .an(an) , .clk(clk), .reset(reset), .dp_in(0) ,.hex3(counter[7:4]), .hex2(counter[3:0]),.hex1(0),.hex0(0));
endmodule   