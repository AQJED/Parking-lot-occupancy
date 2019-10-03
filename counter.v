
 module counter(
 
   input wire clk, reset,
 
   input wire inc, dec,
   
   output reg [7:0] occupancy
  
  );
	
	
	
reg [7:0] count = 8'b00010100;
	
	always@(posedge clk) begin

		if (reset)
		
	count <= 8'b00010100;
		
else if (inc)
			
count <= count + 1'b1;
		
else if (dec)
			
count <= count - 1'b1;

	end
	
	
always @* begin
	
	occupancy = count;
	
end
	

endmodule
