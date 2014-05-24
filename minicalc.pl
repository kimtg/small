#!/usr/bin/perl
# (C) 2014 KIM Taegyoon
# Postfix Calculator

use strict;
use warnings;
our @stk=();
sub check_num_op {
    my ($n) = @_;
    if (scalar(@stk) < $n) {
	printf("Not enough operands. Required: %d. Given: %d.\n", $n, scalar(@stk));
	return 0;
    }
    return 1;
}

print("minicalc (C) 2013-2014 KIM Taegyoon\n");
print("+ - * / ^ sqrt\n");
while (print("> "), my $line=<>) {
    my @tokens = split(/\s+/, $line);
    foreach (@tokens) {
	if (length($_) == 0) {next}
	if ($_ eq "+") {
	    if (!check_num_op(2)) {last}
	    my $a2 = pop(@stk);
	    my $a1 = pop(@stk);
	    push(@stk, $a1 + $a2);
	} elsif ($_ eq "-") {
	    if (!check_num_op(2)) {last}
	    my $a2 = pop(@stk);
	    my $a1 = pop(@stk);
	    push(@stk, $a1 - $a2);
	} elsif ($_ eq "*") {
	    if (!check_num_op(2)) {last}
	    my $a2 = pop(@stk);
	    my $a1 = pop(@stk);
	    push(@stk, $a1 * $a2);
	} elsif ($_ eq "/") {
	    if (!check_num_op(2)) {last}
	    my $a2 = pop(@stk);
	    my $a1 = pop(@stk);
	    push(@stk, $a1 / $a2);
	} elsif ($_ eq "^"){
	    if (!check_num_op(2)) {last}
	    my $a2 = pop(@stk);
	    my $a1 = pop(@stk);
	    push(@stk, $a1 ** $a2);
	} elsif ($_ eq "sqrt") {
	    if (!check_num_op(1)) {last}
	    my $a1 = pop(@stk);
	    push(@stk, sqrt($a1));
	} else {
	    push(@stk, $_);
	}
	foreach (@stk) {
	    printf("%.16g ", $_);
	}
	print("\n");
    }
    @stk = ();
}
