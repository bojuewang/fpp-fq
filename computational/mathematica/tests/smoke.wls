Clear[x];
If[
    Expand[(x + 1)^2 - (x^2 + 2 x + 1)] === 0,
    Print["MATHEMATICA_SMOKE_TEST_OK"]; Exit[0],
    Exit[1]
];
