package Term::ReadLine::Perl;
use Carp;
@ISA = qw(Term::ReadLine::Stub);
#require 'readline.pl';

$VERSION = $VERSION = 0.93;

# 0.93: Now falls back to Term::ReadLine::Stub for the second interface.

sub readline {
  shift; 
  #my $in = 
  &readline::readline(@_);
  #$loaded = defined &Term::ReadKey::ReadKey;
  #print STDOUT "\nrl=`$in', loaded = `$loaded'\n";
  #if (ref \$in eq 'GLOB') {	# Bug under debugger
  #  ($in = "$in") =~ s/^\*(\w+::)+//;
  #}
  #print STDOUT "rl=`$in'\n";
  #$in;
}

#sub addhistory {}
*addhistory = \&AddHistory;

#$term;
$readline::minlength = 1;	# To peacify -w
$readline::rl_readline_name = undef; # To peacify -w
$readline::rl_basic_word_break_characters = undef; # To peacify -w

sub new {
  if (defined $term) {
    warn "Cannot create second readline interface, falling back to dumb.\n";
    return Term::ReadLine::Stub::new @_;
  }
  shift;			# Package
  if (@_) {
    if ($term) {
      warn "Ignoring name of second readline interface.\n" if defined $term;
      shift;
    } else {
      $readline::rl_readline_name = shift; # Name
    }
  }
  if (!@_) {
    if (!defined $term) {
      ($IN,$OUT) = Term::ReadLine->findConsole();
      open(IN,"<$IN") || croak "Cannot open $IN for read";
      open(OUT,">$OUT") || croak "Cannot open $OUT for write";
      $readline::term_IN = \*IN;
      $readline::term_OUT = \*OUT;
    }
  } else {
    if (defined $term and ($term->IN ne $_[0] or $term->OUT ne $_[1]) ) {
      croak "Request for a second readline interface with different terminal";
    }
    $readline::term_IN = shift;
    $readline::term_OUT = shift;    
  }
  eval {require Term::ReadLine::readline}; die $@ if $@;
  # The following is here since it is mostly used for perl input:
  $readline::rl_basic_word_break_characters .= '-:+/*,[])}';
  $term = bless [$readline::term_IN,$readline::term_OUT];
}
sub ReadLine {'Term::ReadLine::readline_pl'}
sub MinLine { shift; $readline::minlength = shift }
sub SetHistory {
  shift;
  @readline::rl_History = @_;
  $readline::rl_HistoryIndex = @readline::rl_History;
}
sub GetHistory {
  @readline::rl_History;
}
sub AddHistory {
  shift;
  push @readline::rl_History, @_;
  $readline::rl_HistoryIndex = @readline::rl_History + @_;
}
%features =  (appname => 1, minline => 1, autohistory => 1, getHistory => 1,
	      setHistory => 1, addHistory => 1, preput => 1, tkRunning => 1);
sub Features { \%features; }
