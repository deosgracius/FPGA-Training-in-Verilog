module decoder(in, W, X, Y, Z);
    input [1:0] in;
    output reg W, X, Y, Z;

    always @(in) begin
        case(in)
            0: begin
                W=1;
                X=0;
                Y=0;
                Z=0;
            end
            1: begin
                W=0;
                X=1;
                Y=0;
                Z=0;
            end
            2: begin
                W=0;
                X=0;
                Y=1;
                Z=0;
            end
            3: begin
                W=0;
                X=0;
                Y=0;
                Z=1;
            end
        endcase
    end
endmodule