#!/usr/bin/perl -w
# WHAT: control vlc from vim for lrc/srt editing and synch
# telnet.pl from perlmonks, modified to work with vlc remote control.
# see https://wiki.videolan.org/Talk:Console/ vlc command line commands
# GPL(C) moshahmed at gmail 2013-08-22
# $Id: vlc.pl,v 1.7 2020/11/15 18:20:42 User Exp $
use strict;
use IO::Socket;

my ( $host, $port, $kidpid, $handle, $line );
( $host, $port ) = ('127.0.0.1', 2150);
my ($verbose,$debug,$cmd,$value,$linein) = (0,0,'',,'');

my $USAGE=qq{
USAGE: $0 [Options] -cmd=VLC_CMDS
WHAT: control vlc from vim 
Options:
    -port=NN  .. vlc telnet port, default is $host:$port
    -h      .. this help.
    -v      .. verbose
    -debug  .. to debug, also use ./telnet.pl to communicate with vlc
VLC_CMDS:
    play, pause, pause (toggle), stop,
    -cmd=get_length .. in h:m:seconds
    -cmd=get_time   .. in h:m:seconds
    -cmd=set_time=1:2:3.40  .. for 1hour 2minutes 3seconds (integral seconds only)
    -cmd=get_file   .. gets file:///path
    -cmd=set_file=file:///path/file.mp3
Examples:
    start c:/view/vlc/vlc.exe
    perl $0 -cmd=set_file:///c:/mosh/sound/mallige.mp3
    perl $0 -cmd=set_time=0:12      .. cue vlc to 12seconds
    vi   +":so ~/sound/vlc.vim" ~/sound/mallige.lrc
      F2/F3/F4 .. Play/Stop/Pause
      F5       .. Play file:time from cline into vlc
      F9       .. Get file:time from vlc onto cline
      F10      .. Get time from vlc onto cline
      F11      .. Get time
      F12      .. Send cfile to SendToApp()
};

# Process args
while( $_ = $ARGV[0], defined($_) && m/^-/ ){ shift; last if /^--$/; if(0){
    }elsif( m/^-[h?]$/ ){ die $USAGE;
    }elsif( m/^-v$/    ){ $verbose++;
    }elsif( m/^-debug$/    ){ $debug++;
    }elsif( m/^-port=(\d+)$/ ){ $port = $1;
    }elsif( m/^-cmd=(set_.+)=(.+)$/ ){ $cmd = $1; $value = $2;
      $value = hms_to_seconds($value);
      warn "$cmd=$value\n" if $debug;
    }elsif( m/^-cmd=(.+)$/ ){ $cmd = $1;
    }elsif( m/^-linein$/ ){ $linein=1; # read stdin (unused).
    }else{ die $USAGE,"Unknown option '$_'\n"; }
}

# foreach(@ARGV) { } .. process leftover args (unused).

# create a tcp connection to the specified host and port
$handle = IO::Socket::INET->new(
    Proto    => "tcp",
    PeerAddr => $host,
    PeerPort => $port,
    ReuseAddr => 1 # To test.
  ) or die "can't connect to port $port on $host: $!";
  $handle->autoflush(1);    # so output gets there right away
print STDERR "[Connected to $host:$port]\n" if $verbose;

# split the program into two processes, identical twins
die "can't fork: $!" unless defined( $kidpid = fork() );

if ($kidpid) { # In parent, parse reply from vlc.
    # the if{} part runs only in the parent process
    DONE:
    while ( defined( $line = <$handle> ) ) {
      if    ($cmd eq 'get_length') { 
        if( $line =~ m,^\d+,) {
          print STDOUT seconds_to_hms($line);
          last DONE;
        }
      }elsif($cmd eq 'get_time') {
        if( $line =~ m,^\d+,) {
          print STDOUT seconds_to_hms($line);
          last DONE;
        }
      }elsif($cmd eq 'get_file') {
        if( $line =~ m,(file://.*)\s[()],i ) {
          my $filename = $1;
          print STDOUT $filename;
          last DONE;
        }
      }elsif($cmd eq 'status') {
        print STDOUT $line;
        last DONE if $line =~ m,returned,;
      }elsif($cmd eq 'play') { last DONE;
      }elsif($cmd eq 'pause') { last DONE;
      }elsif($cmd eq 'stop') { last DONE;
      }else{ print STDOUT $line;
        last DONE if $line =~ m,returned,;
      }
    } # DONE
    kill( "TERM", $kidpid );    # send SIGTERM to child
    exit 0;
} else {  # In child? send cmd to vlc
    if(     $cmd eq 'status' ){ print $handle "$cmd\n";
    }elsif( $cmd eq 'play' ){ print $handle "$cmd\n";
    }elsif( $cmd eq 'pause' ){ print $handle "$cmd\n";
    }elsif( $cmd eq 'stop' ){ print $handle "$cmd\n";
    }elsif( $cmd eq 'get_time' ){ print $handle "$cmd\n";
    }elsif( $cmd eq 'get_file' ){ print $handle
        "pause\nstatus\npause\nstatus\n";
    }elsif( $cmd eq 'get_length' ){ print $handle "play\nget_length\n";
    }elsif( $cmd eq 'set_time' ){ print $handle "seek $value\n";
    }elsif( $cmd eq 'set_file' ){ print $handle "clear\nadd $value\n";
    }else{                        print $handle "$cmd\n";
    }
    exit 0;
}

sub seconds_to_hms {
  my $hourz=int($_[0]/3600);
  my $leftover=$_[0] % 3600;
  my $minz=int($leftover/60);
  my $secz=int($leftover % 60);
  if ($hourz > 0){
    return sprintf ("%d:%02d:02%d", $hourz,$minz,$secz)
  }
  # print 3 seconds as 00:03, so timestamp always has a colon.
  return sprintf ("%02d:%02d", $minz,$secz)
}

sub hms_to_seconds {
    # hms_to_seconds(1:2:3.4) => 1h.2m.3.4s = 1*3600+2*60+3 = 3723.
    my $hms = $_[0];
    if ( $hms =~ m,^(\d+):(\d+):(\d+), ) { # ignore trailing chars.
      return $1 * 3600 + $2 * 60 + $3;
    }elsif( $hms =~ m,^(\d+):(\d+), ) {
      return $1 * 60 + $2;
    }
    return $hms;
} 
