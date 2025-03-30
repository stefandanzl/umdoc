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
mkdir -p "$THESIS_NAME/obsidian"
mkdir -p "$THESIS_NAME/conversion"

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

# Create example Obsidian file
cat > "$THESIS_NAME/obsidian/example_obsidian_note.md" << 'EOF'
# Obsidian Example Note

This is an example note showing how Obsidian wiki-links work and how they will be converted.

## Wiki Links

In Obsidian, you can create links to other notes like this:
- Simple link: [[Background]]
- Link with custom text: [[Background|theoretical background]]
- Link to section: [[Methodology#data-analysis]]

## Images

Images in Obsidian can be included like this:
![[sample-image.png]]

Or with custom alt text:
![[sample-image.png|My Sample Image]]

## Citations

For citations, you should use standard LaTeX citations in your Obsidian notes:
According to Smith \cite{smith2023}, this approach has several advantages.

Multiple citations can be grouped \cite{smith2023, johnson2022}.

## When You're Ready

After placing your Obsidian Markdown files in this directory, run the conversion script:
```bash
cd ../conversion
./obsidian-to-umdoc.sh
```

This will:
1. Copy your files to the chapters directory
2. Convert wiki-links to standard Markdown cross-references
3. Copy referenced images to the images directory
EOF

# Create a sample image for the example
cat > "$THESIS_NAME/obsidian/sample-image.png" << 'EOF'
89504e470d0a1a0a0000000d4948445200000064000000640806000000c673b8a000000006624b474400ff00ff00ffa0bda793000000097048597300000b1300000b1301009a9c180000000774494d4507e7030f072c1b71f35ec80000000d69545874436f6d6d656e740000000000000000f40000001249444154780100000000ffffc80000001000000049454e44ae426082
EOF

# Create README files for each directory
cat > "$THESIS_NAME/README.md" << 'EOF'
# Bachelor Thesis with umdoc

This directory contains all files for your bachelor thesis project using umdoc.

## Directory Structure

- `chapters/`: Your thesis chapters (final Markdown files)
- `obsidian/`: Put your Obsidian Markdown files here
- `images/`: Store images here
- `tex/`: LaTeX style files and templates
- `conversion/`: Scripts for converting Obsidian to umdoc format

## Usage

1. If you're using Obsidian, place your Markdown files in the `obsidian/` directory
2. Run `conversion/obsidian-to-umdoc.sh` to convert them to the proper format
3. Edit your chapters in the `chapters/` directory
4. Build your thesis PDF by running `./build.sh`

## Important Files

- `umdoc.xml`: Main configuration file for umdoc
- `references.bib`: Your bibliography in BibTeX format
- `build.sh`: Script to generate the PDF
EOF

cat > "$THESIS_NAME/chapters/README.md" << 'EOF'
# Chapters Directory

This directory contains the final Markdown files for your thesis chapters.

If you're using Obsidian, do not edit these files directly. Instead:
1. Place your Obsidian files in the `../obsidian/` directory
2. Run `../conversion/obsidian-to-umdoc.sh` to process them
3. The processed files will appear in this directory

If you're writing directly in standard Markdown format, you can edit these files directly.
EOF

cat > "$THESIS_NAME/obsidian/README.md" << 'EOF'
# Obsidian Directory

Place your Obsidian Markdown files in this directory.

After adding your files here, run the conversion script to process them:
```bash
cd ../conversion
./obsidian-to-umdoc.sh
```

This will:
1. Copy your files to the chapters directory
2. Convert wiki-links to standard Markdown cross-references
3. Copy referenced images to the images directory

See `example_obsidian_note.md` for examples of how to format your Obsidian notes for proper conversion.
EOF

cat > "$THESIS_NAME/conversion/README.md" << 'EOF'
# Conversion Scripts

This directory contains scripts for converting Obsidian Markdown to umdoc-compatible format.

## Available Scripts

- `obsidian-to-umdoc.sh`: Copies files from `../obsidian/` to `../chapters/` and converts the format
- `convert-links.sh`: Converts wiki-links in existing files in the `../chapters/` directory

## Usage

If you're using Obsidian:
```bash
./obsidian-to-umdoc.sh
```

If you've manually edited files in the chapters directory and need to convert links:
```bash
./convert-links.sh
```
EOF

cat > "$THESIS_NAME/images/README.md" << 'EOF'
# Images Directory

Store all your thesis images in this directory.

When referencing images in your Markdown files, use relative paths from the chapters directory:

```markdown
![Image Caption](../images/my-image.png)
```

Or for figures with captions:

```markdown
![Figure Caption](../images/my-figure.png) {#figure-id}
```

You can then reference the figure elsewhere with:
```markdown
As shown in [Figure #](#figure-id), the results indicate...
```
EOF

# Create helper scripts
cat > "$THESIS_NAME/build.sh" << EOF
#!/bin/bash

# Build the thesis PDF
$UMDOC_PATH umdoc.xml

echo "Thesis build complete. Check umdoc.pdf for the result."
EOF
chmod +x "$THESIS_NAME/build.sh"

# Create Obsidian link converter
cat > "$THESIS_NAME/conversion/convert-links.sh" << 'EOF'
#!/bin/bash

# This script converts Obsidian wiki-links to standard Markdown links

for file in ../chapters/*.md; do
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
chmod +x "$THESIS_NAME/conversion/convert-links.sh"

# Create Obsidian to umdoc conversion script
cat > "$THESIS_NAME/conversion/obsidian-to-umdoc.sh" << 'EOF'
#!/bin/bash

# This script copies files from the obsidian directory to the chapters directory
# and converts wiki-links to standard Markdown links

OBSIDIAN_DIR="../obsidian"
CHAPTERS_DIR="../chapters"

# Check if obsidian directory contains files
if [ ! "$(ls -A "$OBSIDIAN_DIR" 2>/dev/null)" ]; then
  echo "Error: Obsidian directory is empty or doesn't exist."
  echo "Please add your Obsidian markdown files to the 'obsidian' directory first."
  exit 1
fi

# Copy all files from obsidian directory to chapters
echo "Copying Markdown files from obsidian directory to chapters..."
cp "$OBSIDIAN_DIR"/*.md "$CHAPTERS_DIR"/ 2>/dev/null

# Convert all files in chapters directory
echo "Converting wiki-links in copied files..."
for file in "$CHAPTERS_DIR"/*.md; do
  if [ -f "$file" ]; then
    echo "Processing $file..."
    
    # Convert [[Link]] format
    sed -i -E 's/\[\[([^|#]*)(\|([^#]*))?\]\]/[\3](#\1)/g' "$file"
    
    # Convert image links
    sed -i -E 's/!\[\[([^|]*)(\|([^#]*))?\]\]/![\3](\1)/g' "$file"
    
    # Copy referenced images if they exist
    for img in $(grep -oE '!\[[^\]]*\]\([^)]+\)' "$file" | grep -oE '\([^)]+\)' | tr -d '()'); do
      if [ -f "$OBSIDIAN_DIR/$img" ]; then
        dir=$(dirname "../images/$img")
        mkdir -p "$dir"
        cp "$OBSIDIAN_DIR/$img" "../images/$img"
        echo "  Copied image: $img"
      fi
    done
  fi
done

echo "Conversion complete. Files are ready in the chapters directory."
EOF
chmod +x "$THESIS_NAME/conversion/obsidian-to-umdoc.sh"

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
