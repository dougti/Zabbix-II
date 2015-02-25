#!/usr/bin/perl

use strict;
use warnings;

my $first = 1;
my %server_list = ();

print "{\n";
print "\t\"data\":[\n\n";

for (`cat /etc/fstab`)
 {
  next if m/^\#.*$/;
  next if m/^\s*$/;
  my ($share,$mountpoint,$fstype) = m/^\s*(\S+)\s+(\S+)\s+(\S+)\s.*$/;
  next if $fstype ne "cifs" and $fstype ne "davfs";
  #  print "\t,\n" if not $first;
  #  $first = 0;
  my ($server) = $share =~ m/^\S+\/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*$/s;
  $server_list{$server} = $share;
  #  print "\t{\n";
  #  print "\t\t\"{#SERVER}\":\"$server\",\n";
  #  print "\t}\n";
  #  print "server: $server, mountpoint: $mountpoint, fstype: $fstype\n";
  }

  foreach my $key (keys %server_list) {
  print "\t,\n" if not $first;
  $first = 0;

  print "\t{\n";
  print "\t\t\"{#SERVER}\":\"$key\",\n";
  my $fstype = ($server_list{$key} =~ m/^\/\/\S+$/s ? "cifs" : "davfs");
  print "\t\t\"{#SERVERTYPE}\":\"$fstype\",\n";
  print "\t\t\"{#SERVERSHARE}\":\"$server_list{$key}\"\n";
  print "\t}\n";
}

print "\n\t]\n";
print "}\n";
