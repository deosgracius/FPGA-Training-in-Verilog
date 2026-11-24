/*

Name: Deo Mwala
R-Number: R-11687042
Assignment: Final Project

*/

// 128x32 random access memory (Project 4 RAM, widened for the final project).
//
// addr selects one of 128 locations, each 32 bits wide. All controls are
// active low: with CS high the data bus is high impedance and nothing is
// written; with CS and OE low the selected location is driven on the bus;
// with CS low, the value on the bus is latched into the selected location
// on the falling edge of WR.
//
// rst loads randomized initial contents, like the LUT from class, so the
// program can be seen loading real values from memory.
module RAM(rst, CS, OE, WR, addr, data);
    input rst;                  // loads the initial memory contents
    input CS;                   // chip select, active low
    input OE;                   // output enable, active low
    input WR;                   // write, active low, latches on the falling edge
    input [6:0] addr;           // address of the location to read or write
    inout [31:0] data;          // bidirectional data bus

    reg [31:0] memory[0:127];   // the 128 memory locations

    assign data = (CS==0 && OE==1'b0) ? memory[addr] : 32'hZZZZZZZZ;

    always @(posedge rst or negedge WR) begin
        if(rst==1) begin
            memory[0] <= 32'hC200952D;
            memory[1] <= 32'hCDC85B89;
            memory[2] <= 32'h57554B6A;
            memory[3] <= 32'h6DC2BC88;
            memory[4] <= 32'h8C0DE251;
            memory[5] <= 32'h57D42547;
            memory[6] <= 32'h46E8526A;
            memory[7] <= 32'h6448E7FC;
            memory[8] <= 32'hA38AE723;
            memory[9] <= 32'h875C3820;
            memory[10] <= 32'h1970DC73;
            memory[11] <= 32'h9B3F06C7;
            memory[12] <= 32'h6AFE75F8;
            memory[13] <= 32'h3229DB62;
            memory[14] <= 32'hAB05B1CD;
            memory[15] <= 32'h98BD693B;
            memory[16] <= 32'hE7D99845;
            memory[17] <= 32'hB0298570;
            memory[18] <= 32'h68809C09;
            memory[19] <= 32'hFC917907;
            memory[20] <= 32'h4C040C5A;
            memory[21] <= 32'hB08CBB90;
            memory[22] <= 32'hF1C31E20;
            memory[23] <= 32'hDE43559C;
            memory[24] <= 32'h05C0785B;
            memory[25] <= 32'hA5F8CCA4;
            memory[26] <= 32'hF9F3C507;
            memory[27] <= 32'h15D14697;
            memory[28] <= 32'h97AA0E67;
            memory[29] <= 32'h9BB90B3A;
            memory[30] <= 32'h9BF56A8C;
            memory[31] <= 32'hCC712EA4;
            memory[32] <= 32'hA36E9A0A;
            memory[33] <= 32'hBE87926C;
            memory[34] <= 32'h080469C7;
            memory[35] <= 32'h10590162;
            memory[36] <= 32'h254A75EE;
            memory[37] <= 32'hF20CA1C4;
            memory[38] <= 32'hD514225E;
            memory[39] <= 32'h2E6E03CD;
            memory[40] <= 32'hAD448339;
            memory[41] <= 32'hCEA87613;
            memory[42] <= 32'hD9DFF965;
            memory[43] <= 32'h8A6F8B53;
            memory[44] <= 32'hE22336BE;
            memory[45] <= 32'hE815CD4C;
            memory[46] <= 32'h390ABC88;
            memory[47] <= 32'h990EE32B;
            memory[48] <= 32'h83C8EFD7;
            memory[49] <= 32'h933A561C;
            memory[50] <= 32'hD2792A1E;
            memory[51] <= 32'h68C33004;
            memory[52] <= 32'hA2FB60CC;
            memory[53] <= 32'h4F1170FD;
            memory[54] <= 32'hD79A84BB;
            memory[55] <= 32'hCF57001C;
            memory[56] <= 32'hB00A3057;
            memory[57] <= 32'hE9816C0F;
            memory[58] <= 32'h4763B086;
            memory[59] <= 32'h07096758;
            memory[60] <= 32'h204F4F69;
            memory[61] <= 32'hF0ED298A;
            memory[62] <= 32'h19CBD167;
            memory[63] <= 32'hBBC4E5A9;
            memory[64] <= 32'h075A2E60;
            memory[65] <= 32'h3DF53210;
            memory[66] <= 32'hFD0B7230;
            memory[67] <= 32'hC00713B5;
            memory[68] <= 32'hD8E33868;
            memory[69] <= 32'hB7BE5C18;
            memory[70] <= 32'h4501D749;
            memory[71] <= 32'h20A6A006;
            memory[72] <= 32'hF60064F2;
            memory[73] <= 32'hE3B6C7DF;
            memory[74] <= 32'h01A838D7;
            memory[75] <= 32'h4C7546F9;
            memory[76] <= 32'hD573E70D;
            memory[77] <= 32'h70E8525F;
            memory[78] <= 32'h5493DA38;
            memory[79] <= 32'h356D9FCA;
            memory[80] <= 32'hF090AE8B;
            memory[81] <= 32'hC7AFEB20;
            memory[82] <= 32'hCAA02D18;
            memory[83] <= 32'h5F97C22E;
            memory[84] <= 32'h5BC4B776;
            memory[85] <= 32'h6D29814B;
            memory[86] <= 32'hA6566702;
            memory[87] <= 32'h26C886CF;
            memory[88] <= 32'h30AC9779;
            memory[89] <= 32'hA3A4425F;
            memory[90] <= 32'h836704DF;
            memory[91] <= 32'hE018DCD6;
            memory[92] <= 32'h530BE748;
            memory[93] <= 32'hFC8B6DB1;
            memory[94] <= 32'h67BE6922;
            memory[95] <= 32'h52B84FFA;
            memory[96] <= 32'h0BB6889B;
            memory[97] <= 32'h67846E18;
            memory[98] <= 32'h07E62DC0;
            memory[99] <= 32'hA063AE10;
            memory[100] <= 32'h0F825140;
            memory[101] <= 32'h13BEC274;
            memory[102] <= 32'hF52CCAEF;
            memory[103] <= 32'h4D627C90;
            memory[104] <= 32'h0819B78D;
            memory[105] <= 32'h283504B9;
            memory[106] <= 32'h0AD7C836;
            memory[107] <= 32'hACBA0328;
            memory[108] <= 32'h2239F1DF;
            memory[109] <= 32'h5F6E03B8;
            memory[110] <= 32'h92692DC1;
            memory[111] <= 32'h5C645C6B;
            memory[112] <= 32'hD8E6E084;
            memory[113] <= 32'h7196D88B;
            memory[114] <= 32'h7C827793;
            memory[115] <= 32'h713B327C;
            memory[116] <= 32'h7D817D3B;
            memory[117] <= 32'h2DEAEC1B;
            memory[118] <= 32'h0AA3009B;
            memory[119] <= 32'h42981047;
            memory[120] <= 32'hC9491828;
            memory[121] <= 32'h607D14DA;
            memory[122] <= 32'h4B542525;
            memory[123] <= 32'h8BCAC35D;
            memory[124] <= 32'h6B803DB5;
            memory[125] <= 32'hD67FDF38;
            memory[126] <= 32'hFDE2FBE2;
            memory[127] <= 32'h85890FB2;
        end else if(CS==0) begin
            memory[addr] <= data;
        end
    end
endmodule
