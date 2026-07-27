# Project guide

> Template file. Fill in the *Project* section for the concrete document, keep
> the rest as the reference for the shared LaTeX tooling.

## Project

- **Title:** _(see `metadata.tex`)_
- **Course / thesis:** _..._
- **Author:** _..._
- Built with `latexmk`; PDF in `out/`, auxiliary files in `out/aux/`.

## Where content goes

| Path | Purpose |
|---|---|
| `content/NN_name.tex` | one file per chapter, wired into `main.tex` |
| `exercises/sheetNN.tex` | standalone exercise sheets (compile individually) |
| `slides/slides.tex` | beamer deck, same commands and metadata |
| `ref/references.bib` | bibliography database |
| `figures/` | figures, logos, imported PDFs |
| `style/` | packages, macros, theorem boxes — shared setup |
| `style/palette.tex` | every colour and box frame, for both looks |

New chapter: add `content/NN_name.tex` and an `\input{content/NN_name}` line in
`main.tex`.

## Rendering modes

Set as options where `style/project` is loaded in `main.tex`. They change only
the rendering — never write different content because of the mode.

| Option | Effect |
|---|---|
| `final` / `draft` | the version to hand in, or a DRAFT watermark plus visible `\todo{...}` notes |
| `paper` | **no boxes**: plain `amsthm` environments, bold run-in headings, italic statements, QED square, black and white, indented paragraphs (alias `serious`) |
| `mono` | the boxes, in greys (alias `bw`) |
| `colour` | one hue per box type (alias `color`) |

The look defaults to `paper` when final and `colour` when drafting; naming one
explicitly always wins. Draft-only helpers: `\todo{note}`, `\draftonly{...}`,
`\finalonly{...}`.

The command set is implemented twice — `style/theorems-boxed.tex` (tcolorbox)
and `style/theorems-paper.tex` (amsthm), likewise for the exercises — and
`style/theorems.tex` picks one. **A new box type has to be added to both
files**, with the same numbering, so all looks stay interchangeable. Never
hard-code a colour: add a `\colorlet` to `style/palette.tex`.

## Slides

`slides/slides.tex` loads `style/slides` (not `style/project`) and defines the
same commands, so content can be pasted or imported unchanged:

```latex
\begin{frame}[allowframebreaks]{Foundations}
    \inputcontent{content/02_foundations}
\end{frame}
```

Inside `\inputcontent`, `\chapter` is dropped, each `\section` starts a new
slide, `\subsection` becomes a run-in heading. Also `\makeslidetitle[Subtitle]`
and `\sectionframe{Title}`. Boxes are unbreakable on slides — split the frame
if one overflows.

## Structure conventions

```latex
\chapter{Title}
\section{Title}
\subsection{Title}
```

- **Sentence case** for all headings: capitalize the first word and proper nouns
  only ("Basic group theory", "The Killing form").
- A chapter is either fully divided into `\section`s or has none — don't mix.
- **Never leave a lone subsection:** a section has either 0 or ≥2 subsections.
- Keep granularity coarse, roughly one section per several PDF pages. Promote or
  merge rather than over-splitting.
- Chapter epigraph: `\projectquote{``Quote text.''}`.

## Theorem commands (`style/theorems.tex`)

(The "Colour" column is the `colour` look; in `mono` every box is white with a
grey title bar, and in `paper` there are no boxes at all.)

