module tb_alu;

  // Inputs
  reg [31:0] A;
  reg [31:0] B;
  reg [1:0] F;

  // Outputs
  wire [31:0] Y;
  wire Zero, Overflow, Negative, Carry;

  // Internal signals
  reg clk;

  // Simulation variables
  reg  [31:0]   vectornum, errors;
  reg  [100:0]  testvectors[10000:0];
  reg  [31:0]   ExpectedY;
  reg           ExpectedZero;
  reg           ExpectedOverflow;
  reg           ExpectedNegative;
  reg           ExpectedCarry;

  // Instantiate the Unit Under Test (UUT)
  alu32 uut (A, B, F, Y, Zero, Overflow, Negative, Carry);

  // generate clock
  always
     begin
      clk = 1; #5; clk = 0; #5;
     end

  // at start of test, load vectors
  initial
     begin
      $readmemh("teste_alu", testvectors);
      vectornum = 0; errors = 0;
     end

  // apply test vectors on rising edge of clk
  always @ (posedge clk)
  begin
    #1; {ExpectedCarry, ExpectedNegative, ExpectedOverflow, ExpectedZero, F, A, B,
         ExpectedY} = testvectors[vectornum];
    end

  // check results on falling edge of clk
  always @(negedge clk)
  begin
     if ({Y, Zero, Overflow, Negative, Carry} !==
          {ExpectedY, ExpectedZero, ExpectedOverflow, ExpectedNegative, ExpectedCarry})
       begin
           $display("Error: inputs: F = %h, A = %h, B = %h", F, A, B);
           $display("outputs: Y = %h, Zero = %b, Overflow = %b, Negative = %b, Carry = %b/n
	           (Expected Y = %h, Expected Zero = %b, Expected Overflow = %b, Expected Negative = %b, Expected Carry = %b)",
                    Y, Zero, Overflow, Negative, Carry, ExpectedY, ExpectedZero, ExpectedOverflow, ExpectedNegative, ExpectedCarry);
         errors = errors + 1;
       end
     vectornum = vectornum + 1;
     if (testvectors[vectornum] === 101'hx)
        begin
          $display("%d tests completed with %d errors", vectornum, errors);
         $finish;
       end
  end
endmodule
