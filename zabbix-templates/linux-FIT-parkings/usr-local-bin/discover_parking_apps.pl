#!/usr/bin/perl

use strict;
use warnings;

my $first = 1;
my $base_root="/var/www/";

print "{\n";
print "\t\"data\":[\n\n";

#  foreach my $base ("kznparking") {
#  print "\t,\n" if not $first;
#  $first = 0;
  my $base = "kznparking";

  print "\t{\n";
  print "\t\t\"{#APP_BASE}\":\"$base_root$base\",\n";
  print "\t\t\"{#APP_CITY}\":\"$base\",\n";
  print "\t\t\"{#APP}\":\"frontend_node\",\n";
  print "\t\t\"{#APP_PORT}\":\"9006\"\n";
  print "\t}\n";

  print "\t,\n";
  print "\t{\n";
  print "\t\t\"{#APP_BASE}\":\"$base_root$base\",\n";
  print "\t\t\"{#APP_CITY}\":\"$base\",\n";
  print "\t\t\"{#APP}\":\"payment\",\n";
  print "\t\t\"{#APP_PORT}\":\"9056\"\n";
  print "\t}\n";

#  }

print "\n\t]\n";
print "}\n";
