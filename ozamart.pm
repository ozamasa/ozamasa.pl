package ozamart;

use strict;
## use warnings;
use CGI::Carp qw(carpout fatalsToBrowser);
use CGI::Util qw(escape unescape);

use CGI;
use LWP::UserAgent;
use HTTP::Request::Common;

#------------------------------------------------------------------------------#
my $cgi = CGI->new;
my $ua  = new LWP::UserAgent;
#   $ua -> proxy( http  => 'http://localhost:8000' );

my $ses;

#------------------------------------------------------------------------------#
sub clickfile{
    return "ozamart_ml.txt";
}

#------------------------------------------------------------------------------#
sub param{
    my($in) = @_;

    return $cgi->param( $in );
}

#------------------------------------------------------------------------------#
sub click{
    my($body) = @_;

    my $cnt = 0;
    my $msg = "";
    if( $body eq "" ){
        my $file = &ozamart::clickfile;
        open FH, "$file";
        while( my $line = <FH> ){
	        if( index( $line, "http://" ) >= 0 ){
	            $line =~ tr/0-9a-zA-z:\/.?=+/ /cs;

	            my $spos = index( $line, "http://" );
	            my $epos = length( $line );
	               $epos = index( $line, " " ) if( index( $line, " " ) >= 0 );

	            my $url  = substr( $line, $spos, $epos - $spos );
                    $cnt++;
	            $msg .= "<li>Click $url";
	            &get( $url );
	        }
return $msg if( $cnt==150 );
NEXT_LOOP:
        }
        close FH;
    }

    return $msg;
}


#------------------------------------------------------------------------------#
sub get{
    my($url) = @_;
    my $req = GET( $url );
       $req -> header( "Cookie"  => $ses );
    my $res = $ua->request( $req );
    my $htm = $res->content;
    return $htm;
}


#------------------------------------------------------------------------------#
sub post{
    my($url, $arg) = @_;
    my $req = POST( $url, $arg );
    my $res = $ua->request( $req );
    my $htm = $res->headers_as_string;
    return $htm;
}

#------------------------------------------------------------------------------#
sub session{
    my($url, $arg) = @_;

    my $msg = "";
    my $htm = &post( $url, $arg );
    $_ = $htm;
    if( m{Set-Cookie: (.+);} ){
        $ses = $1;
        my $msg = "<li>Session $ses";
        return $msg;
    }
}

1;
