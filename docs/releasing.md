# Release reference

This page describes how to publish a new version of the template.

## Version format

Tags use the `vYYYY.N` format:

- `YYYY` is the academic year in which the release is published.
- `N` is the revision number within that academic year.

Examples: `v2026.1`, `v2026.2`, `v2027.1`.

The latest tag is listed on the [tags page](https://github.com/pendopo-dev/dike-ugm-thesis-latex/tags).

## Before tagging

1. Confirm that both templates build from a clean tree:

   ```bash
   make clean
   make all
   make check
   ```

2. Confirm that the GitHub Actions workflow is green on the commit you are about to tag.
3. Confirm that the tag follows the `vYYYY.N` format.
4. Review `docs/build.md` and `docs/releasing.md` for commands that changed.
5. Confirm that no build artifacts or private files are staged:

   ```bash
   git status --short
   ```

## Create the release

1. Create an annotated tag:

   ```bash
   git tag -a v2026.2 -m "Template release v2026.2"
   ```

2. Push the tag:

   ```bash
   git push origin v2026.2
   ```

3. The `Compile LaTeX` workflow runs on the tag. It compiles the proposal and the thesis, then attaches both PDFs to a GitHub release.

## Verify the release

1. Open the **Actions** tab and confirm that the tag run completed.
2. Open the **Releases** page and confirm that `proposal.pdf` and `thesis.pdf` are attached.
3. Download both PDFs and confirm that they open.
4. Confirm that the release notes describe the user-visible changes.

## Roll back a release

If a release is incorrect:

1. Delete the GitHub release.
2. Delete the tag locally and remotely:

   ```bash
   git tag -d v2026.2
   git push origin :refs/tags/v2026.2
   ```

3. Fix the problem on `main`, then create a new tag.

## Maintainer notes

- Do not move or reuse a published tag. Create a new revision instead.
- Keep the tag and the `README.md` version in sync.
- The CI workflow grants write permission only to the release job; the compile jobs run with read-only access.
- The release job waits for the class-file check and both PDF jobs, so a drifted class file blocks the release.
