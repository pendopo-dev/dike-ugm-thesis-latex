# Build reference

This page describes the supported ways to build the DIKE UGM thesis template.

## Toolchain

The template is tested with **TeX Live 2026** and the `pdflatex` engine. A full TeX Live installation is required; minimal schemes may omit `natbib`, `nomencl`, `times`, or other packages used by `ugmskripsi.cls`.

Required commands:

- `pdflatex`
- `bibtex`
- `makeindex`

## Local build

From the repository root:

```bash
make proposal
make skripsi
make all
```

The generated files are:

- `template/proposal/main.pdf`
- `template/skripsi/main.pdf`

The Makefile runs `pdflatex`, `bibtex`, and two additional `pdflatex` passes so that citations and cross-references resolve.

### Install TeX Live

- **macOS:** install [MacTeX](https://www.tug.org/mactex/).
- **Windows:** install [MiKTeX](https://miktex.org/) or [TeX Live](https://www.tug.org/texlive/).
- **Linux:** install the `texlive-full` package from your distribution.

Confirm the installation:

```bash
pdflatex --version
bibtex --version
makeindex --version
```

## Docker build

Docker avoids installing TeX Live locally. Start Docker Desktop, then run:

```bash
make proposal-docker
make skripsi-docker
make all-docker
```

The Docker targets build the image from `docker/Dockerfile` and mount `template/` into the container. The generated PDFs appear in the same directories as the local build.

Open an interactive shell in the container:

```bash
make shell
```

## Overleaf

1. Create a new Overleaf project.
2. Upload the contents of `template/proposal/` or `template/skripsi/`.
3. Set `main.tex` as the main document.
4. Select **pdfLaTeX** as the compiler and **BibTeX** as the bibliography tool.
5. Compile.

Overleaf may not run `makeindex` automatically. If you enable `\lambang`, run the glossary target locally first or configure Overleaf to run `makeindex` for the nomenclature file.

## VimTeX

With [vimtex](https://github.com/lervag/vimtex) installed:

```vim
:VimtexCompile
:VimtexView
:VimtexStop
```

VimTeX uses `latexmk` by default. The template also works with the Makefile if you prefer an explicit build command.

## List of symbols and abbreviations

The `\lambang` command is disabled by default in `template/skripsi/main.tex`. To enable it:

1. Add entries to the document:

   ```latex
   \nomenclature{API}{Application Programming Interface}
   \nomenclature{CI}{Continuous Integration}
   ```

2. Uncomment `\lambang` in `template/skripsi/main.tex`.
3. Build the glossary index:

   ```bash
   make glossary-skripsi
   ```

4. Rebuild the document:

   ```bash
   make skripsi
   ```

The proposal template does not enable `\lambang` by default. If your department requires a list of symbols there, add `\lambang` to `template/proposal/main.tex`, add the entries, and run:

```bash
make glossary-proposal
make proposal
```

## Clean

Remove generated LaTeX files:

```bash
make clean
```

This removes auxiliary files created by `pdflatex`, `bibtex`, and `makeindex`. It does not remove the tracked preview PDFs.

## Validation

Check that the three class-file copies are identical:

```bash
make check
```

The CI workflow runs the same check alongside the compile jobs.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `logougm` not found | The logo file is missing or renamed | Replace `template/*/figures/logougm.pdf` with the official UGM logo |
| Citations show `[?]` | BibTeX has not run, or the citation key is missing | Run `make clean && make proposal`; check `references.bib` |
| `natbib.sty` not found | Incomplete TeX Live installation | Install the full TeX Live distribution |
| `babel` package warning about `bahasa` | The class uses a legacy babel language name | The warning is harmless; the document still compiles |
| PDF does not change after an edit | Stale auxiliary files | Run `make clean`, then rebuild |
| Docker target fails | Docker Desktop is not running | Start Docker Desktop and confirm `docker info` succeeds |
| Daftar Lambang is empty | `\lambang` is disabled or `makeindex` has not run | Follow the list-of-symbols procedure above |
| Overfull hbox warnings | A line, table, or figure is wider than the text block | Adjust the content; warnings do not stop the build |

## Notes

- The template uses `pdflatex`, not XeLaTeX or LuaLaTeX. If you switch engines, check `inputenc`, `fontenc`, and the `times` package first.
- The class file is shared by both templates. Edit the canonical `ugmskripsi.cls` at the repository root, copy it to both template directories, and run `make check`.
- The Dockerfile uses `texlive/texlive:latest`. Pin a specific TeX Live image tag if you need a fully reproducible build.
- The `examples/` directory contains official reference documents. Do not edit those PDFs.
