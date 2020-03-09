// Hello FPGA World!
// Let's blink an LED on the DE-1-SoC Evaluation Board  
  
module HelloWorld (
    input logic CLOCK_50, // 50 MHz clock; info from board's user manual & written to the .qsf file
    output logic MY_LED   // 1st LED; info from board's user manual & written to the .qsf file
);
 
// Typdef for the finite state machine's (FSM's) state
typedef enum logic {
    LED_ON = 1'b0,
    LED_OFF  = 1'b1
} state_t;
 
// Local Params
localparam logic ON = 1'b1;
localparam logic OFF = 1'b0;
localparam logic [25:0] DURATION = '1; // (fills 26 bits with 1's) ~1.3 sec w/ 50 MHz clock

// Internal Signal Declarations
state_t state = LED_OFF;
state_t state_next;

logic [ 25:0 ] timer = DURATION;
logic [ 25:0 ] timer_next;

logic MY_LED_next;

// Implementation 
always @* 
    begin
    timer_next = timer;     
    state_next = state; 
    MY_LED_next = MY_LED;
     
    unique case ( state )
        LED_ON:
            begin   
            timer_next = timer - 1'b1;
            MY_LED_next = ON;         
   
            if ( timer == '0 )
                begin
                timer_next = DURATION;
                state_next = LED_OFF;
                end
            end
				
        LED_OFF:
            begin
            timer_next = timer - 1'b1;
            MY_LED_next = OFF;
   
            if ( timer == '0 )
                begin
                timer_next = DURATION;
                state_next = LED_ON;
                end
            end
    endcase
end // always @*

always @( posedge CLOCK_50 ) begin
    timer <= timer_next;
    state <= state_next;
    MY_LED <= MY_LED_next;
end // always @posedge
endmodule
