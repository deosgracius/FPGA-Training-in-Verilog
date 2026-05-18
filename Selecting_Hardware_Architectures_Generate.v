module adder #(
    parameter Use_CARRY_LOOKAHEAD =1,
    parameter WIDTH = 8

)(
    input [WIDTH-1:0] a,b,
    input carry_in,
    output [WIDTH-1:0] sum,
    output cout

); 
    generate 
        if(Use_CARRY_LOOKAHEAD) begin: fast_adder
            // Implement carry lookahead adder
            wire [WIDTH-1:0] generate, propagate;
            wire [WIDTH:0] carry;

            assign carry[0] = carry_in;

            for (genvar i=0; i<WIDTH; i=i+1) begin: gen_loop
                assign generate[i] = a[i] & b[i];
                assign propagate[i] = a[i] ^ b[i];
                assign carry[i+1] = generate[i] | (propagate[i] & carry[i]);
                assign sum[i] = propagate[i] ^ carry[i];
            end

            assign cout = carry[WIDTH];
        end 
        else begin: simple_adder
            // Implement ripple carry adder
            reg [WIDTH-1:0] sum_reg;
            reg cout_reg;
            always @(*) begin
                {cout_reg, sum_reg} = a + b + carry_in;
            end
            assign sum = sum_reg;
            assign cout = cout_reg;
        end
    endgenerate

endmodule