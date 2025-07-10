# Elevator-Controller
This project is designed for an eight floor elevator controller of an integrated circuit that can be used as part of elevator controller. The elevator decides moving direction by comparing request floor with current floor. In a condition that the weight has to be less than required amount of weight and door has to be closed in required amount of time. If the weight is larger than it, the elevator will alert automatically. The Door Alert signal is normally low but goes high whenever the door has been open for more than the required amount of time. There is a sensor at each floor to sense whether the elevator has passed the current floor. This sensor provides the signal that encodes the floor that has been passed.  
The core parts of the design are shift register, three cases of elevator and the while loop when receive Request Floor. 

Design Strategy 

In the coding part, we used several strategies to make the program works. 
First, we defined the input and output current floor as in_current_floor and our_current_floor to avoid same variable name as output and input.  
Second, we add two more input pins - over_time and over_weight in the code. These signals will be output from the sensor to the controller. When the controller receives signal from weight alert or door alert, the complete will become one so that the elevator will stay unmoved at the out_current_floor.   
Third, define the out_current_floor, direction, complete, door_alert and weight_alert as reg then assign them equal to the output. Therefore, those variables will run as a register and output. 
Next, when the reset is off the variable complete, door_alert and weight_alert will be initialized to be zero. Similary, when the request_floor is on, the variable in_current_floor is set to be equal to out_current_floor only once.  
Then, in_current_floor stay the same, out_current_floor keep updating and compare with request_floor, until out_current_floor is at the same level as request_floor. 
Lastly, define three cases of if statement for the elevator. There are cases for normal running cases – (comparing between request_floor and out_current_floor to decide the moving direction), overtime (turn on the door_alert) and overweight cases for elevator - (turn on the weight_alert). 
