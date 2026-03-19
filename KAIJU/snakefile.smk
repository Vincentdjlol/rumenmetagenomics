import os

configfile: "config.yaml"

UNCLASSIFIED_DIR = config["kraken_unclassified"]
OUTDIR = config["kaiju_output"]

SAMPLES = ["T0", "T1", "T2"]


rule all:
    input:
        expand(os.path.join(OUTDIR, "{sample}.kaiju.report"), sample=SAMPLES)


rule kaiju_classify:
    input:
        r1=os.path.join(UNCLASSIFIED_DIR, "unclassifieds_{sample}_sub1.fastq"),
        r2=os.path.join(UNCLASSIFIED_DIR, "unclassifieds_{sample}_sub2.fastq")
    output:
        kaiju=os.path.join(OUTDIR, "{sample}.kaiju.out")
    threads: 4
    resources:
        mem_mb=64000,
        runtime=1440
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        mkdir -p {OUTDIR}

        kaiju \
          -a mem \
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
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaijuReport \
            -t {config[nodes]} \
            -n {config[names]} \
            -i {input} \
            -o {output}
        """