# Magma

Use `.m` for source. Place reusable routines in [lib/](lib/), drivers in [scripts/](scripts/), runnable illustrations in [examples/](examples/) and checks in [tests/](tests/).

```bash
bash scripts/research.sh test magma
bash scripts/research.sh run magma "computational/magma/tests/smoke.m"
```

The launcher uses `-b` to suppress the banner and `-s` to select the [batch startup file](scripts/batch.m), which enables termination on errors. The local override `MAGMA_BIN` can point to an executable Magma driver. The [smoke test](tests/smoke.m) asserts $(x+1)^2=x^2+2x+1$ in $\mathbb Q[x]$ before printing `MAGMA_SMOKE_TEST_OK`. [Magma command-line reference](https://magma.maths.usyd.edu.au/magma/handbook/text/47)
