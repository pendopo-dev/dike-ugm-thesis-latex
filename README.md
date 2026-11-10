# DIKE UGM Thesis LaTeX Template

[![Compile LaTeX](https://github.com/pendopo-dev/dike-ugm-thesis-latex/actions/workflows/compile-latex.yml/badge.svg)](https://github.com/pendopo-dev/dike-ugm-thesis-latex/actions/workflows/compile-latex.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/tag/pendopo-dev/dike-ugm-thesis-latex?label=version)](https://github.com/pendopo-dev/dike-ugm-thesis-latex/tags)

A LaTeX template for the **Proposal Tugas Akhir** and **Skripsi** at the Department of Computer Science and Electronics (DIKE), Faculty of Mathematics and Natural Sciences, Universitas Gadjah Mada (UGM).

The template is organized around the DIKE/UGM pedoman for document structure, page layout, citations, and front matter. It is maintained by the Pendopo Dev community and is **not an official UGM publication**.

## Scope

- `template/proposal/` follows the DIKE proposal structure: Pendahuluan, Penelitian Terkait, Metode dan Rancangan Penelitian, and Jadwal Penelitian.
- `template/skripsi/` follows the **Inovasi Produk** thesis track: six chapters from Pendahuluan through Pengujian dan Evaluasi Produk.
- Other departments and thesis tracks have different requirements. Check your department's pedoman before using this template.

## Quick start

### Use this template

1. Click **Use this template** and create a new repository under your own account.
2. Clone your new repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
   cd YOUR_REPOSITORY
   ```

3. Replace the metadata in `template/proposal/main.tex` and `template/skripsi/main.tex`:

   ```latex
   \titleind{Judul Penelitian dalam Bahasa Indonesia}
   \titleeng{Research Title in English}
   \fullname{Nama Lengkap}
   \idnum{XX/XXXXXX/PA/XXXXX}
   \gelar{Sarjana Ilmu Komputer}
   \yearsubmit{2026}
   \examdate{DD Bulan YYYY}
   \program{Ilmu Komputer}
   \dept{Ilmu Komputer dan Elektronika}
   \firstsupervisor{Nama Dosen Pembimbing}
   \firstexaminer{Nama Dosen Penguji}
   \secondexaminer{Nama Dosen Penguji}
   ```

   If you have a second supervisor, uncomment `\secondsupervisor{...}` in the same file.

4. Write your content in `template/proposal/chapters/` or `template/skripsi/chapters/`.
5. Replace `template/*/figures/logougm.pdf` with the official UGM logo from your department.
6. Compile with `make proposal` or `make skripsi`.

### Fork for contributions

Fork the repository only when you want to improve the template itself. Read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## Requirements

- **TeX Live 2025 or later** (tested with TeX Live 2026) with `pdflatex`, `bibtex`, and `makeindex`.
- **Docker Desktop** if you prefer not to install TeX Live.
- **Overleaf** if you prefer a browser-based editor.
- **`pdftotext`** (Poppler) only when running `make test`.

## Build

### Local TeX Live

```bash
make proposal          # Build template/proposal/main.pdf
make skripsi           # Build template/skripsi/main.pdf
make all               # Build both documents
make check             # Verify that the three class-file copies match
make test              # Build the templates and run the regression tests
make clean             # Remove LaTeX build artifacts
```

Generated `main.pdf` files are ignored by Git. Rebuild them with `make` whenever you need a local copy.

### Docker

```bash
make proposal-docker   # Build the proposal inside the container
make skripsi-docker    # Build the thesis inside the container
make all-docker        # Build both documents
make shell             # Open a shell in the build container
```

### Overleaf

1. Create a new Overleaf project and upload the contents of `template/proposal/` or `template/skripsi/`.
2. Set `main.tex` as the main document.
3. Select **pdfLaTeX** as the compiler and **BibTeX** as the bibliography tool.
4. Compile.

### VimTeX

```vim
:VimtexCompile
:VimtexView
:VimtexStop
```

See [docs/build.md](docs/build.md) for the full build matrix and troubleshooting.

## What is included

| Path | Purpose |
|---|---|
| `template/proposal/` | Proposal document, chapters, bibliography, and figures |
| `template/skripsi/` | Thesis document, chapters, appendix, bibliography, and figures |
| `ugmskripsi.cls` | Canonical class file; the copies in each template must match it |
| `examples/` | Official pedoman and example documents from DIKE/UGM |
| `docker/Dockerfile` | Reproducible TeX Live build environment |
| `docs/` | Build and release reference documentation |
| `tests/` | Build and PDF regression tests for the template |
| `Makefile` | Local, Docker, validation, and test commands |

## Customization

- Replace every metadata placeholder in `main.tex`.
- Replace the chapter placeholders with your own writing.
- Add references to `references.bib` and cite them with `\citep` or `\citet`.
- Replace `figures/logougm.pdf` with the official UGM logo.
- Add your figures to `figures/` and reference them with `\includegraphics`.
- Update the approval page names and examination date.
- Remove the `TODO` comments before submitting the final document.
- Enable `\lambang` and add `\nomenclature` entries if your department requires a list of symbols and abbreviations.
- Run `make clean && make all` before your final submission.

## Troubleshooting

| Problem | Solution |
|---|---|
| `logougm` not found | Replace `template/*/figures/logougm.pdf` with the official UGM logo. |
| References show `[?]` | Run `make clean && make proposal` (or `make skripsi`) so BibTeX runs again. Check that every citation key exists in `references.bib`. |
| `natbib` or `babel` package missing | Install the full TeX Live distribution, not a minimal scheme. |
| The PDF does not update | Run `make clean`, then rebuild. |
| Docker target fails | Start Docker Desktop and confirm that `docker info` succeeds. |
| Daftar Lambang is empty | Enable `\lambang`, add `\nomenclature{...}{...}` entries, then run `make skripsi` (the build runs `makeindex` automatically). |
| Overfull hbox warnings | Adjust the surrounding text, table, or figure width. These warnings do not stop the build. |

## Contributing

Contributions are welcome:

- **Bug report:** use the [bug report form](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=bug_report.md).
- **Feature request:** use the [feature request form](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=feature_request.md).
- **Pedoman update:** use the [template update form](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=template_update.md).
- **Question:** use the [question form](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=question.md).
- **Code or documentation change:** read [CONTRIBUTING.md](CONTRIBUTING.md), then open a pull request.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Version

Tags use the `vYYYY.N` format, where `YYYY` is the academic year in which the template version was released and `N` is the revision number. The latest tag is listed on the [tags page](https://github.com/pendopo-dev/dike-ugm-thesis-latex/tags).

```bash
git clone --branch <tag> https://github.com/pendopo-dev/dike-ugm-thesis-latex.git
```

Replace `<tag>` with a tag from the tags page, for example `v2026.1`.

See [docs/releasing.md](docs/releasing.md) for the release procedure.

## License and attribution

The original contents of this repository are released under the [MIT License](LICENSE).

`ugmskripsi.cls` is based on the UGM thesis class created by Pekik Nurwantoro and retains its original attribution. See [NOTICE](NOTICE) for details. The UGM logo, the pedoman, and the example documents in `examples/` remain the property of Universitas Gadjah Mada and are not covered by the MIT License.

This repository is not affiliated with or endorsed by Universitas Gadjah Mada.

## Acknowledgements

- Pekik Nurwantoro, for the original UGM thesis class.
- DIKE FMIPA UGM, for the pedoman and example documents.
- Everyone who reports issues, improves the documentation, and contributes fixes.
