always @(*) begin
    case (state)

        IDLE:
            next_state = (enable && data_valid)
                         ? PROCESS
                         : IDLE;

        PROCESS:
            next_state = (done)
                         ? IDLE
                         : PROCESS;

        default:
            next_state = IDLE;

    endcase
end


always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
    end else if (enable && data_valid) begin
        state <= PROCESS;
    end else if (done) begin
        state <= IDLE;
    end else begin
        state <= state;    // hold current state
    end
end



always @(*) begin
    case (opcode)
        4'b0000: alu_out = a + b;
        4'b0001: alu_out = a - b;
        4'b0010: alu_out = a & b;
        4'b0011: alu_out = a | b;
        default: alu_out = 0;    // always include default
    endcase
end