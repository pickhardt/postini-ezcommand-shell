#!/usr/bin/env perl
# 
# PSTNCrossAuth.pm
# 
# This package is copied from the Message Security Administration Guide,
# pages 612-613.
# 
# It requires the Digest::SHA1 package, available the CPAN at http:// www.cpan.org.
# 

package PSTNCrossAuth;
use Digest::SHA1( sha1_base64 );

sub new {
    my $class = shift;
    my $self = bless {};
    $self->{secret} = shift;
    return $self;
}

sub authString {
    my $self = shift;
    my $address = shift;
    my $randAddress;
    my $sig; $randAddress = chr( rand( 26 ) + 0x41 ) . chr( rand( 26 ) + 0x41 ) . 
        chr( rand( 26 ) + 0x41 ) . chr( rand( 26 ) + 0x41 ) .
        $address;
        $sig = sha1_base64( $randAddress . $self->{secret} );
        return $sig . $randAddress;
} # return null if not good auth string, else return authenticated # address

sub checkString {
    my $self = shift;
    my $auth = shift;
    my $rand;
    my $address;
    my $sig;
    ( $sig, $rand, $address ) = unpack( 'a27a4a*', $auth );
    if ( sha1_base64( $rand . $address . $self->{secret} ) eq $sig ) {
        return $address;
    } else {
        return 0;
    }
}

sub main::PSTN_authString {
    my $address = shift;
    my $secret = shift;
    my $auth = new PSTNCrossAuth( $secret );
    return $auth->authString( $address );
}

sub main::PSTN_checkString {
    my $string = shift;
    my $secret = shift;
    my $auth = new PSTNCrossAuth( $secret );
    return $auth->checkString( $string );
}

sub urlEscape {
    my $line = shift;
    $line =~ s/%/%25/g;
    $line =~ s/ /%20/g;
    $line =~ s/</%3C/g;
    $line =~ s/>/%3E/g;
    $line =~ s/#/%23/g;
    $line =~ s/{/%7B/g;
    $line =~ s/}/%7D/g;
    $line =~ s/\|/%7C/g;
    $line =~ s/\\/%5C/g;
    $line =~ s/\^/%5E/g;
    $line =~ s/~/%7E/g;
    $line =~ s/\[/%5B/g;
    $line =~ s/\]/%5D/g;
    $line =~ s/`/%60/g;
    $line =~ s/;/%3B/g;
    $line =~ s/\//%2F/g;
    $line =~ s/\?/%3F/g;
    $line =~ s/:/%3A/g;
    $line =~ s/\@/%40/g;
    $line =~ s/\=/%3D/g;
    $line =~ s/\&/%26/g;
    $line =~ s/\+/%2B/g;
    return $line;
}

1; # must return a true value
