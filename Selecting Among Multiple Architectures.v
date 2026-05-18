/* Example 2 — Generate Case: Selecting Among Multiple Architectures
The Core Concept: When if/else Isn't Enough
Generate if handles two choices. But real design often has three or more architectural options with very different trade-off profiles. Generate case extends the same idea to N options — evaluated against a parameter value, one branch becomes hardware, the rest are discarded.
The Hardware Concept: Why Do Multipliers Have Styles?
Multiplication is far more expensive than addition. For two N-bit numbers, the naive approach:
     1 0 1 1    (A = 11)
  ×  0 1 1 0    (B = 6)
  ----------
     0 0 0 0    ← A × B[0] (B[0]=0, so all zeros)
     1 0 1 1 ←  ← A × B[1] (B[1]=1, shift left 1)
     1 0 1 1 ←← ← A × B[2] (B[2]=1, shift left 2)
     0 0 0 0 ←←← ← A × B[3] (B[3]=0, shift left 3)
  ----------
  0 1 0 0 0 1 0 = 66  ← sum all partial products
Each row is called a partial product. You need N partial products for N-bit multiplication, and then you need to add them all together. The three styles attack this differently:
ARRAY MULTIPLIER
  - Compute ALL N partial products simultaneously in parallel hardware
  - Add them all up using a tree of adders
  - Fast: O(log N) delay from the adder tree
  - Expensive: O(N²) gates — area grows with the square of bit width
  - Good for: fixed-function DSP blocks, FPGAs, signal processing

BOOTH ENCODING
  - Mathematical trick: encode B in a way that reduces partial product COUNT
  - Radix-2 Booth: looks at pairs of bits, can replace partial products
    with subtraction (sometimes negative partial products are cheaper)
  - Fewer partial products = smaller adder tree = less area + less power
  - Good for: signed multiplication, power-sensitive designs, ASICs

SHIFT-AND-ADD
  - Hardware equivalent of long multiplication done sequentially
  - One partial product per clock cycle
  - Takes N clock cycles to complete
  - Tiny area: one adder and one shift register
  - Good for: area-critical designs where latency is acceptable
                   SPEED ←————————————————→ AREA
                   
  BOOTH       [████████░░░░░░]   balanced trade-off
  ARRAY       [██████████████]   fastest, largest
  SHIFT-ADD   [░░░░░░░░░░░░░░]   slowest, smallest

  */

module multiplier #(
    parameter Style = "BOOTH",
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a, b,
    output [2*WIDTH-1:0] product
);
    generate
        case (Style)
            "ARRAY": begin: array_mult
                // Implement array multiplier architecture
                // Compute all partial products in parallel and sum them
                wire [WIDTH-1:0] partial_products [WIDTH-1:0];
                wire [2*WIDTH-1:0] sums [WIDTH-1:0];

                genvar i, j;
                for (i=0; i<WIDTH; i=i+1) begin: row_loop
                    for (j=0; j<WIDTH; j=j+1) begin: col_loop
                        assign partial_products[i][j] = a[j] & b[i];
                    end
                    // Sum the partial products for this row (shifted by i)
                    assign sums[i] = {partial_products[i], i'b0} << i;
                end

                // Final product is the sum of all rows
                reg [2*WIDTH-1:0] product_reg;
                integer k;
                always @(*) begin
                    product_reg = 0;
                    for (k=0; k<WIDTH; k=k+1) begin
                        product_reg = product_reg + sums[k];
                    end
                end
                assign product = product_reg;
            end

            "BOOTH": begin: booth_mult
                // Implement Booth encoding multiplier architecture
                // This is a more complex implementation that would involve encoding B and generating fewer partial products.
                // For simplicity, we will not implement the full Booth algorithm here, but it would involve similar generate loops to create the necessary hardware.
            end

            "SHIFT-ADD": begin: shift_add_mult
                // Implement shift-and-add multiplier architecture
                reg [2*WIDTH-1:0] product_reg;
                reg [WIDTH-1:0] multiplicand;
                reg [WIDTH-1:0] multiplier;
                integer i;

                always @(*) begin
                    product_reg = 0;
                    multiplicand = a;
                    multiplier = b;

                    for (i=0; i<WIDTH; i=i+1) begin
                        if (multiplier[0]) begin
                            product_reg = product_reg + multiplicand;
                        end
                        multiplicand = multiplicand << 1; // Shift left multiplicand
                        multiplier = multiplier >> 1;       // Shift right multiplier
                    end
                end

                assign product = product_reg
            end
            default: begin
                // Default case if an unsupported style is selected
                assign product = 0;
            end
        endcase
    endgenerate 
endmodule

