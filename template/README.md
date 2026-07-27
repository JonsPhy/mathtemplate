# LaTeX Project Template

A ready-to-use setup for longer mathematics and physics documents: lecture
notes, theses, seminar reports and exercise sheets. Everything shared lives in
`style/`, so `main.tex` stays a table of contents for your document.

## Quick start

```bash
cp -r mathtemplate/template my-new-project
cd my-new-project
# edit metadata.tex, then:
latexmk -pdf main.tex        # -> out/main.pdf
```

Build a single exercise sheet with `latexmk -pdf exercises/sheet01.tex` and the
slide deck with `latexmk -pdf slides/slides.tex`. Clean everything with
`latexmk -C`. Building from inside `exercises/` or `slides/` works too — those
folders carry their own `.latexmkrc` pointing at the same `out/`.

## Editor setup

`.vscode/settings.json` makes LaTeX Workshop build into `out/` and `out/aux/`.

**VS Code only reads it when this project folder is the workspace root.** If you
open a parent folder instead, LaTeX Workshop falls back to its default recipe,
which passes `-outdir` on the command line — and that overrides `.latexmkrc`, so
every auxiliary file lands next to `main.tex`. Either open the project folder
directly, or copy these two entries into your workspace settings:

```json
"latex-workshop.latex.outDir": "%DIR%/out",
"latex-workshop.latex.tools": [{
    "name": "latexmk",
    "command": "latexmk",
    "args": ["-synctex=1", "-interaction=nonstopmode", "-file-line-error",
             "-pdf", "-outdir=%DIR%/out", "-auxdir=%DIR%/out/aux", "%DOC%"]
}]
```

`%DIR%` is the folder of the root `.tex` file, so this stays correct for every
project in the workspace.

## Layout

```
main.tex             document skeleton: title page, chapters, back matter
metadata.tex         title, author, institution, logo, bibliography file
CLAUDE.md            reference for the commands and conventions below
.latexmkrc           build configuration (out/ and out/aux/)
content/             one file per chapter, \input from main.tex
exercises/           standalone exercise sheets (own document class)
slides/slides.tex    beamer deck reusing the same commands and metadata
ref/references.bib   bibliography database
figures/             figures, logos, imported PDFs (\graphicspath is set)
out/                 build output: out/main.pdf, aux files in out/aux/
style/
  project.sty        packages, layout, title page, bibliography, index
  slides.sty         the same command set for beamer presentations
  palette.tex        every colour and box frame, for the box looks
  commands.tex       math shorthands (\N, \R, ...) and \permu
  theorems.tex       the documented command set; picks one of:
  theorems-boxed.tex   ... tcolorbox rendering (colour / mono)
  theorems-paper.tex   ... amsthm rendering (paper)
  exercises.tex      exercise and homework commands; picks one of:
  exercises-boxed.tex  ... boxed rendering
  exercises-paper.tex  ... amsthm rendering
  index.ist          makeindex style for the two-column definition index
```

## Package options

Set them where `style/project` is loaded in `main.tex`:

| Option | Effect |
|---|---|
| `final` | *(default)* the version you hand in: no watermark, `\todo` notes hidden |
| `draft` | light DRAFT watermark behind the text, footer with the compilation date, `\todo` notes visible |
| `paper` | **no boxes at all** — plain `amsthm` environments, bold run-in headings, italic statements, QED square, black and white, indented paragraphs: the standard layout of a mathematics or physics paper. Alias: `serious` |
| `mono` | keeps the boxes but renders them in greys with thin frames. Alias: `bw` |
| `colour` | one hue per box type. Alias: `color` |
| `noindent` | no first-line indent, paragraphs separated by space |
| `indent` | classic indented paragraphs |
| `biblatex` | *(default)* biblatex + biber, author-only italic citations |
| `bibtex` | natbib + bibtex, using `\projectbibliographystyle` |
| `index` | *(default)* collect definitions into an "Index of Definitions" |
| `noindex` | no index at all |

The look defaults to **`paper` when the document is final and `colour` while
drafting**, so the two commands you actually need are:

```latex
\usepackage[draft]{style/project}    % while writing: colour boxes, watermark, todos
\usepackage{style/project}           % what you hand in: a plain, boxless paper
```

Naming a look explicitly always wins, in either mode — `[draft,paper]` gives a
watermarked copy of the final layout, `[mono]` gives grey boxes, and so on.
The paragraph style follows the look (indented on paper, spaced otherwise)
unless you pass `indent` or `noindent` yourself.

Your content never changes: `\defn`, `\thmpr`, `\ec` and the rest are the same
commands in all three looks, with the same numbering, so switching never
renumbers or rewrites anything.

Draft mode also gives you three helpers: `\todo{...}` (a visible note, prints
nothing in the final version), `\draftonly{...}` and `\finalonly{...}`.
Redefine `\projectwatermarktext` to change the watermark word.

Every colour lives in `style/palette.tex`; add a `\colorlet` there rather than
hard-coding a colour anywhere else.

## Content commands

Numbered environments, all sharing one counter numbered within the section:

