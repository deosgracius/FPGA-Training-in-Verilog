module and_array(
    input [3:0] a,
    input [3:0] b,
    output [3:0] y
);
    genvar i;
    generate
        for(i=0, i<4; i=i+1) begin and_loop
            assign y[i] = a[i] & b[i];
        end             
    endgenerate 
endmodule