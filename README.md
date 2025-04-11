# Module dep

https://github.com/slw287r/dep

```
──────────────────────────────────────────────────────────
  Plot sequencing depth of contig or whole genome in bam
                            ┌──┐
                    ┌─┐    ┌┘  └─┐
              ──────┴─┴────┴─────┴───────
                    ——→    ←——
                            ——←→——
──────────────────────────────────────────────────────────
● Usage: bamdep [options] --in <bam> --out <png>

● Options:
  -i, --in  FILE   Input BAM file with bai index
  -o, --out STR    Output depth plot png [${prefix}.png]
  -s, --sub STR    Sub-title of depth plot [none]
  -c, --ctg STR    Restrict analysis to this contig [none]
  -d, --dep STR    Depth (w/o dup) bed4 file [none]
  -D, --dup STR    Depth (w/ dup) bed4 file [none]

  -h               Show help message
  -v               Display program version
```

## CI/CD
