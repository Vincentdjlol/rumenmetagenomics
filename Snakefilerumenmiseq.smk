krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

rule all:
    input:
        expand("results/{sample}.report", sample = ["T0-17012023_S1_L001", "T1-27012023_S2_L001", "T2-02022023_S3_L001"])

rule kraken2:
    input:
        miseq1 = "rumen_miseq/{sample}_R1_001.fastq",
        miseq2 = "rumen_miseq/{sample}_R2_001.fastq"
    output: 
        report = "results/{sample}.report",
        output = "results/{sample}.kraken"
    threads: 10
    shell: "kraken2 --db {krakendb} --threads {threads} --report {output.report} --output {output.output} {input.miseq1} {input.miseq2}"