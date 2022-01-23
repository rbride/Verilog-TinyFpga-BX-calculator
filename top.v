module pullup(output wire pin, output wire d_in);
  SB_IO #(.PIN_TYPE(6'b1), .PULLUP(1'b1)) io(.PACKAGE_PIN(pin), .D_IN_0(d_in));
endmodule

module top(input wire CLK, output wire LED,
           output wire PIN_1, output wire PIN_2,
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
  wire [3:0] control_pins;
  wire [15:0] keyout;
  wire tick_60hz = counter_60hz == 0;
  wire [3:0] temp_hex_val = 4'h7;
  wire [7:0] sseg_pins;
  wire [63:0] digits;
  wire [15:0] toseg;
  wire insig = sss == 0;
  reg [3:0] counttwohz = 0;
  wire tick_2hz;

  initial begin
    digits = {16'h2000, 16'h2000, 16'h2000, 16'h2000};
  end


   /*Generate 60hz and 2hz clock */
  always @(posedge CLK) begin
      counter_60hz <= counter_60hz + 1;
      if (counter_60hz == clk_divider_60hz)
        counter_60hz <= 0;
        counter_next <= counter_next + 1;
      if (counter_next == clk_divider_next)
        counter_next <= 0;
  end
  always @ ( posedge tick_60hz) begin
      if (counttwohz == 0) begin
          tick_2hz <= ~tick_2hz;
          counttwohz <= 15;
      end else begin
          counttwohz <= counttwohz - 1;
      end
  end

  parameter clk_freq = 16_000_000;
  parameter clk_divider_60hz = clk_freq / 60;
  parameter clk_divider_60hz = clk_freq / 120;
  parameter clk_divider_next = clk_freq / 500;

  wire [15:0] digit_one;
  wire [15:0] digit_two;
  wire [15:0] digit_three;
  wire [15:0] digit_four;

  always @(posedge tick_2hz) begin
      if ( |keyout[15:0] != 1'b1) begin
          sss <= 1;
      end else begin
          sss <= 0;
      end
  end

  integer i = 0;
  always @( posedge tick_60hz) begin
    if (i == 0) begin
      control_pins = 4'b1000;
      toseg[15:0] <=  digits[15:0];
      i = i + 1;
    end
    else if (i == 1) begin
      control_pins =  4'b0100;
      toseg[15:0] <=  digits[31:16];
      i = i + 1;
    end
    else if (i == 2) begin
      control_pins =  4'b0010;
      toseg[15:0] <=  digits[47:32];
      i = i + 1;
    end
    else if (i == 3) begin
      control_pins = 4'b0001;
      toseg[15:0] <=  digits[63:48];
      i = 0;
    end
  end

  /* State Machine to Store digits */
  reg [3:0] index = 4'b0001;
  always @( posedge insig ) begin
      index <= {index[0], index[3:1]};
      if (index == 4'b1000) begin
        digits[15:0] <= keyout;
      end
      if (index == 4'b0100) begin
        digits[31:16] <= keyout;
      end
      if (index == 4'b0010) begin
        digits[47:32] <= keyout;
      end
      else begin
        digits[63:48] <= keyout;
      end
  end

  pullup io1(PIN_18, row_pins[0]);
  pullup io2(PIN_17, row_pins[1]);
  pullup io3(PIN_16, row_pins[2]);
  pullup io4(PIN_15, row_pins[3]);
  assign column_pins = {PIN_19, PIN_20, PIN_21, PIN_22};
  assign sseg_pins = {PIN_5, PIN_6, PIN_7, PIN_8,
                      PIN_9, PIN_10, PIN_11, PIN_12};
  assign control_pins = {PIN_4, PIN_3, PIN_2, PIN_1};

  hex_to_sseg sseg_unit(.CLK(CLK), .keyin(toseg), .sseg(sseg_pins));
  keykeep keeper(.CLK(CLK), .CLK_60HZ(tick_60hz),
       .user_input(keyout), .column_pins(column_pins), .row_pins(row_pins));

endmodule