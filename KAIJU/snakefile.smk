<<<<<<< HEAD
import glob
import os

configfile: "config.yaml"

UNCLASSIFIED_DIR = config["kraken_unclassified"]
OUTDIR = config["KAIJU_output"]

# automatische sample detectie
reads = ["unclassifieds_T1_", "unclassifieds_T2_", "unclassifieds_"]


rule all:
    input:
        expand(os.path.join(OUTDIR, "{sample}.kaiju.report"), sample=reads)


rule kaiju_classify:
    input:
        r1=os.path.join(UNCLASSIFIED_DIR, "{sample}sub1.unclassified"),
        r2=os.path.join(UNCLASSIFIED_DIR, "{sample}sub2.unclassified")
    output:
        kaiju=os.path.join(OUTDIR, "{sample}.kaiju.out")
    threads: config["threads"]
    shell:
        """
        mkdir -p {OUTDIR}

        kaiju \
            -t {config[nodes]} \
            -f {config[kaiju_db]} \
            -i {input.r1} \
            -j {input.r2} \
            -o {output.kaiju} \
            -z {threads}
        """


rule kaiju_report:
    input:
        os.path.join(OUTDIR, "{sample}.kaiju.out")
    output:
        os.path.join(OUTDIR, "{sample}.kaiju.report")
    threads: 1
    shell:
        """
        kaijuReport \
            -t {config[nodes]} \
            -n {config[names]} \
            -i {input} \
            -o {output}
        """
=======
configfile: "config/kraken2.yaml"

SAMPLES = ["T0-17012023_S1_L001",
           "T1-27012023_S2_L001",
           "T2-02022023_S3_L001", ]

rule all:
    input:
        expand("output/kaiju/{sample}.db_refseq_nr.out",sample=SAMPLES)

rule kaiju:
    input:
        r1="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R1_001.fastq",
        r2="/commons/Themas/Thema07/metagenomics/rumen/rumen_miseq/{sample}_R2_001.fastq"
    output:
        out="output/kaiju/{sample}.db_refseq_nr.out"
    params:
        db=config["kaiju_db"]
    threads: 25
    conda:
        "envs/kaiju.yaml"
    shell:
        "kaiju -a mem -z {threads} -t {params.db}/nodes.dmp -f {params.db}/kaiju_db_*.fmi -i {input.r1} -j {input.r2} -o {output.out} -v"

rule kaiju_add_taxon_names:
    input:
        kaiju="output/kaiju/{sample}.db_refseq_nr.out"
    output:
        "output/kaiju/{sample}.names.out"
    params:
        db=config["kaiju_db"]
    conda:
        "envs/kaiju.yaml"
    shell:
        "kaiju-addTaxonNames -t {params.db}/nodes.dmp -n {params.db}/names.dmp -i {input.kaiju} -o {output}"
>>>>>>> Full_pipeline
