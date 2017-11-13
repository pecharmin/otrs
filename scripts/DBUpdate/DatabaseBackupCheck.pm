# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package scripts::DBUpdate::DatabaseBackupCheck;    ## no critic

use strict;
use warnings;

use IO::Interactive qw(is_interactive);

use parent qw(scripts::DBUpdate::Base);

use version;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
);

=head1 NAME

scripts::DBUpdate::DatabaseBackupCheck - Checks if database was backed up.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    return 1;
}

=head2 CheckPreviousRequirement()

Check for initial conditions for running this migration step.

Returns 1 on success:

    my $Result = $DBUpdateObject->CheckPreviousRequirement();

=cut

sub CheckPreviousRequirement {
    my ( $Self, %Param ) = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # This check will occur only if we are in interactive mode.
    if ( $Param{CommandlineOptions}->{NonInteractive} || !is_interactive() ) {
        return 1;
    }

    if ( $Param{CommandlineOptions}->{Verbose} ) {
        print "\n        Warning: this script can make changes to your database which are irreversible.\n"
            . "        Make sure you have properly backed up complete database before continuing.\n\n";
    }
    else {
        print "\n";
    }

    print '        Did you backup the database? [Y]es/[N]o: ';

    my $Answer = <>;

    # Remove white space from input.
    $Answer =~ s{\s}{}smx;

    # Continue only if user answers affirmatively.
    if ( $Answer =~ m{^y}i ) {
        print "\n";

        return 1;
    }

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut