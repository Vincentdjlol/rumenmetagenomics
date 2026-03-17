Deze directory bevat sequencing data uit de Artificial Rumen Reactor, tijdens het "Run 4" experiment van Gert Hofstede in february 2023.

De samples representeren drie tijdspunten;
T0 (inoculation time): 7-2-2023
T1 : 17-2-2023
T2 (experiment end): 24-2-2023

Er is zowel een Illumina als MinION sequencing run gedaan op dezelfde biologische samples.
Uit de biologische samples is 1 x een DNA extractie gedaan voor de sequencing library preps voor beide sequencing methoden. (1 technisch replicaat).

De Illumina data is gegenereerd met Miseq DNA library prep kit v3 met 300bp paired-end reads.
De MinION data is gegeneerd met Rapid Barcoding kit ONT SQK-RBK004 op een FLO-MIN109 flowcell.

De Illumina data is in de "rumen_miseq" directory, de MinION data in de "rumen_minion" directory. Die laatste bevat zowel de ruwe Fast5 data ("fast5_pass") alswel de met Guppy gebasecallde fastq data ("fastq_pass", quality threshold Q8).
