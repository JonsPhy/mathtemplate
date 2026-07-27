# Same build layout as the project root, for when latexmk is started from
# inside this folder (an editor may do that when this file is the root file).
#   ../out/      final PDF
#   ../out/aux/  every auxiliary file
# Building from the project root instead uses ../.latexmkrc and lands in the
# very same place.

use Cwd qw(abs_path);
use File::Path qw(make_path);

$out_dir  = '../out';
$aux_dir  = '../out/aux';
$pdf_mode = 1;

make_path($aux_dir);

my $index_style = abs_path('../style/index.ist');
$makeindex = "makeindex -s \"$index_style\" %O -o %D %S";
