Deze directory bevat sequencing data uit de Artificial Rumen Reactor, tijdens het "Run 4" experiment van Gert Hofstede van februari 2023.

De samples representeren drie tijdspunten;
T0 (inoculation time): 7-2-2023
T1 : 17-2-2023
T2 (experiment end): 24-2-2023

Er is zowel een Illumina als MinION sequencing run gedaan op dezelfde biologische samples.
Uit de biologische samples is 1 x een DNA extractie gedaan voor de sequencing library preps voor beide sequencing methoden. (1 technisch replicaat).

De Illumina data is gegenereerd met Miseq DNA library prep kit v3 met 300bp paired-end reads.
De MinION data is gegeneerd met Rapid Barcoding kit ONT SQK-RBK004 op een FLO-MIN109 flowcell.

De Illumina data is in de "rumen_miseq" directory, de MinION data in de "rumen_minion" directory. Die laatste bevat zowel de ruwe Fast5 data ("fast5_pass") alswel de met Guppy gebasecallde fastq data ("fastq_pass", quality threshold Q8).
---
Structuur van de repository
```
rumenmetagenomics/
│
├── Full_pipeline/ # Complete pipeline scripts
├── slurmprofile/ # Slurm-profiel voor clustergebruik
├── Brackenvegan/ # Bevat code voor gebruik bracken tool, en ook R-code voor gebruik van adonis2 via vegan
├── Kaiju/ # Code en data voor en van gebruik Kaiju
├── Snakefilerumenmiseq.smk # Workflow voor Miseq data
├── Snakefilerumenmiseqsubset.smk # Workflow voor Miseq-subset data
├── Snakefilerumenminion.smk # Workflow voor Minion data
└── config.yaml # Configuratie voor slurm
```

---
De pipeline vereist de volgende software:
Snakemake
Kraken2
Python
---

Gebruik
1. Clone de repository
```
git clone https://github.com/Vincentdjlol/rumenmetagenomics.git
cd rumenmetagenomics
```
---
2. Run de pipeline vanuit ./Full_pipeline/
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
---
Auteurs
Ontwikkeld door Vincent en Bert.
