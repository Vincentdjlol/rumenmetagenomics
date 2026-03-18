krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

reads = ["T0-17012023_S1_L001", "T1-27012023_S2_L001", "T2-02022023_S3_L001"]

rule all:
    input:
        expand("../results/kraken/miseq_subsets/{sample}.kraken", sample=reads)

rule kraken2_paired:
    input:
        R1="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R1_001.fastq",
        R2="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R2_001.fastq"
    output:
        report="../results/kraken/miseq_subsets/{sample}.report",
        kraken="../results/kraken/miseq_subsets/{sample}.kraken"
    threads: 20
    shell:
        "kraken2 --db {krakendb} --paired {input.R1} {input.R2} --threads {threads} --report {output.report} --output {output.kraken}"