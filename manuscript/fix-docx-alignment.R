#!/usr/bin/env Rscript
# Fixes two Quarto/Pandoc docx-writer quirks in the rendered manuscript that
# no apaquarto lua filter can reach, because both are inserted by pandoc's
# own docx writer after every registered filter has already run:
#
#   1. A captioned/cross-referenced code chunk is wrapped as a "float" the
#      same way a figure is, and gets a `<w:jc w:val="center"/>` written
#      directly onto its SourceCode-styled paragraphs -- overriding the
#      SourceCode style's own `w:jc="left"`, since an inline paragraph
#      property always wins over the style it points at. Code should stay
#      left-aligned, so this is stripped back out.
#   2. A data table's `<w:tbl>` gets no `<w:jc>` in its `<w:tblPr>` at all, so
#      any table narrower than the page (which is most of them) renders
#      flush left instead of centered.
#
# This project runs it as a `project: post-render` script (see _quarto.yml),
# patching word/document.xml inside manuscript/ms.docx after quarto/pandoc
# have finished writing it.

docx_path <- "manuscript/ms.docx"
if (!file.exists(docx_path)) {
  quit(save = "no", status = 0)
}
docx_path_abs <- normalizePath(docx_path)

# The {zip} package (not the system zip/unzip binaries, which the Nix CI
# environment does not otherwise need) both reads and writes the archive, so
# this has no external dependency beyond the R packages already in use here.
tmp_dir <- tempfile("docx-align-fix-")
dir.create(tmp_dir)
on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)

zip::unzip(docx_path, exdir = tmp_dir)
doc_path <- file.path(tmp_dir, "word", "document.xml")
xml <- paste(readLines(doc_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

# 1. Source code listings: drop the inline center override, leaving the
# SourceCode style's own left alignment in effect.
fixed <- gsub(
  '(<w:pStyle w:val="SourceCode"\\s*/>)<w:jc w:val="center"\\s*/>',
  "\\1",
  xml,
  perl = TRUE
)

# 2. Data tables: center every <w:tbl> that is not a code listing (no
# SourceCode paragraph inside it) and that has no w:jc of its own yet.
m <- gregexpr("(?s)<w:tbl>.*?</w:tbl>", fixed, perl = TRUE)
matches <- regmatches(fixed, m)[[1]]
if (length(matches) > 0) {
  matches <- vapply(matches, function(tbl) {
    if (grepl("SourceCode", tbl, fixed = TRUE)) return(tbl)
    if (grepl("<w:jc ", tbl, fixed = TRUE)) return(tbl)
    sub("<w:tblPr>", '<w:tblPr><w:jc w:val="center"/>', tbl, fixed = TRUE)
  }, character(1), USE.NAMES = FALSE)
  regmatches(fixed, m)[[1]] <- matches
}

if (identical(fixed, xml)) {
  quit(save = "no", status = 0)
}

writeLines(fixed, doc_path, useBytes = TRUE)

# Re-zip in place, with entries relative to the archive root.
entries <- list.files(tmp_dir, recursive = TRUE, all.files = TRUE)
zip::zip(docx_path_abs, files = entries, root = tmp_dir)
