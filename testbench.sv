`timescale 1ns/1ps
module tb_alu8;
    reg [7:0] A, B;
    reg [2:0] opcode;
    wire [7:0] result;
    wire zero, carry, overflow;
    integer passed = 0, failed = 0;

    alu8 dut(.A(A), .B(B), .opcode(opcode), .result(result),
             .zero(zero), .carry(carry), .overflow(overflow));

    task check;
        input [2:0] op;
        input [7:0] a, b, expected_result;
        input expected_zero, expected_carry, expected_overflow;
        begin
            A = a; B = b; opcode = op; #10;
            if ((result === expected_result) &&
                (zero === expected_zero) &&
                (carry === expected_carry) &&
                (overflow === expected_overflow)) begin
                $display("PASS op=%b A=%d B=%d result=%d Z=%b C=%b V=%b",
                         op,a,b,result,zero,carry,overflow);
                passed = passed + 1;
            end else begin
                $display("FAIL op=%b A=%d B=%d result=%d expected=%d Z=%b C=%b V=%b",
                         op,a,b,result,expected_result,zero,carry,overflow);
                $display("Expected flags: Z=%b C=%b V=%b",
                         expected_zero,expected_carry,expected_overflow);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0,tb_alu8);
        A=0; B=0; opcode=0; #10;
        check(3'b000,10,3,13,0,0,0);
        check(3'b001,10,3,7,0,0,0);
        check(3'b010,10,3,2,0,0,0);
        check(3'b011,10,3,11,0,0,0);
        check(3'b100,10,3,9,0,0,0);
        check(3'b101,10,3,20,0,0,0);
        check(3'b110,10,3,5,0,0,0);
        check(3'b111,10,3,10,0,0,0);
        check(3'b000,255,1,0,1,1,0);
        check(3'b001,5,5,0,1,0,0);
        check(3'b010,0,255,0,1,0,0);
        check(3'b000,127,1,128,0,0,1);
        check(3'b001,128,1,127,0,0,1);
        $display("------------------------------");
        $display("TOTAL PASSED = %0d",passed);
        $display("TOTAL FAILED = %0d",failed);
        if (failed==0) $display("ALL TESTS PASSED");
        else $display("SOME TESTS FAILED");
        $finish;
    end
endmodule
