#open log file, update log file name when needed
open (LOGFILE, "Pc0.4_depth100.txt") or die "I couldn't get at log.txt";

#open out file for uplink statistics
open (LUT, ">E0lut04.txt") or die "$! error trying to overwrite";
     # The original contents are gone, wave goodbye.
$, = ',';
$first_line = false;
for $line(<LOGFILE>) {
	# this is actually useless, it could turn useful if different sections are described by the same RE
	if($line =~ /^\s*Irradiances\s+\W/) {
		$first_line = true;
	}
	if($first_line)
	{
		if($line =~ /^\s*\d*\s*\d+\.\d+\s*(\d+\.\d+)\s*\d+\.\d+E\S\d+\s*\d+\.\d+E\S\d+\s*(\d+\.\d+E\S\d+)\s*\d+\.\d+E\S\d+\s*\d+\.\d+E\S\d+\s*\d+\.\d+\s*\d+\.\d+\s*\d+\.\d+\s*\d+\.\d+E\S\d+/) {
			my @array = ($1, $2);
			local $, = ',';
			print LUT join("\t", @array);
			print LUT "\n";
		}
	}

}


close LUT
