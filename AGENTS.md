# AGENTS.md — DIKE UGM Thesis Writing Reference

> **Official guideline:** `@examples/pedoman_ta.pdf`
> **Proposal example:** `@examples/contoh_proposal.pdf`
> **Thesis example:** `@examples/contoh_skripsi.pdf`

This file is for AI coding agents and maintainers. It describes the document structure and formatting rules used by this template.

---

## Priority rules

1. **The pedoman (`pedoman_ta.pdf`) is the primary source of truth.**
2. If the pedoman and an example PDF disagree, follow the pedoman.
3. Example PDFs are visual and formatting references, not rules.

---

## Thesis type and department

This template targets the **Skripsi Inovasi Produk** track at the Department of Computer Science and Electronics (DIKE), Faculty of Mathematics and Natural Sciences, Universitas Gadjah Mada.

Students develop a technology-based product, application, or prototype. Other departments and thesis tracks may require different front matter, chapter titles, and approval pages; check the relevant pedoman before reuse.

---

## Proposal structure (`template/proposal/`)

> Class: `\documentclass[proposal,indonesia]{ugmskripsi}`

### Front matter

| Element | Included? | Notes |
|---|---|---|
| Cover page | Yes | "PROPOSAL TUGAS AKHIR" |
| Approval page | Yes | Required; listed in the table of contents |
| Table of contents | Yes | Only the table of contents |
| Intisari | Yes | Indonesian only |
| Abstract | Yes | The example includes it; the pedoman does not mention it, so follow the example |

### Main chapters

| Chapter | Title | Contents |
|---|---|---|
| **Chapter 1** | Pendahuluan | Background, **problem statement**, scope and limitations, research objectives, expected benefits |
| **Chapter 2** | Penelitian Terkait | State of the art, literature review |
| **Chapter 3** | Metode dan Rancangan Penelitian | Overview, methodology, flowchart, system design |
| **Chapter 4** | Jadwal Penelitian | Month-based Gantt chart |

### Back matter

| Element | Included? |
|---|---|
| Glossary | Optional — only when technical jargon needs explanation |
| Bibliography | Yes |

### Not included in the proposal

- Declaration page
- Motto
- Dedication
- Preface
- List of tables
- List of figures
- List of symbols
- Appendices

---

## Thesis structure (`template/skripsi/`)

> Class: `\documentclass[skripsi,indonesia]{ugmskripsi}`

### Front matter

| Element | Included? | Notes |
|---|---|---|
| Cover page | Yes | "SKRIPSI" |
| Approval page | Yes | Listed in the table of contents |
| Declaration page | Yes | Listed in the table of contents |
| Motto | Yes | Listed in the table of contents |
| Dedication | Yes | Listed in the table of contents |
| Preface | Yes | Listed in the table of contents |
| Table of contents | Yes | |
| List of tables | Yes | |
| List of figures | Yes | |
| List of symbols | Yes | Via `\lambang` |
| Intisari | Yes | Indonesian |
| Abstract | Yes | English |

### Main chapters (Inovasi Produk — Pedoman Chapter 3.2)

| Chapter | Title | Contents |
|---|---|---|
| **Chapter 1** | Pendahuluan | Background, **product definition**, product scope, objectives, benefits |
| **Chapter 2** | Identifikasi Masalah dan Ide Inovatif | Real-world problem identification and innovative idea development |
| **Chapter 3** | Kajian Ilmiah | Literature review and scientific foundation for the product (methods, algorithms, technology) |
| **Chapter 4** | Perancangan Prototipe/Produk | Architecture, UI/UX, database, technical design |
| **Chapter 5** | Proses Pembuatan Produk | Implementation, code, component integration |
| **Chapter 6** | Pengujian dan Evaluasi Produk | Test methods, scenarios, results, performance evaluation, **conclusions and recommendations** |

### Back matter

| Element | Included? |
|---|---|
| Bibliography | Yes |
| Appendices | Yes | Code, configuration, primary data |

---

## Key differences: proposal vs thesis

| Aspect | Proposal | Thesis |
|---|---|---|
| Class option | `[proposal]` | `[skripsi]` |
| Cover text | "PROPOSAL TUGAS AKHIR" | "SKRIPSI" |
| Chapter 1 title | Problem statement | Product definition |
| Chapter 2 | Related work | Problem identification and innovative idea |
| Chapter 3 | Method and research design | Scientific foundation |
| Chapter 4 | Research schedule | Product design |
| Chapter 5 | Not included | Product development |
| Chapter 6 | Not included | Product testing and evaluation |
| Front matter | Minimal | Complete |
| Appendices | Not included | Included |

---

## Language guidance

- Use **Indonesian** (`[indonesia]`).
- Use English only for the title, the English abstract, and technical terms.
- Explain technical terms in Indonesian the first time they appear.
- Use the glossary for jargon that may confuse readers.

---

## Diagram and flowchart guidance

- **Methodology flowchart** (Proposal Chapter 3 / Thesis Chapters 3–4): required; visualize the research workflow.
- **System architecture** (Chapters 3–4): component diagram and relationships.
- **ERD / database schema** (when relevant): entity relationship diagram.
- **UI/UX wireframe or mockup** (when there is an interface): screen design.
- **Gantt chart** (Proposal Chapter 4): month-based research schedule.
- Put every diagram in a `figure` environment with a caption and label.

---

## LaTeX quick reference

### Citations

```latex
\citep{key}   % (Author, Year)
\citet{key}   % Author (Year)
```

### Figures

```latex
\begin{figure}[H]
  \centering
  \includegraphics[width=0.8\textwidth]{figures/file-name}
  \caption{Figure description}
  \label{fig:label}
\end{figure}
```

### Tables

```latex
\begin{table}[H]
  \centering
  \caption{Table title}
  \begin{tabular}{|l|c|r|}
    \hline
    Column 1 & Column 2 & Column 3 \\
    \hline
    Data & Data & Data \\
    \hline
  \end{tabular}
  \label{tab:label}
\end{table}
```

### Code listings

```latex
\begin{lstlisting}[language=yaml, caption={Listing title}]
# code here
\end{lstlisting}
```

---

## Compilation

From the repository root:

```bash
make proposal
make skripsi
```

Or compile a single document manually:

```bash
cd template/proposal   # or template/skripsi
pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

For the list of symbols and abbreviations, uncomment `\lambang`, add `\nomenclature` entries, and run:

```bash
make glossary-proposal   # or make glossary-skripsi
```

---

## Important notes

- Fill in the metadata (name, student ID, supervisors, examiners, and examination date) in `main.tex`.
- Replace `figures/logougm.pdf` with the official UGM logo.
- For the proposal, present the proposed research design and expected outcomes, not completed results.
- For the thesis, keep every chapter structured and aligned with the pedoman.
- Use `\bibliography{references}` for the bibliography.
- Make sure every `\citep` and `\citet` key exists in `references.bib`.
