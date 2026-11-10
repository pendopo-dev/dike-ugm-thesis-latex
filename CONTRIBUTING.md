# Contributing to the DIKE UGM Thesis LaTeX Template

Thank you for helping improve the template. This guide covers the ways to report a problem, request a change, and submit a pull request.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- **Report a bug** in the class file, build system, or template structure.
- **Request a feature** that makes the template easier to use.
- **Report a pedoman update** when DIKE or UGM changes a requirement.
- **Improve the documentation** in `README.md`, `CONTRIBUTING.md`, `AGENTS.md`, or `docs/`.
- **Submit a code change** for the class file, Makefile, Docker image, or CI workflow.

The thesis content in `template/` stays in Indonesian because the pedoman requires it. Repository documentation is written in English.

## Before opening an issue

1. Search the existing issues to avoid duplicates.
2. Read the [README](README.md) and [build documentation](docs/build.md).
3. Run `make clean` and rebuild before reporting a build failure.
4. Confirm that you use a full TeX Live installation, not a minimal scheme.

## Opening an issue

Use the issue form that matches your report:

| Report | Form | Label |
|---|---|---|
| A build error, wrong page, or broken class behavior | [Bug report](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=bug_report.md) | `bug` |
| A new feature or usability improvement | [Feature request](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=feature_request.md) | `enhancement` |
| A change required by a new pedoman or academic year | [Template update](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=template_update.md) | `template-update` |
| A usage question | [Question](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=question.md) | `question` |

Include the template version, operating system, TeX distribution, the exact command you ran, and the relevant part of the log. Do not paste private data, unpublished thesis content, or credentials.

## Development setup

1. Fork the repository and clone your fork:

   ```bash
   git clone https://github.com/YOUR_USERNAME/dike-ugm-thesis-latex.git
   cd dike-ugm-thesis-latex
   ```

2. Install one of the supported toolchains:

   - TeX Live 2025 or later with `pdflatex`, `bibtex`, and `makeindex`.
   - Docker Desktop for the container-based build.

3. Build both templates:

   ```bash
   make all
   ```

   Or use Docker:

   ```bash
   make all-docker
   ```

4. Validate the class copies:

   ```bash
   make check
   ```

## Making changes

### Branch names

Use a short, descriptive branch name:

```text
fix/proposal-page-numbering
docs/build-troubleshooting
feat/second-supervisor
ci/tag-release
```

### Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Common types:

- `feat`: new behavior
- `fix`: bug fix
- `docs`: documentation
- `style`: formatting only
- `refactor`: internal restructuring
- `ci`: workflow changes
- `chore`: maintenance

Common scopes:

- `cls`: `ugmskripsi.cls`
- `proposal`: proposal template
- `skripsi`: thesis template
- `build`: Makefile or Docker
- `docs`: repository documentation

### Class file changes

`ugmskripsi.cls` is the canonical class file. The copies at `template/proposal/ugmskripsi.cls` and `template/skripsi/ugmskripsi.cls` must stay identical.

After editing the class:

```bash
cp ugmskripsi.cls template/proposal/ugmskripsi.cls
cp ugmskripsi.cls template/skripsi/ugmskripsi.cls
make check
```

### Documentation changes

Update the relevant document when behavior changes:

- `README.md` for user-facing setup and usage.
- `CONTRIBUTING.md` for contribution rules.
- `AGENTS.md` for document-structure guidance.
- `docs/build.md` for build commands and troubleshooting.
- `docs/releasing.md` for the release procedure.

### Build artifacts

Do not commit generated files such as `main.pdf`, `.aux`, `.log`, `.toc`, `.bbl`, `.blg`, `.fls`, `.synctex.gz`, or `.DS_Store`. Run `make clean` before committing. The template PDFs are ignored by Git and should be rebuilt locally with `make`.

## Pull requests

1. Create a branch from `main`.
2. Make the smallest change that solves the problem.
3. Build both templates and run `make check`.
4. Update the documentation if needed.
5. Open a pull request and complete the template checklist.
6. Wait for the GitHub Actions checks to pass.
7. Address review comments and keep the branch up to date.

A maintainer will review the pull request. Do not merge your own pull request unless you are a maintainer and the change has been reviewed.

## Review criteria

A pull request is ready when:

- Both `make proposal` and `make skripsi` succeed.
- `make check` passes.
- The GitHub Actions workflow is green.
- The change follows the pedoman or fixes a verified defect.
- Documentation is updated.
- No build artifacts, credentials, or private thesis content are included.

## Release procedure

Releases use tags in the `vYYYY.N` format. The tag triggers the compile workflow, which builds both PDFs and attaches them to the GitHub release.

See [docs/releasing.md](docs/releasing.md) for the checklist and rollback steps.

## Labels

| Label | Meaning |
|---|---|
| `bug` | A confirmed defect |
| `enhancement` | A new feature or improvement |
| `template-update` | A change required by a new pedoman or academic year |
| `documentation` | Documentation-only work |
| `question` | A usage question |
| `good first issue` | A small, well-scoped task for a new contributor |
| `help wanted` | A task where maintainers welcome assistance |

## Questions and security

For usage questions, open a [question issue](https://github.com/pendopo-dev/dike-ugm-thesis-latex/issues/new?template=question.md).

For a sensitive report, contact the maintainers through their GitHub profiles instead of posting private information in a public issue.
