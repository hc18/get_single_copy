#!usr/bin/perl -w
use strict;
#huangcong16@163.com
open IN2，"<","species.txt";
my @array_big_all;
while (<IN2>) {
	chomp();
	push(@array_big_all,$_);
}

open IN,"<","1-1-1_sort.txt" || die "can not open $!";
my @array_name;
my $num = 0;

while (<IN>) {
	chomp();
	if (/^$array_big_all[0]/){
		@array_name = split(/\t/,$_);

	}else{
		$num++;
		my @array_temp = split (/\t/,$_);
		my $dir = "../compliantFasta";

		opendir DIR,$dir || die "can not open $!";
			while (my $file = readdir DIR) {
				next if ($file =~ /^\./);
				for (my $i = 0; $i <=$#array_name; $i++) {
					if($file =~ /$array_name[$i]/){
						open OUT,">>", $num."_seq.fasta";
						open IN1,"<","$dir/$file" || die "can not open $!"; 
							my %hash;
							my $name;
							my %id;
							while (<IN1>) {
								chomp();
								if (/^>(.*)\|(.*)/) {
									$name = $_;
									$id{$name} = $2;
								}else{
									$hash{$name} .= $_;
								}
							}
							foreach $name (sort keys %hash){
								if ($id{$name} eq $array_temp[$i]) {
									print OUT "$name\_$array_temp[$i]\n$hash{$name}\n";
								}
							}

						close IN1;
						close OUT;
					}	
				}
			}
		close DIR;
	}
	

}


close IN;
