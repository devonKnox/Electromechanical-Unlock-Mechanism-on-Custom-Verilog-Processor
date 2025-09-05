module TFF (
    input  T,
    input  clk,
    output Q
);
    wire D_in, or_up, or_down, T_not, Q_not;
    wire one  = 1'b1;  // Constant 1 for enable
    wire zero = 1'b0;  // Constant 0 for clear

    edffe_ref dffe_in (
        .q(Q),     
        .d(D_in), 
        .clk(clk), 
        .en(one),   
        .clr(zero) 
    );

    // Create the inverted signals
    not u1 (T_not, T);
    not u2 (Q_not, Q);

    // Compute the two product terms for D
    and u3 (or_up, T_not, Q);
    and u4 (or_down, T, Q_not); 

    or u5 (D_in, or_up, or_down);

endmodule
