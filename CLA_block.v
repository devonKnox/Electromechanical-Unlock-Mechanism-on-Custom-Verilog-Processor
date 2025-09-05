module CLA_block(
    input  [7:0] a, b,
    input        c_in,
    output [7:0] sum,
    output       G_block,
    output       P_block);
    wire [7:0] g, p;

    and g0 (g[0], a[0], b[0]);
    and g1 (g[1], a[1], b[1]);
    and g2 (g[2], a[2], b[2]);
    and g3 (g[3], a[3], b[3]);
    and g4 (g[4], a[4], b[4]);
    and g5 (g[5], a[5], b[5]);
    and g6 (g[6], a[6], b[6]);
    and g7 (g[7], a[7], b[7]);

    or  p0 (p[0], a[0], b[0]);
    or  p1 (p[1], a[1], b[1]);
    or  p2 (p[2], a[2], b[2]);
    or  p3 (p[3], a[3], b[3]);
    or  p4 (p[4], a[4], b[4]);
    or  p5 (p[5], a[5], b[5]);
    or  p6 (p[6], a[6], b[6]);
    or  p7 (p[7], a[7], b[7]);


    wire c0;
    assign c0 = c_in;

    // c1 = g0 + p0*c0
    wire c1;
    wire p0c0;
    and aC1_0 (p0c0, p[0], c0);
    or  oC1   (c1,    g[0], p0c0);

    // c2 = g1 + p1*g0 + p1*p0*c0
    wire c2;
    wire p1g0, p1p0c0, c2a;
    and aC2_0 (p1g0,   p[1], g[0]);
    and aC2_1 (p1p0c0, p[1], p[0], c0);
    or  oC2_a (c2a,    g[1], p1g0);
    or  oC2   (c2,     c2a,  p1p0c0);

    // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*c0
    wire c3;
    wire p2g1, p2p1g0, p2p1p0c0, c3a, c3b;
    and aC3_0 (p2g1,       p[2], g[1]);
    and aC3_1 (p2p1g0,     p[2], p[1], g[0]);
    and aC3_2 (p2p1p0c0,   p[2], p[1], p[0], c0);
    or  oC3_a (c3a,        g[2], p2g1);
    or  oC3_b (c3b,        c3a,  p2p1g0);
    or  oC3   (c3,         c3b,  p2p1p0c0);

    // c4 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*c0
    wire c4;
    wire p3g2, p3p2g1, p3p2p1g0, p3p2p1p0c0;
    wire c4a, c4b, c4c;
    and aC4_0 (p3g2,         p[3], g[2]);
    and aC4_1 (p3p2g1,       p[3], p[2], g[1]);
    and aC4_2 (p3p2p1g0,     p[3], p[2], p[1], g[0]);
    and aC4_3 (p3p2p1p0c0,   p[3], p[2], p[1], p[0], c0);

    or  oC4_a (c4a, g[3], p3g2);          // partial OR with g3, p3*g2
    or  oC4_b (c4b, c4a,  p3p2g1);        // add p3*p2*g1
    or  oC4_c (c4c, c4b,  p3p2p1g0);      // add p3*p2*p1*g0
    or  oC4   (c4,  c4c,  p3p2p1p0c0);    // add p3*p2*p1*p0*c0

    // c5 = g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1 + p4*p3*p2*p1*g0 + p4*p3*p2*p1*p0*c0
    wire c5;
    wire p4g3, p4p3g2, p4p3p2g1, p4p3p2p1g0, p4p3p2p1p0c0;
    wire c5a, c5b, c5c, c5d;
    and aC5_0 (p4g3,             p[4], g[3]);
    and aC5_1 (p4p3g2,           p[4], p[3], g[2]);
    and aC5_2 (p4p3p2g1,         p[4], p[3], p[2], g[1]);
    and aC5_3 (p4p3p2p1g0,       p[4], p[3], p[2], p[1], g[0]);
    and aC5_4 (p4p3p2p1p0c0,     p[4], p[3], p[2], p[1], p[0], c0);

    or  oC5_a (c5a, g[4], p4g3);
    or  oC5_b (c5b, c5a,  p4p3g2);
    or  oC5_c (c5c, c5b,  p4p3p2g1);
    or  oC5_d (c5d, c5c,  p4p3p2p1g0);
    or  oC5   (c5,  c5d,  p4p3p2p1p0c0);

    // c6 = g5 + p5*g4 + p5*p4*g3 + p5*p4*p3*g2 + p5*p4*p3*p2*g1
    //      + p5*p4*p3*p2*p1*g0 + p5*p4*p3*p2*p1*p0*c0
    wire c6;
    wire p5g4, p5p4g3, p5p4p3g2, p5p4p3p2g1, p5p4p3p2p1g0, p5p4p3p2p1p0c0;
    wire c6a, c6b, c6c, c6d, c6e;
    and aC6_0 (p5g4,                 p[5], g[4]);
    and aC6_1 (p5p4g3,               p[5], p[4], g[3]);
    and aC6_2 (p5p4p3g2,             p[5], p[4], p[3], g[2]);
    and aC6_3 (p5p4p3p2g1,           p[5], p[4], p[3], p[2], g[1]);
    and aC6_4 (p5p4p3p2p1g0,         p[5], p[4], p[3], p[2], p[1], g[0]);
    and aC6_5 (p5p4p3p2p1p0c0,       p[5], p[4], p[3], p[2], p[1], p[0], c0);

    or  oC6_a (c6a, g[5], p5g4);
    or  oC6_b (c6b, c6a,  p5p4g3);
    or  oC6_c (c6c, c6b,  p5p4p3g2);
    or  oC6_d (c6d, c6c,  p5p4p3p2g1);
    or  oC6_e (c6e, c6d,  p5p4p3p2p1g0);
    or  oC6   (c6,  c6e,  p5p4p3p2p1p0c0);

    // c7 = g6 + p6*g5 + p6*p5*g4 + p6*p5*p4*g3 + p6*p5*p4*p3*g2
    //      + p6*p5*p4*p3*p2*g1 + p6*p5*p4*p3*p2*p1*g0
    //      + p6*p5*p4*p3*p2*p1*p0*c0
    wire c7;
    wire p6g5, p6p5g4, p6p5p4g3, p6p5p4p3g2, p6p5p4p3p2g1, p6p5p4p3p2p1g0, p6p5p4p3p2p1p0c0;
    wire c7a, c7b, c7c, c7d, c7e, c7f;
    and aC7_0 (p6g5,                       p[6], g[5]);
    and aC7_1 (p6p5g4,                     p[6], p[5], g[4]);
    and aC7_2 (p6p5p4g3,                   p[6], p[5], p[4], g[3]);
    and aC7_3 (p6p5p4p3g2,                 p[6], p[5], p[4], p[3], g[2]);
    and aC7_4 (p6p5p4p3p2g1,               p[6], p[5], p[4], p[3], p[2], g[1]);
    and aC7_5 (p6p5p4p3p2p1g0,             p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and aC7_6 (p6p5p4p3p2p1p0c0,           p[6], p[5], p[4], p[3], p[2], p[1], p[0], c0);

    or  oC7_a (c7a, g[6], p6g5);
    or  oC7_b (c7b, c7a,  p6p5g4);
    or  oC7_c (c7c, c7b,  p6p5p4g3);
    or  oC7_d (c7d, c7c,  p6p5p4p3g2);
    or  oC7_e (c7e, c7d,  p6p5p4p3p2g1);
    or  oC7_f (c7f, c7e,  p6p5p4p3p2p1g0);
    or  oC7   (c7,  c7f,  p6p5p4p3p2p1p0c0);

    // c8 = g7 + p7*g6 + p7*p6*g5 + p7*p6*p5*g4
    //      + p7*p6*p5*p4*g3 + p7*p6*p5*p4*p3*g2
    //      + p7*p6*p5*p4*p3*p2*g1 + p7*p6*p5*p4*p3*p2*p1*g0
    //      + p7*p6*p5*p4*p3*p2*p1*p0*c0
    wire c8;
    wire p7g6, p7p6g5, p7p6p5g4, p7p6p5p4g3, p7p6p5p4p3g2;
    wire p7p6p5p4p3p2g1, p7p6p5p4p3p2p1g0, p7p6p5p4p3p2p1p0c0;
    wire c8a, c8b, c8c, c8d, c8e, c8f, c8g, c8h;
    and aC8_0 (p7g6,                             p[7], g[6]);
    and aC8_1 (p7p6g5,                           p[7], p[6], g[5]);
    and aC8_2 (p7p6p5g4,                         p[7], p[6], p[5], g[4]);
    and aC8_3 (p7p6p5p4g3,                       p[7], p[6], p[5], p[4], g[3]);
    and aC8_4 (p7p6p5p4p3g2,                     p[7], p[6], p[5], p[4], p[3], g[2]);
    and aC8_5 (p7p6p5p4p3p2g1,                   p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and aC8_6 (p7p6p5p4p3p2p1g0,                 p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and aC8_7 (p7p6p5p4p3p2p1p0c0,               p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0], c0);

    or  oC8_a (c8a, g[7], p7g6);
    or  oC8_b (c8b, c8a,  p7p6g5);
    or  oC8_c (c8c, c8b,  p7p6p5g4);
    or  oC8_d (c8d, c8c,  p7p6p5p4g3);
    or  oC8_e (c8e, c8d,  p7p6p5p4p3g2);
    or  oC8_f (c8f, c8e,  p7p6p5p4p3p2g1);
    or  oC8_g (c8g, c8f,  p7p6p5p4p3p2p1g0);
    or  oC8_h (c8h, c8g,  p7p6p5p4p3p2p1p0c0);
    // final c8
    assign c8 = c8h;
    assign G_block = c8;  // the group generate is final carry out

    wire p01, p012, p0123, p01234, p012345, p0123456;
    and aP0 (p01,       p[0], p[1]);
    and aP1 (p012,      p01,   p[2]);
    and aP2 (p0123,     p012,  p[3]);
    and aP3 (p01234,    p0123, p[4]);
    and aP4 (p012345,   p01234,p[5]);
    and aP5 (p0123456,  p012345,p[6]);
    and aP6 (P_block,   p0123456, p[7]);

    xor x0 (sum[0], a[0], b[0], c0);
    xor x1 (sum[1], a[1], b[1], c1);
    xor x2 (sum[2], a[2], b[2], c2);
    xor x3 (sum[3], a[3], b[3], c3);
    xor x4 (sum[4], a[4], b[4], c4);
    xor x5 (sum[5], a[5], b[5], c5);
    xor x6 (sum[6], a[6], b[6], c6);
    xor x7 (sum[7], a[7], b[7], c7);

endmodule