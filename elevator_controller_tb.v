`timescale 1ns/1ns

module elevator_controller_tb;

reg [7:0] request_floor;
reg [7:0] in_current_floor;
reg clk;
reg reset;
reg over_time;
reg over_weight;

wire direction;
wire complete;
wire door_alert;
wire weight_alert;
wire [7:0] out_current_floor;

integer test_case;

elevator_controller ec(
    .request_floor(request_floor),
    .in_current_floor(in_current_floor),
    .clk(clk),
    .reset(reset),
    .direction(direction),
    .out_current_floor(out_current_floor),
    .complete(complete),
    .over_time(over_time),
    .over_weight(over_weight),
    .door_alert(door_alert),
    .weight_alert(weight_alert)
);

always #50 clk = ~clk;

task upward_movement;
    begin
      $display("Test Case 1: Normal Upward Movement");
      in_current_floor = 8'b00000010;  // Floor 1
      request_floor = 8'b00010000;     // Floor 4
      over_time = 0;
      over_weight = 0;
    end
endtask

task downward_movement;
    begin
      $display("Test Case 2: Normal Downward Movement");
      in_current_floor = 8'b00100000;  // Floor 5
      request_floor = 8'b00000100;     // Floor 2
      over_time = 0;
      over_weight = 0;
    end
endtask
  
task multiple_upward;
    begin
      $display("Test Case 3: Multiple Requests in Same Direction");
      in_current_floor = 8'b00000001;  // Floor 0
      request_floor = 8'b00000100;     // Floor 3
      #200 in_current_floor = 8'b00000100;  // Floor 3
      request_floor = 8'b01000000;   // Floor 6
      over_time = 0;
      over_weight = 0;
    end
endtask
  
task opposite_requests;
    begin
      $display("Test Case 4: Multiple Requests in Opposite Direction");
      in_current_floor = 8'b00010000;  // Floor 4
      request_floor = 8'b01000000;     // Floor 6
      #150 in_current_floor = 8'b01000000;  // Floor 6
      request_floor = 8'b00000100;     // Floor 2
    end
endtask

task over_time_active;
    begin
      $display("Test Case 5: Over Time Active");
      in_current_floor = 8'b00001000;  // Floor 3
      request_floor = 8'b01000000;     // Floor 6
      over_time = 1;
      over_weight = 0;
      #150 over_time = 0;
    end
endtask

task over_weight_active;
    begin
      $display("Test Case 6: Over Weight Active");
      in_current_floor = 8'b00100000;  // Floor 5
      request_floor = 8'b00000100;     // Floor 2
      over_time = 0;
      over_weight = 1;
      #200 over_weight = 0;
    end
endtask

task idle_then_request;
    begin
      $display("Test Case 7: Idle then Request");
      in_current_floor = 8'b00000010;  // Floor 1
      request_floor = 8'b00000000;     // No request
      #40 request_floor = 8'b00010000;     // Request at floor 4
      over_time = 0;
      over_weight = 0;
    end
endtask

task reset_during_move;
    begin
      $display("Test Case 8: Reset During Movement");
      in_current_floor = 8'b00000001;  // Floor 0
      request_floor = 8'b00010000;     // Floor 4
      over_time = 0;
      over_weight = 0;
      #30 reset = 0; 
      #200 reset = 1;
    end
  endtask

task same_floor_request;
    begin
      $display("Test Case 9: Already at requested floor");
      in_current_floor = 8'b00001000;  // Floor 3
      request_floor = 8'b00001000;     // Again Floor 3
      over_time = 0;
      over_weight = 0;
    end
endtask

task boundary_case;
    begin
      $display("Test Case 10: Boundary Case (Ground to top floor");
      in_current_floor = 8'b00000001;  // Floor 0
      request_floor = 8'b10000000;     // Floor 7
      over_time = 0;
      over_weight = 0;
    end
endtask

initial 
begin

    clk = 0;
    reset = 1;
    over_time = 0;
    over_weight = 0;
    #10 reset =0;
    
    test_case = 0;
    
    case(test_case)
    
       1: upward_movement();
       2: downward_movement();
       3: multiple_upward();
       4: opposite_requests();
       5: over_time_active();
       6: over_weight_active();
       7: idle_then_request();
       8: reset_during_move();
       9: same_floor_request();
       10: boundary_case();
       
       default: $display("Unknown Test Case : %0d", test_case);
     endcase
     
end

endmodule
