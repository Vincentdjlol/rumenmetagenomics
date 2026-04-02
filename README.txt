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

Rumen Metagenomics Pipeline
Deze repository bevat een bio-informatica pipeline voor de analyse van metagenomische data uit een kunstmatige pens (rumen) reactor. De pipeline is ontwikkeld voor het verwerken en analyseren van sequencing data afkomstig van zowel Illumina MiSeq als Oxford Nanopore MinION.
Over het project
De samples representeren drie tijdspunten van de kunstmatige rumenreactor;
T0 (inoculation time): 7-2-2023
T1 : 17-2-2023
T2 (experiment end): 24-2-2023

De pipeline maakt gebruik van Snakemake workflows en Kraken2 voor taxonomische classificatie.
---
Structuur van de repository
```
rumenmetagenomics/
│
├── Full_pipeline/        # Complete pipeline scripts
├── profiles/            # Slurm-profiel voor clustergebruik
├── README.txt           # Originele projectnotities
├── Snakefilerumenmiseq.smk   # Workflow voor MiSeq data
├── Snakefilerumenminion.smk  # Workflow voor MinION data
└── config.yaml          # Configuratiebestand (indien aanwezig)
```
---
Vereisten
De pipeline vereist de volgende software:
Snakemake
Kraken2
Python (≥ 3.8 aanbevolen)
---
Gebruik
1. Clone de repository
```
git clone https://github.com/Vincentdjlol/rumenmetagenomics.git
cd rumenmetagenomics
```
2. Configureer paden
Let op: de huidige workflow bevat hardcoded paden (bijv. `/commons/...` of `/students/...`).
Pas deze aan naar jouw eigen directory-structuur voordat je de pipeline uitvoert.
---
3. Run de pipeline vanuit ./Full_pipeline/
Voor MinION data:
```
snakemake -s Snakefilerumenminion.smk --jobs 15 --workflow-profile slurmprofile/ --use-conda
```
Voor MiSeq data:
```
snakemake -s snakefile.smk --jobs 15 --workflow-profile slurmprofile/
```
Hierna werd significantie van de report bestanden onderling vergeleken met een Adonis2 functie uit de R package Vegan.
Visualisaties zijn gemaakt met behulp van pavian, een tool voor het visualiseren van klassificatiedata. Hiervoor is gebruik gemaakt van de website ontwikkeld door Florian Breitwieser: https://shiny.hiplot.cn/pavian/ 
Verbeterde documentatie en logging
Automatische kwaliteitscontrole toevoegen
---
Auteurs
Ontwikkeld door Vincent en Bert.
