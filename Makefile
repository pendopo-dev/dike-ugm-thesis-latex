# DIKE UGM Thesis LaTeX Template - Makefile
# Supports local compilation with TeX Live and container-based compilation with Docker.

.PHONY: help proposal skripsi clean glossary-proposal glossary-skripsi check-cls check test \
	build-docker proposal-docker skripsi-docker shell all all-docker

# Default target
help:
	@echo "DIKE UGM Thesis LaTeX Template - Build Options"
	@echo "=================================================="
	@echo ""
	@echo "Local compilation (requires TeX Live):"
	@echo "  make proposal          - Compile template/proposal/main.tex"
	@echo "  make skripsi           - Compile template/skripsi/main.tex"
	@echo "  make all               - Compile both documents"
	@echo "  make clean             - Remove build artifacts"
	@echo ""
	@echo "List of symbols and abbreviations:"
	@echo "  make glossary-proposal - Build the proposal nomenclature index"
	@echo "  make glossary-skripsi  - Build the thesis nomenclature index"
	@echo ""
	@echo "Validation:"
	@echo "  make check             - Verify that the three class-file copies match"
	@echo "  make test              - Build the templates and run the regression tests"
	@echo ""
	@echo "Docker compilation (no TeX Live installation required):"
	@echo "  make proposal-docker   - Compile the proposal in a container"
	@echo "  make skripsi-docker    - Compile the thesis in a container"
	@echo "  make all-docker        - Compile both documents in a container"
	@echo "  make shell             - Open an interactive shell in the container"

# Local compilation
proposal:
	cd template/proposal && \
		pdflatex -interaction=nonstopmode main.tex && \
		bibtex main && \
		makeindex main.nlo -s nomencl.ist -o main.nls && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

skripsi:
	cd template/skripsi && \
		pdflatex -interaction=nonstopmode main.tex && \
		bibtex main && \
		makeindex main.nlo -s nomencl.ist -o main.nls && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

# Nomenclature indexes (normally produced automatically by the build targets)
glossary-proposal:
	@cd template/proposal && \
		test -f main.nlo || { echo "error: main.nlo not found; run make proposal first."; exit 1; } && \
		makeindex main.nlo -s nomencl.ist -o main.nls

glossary-skripsi:
	@cd template/skripsi && \
		test -f main.nlo || { echo "error: main.nlo not found; run make skripsi first."; exit 1; } && \
		makeindex main.nlo -s nomencl.ist -o main.nls

# Validation
check-cls:
	@cmp -s ugmskripsi.cls template/proposal/ugmskripsi.cls || { \
		echo "error: template/proposal/ugmskripsi.cls differs from ugmskripsi.cls"; exit 1; }
	@cmp -s ugmskripsi.cls template/skripsi/ugmskripsi.cls || { \
		echo "error: template/skripsi/ugmskripsi.cls differs from ugmskripsi.cls"; exit 1; }
	@echo "Class file copies match."

check: check-cls

test:
	./tests/run.sh

clean:
	@find template -type f \( \
		-name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.toc" \
		-o -name "*.lof" -o -name "*.lot" -o -name "*.fls" -o -name "*.fdb_latexmk" \
		-o -name "*.synctex.gz" -o -name "*.bbl" -o -name "*.blg" -o -name "*.glo" \
		-o -name "*.gls" -o -name "*.glg" -o -name "*.idx" -o -name "*.ind" \
		-o -name "*.ilg" -o -name "*.ist" -o -name "*.loa" \
		-o -name "*.nlo" -o -name "*.nls" \
	\) -delete

# Docker compilation
DOCKER_IMAGE := dike-ugm-thesis-latex
DOCKER_TAG := latest

build-docker:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f docker/Dockerfile .

proposal-docker: build-docker
	docker run --rm -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) \
		sh -c "cd /workspace/proposal && pdflatex -interaction=nonstopmode main.tex && bibtex main && makeindex main.nlo -s nomencl.ist -o main.nls && pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex"

skripsi-docker: build-docker
	docker run --rm -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) \
		sh -c "cd /workspace/skripsi && pdflatex -interaction=nonstopmode main.tex && bibtex main && makeindex main.nlo -s nomencl.ist -o main.nls && pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex"

shell: build-docker
	docker run --rm -it -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) sh

# Compile all
all: proposal skripsi

all-docker: proposal-docker skripsi-docker
