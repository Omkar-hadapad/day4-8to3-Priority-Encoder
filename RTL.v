//======================================================
// DAY 4 - 8-to-3 PRIORITY ENCODER
// Priority: I7 > I6 > I5 > I4 > I3 > I2 > I1 > I0
//======================================================


//======================================================
// 1. BASIC GATES
//======================================================

module not_gate (
    input A,
    output Y
);

assign Y = ~A;

endmodule


module and_gate (
    input A,
    input B,
    output Y
);

assign Y = A & B;

endmodule


module or_gate (
    input A,
    input B,
    output Y
);

assign Y = A | B;

endmodule



//======================================================
// 2. 2-TO-1 PRIORITY ENCODER
//======================================================
// I1 has higher priority than I0.
//
// If I1 = 1 -> Y = 1
// Else if I0 = 1 -> Y = 0
// Else -> invalid
//======================================================

module priority_encoder_2to1 (
    input I1,
    input I0,

    output Y,
    output VALID
);

assign Y     = I1;
assign VALID = I1 | I0;

endmodule



//======================================================
// 3. 4-TO-2 PRIORITY ENCODER
//======================================================
// Priority:
// I3 > I2 > I1 > I0
//======================================================

module priority_encoder_4to2 (
    input  I3,
    input  I2,
    input  I1,
    input  I0,

    output [1:0] Y,
    output VALID
);

assign Y[1] = I3 | I2;

assign Y[0] =
          I3
        | (~I2 & I1);

assign VALID = I3 | I2 | I1 | I0;

endmodule



//======================================================
// 4. 8-TO-3 PRIORITY ENCODER - STRUCTURAL
//======================================================
// Priority:
// I7 > I6 > I5 > I4 > I3 > I2 > I1 > I0
//
// Upper group:
// I7,I6,I5,I4
//
// Lower group:
// I3,I2,I1,I0
//======================================================

module priority_encoder_8to3 (
    input  I7,
    input  I6,
    input  I5,
    input  I4,
    input  I3,
    input  I2,
    input  I1,
    input  I0,

    output [2:0] Y,
    output VALID
);

wire [1:0] upper_y;
wire [1:0] lower_y;

wire upper_valid;
wire lower_valid;


// Upper 4 inputs

priority_encoder_4to2 UPPER (
    .I3(I7),
    .I2(I6),
    .I1(I5),
    .I0(I4),

    .Y(upper_y),
    .VALID(upper_valid)
);


// Lower 4 inputs

priority_encoder_4to2 LOWER (
    .I3(I3),
    .I2(I2),
    .I1(I1),
    .I0(I0),

    .Y(lower_y),
    .VALID(lower_valid)
);


// If upper group has an active input,
// it gets priority.

assign Y[2] = upper_valid;

assign Y[1] =
        upper_valid ? upper_y[1] : lower_y[1];

assign Y[0] =
        upper_valid ? upper_y[0] : lower_y[0];

assign VALID = upper_valid | lower_valid;

endmodule



//======================================================
// 5. 8-TO-3 PRIORITY ENCODER - BEHAVIORAL RTL
//======================================================

module priority_encoder_8to3_rtl (
    input  [7:0] I,

    output reg [2:0] Y,
    output reg VALID
);

always @(*)
begin

    // Default values

    Y     = 3'b000;
    VALID = 1'b0;


    // Highest priority first

    if (I[7])
    begin
        Y     = 3'b111;
        VALID = 1'b1;
    end

    else if (I[6])
    begin
        Y     = 3'b110;
        VALID = 1'b1;
    end

    else if (I[5])
    begin
        Y     = 3'b101;
        VALID = 1'b1;
    end

    else if (I[4])
    begin
        Y     = 3'b100;
        VALID = 1'b1;
    end

    else if (I[3])
    begin
        Y     = 3'b011;
        VALID = 1'b1;
    end

    else if (I[2])
    begin
        Y     = 3'b010;
        VALID = 1'b1;
    end

    else if (I[1])
    begin
        Y     = 3'b001;
        VALID = 1'b1;
    end

    else if (I[0])
    begin
        Y     = 3'b000;
        VALID = 1'b1;
    end

end

endmodule



//======================================================
// 6. TOP MODULE
//======================================================

module priority_encoder_8to3_top (
    input  [7:0] I,

    output [2:0] Y_structural,
    output        VALID_structural,

    output [2:0] Y_rtl,
    output        VALID_rtl
);

priority_encoder_8to3 STRUCTURAL (
    .I7(I[7]),
    .I6(I[6]),
    .I5(I[5]),
    .I4(I[4]),
    .I3(I[3]),
    .I2(I[2]),
    .I1(I[1]),
    .I0(I[0]),

    .Y(Y_structural),
    .VALID(VALID_structural)
);


priority_encoder_8to3_rtl RTL (
    .I(I),

    .Y(Y_rtl),
    .VALID(VALID_rtl)
);

endmodule
