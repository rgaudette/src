#!/usr/bin/perl
use Cwd;
$this_dir = getcwd;
print "Current working directory: $this_dir\n";
$btpw = `pwd`;
print "Backtick pwd: $btpw\n";

# Change the current directory and repeat
$retval = chdir("A Folder");
print "Return value: $retval\n";

$this_dir = getcwd;
print "Current working directory: $this_dir\n";
$btpw = `pwd`;
print "Backtick pwd: $btpw\n";

print "cypath conversion to mixed\n";
system("cygpath --mixed $this_dir") == 0
or die("cygpath command failed when creating C++ regression test data dir\n$?");
print "$?\n";
$cygpath_out = $?;
chomp($cygpath_out);
print "out: $cygpath_out \n";