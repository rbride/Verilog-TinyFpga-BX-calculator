module keykeep(
      input wire CLK, input wire CLK_60HZ,
      output reg [3:0] column_pins, input wire [3:0] row_pins,
      output reg [15:0] user_input,
      );

  wire [15:0] keypad_read;
  wire [15:0] conv;
  //Initialize the Keypad module under the Key Press Keeper module
  keypad k(CLK, column_pins, row_pins, keypad_read);

  initial begin
    user_input = 0;
  end

  always @(posedge CLK) begin
      user_input <= keypad_read;
  end

endmodule
