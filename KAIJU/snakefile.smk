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