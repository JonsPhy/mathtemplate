# LaTeX Project Template

This template combines the structure of `BachelorThesis` with the reusable math-note tooling from `liegroups`.

## Structure

* `main.tex` - main entry point
* `.latexmkrc` - sends build artifacts to `out/`
* `metadata.tex` - project metadata and title-page content
* `style/project.sty` - packages, layout, headers, and shared defaults
* `style/commands.tex` - personal math commands and helper macros
* `style/theorems.tex` - theorem boxes and proof helpers
* `content/` - chapter files
* `ref/references.bib` - bibliography database
* `figures/` - figures and logos

## Workflow

1. Copy `template/` to a new project directory.
2. Adjust the fields in `metadata.tex`.
3. Add or rename chapter files in `content/`.
4. Put bibliography entries into `ref/references.bib`.
5. Compile with `latexmk -pdf main.tex`.

## Notes

* The template uses `report` as a good middle ground for thesis-style documents and longer notes.
* The theorem boxes from the notes project are included, but regular theorem environments still work.
* `physics` is loaded because it appeared in your thesis workflow. If it ever clashes with a package in a future project, remove it centrally in `style/project.sty`.
* Generated files such as `.aux`, `.bbl`, `.log`, and the final PDF are written to `out/`.
