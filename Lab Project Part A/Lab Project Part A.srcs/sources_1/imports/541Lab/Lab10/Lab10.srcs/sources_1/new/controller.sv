//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/30/2015 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

// These are non-R-type, so check op code
`define LW     6'b 100011
`define SW     6'b 101011
`define ADDI   6'b 001000
`define SLTI   6'b 001010
`define ORI    6'b 001101
`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011
`define LUI    6'b 001111

// These are all R-type, i.e., op=0, so check the func field
`define ADD    6'b 100000
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SLLV    6'b 000100
`define SRL    6'b 000010
`define SRA    6'b 000011
`define JR     6'b 001000  


module controller(
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output logic [1:0] pcsel,
   output logic [1:0] wasel, 
   output logic sext,
   output logic bsel,
   output logic [1:0] wdsel, 
   output logic [4:0] alufn,
   output logic wr,
   output logic werf, 
   output logic [1:0] asel
   ); 

  assign pcsel = ((op == 6'b000000) && (func == `JR)) ? 2'b11 :   // controls 4-way multiplexor
              (op == `J || op == `JAL) ? 2'b10 : 
              (((op == `BEQ) && (Z == 1'b1)) || ((op == `BNE) && (Z == 1'b0))) ? 2'b01 : 2'b00;

  logic [9:0] controls;
  assign {werf, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, wr} = controls[9:0];

  always_comb
     case(op)                                     // non-R-type instructions
       `LW: controls <= 10'b 1_10_01_00_1_1_0;     // LW
       `SW: controls <= 10'b 0_xx_xx_00_1_1_1;                        // SW
       `ADDI: controls <= 10'b 1_01_01_00_1_1_0;                                     // ADDI
       `SLTI: controls <= 10'b 1_01_01_00_1_1_0;     // SLTI
       `ORI: controls <= 10'b 1_01_01_00_1_1_0;  
       `LUI: controls <= 10'b 1_01_01_10_1_1_0;
       `BEQ: controls <= 10'b 0_xx_xx_00_0_1_0;
       `BNE: controls <= 10'b 0_xx_xx_00_0_1_0;
       `J: controls <= 10'b 0_xx_xx_xx_x_x_0;
       `JAL: controls <= 10'b 1_00_10_xx_x_x_0;
      6'b000000:                                    
         case(func)                              // R-type
             `ADD: controls <= 10'b 1_01_00_00_0_x_0; // ADD
             `SUB: controls <= 10'b 1_01_00_00_0_x_0; // SUB
             `AND: controls <= 10'b 1_01_00_00_0_x_0;
             `NOR: controls <= 10'b 1_01_00_00_0_x_0;
             `OR: controls <= 10'b 1_01_00_00_0_x_0;
             `XOR: controls <= 10'b 1_01_00_00_0_x_0;
             `SLT: controls <= 10'b 1_01_00_00_0_x_0;
             `SLTU: controls <= 10'b 1_01_00_00_0_x_0;
             `SLL: controls <= 10'b 1_01_00_01_0_x_0;
             `SLLV: controls <= 10'b 1_01_00_00_0_x_0;
             `SRL: controls <= 10'b 1_01_00_01_0_x_0;
             `SRA: controls <= 10'b 1_01_00_01_0_x_0;
             `JR: controls <= 10'b 0_xx_xx_xx_x_x_0;
            default:   controls <= 10'b0000000000; // unknown instruction, turn off register and memory writes
         endcase
      default: controls <= 10'b0000000000; // unknown instruction, turn off register and memory writes
    endcase
    

  always_comb
    case(op)                        // non-R-type instructions
      `LW: alufn <= 5'b0xx01;
      `SW: alufn <= 5'b0xx01;
      `ADDI: alufn <= 5'b0xx01;      // ADDI
      `SLTI: alufn <= 5'b1x011;      // SLTI                                      // ADDI
      `ORI: alufn <= 5'bx0100;  
      `LUI: alufn <= 5'bx0010;
      `BEQ: alufn <= 5'b1xx01;
      `BNE: alufn <= 5'b1xx01;
      6'b000000:                      
         case(func)                 // R-type
             `ADD: alufn <= 5'b0xx01; // ADD
             `SUB: alufn <= 5'b1xx01; // SUB
             `AND: alufn <= 5'bx0000;
             `NOR: alufn <= 5'bx1100;
             `OR: alufn <= 5'bx0100;
             `XOR: alufn <= 5'bx1000;
             `SLT: alufn <= 5'b1x011;
             `SLTU: alufn <= 5'b1x111;
             `SLL: alufn <= 5'bx0010;
             `SLLV: alufn <= 5'bx0010;
             `SRL: alufn <= 5'bx1010;
             `SRA: alufn <= 5'bx1110;
             `JR: alufn <= 5'bxxxxx;
            default:   alufn <= 5'bxxxxx; // ???
         endcase
      default: alufn <= 5'b00000;          // J, JAL
    endcase
    
endmodule