SetQuitOnError(true);
Qx<x> := PolynomialRing(Rationals());
assert (x + 1)^2 eq x^2 + 2*x + 1;
print "MAGMA_SMOKE_TEST_OK";
quit;