| Command | Environment |
|---|---|
| `\defn{Title}{body}` | Definition (red) — the title is indexed automatically |
| `\thm{Title}{body}` | Theorem (purple) |
| `\lem{Title}{body}` | Lemma (violet) — an empty title renders just "Lemma" |
| `\cor{body}` / `\prop{body}` | Corollary (orange) / Proposition (yellow) |
| `\fact{body}` | Fact (blue) |
| `\clm{Title}{body}` | Claim (pink, unnumbered) |
| `\exercise{Title}{body}` / `\hw{Title}{body}` | Exercise (teal) / Homework (green) |

(The colours in brackets are the `colour` look. In `mono` every box is white
with a grey title bar; in `paper` there are no boxes — a `\thm` becomes a bold
run-in "Theorem 2.1 (Title)." with the statement in italics, and `\pf` becomes
the standard `proof` environment with a QED square.)

Suffixes combine: `r` adds a label argument (`\thmr{Title}{label}{body}` →
`\ref{thm:label}`), `p` attaches a matching proof block
(`\lemp{Title}{body}{proof}`), `pr` does both
(`\thmpr{Title}{label}{body}{proof}`).

Unnumbered blocks (a coloured side rule in the box looks, a plain run-in
heading on paper): `\ex{body}` (example),
`\rmkb{body}` (remark), `\factb{body}` (fact), `\pf{body}` (proof) and
`\rmk{text}` (inline italic aside).

Solved exercise sheets: `\ec{Title}{statement}{answer}` for a single answer, and
`\ecs{Title}{statement}{parts}` with `\ecpart{question}{answer}` for a), b), …
subtasks.

Helpers: `\projectquote{...}` for a chapter epigraph, `\makesheettitle{...}` for
an exercise-sheet header, `\permu{1,2,3}{2,3,1}` for permutation diagrams, plus
the usual `\N \Z \Q \R \C \D \E \I \bs \diag \lcm`.

All body arguments are declared `+m`, so `align*`, `itemize`, `tikzpicture` and
friends work inside them. Two consequences: don't put `\verb` in a body (write
`\texttt{\textbackslash cmd}` instead), and inside `tikzcd` use
`[ampersand replacement=\&]`.

## Slides

`slides/slides.tex` is a beamer deck that loads `style/slides` instead of
`style/project`. It gives you **the same commands** — `\defn`, `\thm`, `\lemp`,
`\ex`, `\rmkb`, `\ec`, `\permu`, `\N`, `\R`, … — and reads `metadata.tex`, so a
talk never drifts from the notes. It takes the same `draft` and look options,
but defaults to `colour` whether or not you are drafting — boxes are what a
projector needs. Pass `[paper]` for a boxless deck.

Two ways to build a deck:

```latex
% 1. write the frame, paste anything from content/ into it
\begin{frame}{The boxes you already use}
    \defn{Template idea}{Keep recurring setup in one place.}
\end{frame}

% 2. pull in a whole chapter and let it flow across slides
\begin{frame}[allowframebreaks]{Foundations}
    \inputcontent{content/02_foundations}
\end{frame}
```

Inside `\inputcontent` the file's `\chapter` is dropped (the frame title already
names it), every `\section` starts a new slide with a bold heading, and
`\subsection` becomes a run-in heading. Also available: `\makeslidetitle`
(title slide from the metadata, optional argument overrides the subtitle) and
`\sectionframe{Title}` (divider slide).

## Cross-references and the index

Because every numbered environment shares one counter, cleveref cannot infer
the type name in the box looks. Use plain `\ref{thm:label}` and write the word yourself:
`Theorem~\ref{thm:sample}`.

`\defn` indexes its title. Use `\defn[key]{Title}{body}` to index a different
key and `\defn[-]{Title}{body}` to skip the entry; `\index{parent!child}` inside
a body adds subentries. The index is typeset in two columns via
`style/index.ist`, which `.latexmkrc` hands to makeindex.

## Notes

* The `report` class is a good middle ground for theses and longer notes; the
  `\frontmatter` / `\mainmatter` / `\backmatter` helpers come from
  `style/project.sty`.
* Regular `amsthm` environments still work alongside the boxes.
* `physics`, `siunitx`, `ytableau` and `slashed` are loaded for
  physics-flavoured documents. Drop the ones you don't need centrally in
  `style/project.sty`.
* Generated files never touch the project root: the PDF goes to `out/`, all
  auxiliary files to `out/aux/`. Both are ignored by `.gitignore`. If you ever
  see `main.aux` next to `main.tex`, something passed `-outdir` on the command
  line — see *Editor setup* above.
* Figures work from any depth. `\graphicspath` covers `figures/` seen from the
  root and from `exercises/` or `slides/`, and the title-page logo is resolved
  by `\projectfindfile` — `\IfFileExists` alone would disagree with
  `\includegraphics` for documents outside the project root.
* In the box looks, slide boxes are unbreakable — if one overflows, split the
  frame or add `[allowframebreaks]`.
* Adding a new box type means adding it to *both* `theorems-boxed.tex` and
  `theorems-paper.tex`, so every look keeps the same command set.
* Beamer's own `example` and `fact` blocks are cleared in `style/slides.sty` so
  that the project versions of those names win.
