krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

reads = ["T0-17012023_S1_L001", "T1-27012023_S2_L001", "T2-02022023_S3_L001"]

rule all:
    input:
        expand("../../results/kraken/bracken/{sample}.bracken", sample=reads)


rule bracken:
    input:
        report = "../../results/kraken/miseq_full/{sample}.report"
    output: 
        output = "../../results/kraken/bracken/{sample}.bracken"
    threads: 10
    shell: "bracken -d {krakendb} -i {input.report} -o {output.output} -r 150 -l S -t 1"