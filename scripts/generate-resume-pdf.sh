#!/bin/bash

# Script to generate PDF from resume markdown file
# Usage: ./generate-resume-pdf.sh

set -e

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Installing now..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install pandoc
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y pandoc
    else
        echo "Unsupported OS. Please install pandoc manually."
        exit 1
    fi
fi

# Function to generate HTML version of resume
generate_html_resume() {
    echo "Generating HTML version of resume..."

    # Create directory if it doesn't exist
    mkdir -p static/resume

    # Extract just the resume content (without HTML tags) and remove the download link section
    cat content/resume/index.md | sed 's/<div class="resume-container">//g' | sed 's/<\/div>//g' | sed 's/<link.*>//g' | sed '/<div style="text-align: center;">/,/<\/div>/d' > resume_content_clean.md

    # Generate HTML from Markdown
    pandoc resume_content_clean.md \
      -f markdown \
      -t html \
      --standalone \
      --metadata title="Sviatoslav Osadtsia - Resume" \
      --css=https://cdn.jsdelivr.net/npm/water.css@2/out/water.min.css \
      -o static/resume/SviatoslavOsadtsia_resume.html

    # Create a plain text version for ATS systems
    pandoc resume_content_clean.md -f markdown -t plain -o static/resume/SviatoslavOsadtsia_resume.txt

    # Clean up temporary files
    rm resume_content_clean.md

    echo "HTML resume generated: static/resume/SviatoslavOsadtsia_resume.html"
    echo "Plain text resume generated: static/resume/SviatoslavOsadtsia_resume.txt"
}

# Try to install WeasyPrint if not available
if ! command -v weasyprint &> /dev/null; then
    echo "WeasyPrint not found. Attempting to install..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo "Installing WeasyPrint using Homebrew..."
            brew install weasyprint
        else
            echo "Homebrew not found. Please install Homebrew first:"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            echo "Then run this script again."
            generate_html_resume
            exit 0
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v pip3 &> /dev/null; then
            echo "Installing WeasyPrint using pip..."
            pip3 install weasyprint
        elif command -v apt-get &> /dev/null; then
            echo "Installing WeasyPrint using apt..."
            sudo apt-get update && sudo apt-get install -y python3-pip
            pip3 install weasyprint
        else
            echo "Could not determine package manager. Please install WeasyPrint manually."
            generate_html_resume
            exit 0
        fi
    else
        echo "Unsupported OS. Please install WeasyPrint manually."
        generate_html_resume
        exit 0
    fi
fi

# Check if WeasyPrint is installed
if command -v weasyprint &> /dev/null; then
    echo "WeasyPrint found, generating PDF..."

    # Create directory if it doesn't exist
    mkdir -p static/resume

    # Extract just the resume content (without HTML tags) and remove the download link section
    cat content/resume/index.md | sed 's/<div class="resume-container">//g' | sed 's/<\/div>//g' | sed 's/<link.*>//g' | sed '/<div style="text-align: center;">/,/<\/div>/d' > resume_content_clean.md

    # Create a simple CSS file that's compatible with WeasyPrint
    cat > resume_style.css << 'EOL'
@font-face {
  font-family: 'Calibri';
  src: local('Calibri');
}

body {
  font-family: 'Calibri', Arial, sans-serif;
  font-size: 12pt !important;
  max-width: 900px !important;
  margin: 0 auto;
  padding: 10px;
  color: #333;
  line-height: 1.3;
}

h1 {
  font-family: 'Calibri', Arial, sans-serif;
  font-size: 16pt;
  margin-bottom: 8px;
  text-align: center;
}

/* Center contact information */
p:first-of-type {
  text-align: center;
  margin-bottom: 15px;
}

h2 {
  font-family: 'Calibri', Arial, sans-serif;
  font-size: 13pt;
  margin-top: 15px;
  margin-bottom: 8px;
  border-bottom: 1px solid #3498db;
  padding-bottom: 3px;
  color: #2c3e50;
}

h3 {
  font-family: 'Calibri', Arial, sans-serif;
  font-size: 12pt;
  max-width: 900px !important;
  margin-bottom: 4px;
  margin-top: 12px;
  color: #2c3e50;
}

ul {
  margin-top: 6px;
  margin-bottom: 8px;
  padding-left: 18px;
}

li {
  margin-bottom: 3px;
}

p {
  margin-bottom: 8px;
}

strong {
  font-weight: bold;
}

a {
  color: #3498db;
  text-decoration: none;
}

@page {
  size: letter;
  margin: 1cm;
}
EOL

    # Generate HTML from Markdown with inline CSS
    pandoc resume_content_clean.md \
      -f markdown \
      -t html \
      --standalone \
      -o static/resume/temp.html

    # Convert HTML to PDF using WeasyPrint
    echo "Converting HTML to PDF using WeasyPrint..."
    weasyprint \
      --stylesheet resume_style.css \
      static/resume/temp.html \
      static/resume/SviatoslavOsadtsia_resume.pdf

    # Create a plain text version for ATS systems
    pandoc resume_content_clean.md -f markdown -t plain -o static/resume/SviatoslavOsadtsia_resume.txt

    # Clean up temporary files
    rm resume_content_clean.md static/resume/temp.html resume_style.css

    echo "Resume files generated successfully in static/resume/ directory"
else
    echo "WeasyPrint installation failed."
    echo ""
    echo "Alternative installation methods:"
    echo "  1. macOS: brew install weasyprint"
    echo "  2. Linux: pip3 install weasyprint"
    echo "  3. Manual installation: https://doc.courtbouillon.org/weasyprint/stable/first_steps.html"
    echo ""
    echo "Proceeding with HTML version only..."
    echo ""

    generate_html_resume
fi
