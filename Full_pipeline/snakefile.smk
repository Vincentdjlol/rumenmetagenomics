configfile: "config/config.yaml"

SAMPLES = [
    "T0-17012023_S1_L001",
    "T1-27012023_S2_L001",
    "T2-02022023_S3_L001",
]

KRAKENDB = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

##################################
# Final targets
##################################

rule all:
    input:
        expand("output/results/kraken/{sample}.report", sample=SAMPLES),
        expand("output/results/kraken/{sample}.kraken", sample=SAMPLES),
        expand("output/results/kaiju/{sample}.names.out", sample=SAMPLES)


##################################
# Kraken2
##################################

rule kraken2:
    input:
        R1="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R1_001.fastq",
        R2="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R2_001.fastq"
    output:
        report="output/results/kraken/{sample}.report",
        kraken="output/results/kraken/{sample}.kraken",
        unclassified_1="output/results/kraken/{sample}_unclassified_1.fastq",
        unclassified_2="output/results/kraken/{sample}_unclassified_2.fastq"
    threads: 12
    shell:
        """
        kraken2 \
            --db {KRAKENDB} \
            --paired {input.R1} {input.R2} \
            --threads {threads} \
            --report {output.report} \
            --output {output.kraken} \
            --unclassified-out output/results/kraken/{wildcards.sample}_unclassified#.fastq
        """

##################################
# Kaiju (op UNCLASSIFIED reads)
##################################

rule kaiju:
    input:
        r1="output/results/kraken/{sample}_unclassified_1.fastq",
        r2="output/results/kraken/{sample}_unclassified_2.fastq"
    output:
        "output/results/kaiju/{sample}.db_refseq_nr.out"
    params:
        db=config["kaiju_db"]
    threads: 20
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaiju -a mem \
              -z {threads} \
              -t {params.db}/nodes.dmp \
              -f {params.db}/kaiju_db_*.fmi \
              -i {input.r1} \
              -j {input.r2} \
              -o {output} \
              -v
        """

##################################
# Kaiju taxon names
##################################

rule kaiju_add_taxon_names:
    input:
        "output/results/kaiju/{sample}.db_refseq_nr.out"
    output:
        "output/results/kaiju/{sample}.names.out"
    params:
        db=config["kaiju_db"]
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaiju-addTaxonNames \
            -t {params.db}/nodes.dmp \
            -n {params.db}/names.dmp \
            -i {input} \
            -o {output}
        """