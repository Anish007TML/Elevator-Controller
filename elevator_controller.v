module elevator_controller(
       request_floor, //It represents the floor from where request is generated
       in_current_floor, //It  represents the initial floor
       clk,
       reset,
       complete, //'1' represents the elevator reaches the request floor and also represent pause,i.e, stay unmoved at the out_current_floor when over_time or weight_alert is on     
       direction, //'1' represents moving up and vice versa
       over_time, //It indicates the time for which the door will be open
       over_weight, //It indicates the limit of the weight in the elevator
       weight_alert, //'1' represents the elevator is overload
       door_alert, //'1' represents waiting time is longer than over_time
       out_current_floor //It is a variable that will be used in the shift register and it shows the current floor elevator is present
       );

//input pins
input [7:0] request_floor,in_current_floor;
input clk, reset, over_time, over_weight;

//output pins
output direction, complete, door_alert, weight_alert;
output [7:0] out_current_floor;

//register parameters
reg r_direction; // It is a 1 bit register connected to the output direction to store it
reg r_complete;  // It is connected to the output complete
reg r_door_alert; // It is connected to the output door_alert
reg r_weight_alert; // It is connected to the output weight_alert
reg [7:0] r_out_current_floor;  // It is connected to the output out_current_floor

reg clk_trigger; //used to enable movement

//match pins and registers
assign direction = r_direction;
assign complete = r_complete;
assign door_alert = r_door_alert;
assign weight_alert = r_weight_alert;
assign out_current_floor = r_out_current_floor;

//initialization
always @ (negedge reset) 
begin
    clk_trigger = 1'b0;
    
    r_complete = 1'b0;   
    r_door_alert = 1'b0;
    r_weight_alert = 1'b0;
end

// in the case if there is a request floor
always @ (request_floor) //It will run only when it receives request
begin 
    // trigger the clock
    clk_trigger = 1;
    // r_out_current_floor will be keep updating whenever it reach the next floor, while the in_current_floor stay at the initial floor 
    r_out_current_floor <= in_current_floor; 
end

always @ (posedge clk) 
begin
    // case 1: the normal running case of the elevator
    if (!reset && !over_time && !over_weight) 
    begin
        // If the request_floor is greater than r_out_current_floor the elevator will move up
        if (request_floor > r_out_current_floor)  
        begin
            r_direction = 1'b1;
            r_out_current_floor <= r_out_current_floor << 1;
        end
        // If the request_floor is smaller than r_out_current_floor the elevator will move down
        else if (request_floor < r_out_current_floor) 
        begin
            r_direction = 1'b0;
            r_out_current_floor = r_out_current_floor >> 1;
        end
        // If the request_floor is equal to r_out_current_floor ,i.e., it reach the request floor, and the r_complete is on and elevator stop moving
        else if (request_floor == r_out_current_floor) 
        begin
            r_complete = 1;
            r_direction = 0;
        end
    end
    
    //case 2: the door keep open for more than 3 minutes
    else if (!reset && over_time) 
    begin
        r_door_alert = 1;
        r_weight_alert = 0;
        r_complete = 1;
        r_direction = 0;
        r_out_current_floor <= r_out_current_floor;
    end 
    // the door alert ring and the elevator will stop moving when it is over time

    //case 3: the total weight in the elevator is more than 4500 lbs
    else if (!reset && over_weight) 
    begin
        r_door_alert = 0;
        r_weight_alert = 1;
        r_complete = 1;
        r_direction = 0;
        r_out_current_floor <= r_out_current_floor;
    end
    // the weight alert ring and the elevator will stop moving when it is over load
end

endmodule
