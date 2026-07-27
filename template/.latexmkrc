# latexmk configuration
#   out/      final PDF (and synctex)
#   out/aux/  every auxiliary file
# Build from this directory with:  latexmk -pdf main.tex

use Cwd qw(abs_path);
use File::Path qw(make_path);

$out_dir  = 'out';
$aux_dir  = 'out/aux';
$pdf_mode = 1;

# Create the build directories up front. Without this, the first run after a
# "latexmk -C" finds no out/aux/, pdflatex fails on -output-directory and
# latexmk falls back to writing every auxiliary file into the project root.
make_path($aux_dir);

# Two-column "Index of Definitions" styling. The absolute path makes makeindex
# find the style file no matter which directory it is invoked from.
my $index_style = abs_path('style/index.ist');
$makeindex = "makeindex -s \"$index_style\" %O -o %D %S";
