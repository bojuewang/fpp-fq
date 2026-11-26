# Mathematica

Place shared Wolfram Language code in [packages/](packages/), executable `.wl` or `.wls` drivers in [scripts/](scripts/), `.nb` notebooks in [notebooks/](notebooks/), examples in [examples/](examples/) and checks in [tests/](tests/).

```bash
bash scripts/research.sh test mathematica
bash scripts/research.sh run mathematica "computational/mathematica/tests/smoke.wls"
```

The launcher probes local WolframScript and kernel interfaces for a kernel version before running the file once. On WSL it also tries Windows executables and translates input paths for them. WolframScript uses `-local -file`. Direct WolframKernel and MathKernel interfaces use `-script`. Set `WOLFRAM_BIN` to select one installed interface explicitly, retaining its standard executable name.

The [smoke test](tests/smoke.wls) expands the difference of two polynomials with exact integer coefficients, checks that the result is the integer zero and prints `MATHEMATICA_SMOKE_TEST_OK` on success.
