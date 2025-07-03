# Portfolio Website

A collection of my projects.

## Setup

### Prerequisites
- [Hugo](https://gohugo.io/installation/) (version 0.141.0 or later)
- Git
- [Pandoc](https://pandoc.org/installing.html) (for resume generation)
- [WeasyPrint](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html) (for PDF generation)

### Local Development
1. Clone this repository
   ```
   git clone https://github.com/yourusername/portfolio.git
   cd portfolio
   ```

2. Initialize submodules (for themes)
   ```
   git submodule update --init --recursive
   ```

3. Run the Hugo server
   ```
   hugo server -D
   ```

## Resume Generation

This portfolio includes my resume that can be viewed online and downloaded as a PDF.

### Features
- Responsive design that looks good on all devices
- PDF version generated automatically
- Plain text version
- Consistent styling across all formats

### Generating Resume Files
To generate the resume PDF and plain text versions:

```bash
# Make the script executable
chmod +x ./scripts/generate-resume-pdf.sh

# Run the script
./scripts/generate-resume-pdf.sh
```

## Deployment

This site is automatically deployed to GitHub Pages when changes are pushed to the main branch. The GitHub Actions workflow automatically generates the resume PDF and plain text versions during deployment.
