`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:08:27 03/02/2018 
// Design Name: 
// Module Name:    ParkingFinal 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module ParkingFinal(
    input a,
    input b,
    input clk,
    input reset,
    output reg increment,
    output reg decrement
    );

 localparam [2:0]
			idle = 3'b000,
			s1 = 3'b001,
			s2 = 3'b010,
			s3 = 3'b011,
			s4 = 3'b100,
			s5 = 3'b101,
			s6 = 3'b110,
			invalid =3'b111;
			//Internal Registers as Temp variabls
			reg[2:0] state_reg,state_next;
			initial begin
			state_reg = 0;			//Initializing state_reg to zero
			state_next = 0;
			end
				// STATE_REGESTER
			always@(posedge clk, posedge reset)
				begin
				if (reset)
					state_reg <= idle;
				else
					state_reg <= state_next;
				end
				
				//NEXT_STATE LOGIC AND OUTPUT
				
				always@*
				begin
					increment <= 0 ; // default value for inc going to the clock is 0 unless triggered
					decrement <= 0 ; // default value for dec going to the clock is 0 unless triggered
					
					case(state_reg)
		         //initial state 
						idle:
							if(a&~b) // car entering
								state_next <= s1;
							else if (~a&b) //care exiting
								state_next <= s4;
							else if (~a&~b) //No car
								state_next<=idle;
			// if both sensors are triggered at the same time without having a car entring or leaving
			// Impossible to happen but it's for the safety of the system.
							else if (a&b) 
								state_next <= invalid;
						s1:
							if(a&b) // a car half way through entring the parking structure.
								state_next <= s2;
							else if(~a&~b) // if a car enters and then back off 
								state_next <= idle;
							else if (a&~b) // car enters but not moving or moving slowly 
								state_next<=s1;
						s2:
							if(~a&b) // car is alomost entering
								state_next <= s3;
							else if(a&~b)
								state_next <= s1; // backing off!!
							else if(a&b)
								state_next <= s2; //not moving!!
						s3:
							if(~a&~b) // car entered!!
								begin
									increment <= 1; // incrementing the number of cars in the parking structure.
									state_next <= idle; // starting all over again
								end
							else if(a&b)	// the car is backing off and it is in the middle 
								state_next <= s2;
							else if (~a&b) // the car not moving.!!
								state_next <= s3;
						
						s4:
							if(a&b) // the car is half way through leving 
								state_next <= s5;
							else if(~a&~b) // the car is backing off and going back the parking structure!!
								state_next <= idle;
							else if (~a&b) // The car not maving!! it triggered sensor b and stopped moving
								state_next <= s4;
						s5:
							if(a&~b) // The car is almost leaving the parking structure
								state_next <= s6;
							else if(~a&b) //The car is backing off!!
								state_next <= s4;
							else if (a&b) // The car is half way through leaving but stopped moving
								state_next <= s5;
								
						s6:
							if(~a&~b) // the car left the parking structure!!
							begin
								decrement <= 1 ;
								state_next<=idle;
							end
							else if(a&b) // going back to the parking structure
								state_next <= s5;
							else if(a&~b) // The car is triggering sensor "a" on the way leaving the parking 
							             //but did not leave.Stopped!!
								state_next <= s6;						
								invalid:
							state_next<=idle;
					endcase
				end
		 endmodule
