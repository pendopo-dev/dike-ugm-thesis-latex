#!/usr/bin/env python3
"""PDF assertions for the template build tests."""

import re
import subprocess
import sys

HEADINGS = ("DAFTAR TABEL", "DAFTAR GAMBAR", "DAFTAR LAMBANG DAN SINGKATAN")


def fail(message):
    print(f"  FAIL: {message}", file=sys.stderr)
    raise SystemExit(1)


def pages(pdf):
    try:
        raw = subprocess.check_output(
            ["pdftotext", "-layout", pdf, "-"], text=True, stderr=subprocess.STDOUT
        )
    except FileNotFoundError:
        fail("pdftotext is required for PDF assertions")
    return raw.split("\f")


def standalone(pages_list, heading):
    return [
        index
        for index, page in enumerate(pages_list)
        if any(line.strip() == heading for line in page.splitlines())
    ]


def toc_region(pages_list):
    toc_pages = standalone(pages_list, "DAFTAR ISI")
    if not toc_pages:
        fail("DAFTAR ISI heading not found")
    start = toc_pages[0]
    following = [
        index
        for index in range(start + 1, len(pages_list))
        if any(
            line.strip() in HEADINGS for line in pages_list[index].splitlines()
        )
    ]
    end = following[0] if following else len(pages_list)
    return "\n".join(pages_list[start:end])


def check_toc_entry(pdf, heading):
    pages_list = pages(pdf)
    entry = None
    for line in toc_region(pages_list).splitlines():
        if heading in line and len(line.split()) > len(heading.split()):
            entry = line
            break
    if entry is None:
        fail(f"{heading} is missing from the table of contents")

    toc_page = entry.split()[-1]
    hits = standalone(pages_list, heading)
    if not hits:
        fail(f"{heading} page not found")
    page_lines = [line.strip() for line in pages_list[hits[0]].splitlines() if line.strip()]
    page_label = page_lines[-1] if page_lines else ""
    if toc_page != page_label:
        fail(f"{heading} TOC page {toc_page!r} does not match page label {page_label!r}")


def check_text(pdf, needle):
    if not any(needle in page for page in pages(pdf)):
        fail(f"{needle!r} is missing from the PDF")


def check_logo(pdf):
    try:
        from pypdf import PdfReader
    except ImportError:
        print("  SKIP: pypdf is not installed; logo size not asserted")
        return

    reader = PdfReader(pdf)
    expected_points = 5.5 / 2.54 * 72
    for page_index in (0, 1):
        page = reader.pages[page_index]
        resources = page.get("/Resources")
        xobjects = resources.get("/XObject") if resources else None
        if not xobjects:
            fail(f"no form XObject on page {page_index + 1}")
        content = page.get_contents().get_data().decode("latin1")

        placed = []
        for name, reference in xobjects.items():
            xobject = reference.get_object()
            if xobject.get("/Subtype") != "/Form":
                continue
            box = xobject.get("/BBox")
            width = float(box[2]) - float(box[0])
            if f"{name} Do" not in content:
                continue
            scales = [
                float(match.group(1))
                for line in content.splitlines()
                for match in re.finditer(
                    r"(\d+(?:\.\d+)?) 0 0 \1 \d+(?:\.\d+)? \d+(?:\.\d+)? cm", line
                )
            ]
            if not scales:
                continue
            placed.append(width * max(scales))

        if not placed:
            fail(f"logo placement not found on page {page_index + 1}")
        if not any(abs(value - expected_points) <= 1.5 for value in placed):
            fail(
                f"logo on page {page_index + 1} is {placed[0]:.2f} pt wide; "
                f"expected {expected_points:.2f} pt (5.5 cm)"
            )


def main():
    if len(sys.argv) != 3:
        sys.exit("usage: check_pdf.py <nomenclature|toc-lists|logo|text> <pdf>")
    command, pdf = sys.argv[1], sys.argv[2]

    if command == "nomenclature":
        check_toc_entry(pdf, "DAFTAR LAMBANG DAN SINGKATAN")
        check_text(pdf, "Application Programming Interface")
    elif command == "toc-lists":
        check_toc_entry(pdf, "DAFTAR TABEL")
        check_toc_entry(pdf, "DAFTAR GAMBAR")
    elif command == "logo":
        check_logo(pdf)
    else:
        sys.exit(f"unknown command: {command}")


if __name__ == "__main__":
    main()
