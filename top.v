module pullup(output wire pin, output wire d_in);
  SB_IO #(.PIN_TYPE(6'b1), .PULLUP(1'b1)) io(.PACKAGE_PIN(pin), .D_IN_0(d_in));
endmodule


module top(input wire CLK,
           output wire LED, output wire PIN_1, output wire PIN_2,
           output wire PIN_3, output wire PIN_4, output wire PIN_5,
           output wire PIN_6, output wire PIN_7, output wire PIN_8,
           output wire PIN_9, output wire PIN_10, output wire PIN_11,
           output wire PIN_12, output wire PIN_22, output wire PIN_21,
           output wire PIN_20, output wire PIN_19,
           input wire PIN_18, input wire PIN_17,
           input wire PIN_16, input wire PIN_15,
           );

  reg [18:0] counter_60hz, counter_next;
  wire [3:0] row_pins;
  wire [3:0] column_pins;
  wire [15:0] keys;
  wire tick_60hz = counter_60hz == 0;
  wire [3:0] temp_hex_val = 4'h7;
  wire [7:0] sseg_pins;

  parameter clk_freq = 16_000_000;
  parameter clk_divider_60hz = clk_freq / 60;
  parameter clk_divider_next = clk_freq / 500;

  always @(posedge CLK) begin
      counter_60hz <= counter_60hz + 1;
      if (counter_60hz == clk_divider_60hz)
        counter_60hz <= 0;
        counter_next <= counter_next + 1;
      if (counter_next == clk_divider_next)
        counter_next <= 0;
  end

  assign LED = ~keys[3];

  assign column_pins = {PIN_19, PIN_20, PIN_21, PIN_22};
  assign sseg_pins = {PIN_5, PIN_6, PIN_7, PIN_8,
                      PIN_9, PIN_10, PIN_11, PIN_12};

  //temp to control which pin to display
  assign PIN_3 = 1'b0;
  assign PIN_2 = 1'b0;
  assign PIN_1 = 1'b0;
  assign PIN_4 = 1'b1;

  pullup io1(PIN_18, row_pins[0]);
  pullup io2(PIN_17, row_pins[1]);
  pullup io3(PIN_16, row_pins[2]);
  pullup io4(PIN_15, row_pins[3]);

  keypad k(CLK, column_pins, row_pins, keys);
  hex_to_sseg sseg_unit(.CLK(CLK), .keyin(keys), .sseg(sseg_pins));

endmodule
