krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

# reads = ["T1_sub1", "T1_sub2", "T2_sub1", "T2_sub2", "sub1", "sub2"]

rule all:
    input:
        expand("results/T2/test.report"),
        expand("results/T2/test.kraken")

rule kraken2:
    input:
        r1="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/T2-02022023_S3_L001_R1_001.fastq",
        r2="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/T2-02022023_S3_L001_R2_001.fastq"
    output:
        report="results/miseq_subsets{sample}.report",
        kraken="results/miseq_subsets{sample}.kraken"
    threads: 20
    shell:
        "kraken2 --db {krakendb} --paired --threads {threads} --report {output.report} --output {output.kraken} {input.r1} {input.r2}"