/****************keypad layout****************
**  1  2  3  a        Default State is to
**  4  5  6  b          Display Nothing
**  7  8  9  c
**  d  0  e  f
**********************************************/
module hex_to_sseg
  (
    input wire CLK,
    input wire [15:0] keyin,
    output reg [7:0] sseg
  );

  reg [15:0] hex = 16'h0 ^keyin;

  always @(*) begin
    case(hex)
      16'h1:    sseg[7:0] = 8'b11111001;  //1
      16'h2:    sseg[7:0] = 8'b10100100;  //2
      16'h4:    sseg[7:0] = 8'b10110000;  //3
      16'h10:   sseg[7:0] = 8'b10011001;  //4
      16'h20:   sseg[7:0] = 8'b10010010;  //5
      16'h40:   sseg[7:0] = 8'b10000010;  //6
      16'h100:  sseg[7:0] = 8'b11111000;  //7
      16'h200:  sseg[7:0] = 8'b10000000;  //8
      16'h400:  sseg[7:0] = 8'b10010000;  //9
      16'h2000: sseg[7:0] = 8'b11000000;  //0
      16'h8:    sseg[7:0] = 8'b10001000;  //a
      16'h80:   sseg[7:0] = 8'b10000011;  //b
      16'h800:  sseg[7:0] = 8'b11000110;  //c
      16'h1000: sseg[7:0] = 8'b10100001;  //d
      16'h4000: sseg[7:0] = 8'b10000110;  //e
      16'h8000: sseg[7:0] = 8'b10001110;  //f
      default:  sseg[7:0] = 8'b11111111;  //display nothing
    endcase
  end
endmodule
