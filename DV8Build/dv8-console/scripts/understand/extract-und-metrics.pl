#
#  Extract metrics from a udb file
#  Copyright (c) 2020, ArchDia LLC.
#  All rights reserved.
#
sub usage($) {
    return shift(@_) . <<"END_USAGE";
Usage: $0 -db database
  -db database      Specify Understand database (required for
                    uperl, inherited from Understand)
  -outputFile       Specify the output csv file
  -language         Language filter, default don't filter. Possible values include "Ada", "C", "C#", "Fortran", "Java", "Jovial", "Pascal",
                      "Plm", "VHDL" and "Web". C++ is included as part of "C".
END_USAGE
}

use Understand;
use Getopt::Long;
use strict;
use Data::Dumper;
use File::Basename;

my $LANG = "language";
my $FILENAME = "filename";
my $LOC = "LOC";

my $dbPath;
my $outputFile;
my $languageFilter;
my $help;

GetOptions(
  "db=s" => \$dbPath,
  "language=s" => \$languageFilter,
  "outputFile=s"  => \$outputFile,
  "help" => \$help,
);

# help message
die usage("") if ($help);

die usage("Please specify output csv file\n") unless ($outputFile);

$| = 1;

# open the database
print "Parsing metrics ...";
my $db=openDatabase($dbPath);
print "\rParsing metrics Done\n";

#code body*******************************************************************

print "\rExtracting metrics ...";

my @metrics;
my @ents = $db->ents("file ~unresolved ~unknown");
my @references;

foreach my $ent (@ents) {
  next if($languageFilter && ($languageFilter ne $ent->language));
  my $count_line = $ent->metric("CountLine");
  my %metric = (
    $LANG => $ent->language,
    $FILENAME => $ent->longname,
    $LOC => $count_line
  );
  push @metrics, \%metric;
}

print "\rExtracting metrics Done\n";

print "Exporting metrics ...";

print_metrics_csv(@metrics);

print "\rExporting metrics Done\n";

#end body********************************************************************
closeDatabase($db);

sub print_metrics_csv {
  my (@_metrics) = @_;
  my ($delimiter) = ",";
  open(FILE,">$outputFile") || die("Couldn't write to output csv file. $!");
  print FILE $LANG.$delimiter.$FILENAME.$delimiter.$LOC."\n";
  foreach my $metric (@_metrics) {
    my $filename = $metric->{$FILENAME};
    print FILE $metric->{$LANG}.$delimiter.$filename.$delimiter.$metric->{$LOC};
    print FILE "\n";
  }
}

sub openDatabase($)
{
    my ($dbPath) = @_;

    my $db = Understand::Gui::db();

    # path not allowed if opened by understand
    if ($db&&$dbPath) {
  die "database already opened by GUI, don't use -db option\n";
    }

    # open database if not already open
    if (!$db) {
  my $status;
  die usage("Error, database not specified\n\n") unless ($dbPath);
  ($db,$status)=Understand::open($dbPath);
  die "Error opening database: ",$status,"\n" if $status;
    }
    return($db);
}

sub closeDatabase($)
{
    my ($db)=@_;

    # close database only if we opened it
    $db->close() if $dbPath;
}