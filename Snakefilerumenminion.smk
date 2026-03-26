krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

reads = [f"FAW60292_pass_barcode07_f8cd6141_86f121af_{i}.fastq.gz_classified" for i in range(23)]

rule all:
    input:
        expand("results/{sample}.report", sample = reads)

rule kraken2:
    input:
        minion = "/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T2/{sample}.fastq"
    output: 
        report = "results/{sample}.report",
        output = "results/{sample}.kraken"
    threads: 10
    shell: "kraken2 --db {krakendb} --threads {threads} --report {output.report} --output {output.output} {input.minion}"