//======================================================
// DAY 4 TESTBENCH
// 8-TO-3 PRIORITY ENCODER
//======================================================

module day4_tb;

reg [7:0] I;

wire [2:0] Y_structural;
wire       VALID_structural;

wire [2:0] Y_rtl;
wire       VALID_rtl;


//======================================================
// DUT
//======================================================

priority_encoder_8to3_top DUT (

    .I(I),

    .Y_structural(Y_structural),
    .VALID_structural(VALID_structural),

    .Y_rtl(Y_rtl),
    .VALID_rtl(VALID_rtl)

);


//======================================================
// EXPECTED VALUE
//======================================================

reg [2:0] expected_Y;
reg       expected_VALID;

integer i;
integer error_count;


//======================================================
// CALCULATE EXPECTED RESULT
//======================================================

task calculate_expected;

begin

    expected_Y     = 3'b000;
    expected_VALID = 1'b0;

    if (I[7])
    begin
        expected_Y     = 3'b111;
        expected_VALID = 1'b1;
    end

    else if (I[6])
    begin
        expected_Y     = 3'b110;
        expected_VALID = 1'b1;
    end

    else if (I[5])
    begin
        expected_Y     = 3'b101;
        expected_VALID = 1'b1;
    end

    else if (I[4])
    begin
        expected_Y     = 3'b100;
        expected_VALID = 1'b1;
    end

    else if (I[3])
    begin
        expected_Y     = 3'b011;
        expected_VALID = 1'b1;
    end

    else if (I[2])
    begin
        expected_Y     = 3'b010;
        expected_VALID = 1'b1;
    end

    else if (I[1])
    begin
        expected_Y     = 3'b001;
        expected_VALID = 1'b1;
    end

    else if (I[0])
    begin
        expected_Y     = 3'b000;
        expected_VALID = 1'b1;
    end

end

endtask



//======================================================
// TEST
//======================================================

initial
begin

    error_count = 0;

    $display("==========================================");
    $display("DAY 4 - 8-to-3 PRIORITY ENCODER");
    $display("==========================================");


    // Test all 256 input combinations

    for (i = 0; i < 256; i = i + 1)
    begin

        I = i;

        #1;

        calculate_expected;

        // Check structural design

        if ((Y_structural !== expected_Y) ||
            (VALID_structural !== expected_VALID))
        begin

            $display(
                "STRUCTURAL ERROR: I=%b Expected Y=%b V=%b Got Y=%b V=%b",
                I,
                expected_Y,
                expected_VALID,
                Y_structural,
                VALID_structural
            );

            error_count = error_count + 1;

        end


        // Check RTL design

        if ((Y_rtl !== expected_Y) ||
            (VALID_rtl !== expected_VALID))
        begin

            $display(
                "RTL ERROR: I=%b Expected Y=%b V=%b Got Y=%b V=%b",
                I,
                expected_Y,
                expected_VALID,
                Y_rtl,
                VALID_rtl
            );

            error_count = error_count + 1;

        end


        // Structural and RTL must match

        if ((Y_structural !== Y_rtl) ||
            (VALID_structural !== VALID_rtl))
        begin

            $display(
                "MISMATCH: I=%b Structural=%b/%b RTL=%b/%b",
                I,
                Y_structural,
                VALID_structural,
                Y_rtl,
                VALID_rtl
            );

            error_count = error_count + 1;

        end

    end


    //==================================================
    // FINAL RESULT
    //==================================================

    if (error_count == 0)
    begin
        $display("");
        $display("ALL TESTS PASSED");
        $display("Total input combinations tested = 256");
    end

    else
    begin
        $display("");
        $display("TEST FAILED");
        $display("Total errors = %0d", error_count);
    end


    $finish;

end



//======================================================
// WAVEFORM
//======================================================

initial
begin

    $dumpfile("day4.vcd");
    $dumpvars(0, day4_tb);

end

endmodule
