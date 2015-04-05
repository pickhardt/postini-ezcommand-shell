## Summary ##
Postini EZCommand Shell is a Perl script allowing Postini administrators to issue EZCommands from a terminal.  It also provides sample code for developers to use as a guide to integrate Postini with other systems.

## Download ##
To download Postini EZCommand Shell, right click and download the following zip file:
> http://postini-ezcommand-shell.googlecode.com/svn-history/r4/trunk/ezcommand.zip

## Instructions ##
Postini EZCommand Shell commands are run from a terminal. First, navigate (cd) to the directory containing ezcommand.pl. Next, run the following command:
> `perl ezcommand.pl help`
This will detail all the available subroutines. In order to issue an EZCommand to Postini, you will have to build an AuthString. To do so, run the following command:
> `perl ezcommand.pl makeauth <admin>, <secret>, <hostname>`
When finished, erase your credentials with the clearauth command.

## URL for the Email Security Batch Reference Guide ##
> http://www.postini.com/webdocs/batch/reference

## List of All EZCommand Shell Commands ##

`makeauth <admin>, <secret>, <hostname>`
> Takes parameters:
    * admin is an administrative account.
    * secret is the EZCommand Shared Secret for the admin's organization.
    * hostname is the host name listed in the URL after a successful log in to the Administration Console. It will be of the form ac-sN.postini.com.

> Description:
> > Subroutine makeauth builds an authentication string out of $admin and $secret.  The authentication string is stored in the credentials.txt file until clearauth is called.


> Here's how you find an EZCommand Shared Secret.
  1. In the Administration Console, go to Orgs & Users > Orgs.
  1. Choose the organization from the Choose Org pull-down, or click the name in organization list.
  1. In the Organization Management page, scroll to the Organization Settings section and click General Settings.
  1. On the General Settings page, enter the shared secret in the EZCommand Shared Secret field and click Save.
  1. Add shared secrets to other organizations that contain administrators who will submit EZCommands. With EZCommand, the shared secret must be set for each organization; the shared secrets are not inherited down the organization hierarchy.

> Example usage:
```
        perl ezcommand.pl makeauth jeff@jumboinc.com dontsharethis ac-s8.postini.com
        Success. Credentials stored for jeff@jumboinc.com under system ac-s8.postini.com.
        AuthString is 6cgfDIRRzWusboAENaOVimaPz1MBBLAjeff@jumboinc.com
        Note that this does not mean EZCommand Shell has successfully authenticated to Postini.
```

`clearauth`
> Takes parameters:
    * none

> Description:
> > Subroutine clearauth deletes the credentials.txt file. Use this when you're done with an EZCommand Shell session.


> Example usage:
```
        perl ezcommand.pl clearauth
        Success. Deleted credentials.txt
        
        perl ezcommand.pl clearauth
        Error. credentials.txt does not exist to begin with.
```


`help`
> Takes parameters:
    * none

> Description:
> > Explains all available subroutines.


> Example usage:
```
        perl ezcommand.pl help
        EZCommand Shell subroutines are:
            clearauth
                Clears the credentials.txt file, if it exists.
            help
                Explains all available subroutines.
            info
                Details the current authentication state, assuming makeauth was already called.
            makeauth <admin> <secret> <hostname>
                Builds and stores the AuthString in credentials.txt
        EZCommands are:
            adduser <user address> [, additional parameters]
                Provisions a user.
            modifyuser <user address> [, additional parameters]
                Modifies a user.
            deleteuser <user address> [, additional parameters]
                Deletes a user.
            suspenduser <user address> [, additional parameters]
                Suspends a user.
            addalias <user address>, <alias> [, confirm]
                Creates an alias for a user.
            deletealias <alias>
                Deletes an alias for a user.
```

`info`
> Takes parameters:
    * none

> Description:
> > Explains all available subroutines.


> Example usage:
```
        perl ezcommand.pl info
        EZCommand Shell version 1.0.0
        Credentials stored for jeff@jumboinc.com under system ac-s8.postini.com.
        AuthString is 6cgfDIRRzWusboAENaOVimaPz1MBBLAjeff@jumboinc.com
```


`adduser <user address> [, additional parameters]`
> Takes parameters:
    * user address is the user address to create.
    * See Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.

> Description:
> > Provided you have made the authstring, this adds a user to Postini. For more information, see the Email Security Batch Reference Guide.


> Example usage;
```
        perl ezcommand.pl adduser jim@jumboinc.com, approved_senders=+hugeisp.com, welcome=1
        Success. Created new user jim@jumboinc.com in organization jumboinc-com.
```

`modifyuser <user address> [, additional parameters]`
> Takes parameters:
    * user address is the user address to modify.
    * For more information, see Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.

> Description:
> > Provided you have made the authstring, this adds a user to Postini. For more information, see the Email Security Batch Reference Guide.


> Example usage:
```
        perl ezcommand.pl modifyuser jim@jumboinc.com, password=NewP*ssw0rd
        Success. Modified jim@jumboinc.com:  Set PASSWD to X.
```


`deleteuser <user address> [, additional parameters]`
> Takes parameters:
    * user address is the name of the user being deleted.
    * For more information, see Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.

> Description:
> > Provided you have made the authstring, this deletes a user. For more information, see the Email Security Batch Reference Guide.


> Example usage:
```
        perl ezcommand.pl deleteuser jimb@jumboinc.com
        Success. Deleted user jimb@jumboinc.com.
```

`suspenduser <user address> [, additional parameters]`
> Takes parameters:
    * user address is the name of the user being suspended.
    * For more information, see Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.

> Description:
> > Provided you have made the authstring, this suspends a user. For more information, see the Email Security Batch Reference Guide.


> Example usage:
```
        perl ezcommand.pl suspenduser jim@jumboinc.com
        Success. Suspended user jim@jumboinc.com. 
```

`addalias <user address>, <alias> [, confirm]`
> Takes parameters:
    * user address is the user's primary address associated with the alias.
    * alias is the alias address for the user’s primary address.
    * [confirm](confirm.md) is an optional positional parameter that is required if an existing user address is being overwritten to become an alias address. The text confirm must be at the end of the command. There is no numeric equivalent.
> > For more information, see Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.


> Description:
> > Provided you have made the authstring, this adds an alias to a user. For more information, see the Email Security Batch Reference Guide.


> Example usage:
```
        perl ezcommand.pl addalias jim@jumboinc.com, jimmy@jumboinc.com, confirm
        Success. Added alias jimmy@jumboinc.com to user jim@jumboinc.com.
```


`deletealias <alias>`
> Takes parameters:
    * alias is the alias address for the user’s primary address.
    * For more information, see Chapter 28 - Batch Processing and EZCommand, in the Email Security Batch Reference Guide.

> Description:
> > Provided you have made the authstring, this deletes the alias. For more information, see the Email Security Batch Reference Guide.


> Example usage:
```
        perl ezcommand.pl deletealias jimmy@jumboinc.com
        Success. Deleted alias jimmy@jumboinc.com from user jim@jumboinc.com.
```

