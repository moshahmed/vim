#!/usr/bin/perl -w
# WHAT: search ~/.vim_mru_files
# by moshahmed at gmail
use strict;
use Cwd;
use Time::Piece;

my $today=localtime->strftime('%Y-%m-%d_%H%M');
my(%mrufiles, $verbose, $quickfix, $skipre, $filere, $wordre);
my($dironly, %printed_dir);

my $HOME = "$ENV{HOME}" || '';
my $PWD  = getcwd();

for ($HOME, $PWD){
  s,\\,/,g; s,/cygdrive/(\w)/,$1:/,;
}

my $vim_mru_file = "${HOME}/.vim_mru_files";
my @filelist;

my $USAGE="
USAGE: ffmru.pl [options] FILERE [WORDRE] .. Print matching files/lines in ~/.vim_mru_files
  eg. ffmru mpy activate                  .. search activate in mru file /mpy/
Notes: all regex are perlre and defaulted to be case insensitive.
Options;
  -q .. pipe matching files to vim -q -
  -s/SKIPRE .. skip files matching SKIPRE
  -d .. dir only
  -v,-h .. verbose, help
";

while( $_ = $ARGV[0], defined($_) && /^-/ ){
    shift; m/^--$/ && last;
    if(     m/^-v$/        ){ $verbose++;
    }elsif( m/^-q$/        ){ $quickfix=1;
    }elsif( m,^-s/(.+)$,   ){ $skipre=$1;
    }elsif( m/^-d$/        ){ $dironly=1;
    }elsif( m/^-[?h]$/       ){ die $USAGE;
    }else{ die $USAGE."Invalid option '$_'\n";
    }
}

$filere = shift or die $USAGE;
$wordre = shift;

print STDERR "# Date: $today:\n" if $verbose;
read_mru();
print_mru();
grep_files() if $wordre;

# End of main

sub print_mru {
  foreach (sort keys %mrufiles){
    # $_ = `cygpath -wasm $_` if $_ =~ m,^\.\.,;
    chomp;
    s,\\,/,g;
    next if $skipre && m,$skipre,oi;
    next if $filere && !m/$filere/oi;
    next unless -e $_;
    if( $dironly ) {
      s,/[^/]*$,,; # basename
      next if $printed_dir{$_}++;
      next unless -d $_;
      printf "%s\n", abbrev_file($_);
    }elsif( $quickfix ) {
      next unless -T $_;
      printf "%s:1:1\n", abbrev_file($_);
    }elsif( $wordre ) {
      push(@filelist, $_);
    }else{
      printf "%s\n", abbrev_file($_);
    }
  }
}

sub grep_files {
  for my $file (@filelist) {
    open(my $fh, $file) or warn "Cannot read $file";
    while (my $line = <$fh>) {
      chomp $line;
      next unless $line =~ /$wordre/gio;
      printf "%s:%d:%s\n", abbrev_file($file),$., $line;
    }
    close $fh;
  }
}

sub abbrev_file {
  my $file = shift;
  # order is important
  $file =~ s,^$PWD/,./,io;
  $file =~ s,^$HOME/,~/,io;
  return $file;
}

sub read_mru {
  die "Cannot find vim_mru_file $vim_mru_file"
    unless -f $vim_mru_file;

  my $filename = $vim_mru_file;
  open(D,$filename ) or die "cannot read $filename \n";
  warn "# Reading $filename \n" if $verbose;
  my $count;
  while(<D>){
    chomp;
    s,\\,/,g;
    if ( m/PWD=/ ) { # dated ~/.vim_mru_files
      ($_) = split( qq/\t/, $_, 2); # keep only the first column
    }
    next unless -f $_;
    $mrufiles{$_}++;
    $count++;
  }
  printf STDERR "# Found %d files in %s\n", $count, $filename
    if $verbose;
}
