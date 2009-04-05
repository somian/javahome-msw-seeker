@Echo OFF
:: $Author: somian $
:: $RCSfile: javahome-msw-seeker.bat,v $
:: $Revision: 1.3 $
:: $Date: 2009/04/05 05:09:26 $
:: Purpose: set JAVA_HOME env var
rem Echo This script lives in %~p0

SETLOCAL
SET YIT=
IF NOT "%0:~-4%" == ".bat" SET YIT=.bat

FOR /f %%J IN ('perl -x %0%YIT%') DO @(ENDLOCAL
SET JAVA_HOME=%%J
)
GoTo :THATSALL


#!perl
use Win32::TieRegistry (Delimiter=>q{#});
use File::Spec;
use strict;

# To use this to set JAVA_HOME for a process we're going to start, could
# for example do
#     call %~dp0FindJAVAHOME &&  goto valid_JAVA_HOME
# (that's an example from modified startGroovy.bat from the Groovy distro.)
# This works if this script file is in the same directory as the bat file
# that calls us.

sub _SHRT {
    die q/CODING ERROR: Bad param ($_[0] undefined or null)/ unless $_[0];
    my $Nom = Win32::GetShortPathName(shift);
    $Nom=~s{(?<=[:]).+$}{lc $&}e;
    $Nom
}


sub readregkeys
{
    my (%Poss, @Bingo);
    my $regkey;
    my $k1 = $Registry->{'LMachine#SOFTWARE#JavaSoft#Java Development Kit#'};
    my $k2 = $Registry->{'LMachine#SOFTWARE#JavaSoft#Java Runtime Environment#'};
    ($regkey = $k1 || $k2)
        or die qq%Cannot read "HKLM/SOFTWARE/JavaSoft/Java Runtime Environment/" key%;


    foreach my $subkey ($regkey->SubKeyNames) {
        if ($subkey =~ m{  (
                1[.][[:digit:]._]+
                )}x)
        {
            my $vk = join ' ',unpack('i i i i', pack( 'i*' , split('[._]'=>$1) ));
            $Poss{$vk} = $subkey;

        }
    }

    my %tu;
    foreach my $jre_rel (reverse sort keys %Poss) {
        my $elan;
        my $sib = $regkey->{$Poss{$jre_rel} .'#'};
        $elan = $sib->GetValue('JavaHome');
        next unless $elan;
        next if $tu{$elan}++;
        push (@Bingo, $elan) unless not -e $elan;
    }


    for (@Bingo) {
        s{\\}{/}g;
        my @pe = split('/');
        die unless @pe >= 2;
        for(my $i=1; $i<@pe; $i++) {
            $pe[$i] = ($pe[$i]=~/\s/
                ? do { my $r = _SHRT(join '/' => @pe[0..$i]);
                    substr($r,rindex($r, '/')+1) }  # Yes, it needs to be that complicated.
                : $pe[$i])
        }
        $_ = File::Spec->catfile( @pe );
    }
    return shift @Bingo;
}

print readregkeys;
exit;
__END__
:THATSALL