| Command | Renders as | Colour | Notes |
|---|---|---|---|
| `\defn{Title}{body}` | Definition | red | auto-indexes the title |
| `\defn[key]{Title}{body}` | Definition | red | index under `key`; `[-]` suppresses |
| `\defnr{Title}{label}{body}` | Definition (referenceable) | red | `\ref{defn:label}` |
| `\thm{Title}{body}` | Theorem | purple | |
| `\thmr{Title}{label}{body}` | Theorem (referenceable) | purple | `\ref{thm:label}` |
| `\thmp{Title}{body}{proof}` | Theorem + proof | purple | |
| `\thmpr{Title}{label}{body}{proof}` | Theorem + proof (referenceable) | purple | |
| `\lem{Title}{body}` | Lemma | violet | empty title → just "Lemma" |
| `\lemr` / `\lemp` / `\lempr` | Lemma variants | violet | |
| `\cor{body}` | Corollary | orange | no title |
| `\corr{label}{body}`, `\corp{body}{proof}` | Corollary variants | orange | |
| `\prop{body}` | Proposition | yellow | no title |
| `\propr{label}{body}`, `\propp{body}{proof}` | Proposition variants | yellow | |
| `\clm{Title}{body}`, `\clmp{Title}{body}{proof}` | Claim | pink | unnumbered |
| `\fact{body}` | Fact | blue box | numbered |
| `\factb{body}` | Fact | cyan side rule | unnumbered, styled like a remark |
| `\pf{body}` | Proof block | grey side rule | standalone proof |
| `\ex{body}` | Example | cyan side rule | |
| `\rmk{text}` | Inline remark | blue italic | |
| `\rmkb{body}` | Remark block | cyan side rule | |
| `\exercise{Title}{body}` | Exercise | teal | statement only |
| `\hw{Title}{body}` | Homework | green | statement only |
| `\ec{Title}{body}{answer}` | Exercise + answer | teal | |
| `\ecs{Title}{body}{parts}` | Exercise + a), b), … | teal | parts are `\ecpart{q}{a}` |

Body arguments are `+m` (verbatim), so `align*`, `itemize`, `tikzpicture` etc.
work inside them without bracing tricks.

## Cross-references

All numbered boxes share the `mydefinition` counter, so cleveref cannot infer a
type name — `\cref{thm:label}` renders as "?? 3.2.12". Use plain
`\ref{thm:label}` and write the word yourself: "Maschke's theorem,
\ref{thm:maschke}".

## Packages available

`amsmath`, `mathtools`, `amssymb`, `amsthm`, `mathrsfs`, `physics`, `siunitx`,
`ytableau`, `slashed`, `tikz` (`arrows.meta`, `calc`, `cd`, `hobby`,
`decorations.pathreplacing`), `pgfplots`, `tcolorbox`, `xcolor`, `enumitem`,
`hyperref`, `cleveref`, `makeidx` + `idxlayout`, `biblatex`, `listings`.

## Citations

`\cite{key}` → italic author name; `\citep{key}` → "(Author)";
`\cite[Chapter~5]{key}` adds a postnote; `\cite[pre][post]{key}` for both.

## Known LaTeX gotchas

- **No trailing `%`** after the opening brace of a box command — write `\rmkb{`,
  not `\rmkb{%`. The boxes trim leading whitespace anyway.
- **tikzcd inside a box command:** bodies are verbatim, so `&` gets the wrong
  catcode ("Single ampersand used with wrong catcode"). Use
  `\begin{tikzcd}[ampersand replacement=\&]` and `\&` between cells.
- **tikzcd edge labels:** avoid quoted labels containing macros, `^` or `?`
  (`\arrow[dr,"e^{ix}"]`) — they break tikz-cd's node naming ("Missing
  \endcsname"). Leave the arrow unlabeled and explain in prose.
- Put tikzcd diagrams in a `center` environment, not inside `\[ ... \]`.
- Index entries inside a body: `\index{term}`, `\index{parent!child}`.
- **`\verb` does not work inside a box body** (the bodies are arguments) — write
  `\texttt{\textbackslash cmd}` instead.
- Beamer defines its own `example` and `fact` blocks; `style/slides.sty` clears
  them before loading the project boxes. Don't reintroduce those names.
- **Never wrap `\begin{...}`/`\end{...}` in a bare `\if...\fi` inside a beamer
  frame** — the frame body is collected and re-scanned, which breaks the
  conditional ("Incomplete \ifx"). Keep the conditional inside one macro.
- **Locating files:** `\IfFileExists` searches `\input@path` (which sheets and
  slides extend with `../`), while `\includegraphics` searches `\graphicspath`.
  For anything outside the project root, resolve the path once with
  `\projectfindfile{path}` and use `\projectfoundfile`.
- Auxiliary files belong in `out/aux/`. A command-line `-outdir` beats
  `.latexmkrc`, so an editor configured elsewhere will litter the project root.
