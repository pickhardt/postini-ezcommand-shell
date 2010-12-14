#!/usr/bin/env perl
#
# EZCommand Shell
# ezcommand.pl
#
# EZCommand Shell is a script allowing Postini administrators to issue
# EZCommands to Postini.
#
# For more information, see http://code.google.com/p/postini-ezcommand-shell/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

use strict;
use warnings;
use LWP::UserAgent;
use PSTNCrossAuth;
use URI::Escape;

my $AUTHOR = 'jeffpickhardt@google.com (Jeff Pickhardt)';
my $VERSION = '1.0.0';
my $LICENSE = 'Apache License 2.0 (http://www.apache.org/licenses/LICENSE-2.0)';

my $TOKEN_PATH = 'credentials.txt';

# trim($string) removes all leading and trailing whitespace from a string.
sub trim {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

# makeAuth($admin, $secret, $hostname) builds an authString and stores the credentials.
# It returns information about the credentials. Specifically, it returns the
# values of ($admin, $authString, $hostname)
sub makeAuth {
    my ($admin, $secret, $hostname) = @_;
    my $authString = '';
    if (!$admin || !$secret || !$hostname) {
        # try to authenticate from the token.txt file
        if (-e $TOKEN_PATH) {
            open(FILE, '<', $TOKEN_PATH);
            my $line = <FILE>;
            ($admin, $authString, $hostname) = split(/,/, $line);
            close FILE;
        } else {
            # ERROR!
            die('Error. No credentials provided, and the credentials file does not exist');
        }
    } else {
        my $auth = new PSTNCrossAuth($secret);
        $authString = $auth->authString($admin);
    }
    $admin = trim($admin);
    $authString = trim($authString);
    $hostname = trim($hostname);
    open(FILE2, '>', $TOKEN_PATH);
    print FILE2 $admin . ',' . $authString . ',' . $hostname;
    close FILE2;
    return ($admin, $authString, $hostname);
}

# clearAuth() deletes the token.txt file, if it exists.
sub clearAuth {
    if (-e $TOKEN_PATH) {
        unlink($TOKEN_PATH);
        print "Success. Deleted $TOKEN_PATH\n";
    } else {
        print "Error. $TOKEN_PATH does not exist to begin with.\n"
    }
}

# printInfo() prints information about EZCommand Shell and
# the currently logged in credentials.
sub printInfo {
    print "EZCommand Shell version $VERSION.\n";
    my ($admin, $authString, $hostname) = makeAuth();
    print "Credentials stored for $admin under system $hostname.\nAuthString is $authString\n";
}

# printHelp() prints information about the available subroutines.
sub printHelp {
    print "EZCommand Shell subroutines are:\n";
    print "    clearauth\n";
    print "        Clears the credentials.txt file, if it exists.\n";
    print "    help\n";
    print "        Explains all available subroutines.\n";
    print "    info\n";
    print "        Details the current authentication state, assuming makeauth was already called.\n";
    print "    makeauth <admin> <secret> <hostname>\n";
    print "        Builds and stores the AuthString in credentials.txt\n";
    print "EZCommands are:\n";
    print "    adduser <user address> [, additional parameters]\n";
    print "        Provisions a user.\n";
    print "    modifyuser <user address> [, additional parameters]\n";
    print "        Modifies a user.\n";
    print "    deleteuser <user address> [, additional parameters]\n";
    print "        Deletes a user.\n";
    print "    suspenduser <user address> [, additional parameters]\n";
    print "        Suspends a user.\n";
    print "    addalias <user address>, <alias> [, confirm]\n";
    print "        Creates an alias for a user.\n";
    print "    deletealias <alias>\n";
    print "        Deletes an alias for a user.\n";
}

# runCommand($command) issues an EZCommand to Postini.
sub runCommand {
    my $command = shift;
    my ($admin, $authString, $hostname) = makeAuth();
    my $userAgent=LWP::UserAgent->new;
    $userAgent->timeout(1000);
    my $commandURL =  "https://$hostname/exec/remotecmd?auth=$authString&cmd=$command";
    my $request = $userAgent->post($commandURL);
    if(${$request}{_msg} ne 'OK') {
        print "\nError. Error when posting data: ${$request}{_msg}\n";
        exit 1;
    } 
    my $results = ${$request}{_content};
    $results =~ s/^0/Error./; # EZCommand returns a string starting with 0 if running the command caused an error.
    $results =~ s/^1/Success./; # EZCommand returns a string starting with 1 if the command was successful.
    print $results;
    return $results;
}

## MAIN PROCESSING ##

my $command = join(' ', @ARGV);
$command = trim($command);
$command = uri_escape($command);
if (!$command) {
    $command = 'adduser newtestuser@jumboinc.info';
}

# Not using switch because some clients may not have the Switch package installed.
if($ARGV[0] eq 'makeauth') {
    my $admin = $ARGV[1];
    my $secret = $ARGV[2];
    my $hostname = $ARGV[3];
    $admin =~ s/,$//; # remove any trailing commas
    $secret =~ s/,$//; # remove any trailing commas
    $hostname =~ s/,$//; # remove any trailing commas
    my ($returnAdmin, $returnAuthString, $returnHostname) = makeAuth($admin, $secret, $hostname);
    print "Success. Credentials stored for $returnAdmin under system $returnHostname.\nAuthString is $returnAuthString\nNote that this does not mean EZCommand Shell has successfully authenticated to Postini.\n";
} elsif($ARGV[0] eq 'clearauth') {
    clearAuth();
} elsif($ARGV[0] eq 'info') {
    printInfo();
} elsif($ARGV[0] eq 'help') {
    printHelp();
} else {
    runCommand($command);
}
