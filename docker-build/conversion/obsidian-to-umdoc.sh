#!/bin/bash

# This script helps convert Obsidian wiki-links to standard Markdown links
# Usage: ./obsidian-to-umdoc.sh /path/to/obsidian/vault /path/to/output/directory

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/obsidian/vault /path/to/output/directory"
    exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

# Create output directory if it doesn't exist
mkdir -p "$TARGET_DIR"

echo "Converting Obsidian vault to umdoc-compatible Markdown..."

# Process each Markdown file in the source directory
for file in "$SOURCE_DIR"/*.md; do
    filename=$(basename "$file")
    echo "Processing $filename..."
    
    # Create a processed copy in the target directory
    sed -E 's/\[\[([^|#]*)(\|([^#]*))?\]\]/[\3](#\1)/g' "$file" > "$TARGET_DIR/$filename"
    
    # Convert Obsidian image links if needed
    sed -i -E 's/!\[\[([^|]*)(\|([^#]*))?\]\]/![\3](\1)/g' "$TARGET_DIR/$filename"
done

echo "Creating umdoc.xml file..."
cat > "$TARGET_DIR/umdoc.xml" << EOL
<umdoc>
    <set name="author" value="Your Name"/>
    <set name="title" value="Your Thesis Title"/>
    <set name="university" value="Your University"/>
    <set name="date" value="$(date +"%B %Y")"/>
    
    <tex file="thesis-style.tex"/>
    
    <document>
        <tex file="titlepage.tex"/>
        <tableOfContents/>
        <pageBreak/>
EOL

# Add all Markdown files to the umdoc.xml
for file in "$TARGET_DIR"/*.md; do
    filename=$(basename "$file")
    echo "        <md file=\"$filename\"/>" >> "$TARGET_DIR/umdoc.xml"
    echo "        <pageBreak/>" >> "$TARGET_DIR/umdoc.xml"
done

# Close the XML file
cat >> "$TARGET_DIR/umdoc.xml" << EOL
        <tex file="bibliography.tex"/>
        <listOfFigures/>
        <pageBreak/>
        <listOfTables/>
    </document>
</umdoc>
EOL

echo "Created $TARGET_DIR/umdoc.xml"

# Create a simple template for LaTeX style
cat > "$TARGET_DIR/thesis-style.tex" << EOL
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

echo "Created $TARGET_DIR/thesis-style.tex"

# Create a sample title page
cat > "$TARGET_DIR/titlepage.tex" << EOL
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
    %university%
    
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

echo "Created $TARGET_DIR/titlepage.tex"

# Create bibliography file
cat > "$TARGET_DIR/bibliography.tex" << EOL
% Bibliography settings
\bibliographystyle{plain}
\bibliography{references}
EOL

echo "Created $TARGET_DIR/bibliography.tex"

echo "Conversion complete! Now you can customize the files in $TARGET_DIR and build with umdoc."
echo "To build your thesis, run: ./umdoc-linux $TARGET_DIR/umdoc.xml"
