configfile: "config.yaml"

krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"
kaijudb = "/data/datasets/KAIJU/kaiju_db_nr_2024-08-25"

READS_PER_FOLDER = {
    "T0": 16,
    "T1": 20,
    "T2": 23
}

BARCODES = {
    "T0": "09",
    "T1": "08",
    "T2": "07"
}

def get_samples(folder):
    barcode = BARCODES[folder]
    return [
        f"FAW60292_pass_barcode{barcode}_f8cd6141_86f121af_{i}.fastq.gz_classified.fastq"
        for i in range(READS_PER_FOLDER[folder])
    ]

rule all:
    input:
        expand("results/kraken/T0/{sample}.kraken", sample=get_samples("T0")),
        expand("results/kraken/T1/{sample}.kraken", sample=get_samples("T1")),
        expand("results/kraken/T2/{sample}.kraken", sample=get_samples("T2")),
        expand("results/kaiju/T0/{sample}.kaiju.out", sample=get_samples("T0")),
        expand("results/kaiju/T1/{sample}.kaiju.out", sample=get_samples("T1")),
        expand("results/kaiju/T2/{sample}.kaiju.out", sample=get_samples("T2")),
        expand("results/kaiju/T0/{sample}.names.out", sample=get_samples("T0")),
        expand("results/kaiju/T1/{sample}.names.out", sample=get_samples("T1")),
        expand("results/kaiju/T2/{sample}.names.out", sample=get_samples("T2")),
        expand("results/kaiju/T0/{sample}.summary.tsv", sample=get_samples("T0")),
        expand("results/kaiju/T1/{sample}.summary.tsv", sample=get_samples("T1")),
        expand("results/kaiju/T2/{sample}.summary.tsv", sample=get_samples("T2"))

rule kraken2_T0:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T0/{wc.sample}"
    output:
        kraken="results/kraken/T0/{sample}.kraken",
        report="results/kraken/T0/{sample}.report",
        unclassified="results/kraken/T0/{sample}_unclassified.fastq"
    threads: 20
    params:
        db=config["kraken_db"]
    shell:
        """
        kraken2 \
            --db {params.db} \
            --threads {threads} \
            --output {output.kraken} \
            --report {output.report} \
            --unclassified-out {output.unclassified} \
            {input}
        """

rule kraken2_T1:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T1/{wc.sample}"
    output:
        kraken="results/kraken/T1/{sample}.kraken",
        report="results/kraken/T1/{sample}.report",
        unclassified="results/kraken/T1/{sample}_unclassified.fastq"
    params:
        db = config["kaiju_db"]
    threads: 20
    shell:
        """
        kraken2 \
            --db {params.db} \
            --threads {threads} \
            --output {output.kraken} \
            --report {output.report} \
            --unclassified-out {output.unclassified} \
            {input}
        """

rule kraken2_T2:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T2/{wc.sample}"
    output:
        kraken="results/kraken/T2/{sample}.kraken",
        report="results/kraken/T2/{sample}.report",
        unclassified="results/kraken/T2/{sample}_unclassified.fastq"
    threads: 20
    params:
        db=config["kraken_db"]
    shell:
        """
        kraken2 \
            --db {params.db} \
            --threads {threads} \
            --output {output.kraken} \
            --report {output.report} \
            --unclassified-out {output.unclassified} \
            {input}
        """

rule kaiju_T0:
    input:
        unclassified="results/kraken/T0/{sample}_unclassified.fastq"
    output:
        "results/kaiju/T0/{sample}.kaiju.out"
    threads: 20
    params:
        db=config["kaiju_db"]
    shell:
        """
        kaiju -a mem \
              -z {threads} \
              -t {params.db}/nodes.dmp \
              -f {params.db}/kaiju_db_nr.fmi \
              -i {input.unclassified} \
              -o {output} \
              -v
        """

rule kaiju_T1:
    input:
        unclassified="results/kraken/T1/{sample}_unclassified.fastq"
    output:
        "results/kaiju/T1/{sample}.kaiju.out"
    threads: 20
    params:
        db=config["kaiju_db"]
    shell:
        """
        kaiju -a mem \
              -z {threads} \
              -t {params.db}/nodes.dmp \
              -f {params.db}/kaiju_db_nr.fmi \
              -i {input.unclassified} \
              -o {output} \
              -v
        """

rule kaiju_T2:
    input:
        unclassified="results/kraken/T2/{sample}_unclassified.fastq"
    output:
        "results/kaiju/T2/{sample}.kaiju.out"
    threads: 20
    params:
        db=config["kaiju_db"]
    shell:
        """
        kaiju -a mem \
              -z {threads} \
              -t {params.db}/nodes.dmp \
              -f {params.db}/kaiju_db_nr.fmi \
              -i {input.unclassified} \
              -o {output} \
              -v
        """


rule kaiju_add_taxon_names_T0:
    input:
        "results/kaiju/T0/{sample}.kaiju.out"
    output:
        "results/kaiju/T0/{sample}.names.out"
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

rule kaiju_add_taxon_names_T1:
    input:
        "results/kaiju/T1/{sample}.kaiju.out"
    output:
        "results/kaiju/T1/{sample}.names.out"
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

rule kaiju_add_taxon_names_T2:
    input:
        "results/kaiju/T2/{sample}.kaiju.out"
    output:
        "results/kaiju/T2/{sample}.names.out"
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

rule kaiju_report_T0:
    input:
        "results/kaiju/T0/{sample}.kaiju.out"
    output:
        "results/kaiju/T0/{sample}.summary.tsv"
    params:
        db=config["kaiju_db"]
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaiju2table \
            -t {params.db}/nodes.dmp \
            -n {params.db}/names.dmp \
            -r species \
            -o {output} \
            {input}
        """

rule kaiju_report_T1:
    input:
        "results/kaiju/T1/{sample}.kaiju.out"
    output:
        "results/kaiju/T1/{sample}.summary.tsv"
    params:
        db=config["kaiju_db"]
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaiju2table \
            -t {params.db}/nodes.dmp \
            -n {params.db}/names.dmp \
            -r species \
            -o {output} \
            {input}
        """

rule kaiju_report_T2:
    input:
        "results/kaiju/T2/{sample}.kaiju.out"
    output:
        "results/kaiju/T2/{sample}.summary.tsv"
    params:
        db=config["kaiju_db"]
    conda:
        "envs/kaiju.yaml"
    shell:
        """
        kaiju2table \
            -t {params.db}/nodes.dmp \
            -n {params.db}/names.dmp \
            -r species \
            -o {output} \
            {input}
        """