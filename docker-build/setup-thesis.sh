#!/bin/bash

# Exit on any error
set -e

# Configuration
THESIS_DIR="${1:-thesis}"
UMDOC_BIN="${2:-./umdoc}"

# Check if umdoc is accessible
if ! command -v "$UMDOC_BIN" &> /dev/null; then
    echo "Error: umdoc binary not found at '$UMDOC_BIN'"
    echo "Usage: $0 [thesis-directory] [path-to-umdoc]"
    exit 1
fi

# Create thesis directory structure
echo "Creating thesis directory structure at '$THESIS_DIR'..."
mkdir -p "$THESIS_DIR/tex"
mkdir -p "$THESIS_DIR/chapters"
mkdir -p "$THESIS_DIR/images"

# Create umdoc.xml
echo "Creating umdoc.xml..."
cat > "$THESIS_DIR/umdoc.xml" << 'EOL'
<umdoc>
    <set name="author" value="Your Name"/>
    <set name="title" value="Your Thesis Title"/>
    <set name="university" value="Your University"/>
    <set name="department" value="Your Department"/>
    <set name="date" value="March 2025"/>
    
    <tex file="tex/thesis-style.tex"/>
    
    <document>
        <tex file="tex/titlepage.tex"/>
        <pageBreak/>
        
        <tex file="tex/abstract.tex"/>
        <pageBreak/>
        
        <tableOfContents/>
        <pageBreak/>
        
        <md file="chapters/01_introduction.md"/>
        <pageBreak/>
        <md file="chapters/02_literature.md"/>
        <pageBreak/>
        <md file="chapters/03_methodology.md"/>
        <pageBreak/>
        <md file="chapters/04_results.md"/>
        <pageBreak/>
        <md file="chapters/05_discussion.md"/>
        <pageBreak/>
        <md file="chapters/06_conclusion.md"/>
        <pageBreak/>
        
        <tex file="tex/bibliography.tex"/>
        <pageBreak/>
        
        <listOfFigures/>
        <pageBreak/>
        <listOfTables/>
    </document>
</umdoc>
EOL

# Create thesis style
echo "Creating LaTeX style file..."
cat > "$THESIS_DIR/tex/thesis-style.tex" << 'EOL'
% Thesis style file
\documentclass[12pt,a4paper]{report}

% Packages
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{times}
\usepackage{graphicx}
\usepackage{setspace}
\usepackage[left=3.5cm,right=2.5cm,top=3cm,bottom=3cm]{geometry}
\usepackage{fancyhdr}
\usepackage{natbib}
\usepackage{hyperref}
\usepackage{booktabs}

% Title and author from XML variables
\title{%title%}
\author{%author%}
\date{%date%}

% Custom header/footer
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\slshape \leftmark}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

% Other customizations
\onehalfspacing
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
EOL

# Create title page
echo "Creating title page..."
cat > "$THESIS_DIR/tex/titlepage.tex" << 'EOL'
% Title page
\begin{titlepage}
    \centering
    \vspace*{1cm}
    
    \Huge
    \textbf{%title%}
    
    \vspace{1.5cm}
    
    \Large
    A thesis presented for the degree of\\
    Bachelor of Science
    
    \vspace{1.5cm}
    
    \Large
    \textbf{%author%}
    
    \vspace{1cm}
    
    \large
    %university%\\
    %department%
    
    \vfill
    
    \large
    %date%
    
\end{titlepage}

% Add a blank page after the title page
\newpage
\thispagestyle{empty}
\mbox{}
\newpage
EOL

# Create abstract
echo "Creating abstract..."
cat > "$THESIS_DIR/tex/abstract.tex" << 'EOL'
\begin{abstract}
% Replace this with your abstract text
This thesis explores...
\end{abstract}
EOL

# Create bibliography
echo "Creating bibliography settings..."
cat > "$THESIS_DIR/tex/bibliography.tex" << 'EOL'
% Bibliography settings
\bibliographystyle{plain}
\bibliography{references}
EOL

