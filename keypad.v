module keypad(input wire clk,
              output reg [3:0]  column_pins,
              input wire [3:0]  row_pins,
              output reg [15:0]  keys);

  reg [1:0] column = 0;

  initial begin
    column_pins = 4'b1110;
    keys = 0;
  end

  integer i;

  always @(posedge clk) begin
    for (i = 0; i < 4; i++)
      /*if row_pins[i] == 0 set keys[i+column] == 1
      **else set keys[i+column] == 0    */
      keys[i*4 + column] <= (row_pins[i] == 0);

    /*After the for loop is run, column increases by one
    **if column = 3 it resets to 0      */
    column <= (column + 1) % 4;
    /*move which column pin is set to 0 each clock tick*/
    column_pins <= (column_pins << 1) + (column_pins >> 3);

  end
endmodule
