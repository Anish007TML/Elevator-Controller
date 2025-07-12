# Elevator-Controller
This project is designed for an eight floor elevator controller of an integrated circuit that can be used as part of elevator controller. The elevator decides moving direction by comparing request floor with current floor. In a condition that the weight has to be less than required amount of weight and door has to be closed in required amount of time. If the weight is larger than it, the elevator will alert automatically. The Door Alert signal is normally low but goes high whenever the door has been open for more than the required amount of time. There is a sensor at each floor to sense whether the elevator has passed the current floor. This sensor provides the signal that encodes the floor that has been passed.  
The core parts of the design are shift register, three cases of elevator and the while loop when receive Request Floor. 

## Schematic Design

<img width="2342" height="1294" alt="image" src="https://github.com/user-attachments/assets/d934968e-70b5-4206-b38d-a8ee91298050" />

## FSM Logic Summary
The controller behaves based on:
1. **Request logic**: Moves up/down based on requested floor vs. current.
2. **Door alert**: If door open exceeds `over_time`, it triggers an alert.
3. **Weight alert**: If total weight exceeds `over_weight`, movement halts.
4. **Complete signal**: Indicates elevator reached its requested floor.

## Design Strategy 
In the coding part, we used several strategies to make the program works. 
First, we defined the input and output current floor as in_current_floor and our_current_floor to avoid same variable name as output and input.  
Second, we add two more input pins - over_time and over_weight in the code. These signals will be output from the sensor to the controller. When the controller receives signal from weight alert or door alert, the complete will become one so that the elevator will stay unmoved at the out_current_floor.   
Third, define the out_current_floor, direction, complete, door_alert and weight_alert as reg then assign them equal to the output. Therefore, those variables will run as a register and output. 
Next, when the reset is off the variable complete, door_alert and weight_alert will be initialized to be zero. Similary, when the request_floor is on, the variable in_current_floor is set to be equal to out_current_floor only once.  
Then, in_current_floor stay the same, out_current_floor keep updating and compare with request_floor, until out_current_floor is at the same level as request_floor. 
Lastly, define three cases of if statement for the elevator. There are cases for normal running cases – (comparing between request_floor and out_current_floor to decide the moving direction), overtime (turn on the door_alert) and overweight cases for elevator - (turn on the weight_alert). 

## Testbench Implementation
The testbench elevator_controller_tb.v is designed to validate and simulate the behavior of the elevator_controller module using realistic elevator scenarios. It features a modular structure with a test_case task and a case-based selector that runs different test scenarios sequentially. 

The test cases are :- 

| Test Case | Scenario                           |
| --------- | ---------------------------------- |
|     1     | Normal upward movement             |
|     2     | Normal downward movement           |
|     3     | Multiple requests upward           |
|     4     | Opposite direction requests        |
|     5     | Over time door open condition      |
|     6     | Overweight condition               |
|     7     | Idle - new request                 |
|     8     | Reset during movement              |
|     9     | Same floor request                 |
|     10    | Boundary test (ground to top floor)|

The testbench rigorously exercises the elevator controller across a wide range of real-world conditions to ensure functional correctness, responsiveness to abnormal events (like overweight and overtime), and proper FSM transitions. With clearly defined and reusable test cases, it provides a solid foundation for verifying and extending the system — whether for FPGA implementation, multi-elevator coordination, or advanced scheduling logic.

## **Simulation Waveforms**

Test Case 1 : Normal upward movement
<img width="2317" height="1011" alt="image" src="https://github.com/user-attachments/assets/a36ab7f5-39cc-4bba-9415-9063fff78e5e" />

Test Case 2 : Normal downward movement
<img width="2312" height="1006" alt="image" src="https://github.com/user-attachments/assets/690887a5-699a-486a-8c4d-7e0aeebc2957" />

Test Case 3 : Multiple requests upward
<img width="2312" height="1003" alt="image" src="https://github.com/user-attachments/assets/a325e2f1-2cbc-4b3a-8f2e-78f81a2a412b" />

Test Case 4 : Opposite direction requests
<img width="2325" height="984" alt="image" src="https://github.com/user-attachments/assets/53467cb9-078c-4723-8494-9d7bc8d9ab4e" />

Test Case 5 : Over time door open condition
<img width="2312" height="1001" alt="image" src="https://github.com/user-attachments/assets/13634327-5a8e-4f90-9622-6780f437883a" />

Test Case 6 : Overweight condition
<img width="2318" height="997" alt="image" src="https://github.com/user-attachments/assets/9584ad98-3e03-4b28-bf60-9235af4f7c1e" />

Test Case 7 : Idle - new request
<img width="2308" height="1000" alt="image" src="https://github.com/user-attachments/assets/85842c51-f5a2-4cb1-9cac-9015b249bba9" />

Test Case 8 : Reset during movement
<img width="2289" height="994" alt="image" src="https://github.com/user-attachments/assets/b1c5bfba-437d-4971-b6ad-34e43eef5cf6" />

Test Case 9 : Same floor request                 
<img width="2318" height="1014" alt="image" src="https://github.com/user-attachments/assets/384c7bb3-a812-48c8-9982-75134aa27d1e" />

Test Case 10 : Boundary test (ground to top floor)
<img width="2310" height="1005" alt="image" src="https://github.com/user-attachments/assets/b79f3216-3f15-47fe-917b-c68217491da0" />


## **Result**

All test cases executed successfully, confirming that the FSM-based elevator controller operates as intended. It accurately handles direction changes, floor transitions, and idle scenarios, while also responding correctly to critical conditions like door over-time and weight overload. The results validate its reliability, efficiency, and real-world applicability in elevator systems.

## **Conclusion**

For this project, we learned the basic idea of how does the normal elevators run in many cases, even though it is simplified, we still spent lots of time to design and to figure out many problems when combining all the cases, of course the most challenging and time consuming part is debugging. However, after accomplishing it, we learned many things beyond this project.
