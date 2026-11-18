# Portfolio Website

Personal site for Sviatoslav Osadtsia. Edit `hugo.toml`, `content/`, and `static/images/`.

## Setup

### Prerequisites

- [Hugo](https://gohugo.io/installation/)
- Git
- [Pandoc](https://pandoc.org/installing.html) and [WeasyPrint](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html) when generating the resume PDF locally

### Local development

```bash
git clone https://github.com/sosadtsia/portfolio.git
cd portfolio
git submodule update --init --recursive
hugo server -D
```

## Resume PDF

The resume page is `content/resume/index.md`. GitHub Actions builds the PDF during deploy. The same two commands work locally in fish or bash:

```fish
mkdir -p static/resume
pandoc content/resume/index.md --pdf-engine=weasyprint --css=assets/resume.css -o static/resume/resume.pdf
pandoc content/resume/index.md -t plain -o static/resume/resume.txt
```

## Deployment

Pushes to `main` deploy the site to GitHub Pages. The workflow generates the resume PDF, then runs Hugo.
