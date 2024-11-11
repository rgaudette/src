$var = `pwd`;
chomp $var;
print "Curr dir $var\n";
$listing = `ls *.bat`;
chomp $listing;
print "$listing\n";

$out = `which Test_AlignmentTransformer`;
chomp $out;
print "$out\n";