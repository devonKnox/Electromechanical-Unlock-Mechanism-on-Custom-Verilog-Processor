module CLA( 
    output [31:0] sum,
    output        c32,       // final carry out
    input  [31:0] a, b,
    input         c0
);

    wire G0, P0, G1, P1, G2, P2, G3, P3;
    wire c8, c16, c24, c32;

    // 8-bit block 0
    CLA_block block0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .c_in(c0),
        .sum(sum[7:0]),
        .G_block(G0),
        .P_block(P0)
    );

    // block 1
    CLA_block block1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .c_in(c8),
        .sum(sum[15:8]),
        .G_block(G1),
        .P_block(P1)
    );

    // block 2
    CLA_block block2 (
        .a(a[23:16]),
        .b(b[23:16]),
        .c_in(c16),
        .sum(sum[23:16]),
        .G_block(G2),
        .P_block(P2)
    );

    // block 3
    CLA_block block3 (
        .a(a[31:24]),
        .b(b[31:24]),
        .c_in(c24),
        .sum(sum[31:24]),
        .G_block(G3),
        .P_block(P3)
    );

    // c8 = G0 + P0 * c0
    wire p0c0;
    and a1(p0c0, P0, c0);
    or  o1(c8, G0, p0c0);

    // c16 = G1 + P1*G0 + P1*P0*c0
    wire p1g0, p1p0c0, c16_temp;
    and a2(p1g0,   P1, G0);
    and a3(p1p0c0, P1, P0, c0);
    or  o2(c16_temp, G1, p1g0);
    or  o3(c16, c16_temp, p1p0c0);

    // c24 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*c0
    wire p2g1, p2p1g0, p2p1p0c0, c24_temp1, c24_temp2;
    and a4(p2g1,     P2, G1);
    and a5(p2p1g0,   P2, P1, G0);
    and a6(p2p1p0c0, P2, P1, P0, c0);
    or  o4(c24_temp1, G2, p2g1);
    or  o5(c24_temp2, c24_temp1, p2p1g0);
    or  o6(c24,       c24_temp2, p2p1p0c0);

    // c32 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*c0
    wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0;
    wire c32_temp1, c32_temp2, c32_temp3;
    and a7(p3g2,        P3, G2);
    and a8(p3p2g1,      P3, P2, G1);
    and a9(p3p2p1g0,    P3, P2, P1, G0);
    and a10(p3p2p1p0c0, P3, P2, P1, P0, c0);
    or  o7(c32_temp1, G3, p3g2);
    or  o8(c32_temp2, c32_temp1, p3p2g1);
    or  o9(c32_temp3, c32_temp2, p3p2p1g0);
    or  o10(c32, c32_temp3, p3p2p1p0c0);

endmodule
