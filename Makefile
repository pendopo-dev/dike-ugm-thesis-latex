# DIKE UGM Thesis LaTeX Template - Makefile
# Supports local compilation with TeX Live and container-based compilation with Docker.

.PHONY: help proposal skripsi skripsi-inovasi-produk skripsi-ilmiah-akademik clean \
	glossary-proposal glossary-skripsi glossary-skripsi-inovasi-produk glossary-skripsi-ilmiah-akademik \
	check-cls check test build-docker proposal-docker \
	skripsi-inovasi-produk-docker skripsi-ilmiah-akademik-docker skripsi-docker \
	shell all all-docker

# Default target
help:
	@echo "DIKE UGM Thesis LaTeX Template - Build Options"
	@echo "=================================================="
	@echo ""
	@echo "Local compilation (requires TeX Live):"
	@echo "  make proposal                 - Compile template/proposal/main.tex"
	@echo "  make skripsi                  - Compile both thesis tracks"
	@echo "  make skripsi-inovasi-produk   - Compile template/skripsi/inovasi-produk/main.tex"
	@echo "  make skripsi-ilmiah-akademik  - Compile template/skripsi/ilmiah-akademik/main.tex"
	@echo "  make all                      - Compile the proposal and both thesis tracks"
	@echo "  make clean                    - Remove build artifacts"
	@echo ""
	@echo "List of symbols and abbreviations:"
	@echo "  make glossary-proposal                   - Build the proposal nomenclature index"
	@echo "  make glossary-skripsi                    - Build both thesis nomenclature indexes"
	@echo "  make glossary-skripsi-inovasi-produk     - Build the inovasi-produk nomenclature index"
	@echo "  make glossary-skripsi-ilmiah-akademik    - Build the ilmiah-akademik nomenclature index"
	@echo ""
	@echo "Validation:"
	@echo "  make check                    - Verify that the class-file copies match"
	@echo "  make test                     - Build the templates and run the regression tests"
	@echo ""
	@echo "Docker compilation (no TeX Live installation required):"
	@echo "  make proposal-docker                 - Compile the proposal in a container"
	@echo "  make skripsi-docker                  - Compile both thesis tracks in containers"
	@echo "  make skripsi-inovasi-produk-docker   - Compile the inovasi-produk thesis in a container"
	@echo "  make skripsi-ilmiah-akademik-docker  - Compile the ilmiah-akademik thesis in a container"
	@echo "  make all-docker                      - Compile the proposal and both thesis tracks"
	@echo "  make shell                           - Open an interactive shell in the container"

# Local compilation
proposal:
	cd template/proposal && \
		pdflatex -interaction=nonstopmode main.tex && \
		bibtex main && \
		makeindex main.nlo -s nomencl.ist -o main.nls && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

skripsi-inovasi-produk:
	cd template/skripsi/inovasi-produk && \
		pdflatex -interaction=nonstopmode main.tex && \
		bibtex main && \
		makeindex main.nlo -s nomencl.ist -o main.nls && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

skripsi-ilmiah-akademik:
	cd template/skripsi/ilmiah-akademik && \
		pdflatex -interaction=nonstopmode main.tex && \
		bibtex main && \
		makeindex main.nlo -s nomencl.ist -o main.nls && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

skripsi: skripsi-ilmiah-akademik skripsi-inovasi-produk

# Nomenclature indexes (normally produced automatically by the build targets)
glossary-proposal:
	@cd template/proposal && \
		test -f main.nlo || { echo "error: main.nlo not found; run make proposal first."; exit 1; } && \
		makeindex main.nlo -s nomencl.ist -o main.nls

glossary-skripsi-inovasi-produk:
	@cd template/skripsi/inovasi-produk && \
		test -f main.nlo || { echo "error: main.nlo not found; run make skripsi-inovasi-produk first."; exit 1; } && \
		makeindex main.nlo -s nomencl.ist -o main.nls

glossary-skripsi-ilmiah-akademik:
	@cd template/skripsi/ilmiah-akademik && \
		test -f main.nlo || { echo "error: main.nlo not found; run make skripsi-ilmiah-akademik first."; exit 1; } && \
		makeindex main.nlo -s nomencl.ist -o main.nls

glossary-skripsi: glossary-skripsi-ilmiah-akademik glossary-skripsi-inovasi-produk

# Validation
check-cls:
	@for dir in template/proposal template/skripsi/inovasi-produk template/skripsi/ilmiah-akademik; do \
		cmp -s ugmskripsi.cls "$$dir/ugmskripsi.cls" || { \
			echo "error: $$dir/ugmskripsi.cls differs from ugmskripsi.cls"; exit 1; }; \
	done
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

skripsi-inovasi-produk-docker: build-docker
	docker run --rm -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) \
		sh -c "cd /workspace/skripsi/inovasi-produk && pdflatex -interaction=nonstopmode main.tex && bibtex main && makeindex main.nlo -s nomencl.ist -o main.nls && pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex"

skripsi-ilmiah-akademik-docker: build-docker
	docker run --rm -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) \
		sh -c "cd /workspace/skripsi/ilmiah-akademik && pdflatex -interaction=nonstopmode main.tex && bibtex main && makeindex main.nlo -s nomencl.ist -o main.nls && pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex"

skripsi-docker: skripsi-ilmiah-akademik-docker skripsi-inovasi-produk-docker

shell: build-docker
	docker run --rm -it -v $(PWD)/template:/workspace $(DOCKER_IMAGE):$(DOCKER_TAG) sh

# Compile all
all: proposal skripsi

all-docker: proposal-docker skripsi-docker