# Create sample bibtex file
echo "Creating references.bib..."
cat > "$THESIS_DIR/references.bib" << 'EOL'
% Sample BibTeX entries
@article{smith2023,
  author  = {Smith, J.},
  title   = {Sample Article Title},
  journal = {Journal of Examples},
  year    = {2023},
  volume  = {1},
  pages   = {1--10}
}

@book{johnson2022,
  author    = {Johnson, M.},
  title     = {Comprehensive Textbook},
  publisher = {Academic Press},
  year      = {2022}
}
EOL

# Create sample chapter files
echo "Creating sample chapter files..."

cat > "$THESIS_DIR/chapters/01_introduction.md" << 'EOL'
# Introduction {#introduction}

This is the introduction to your thesis. Here you would outline the problem statement,
research questions, and the overall structure of your thesis.

According to Smith \cite{smith2023}, this approach has several advantages.

## Background {#background}

This section provides context for your research.

## Research Questions {#research-questions}

The primary research questions addressed in this thesis are:

1. First research question
2. Second research question
3. Third research question

## Thesis Structure {#thesis-structure}

The remainder of this thesis is organized as follows:

- Chapter 2 presents a review of relevant literature.
- Chapter 3 describes the methodology.
- Chapter 4 presents the results.
- Chapter 5 discusses the findings.
- Chapter 6 concludes and suggests future work.
EOL

cat > "$THESIS_DIR/chapters/02_literature.md" << 'EOL'
# Literature Review {#literature-review}

This chapter reviews the existing literature relevant to your research.

## Theoretical Framework {#theoretical-framework}

This section discusses the theoretical framework that guides your research.

## Previous Studies {#previous-studies}

This section summarizes previous studies in the field.

As noted by Johnson \cite{johnson2022}, there are several important considerations.
EOL

# Create stub files for remaining chapters
for i in 03_methodology.md 04_results.md 05_discussion.md 06_conclusion.md; do
    chapter_name=$(echo "$i" | sed 's/^[0-9]*_//' | sed 's/\.md$//')
    title=$(echo "$chapter_name" | sed 's/\b\(.\)/\u\1/g')
    
    cat > "$THESIS_DIR/chapters/$i" << EOL
# $title {#$chapter_name}

This is a placeholder for the $title chapter.

## Section One {#$chapter_name-section-one}

Content for section one.

## Section Two {#$chapter_name-section-two}

Content for section two.
EOL
done

echo "Creating a build script..."
cat > "$THESIS_DIR/build.sh" << EOL
#!/bin/bash

# Build the thesis using umdoc
$UMDOC_BIN umdoc.xml

echo "Build completed. Check umdoc.pdf for the result."
EOL
chmod +x "$THESIS_DIR/build.sh"

echo "Creating conversion script for Obsidian wiki-links..."
cat > "$THESIS_DIR/convert-obsidian-links.sh" << 'EOL'
#!/bin/bash

# Process each Markdown file in the chapters directory
for file in chapters/*.md; do
    echo "Processing $file..."
    
    # Create a backup
    cp "$file" "$file.bak"
    
    # Convert wiki links
    sed -i -E 's/\[\[([^|#]*)(\|([^#]*))?\]\]/[\3](#\1)/g' "$file"
    
    # Convert image links
    sed -i -E 's/!\[\[([^|]*)(\|([^#]*))?\]\]/![\3](\1)/g' "$file"
done

echo "Conversion complete. Original files backed up with .bak extension."
EOL
chmod +x "$THESIS_DIR/convert-obsidian-links.sh"

echo "Thesis project initialized successfully in directory: $THESIS_DIR"
echo ""
echo "You can now:"
echo "1. Edit the chapters in $THESIS_DIR/chapters/"
echo "2. Add your images to $THESIS_DIR/images/"
echo "3. Customize the LaTeX style in $THESIS_DIR/tex/"
echo "4. Add your references to $THESIS_DIR/references.bib"
echo "5. Run $THESIS_DIR/build.sh to build your thesis"
echo ""
echo "For Obsidian users: Use $THESIS_DIR/convert-obsidian-links.sh to convert wiki-links"
