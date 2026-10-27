`include "main.v"

module main_tb;
    reg clk, rst;
    reg inquarter, indime, innickel;
    reg inbev1, inbev2, inbev3;
    reg cancel;

    wire outquarter, outdime, outnickel;
    wire outbev1, outbev2, outbev3;

    integer index;
    integer testNum, errors;
    integer quarters, dimes, nickels, bevs1, bevs2, bevs3;
    integer tQuarter, tDime, tNickel, tBev1, tBev2, tBev3;

    main UUT(.clk(clk), .rst(rst),
             .inquarter(inquarter), .indime(indime), .innickel(innickel),
             .inbev1(inbev1), .inbev2(inbev2), .inbev3(inbev3), .cancel(cancel),
             .outquarter(outquarter), .outdime(outdime), .outnickel(outnickel),
             .outbev1(outbev1), .outbev2(outbev2), .outbev3(outbev3)
             );

    // count every output pulse and check that each one is 20 units wide
    always @(posedge outquarter) begin quarters=quarters+1; tQuarter=$time; end
    always @(posedge outdime) begin dimes=dimes+1; tDime=$time; end
    always @(posedge outnickel) begin nickels=nickels+1; tNickel=$time; end
    always @(posedge outbev1) begin bevs1=bevs1+1; tBev1=$time; end
    always @(posedge outbev2) begin bevs2=bevs2+1; tBev2=$time; end
    always @(posedge outbev3) begin bevs3=bevs3+1; tBev3=$time; end

    always @(negedge outquarter) begin checkWidth(tQuarter); tQuarter=-1; end
    always @(negedge outdime) begin checkWidth(tDime); tDime=-1; end
    always @(negedge outnickel) begin checkWidth(tNickel); tNickel=-1; end
    always @(negedge outbev1) begin checkWidth(tBev1); tBev1=-1; end
    always @(negedge outbev2) begin checkWidth(tBev2); tBev2=-1; end
    always @(negedge outbev3) begin checkWidth(tBev3); tBev3=-1; end

    // only one coin and one beverage can be dispensed at a time
    always @(posedge clk) begin
        if(outquarter+outdime+outnickel>1) begin
            errors=errors+1;
            $display("FAIL test %0d: two coins dispensed at once at time %0t", testNum, $time);
        end
        if(outbev1+outbev2+outbev3>1) begin
            errors=errors+1;
            $display("FAIL test %0d: two beverages dispensed at once at time %0t", testNum, $time);
        end
    end

    // stimulus must not change on a clock edge (edges are at 10, 30, 50, ...)
    always @(inquarter or indime or innickel or inbev1 or inbev2 or inbev3 or cancel) begin
        if($time%20==10) begin
            errors=errors+1;
            $display("FAIL test %0d: input changed on a clock edge at time %0t", testNum, $time);
        end
    end

    // start is the time the pulse began, or -1 if no pulse has started
    task checkWidth;
    input integer start;
    begin
        if(start>=0) begin
            if($time-start!=20) begin
                errors=errors+1;
                $display("FAIL test %0d: pulse width %0d instead of 20 at time %0t", testNum, $time-start, $time);
            end
        end
    end
    endtask

    // compare the pulses counted since the last check with what is expected
    task check;
    input integer expQuarters, expDimes, expNickels, expBev1, expBev2, expBev3, expMoney;
    begin
        if(quarters==expQuarters && dimes==expDimes && nickels==expNickels &&
           bevs1==expBev1 && bevs2==expBev2 && bevs3==expBev3 && UUT.monCount==expMoney) begin
            $display("PASS test %0d", testNum);
        end else begin
            errors=errors+1;
            $display("FAIL test %0d: quarters=%0d dimes=%0d nickels=%0d bev1=%0d bev2=%0d bev3=%0d money=%0d (expected %0d %0d %0d %0d %0d %0d %0d)",
                     testNum, quarters, dimes, nickels, bevs1, bevs2, bevs3, UUT.monCount,
                     expQuarters, expDimes, expNickels, expBev1, expBev2, expBev3, expMoney);
        end
        quarters=0;
        dimes=0;
        nickels=0;
        bevs1=0;
        bevs2=0;
        bevs3=0;
        testNum=testNum+1;
    end
    endtask

    task quarter;
    begin
        inquarter=1;
        #20;
        inquarter=0;
        #20;
    end
    endtask

    task dime;
    begin
        indime=1;
        #20;
        indime=0;
        #20;
    end
    endtask

    task nickel;
    begin
        innickel=1;
        #20;
        innickel=0;
        #20;
    end
    endtask

    task bev1;
    begin
        inbev1=1;
        #20;
        inbev1=0;
        #20;
    end
    endtask

    task bev2;
    begin
        inbev2=1;
        #20;
        inbev2=0;
        #20;
    end
    endtask

    task bev3;
    begin
        inbev3=1;
        #20;
        inbev3=0;
        #20;
    end
    endtask

    task cancelTx;
    begin
        cancel=1;
        #20;
        cancel=0;
        #20;
    end
    endtask

    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);

        clk=0;
        rst=0;
        inquarter=0;
        indime=0;
        innickel=0;
        inbev1=0;
        inbev2=0;
        inbev3=0;
        cancel=0;
        testNum=1;
        errors=0;
        quarters=0;
        dimes=0;
        nickels=0;
        bevs1=0;
        bevs2=0;
        bevs3=0;
        index=0;
        tQuarter=-1;
        tDime=-1;
        tNickel=-1;
        tBev1=-1;
        tBev2=-1;
        tBev3=-1;
        #20;

        rst=1;
        #20;
        rst=0;
        #20;

        // Test 1: cancel after inserting 40 cents, quarter dime nickel are returned
        quarter;
        dime;
        nickel;
        cancelTx;
        #200;
        check(1, 1, 1, 0, 0, 0, 0);

        // Test 2: 25 cents is not enough for any beverage, the money stays in
        quarter;
        bev1;
        bev2;
        bev3;
        check(0, 0, 0, 0, 0, 0, 25);

        // Test 3: cancel returns the 25 cents
        cancelTx;
        #100;
        check(1, 0, 0, 0, 0, 0, 0);

        // Test 4: one nickel short of each price is refused (60 for bev1, 85 for bev2, 115 for bev3)
        quarter;
        quarter;
        dime;
        bev1;
        quarter;
        bev2;
        quarter;
        nickel;
        bev3;
        check(0, 0, 0, 0, 0, 0, 115);

        // Test 5: cancel returns the 115 cents as four quarters, a dime and a nickel
        cancelTx;
        #300;
        check(4, 1, 1, 0, 0, 0, 0);

        // Test 6: bev1 (65) with 75 inserted, change 10
        for(index=0; index<3; index=index+1) begin
            quarter;
        end
        bev1;
        #200;
        check(0, 1, 0, 1, 0, 0, 0);

        // Test 7: bev2 (90) with 100 inserted, change 10
        for(index=0; index<4; index=index+1) begin
            quarter;
        end
        bev2;
        #200;
        check(0, 1, 0, 0, 1, 0, 0);

        // Test 8: bev3 (120) with 125 inserted, change 5
        for(index=0; index<5; index=index+1) begin
            quarter;
        end
        bev3;
        #200;
        check(0, 0, 1, 0, 0, 1, 0);

        // Test 9: bev1 (65) with 120 inserted, change 55 is quarter quarter nickel
        for(index=0; index<4; index=index+1) begin
            quarter;
        end
        dime;
        dime;
        bev1;
        #300;
        check(2, 0, 1, 1, 0, 0, 0);

        // Test 10: exact money for each beverage, no change
        quarter;
        quarter;
        dime;
        nickel;
        bev1;
        #100;
        for(index=0; index<3; index=index+1) begin
            quarter;
        end
        dime;
        nickel;
        bev2;
        #100;
        for(index=0; index<4; index=index+1) begin
            quarter;
        end
        dime;
        dime;
        bev3;
        #100;
        check(0, 0, 0, 1, 1, 1, 0);

        // Test 11: bev1 (65) with 175, change 110 is paid out as four quarters and a dime;
        // during the payout 75 cents is inserted and kept, while a selection and a cancel are ignored
        for(index=0; index<7; index=index+1) begin
            quarter;
        end
        bev1;
        quarter;
        quarter;
        quarter;
        bev1;
        cancelTx;
        #300;
        check(4, 1, 0, 1, 0, 0, 75);

        // Test 12: the kept 75 buys bev1, change 10
        bev1;
        #200;
        check(0, 1, 0, 1, 0, 0, 0);

        // Test 13: a coin signal held for 60 units counts once; a button held for 100 units
        // gives one beverage only, even when 75 more cents are inserted while it is still held
        inquarter=1;
        #60;
        inquarter=0;
        #20;
        quarter;
        quarter;
        inbev1=1;
        #100;
        quarter;
        quarter;
        quarter;
        inbev1=0;
        #200;
        check(0, 1, 0, 1, 0, 0, 75);

        // Test 14: releasing and pressing again buys with the 75 kept, change 10
        bev1;
        #200;
        check(0, 1, 0, 1, 0, 0, 0);

        // Test 15: cancel held for 300 units refunds once (50 cents); a quarter inserted
        // after the refund, while cancel is still held, is kept
        quarter;
        quarter;
        cancel=1;
        #200;
        quarter;
        #60;
        cancel=0;
        #100;
        check(2, 0, 0, 0, 0, 0, 25);

        // Test 16: a new cancel returns the kept quarter
        cancelTx;
        #100;
        check(1, 0, 0, 0, 0, 0, 0);

        // Test 17: a coin signal held for 60 units counts once, a button held for 100 units
        // gives one beverage only
        inquarter=1;
        #60;
        inquarter=0;
        #20;
        quarter;
        quarter;
        inbev1=1;
        #100;
        inbev1=0;
        #200;
        check(0, 1, 0, 1, 0, 0, 0);

        // Test 18: cancel and bev1 at the same time, cancel wins and 75 is returned
        for(index=0; index<3; index=index+1) begin
            quarter;
        end
        cancel=1;
        inbev1=1;
        #20;
        cancel=0;
        inbev1=0;
        #300;
        check(3, 0, 0, 0, 0, 0, 0);

        if(errors==0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("%0d ERRORS", errors);
        end
        $finish();
    end

    always begin
        #10;
        clk=~clk;
    end
endmodule
