#!/bin/bash

# This script sets up a thesis structure for use with your existing umdoc binary

# Default values
THESIS_NAME="my-thesis"
UMDOC_PATH="./umdoc"

# Check for arguments
if [ $# -ge 1 ]; then
  THESIS_NAME="$1"
fi

if [ $# -ge 2 ]; then
  UMDOC_PATH="$2"
fi

echo "Setting up thesis directory: $THESIS_NAME"
echo "Using umdoc from: $UMDOC_PATH"

# Create directory structure
mkdir -p "$THESIS_NAME/tex"
mkdir -p "$THESIS_NAME/chapters"
mkdir -p "$THESIS_NAME/images"

# Create umdoc.xml
cat > "$THESIS_NAME/umdoc.xml" << EOF
<umdoc>
    <set name="author" value="Your Name"/>
    <set name="title" value="Your Thesis Title"/>
    <set name="university" value="Your University"/>
    <set name="department" value="Your Department"/>
    <set name="date" value="$(date +"%B %Y")"/>
    
    <tex file="tex/thesis-style.tex"/>
    
    <document>
        <tex file="tex/titlepage.tex"/>
        <pageBreak/>
        
        <tableOfContents/>
        <pageBreak/>
        
        <md file="chapters/01_introduction.md"/>
        <pageBreak/>
        
        <md file="chapters/02_background.md"/>
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
EOF

# Create LaTeX style file
cat > "$THESIS_NAME/tex/thesis-style.tex" << EOF
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
EOF

# Create title page
cat > "$THESIS_NAME/tex/titlepage.tex" << EOF
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
EOF

# Create bibliography settings
cat > "$THESIS_NAME/tex/bibliography.tex" << EOF
% Bibliography settings
\bibliographystyle{plain}
\bibliography{references}
EOF

# Create references file
cat > "$THESIS_NAME/references.bib" << EOF
@article{smith2023,
  author  = {Smith, John},
  title   = {Example Research Paper},
  journal = {Journal of Examples},
  year    = {2023},
  volume  = {10},
  pages   = {1--15}
}

@book{johnson2022,
  author    = {Johnson, Mary},
  title     = {Comprehensive Guide},
  publisher = {Academic Press},
  year      = {2022}
}

@online{website2023,
  author  = {{Organization Name}},
  title   = {Website Title},
  url     = {https://example.com},
  year    = {2023},
  urldate = {2023-12-15}
}
EOF

# Create example chapter files
cat > "$THESIS_NAME/chapters/01_introduction.md" << EOF
# Introduction {#introduction}

This is the introduction chapter of your thesis. Here you would provide an overview of your research problem, objectives, and the structure of your thesis.

According to Smith \cite{smith2023}, this approach has several advantages.

## Background {#background}

This section provides context for your research.

## Research Questions {#research-questions}

The primary research questions addressed in this thesis are:

1. First research question
2. Second research question
3. Third research question

## Thesis Structure {#thesis-structure}

This thesis is organized as follows:

- Chapter 2 presents a review of the relevant literature.
- Chapter 3 describes the methodology used.
- Chapter 4 presents the results.
- Chapter 5 discusses the implications of the findings.
- Chapter 6 concludes the thesis and suggests directions for future research.
EOF

# Create a template for the remaining chapters
for chapter in "02_background" "03_methodology" "04_results" "05_discussion" "06_conclusion"; do
  title=$(echo "${chapter:3}" | sed 's/\b\([a-z]\)/\u\1/g')
  
  cat > "$THESIS_NAME/chapters/$chapter.md" << EOF
# $title {#${chapter:3}}

This is the $title chapter of your thesis.

## First Section {#${chapter:3}-first-section}

Content for the first section.

## Second Section {#${chapter:3}-second-section}

Content for the second section.

According to Johnson \cite{johnson2022}, this aspect is significant.
EOF
done

# Create helper scripts
cat > "$THESIS_NAME/build.sh" << EOF
#!/bin/bash

# Build the thesis PDF
$UMDOC_PATH umdoc.xml

echo "Thesis build complete. Check umdoc.pdf for the result."
EOF
chmod +x "$THESIS_NAME/build.sh"

# Create Obsidian link converter
cat > "$THESIS_NAME/convert-links.sh" << 'EOF'
#!/bin/bash

# This script converts Obsidian wiki-links to standard Markdown links

for file in chapters/*.md; do
  echo "Processing $file..."
  
  # Back up the file
  cp "$file" "$file.bak"
  
  # Convert [[Link]] format
  sed -i -E 's/\[\[([^|#]*)(\|([^#]*))?\]\]/[\3](#\1)/g' "$file"
  
  # Convert image links
  sed -i -E 's/!\[\[([^|]*)(\|([^#]*))?\]\]/![\3](\1)/g' "$file"
done

echo "Conversion complete. Backup files saved with .bak extension."
EOF
chmod +x "$THESIS_NAME/convert-links.sh"

echo "========================================================"
echo "Thesis structure created successfully!"
echo "========================================================"
echo ""
echo "Your thesis is set up in the '$THESIS_NAME' directory."
echo ""
echo "Get started by:"
echo "1. Edit chapters in $THESIS_NAME/chapters/"
echo "2. Add your references to $THESIS_NAME/references.bib"
echo "3. If you use Obsidian wiki-links, run $THESIS_NAME/convert-links.sh to convert them"
echo "4. Build your PDF with $THESIS_NAME/build.sh"
echo ""
echo "Happy writing!"
