configfile: "config/config.yaml"

krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"

# Aantal reads per folder
READS_PER_FOLDER = {
    "T0": 16,
    "T1": 20,
    "T2": 23
}

# Barcode nummers per folder (dubbel cijfer)
BARCODES = {
    "T0": ["09"],
    "T1": ["08"],
    "T2": ["07"]
}

# Maak een lijst van samples per folder
def get_samples(folder):
    samples = []
    for barcode in BARCODES[folder]:
        for i in range(READS_PER_FOLDER[folder]):
            samples.append(f"FAW60292_pass_barcode{barcode}_f8cd6141_86f121af_{i}.fastq.gz_classified.fastq")
    return samples

# Regel all – bouw alle kraken outputs op
rule all:
    input:
        expand("results/kraken/T0/{sample}.kraken", sample=get_samples("T0")),
        expand("results/kraken/T1/{sample}.kraken", sample=get_samples("T1")),
        expand("results/kraken/T2/{sample}.kraken", sample=get_samples("T2"))

# Kraken2 voor T0
rule kraken2_T0:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T0/{wc.sample}"
    output:
        kraken="results/kraken/T0/{sample}.kraken",
        report="results/kraken/T0/{sample}.report"
    threads: 10
    shell:
        "kraken2 --db {krakendb} --threads {threads} "
        "--output {output.kraken} --report {output.report} {input}"

# Kraken2 voor T1
rule kraken2_T1:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T1/{wc.sample}"
    output:
        kraken="results/kraken/T1/{sample}.kraken",
        report="results/kraken/T1/{sample}.report"
    threads: 10
    shell:
        "kraken2 --db {krakendb} --threads {threads} "
        "--output {output.kraken} --report {output.report} {input}"

# Kraken2 voor T2
rule kraken2_T2:
    input:
        lambda wc: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/T2/{wc.sample}"
    output:
        kraken="results/kraken/T2/{sample}.kraken",
        report="results/kraken/T2/{sample}.report"
    threads: 10
    shell:
        "kraken2 --db {krakendb} --threads {threads} "
        "--output {output.kraken} --report {output.report} {input}"

# Kaiju rule – draait alleen over unclassified reads (voorbeeld)
rule kaiju:
    input:
        unclassified="results/kraken/{folder}/{sample}_unclassified.fastq"
    output:
        "results/kaiju/{folder}/{sample}.kaiju.out"
    threads: 20
    shell:
        """
        kaiju -a mem -z {threads} \
              -t /data/datasets/KAIJU/kaiju_db_nr_2024-08-25/nodes.dmp \
              -f /data/datasets/KAIJU/kaiju_db_nr_2024-08-25/kaiju_db_*.fmi \
              -i {input.unclassified} \
              -o {output} -v
        """





#krakendb = "/commons/data/NCBI/KRAKEN2/k2_standard_20251015"
#
## SAMPLES = [f"FAW60292_pass_barcode07_f8cd6141_86f121af_{i}.fastq.gz_classified" for i in range(23)]
#
#barcode_map = {
#    "07": "T2",
#    "08": "T1",
#    "09": "T0"
#}
#
#
#SAMPLES = []
#for barcode, folder in barcode_map.items():
#    for i in range(23):
#        SAMPLES.append({"folder": folder, "sample": f"FAW60292_pass_barcode{barcode}_f8cd6141_86f121af_{i}.fastq.gz_classified"})
#
#rule all:
#    input:
#        expand("output/results/minion/{folder}/{sample}.report", folder=[s["folder"] for s in SAMPLES], sample=[s["sample"] for s in SAMPLES]),
#        expand("output/results/minion/{sample}.kaiju.out", sample=[s["sample"] for s in SAMPLES])
#
#rule kraken2minion:
#    input:
#        minion = lambda wildcards: f"/commons/Themas/Thema07/metagenomics/rumen/rumen_minion/fastq_pass/{wildcards.folder}/{wildcards.sample}.fastq"
#    output:
#        report = "output/results/minion/{sample}.report",
#        output = "output/results/minion/{sample}.kraken",
#        unclassified = "output/results/minion/{sample}_unclassified.fastq"
#    threads: 10
#    shell:
#        """
#        kraken2 --db {krakendb} \
#                --threads {threads} \
#                --report {output.report} \
#                --output {output.output} \
#                --unclassified-out {output.unclassified} \
#                {input.minion}
#        """
#
#
#rule kaiju:
#    input:
#        unclassified = "output/results/minion/{sample}_unclassified.fastq"
#    output:
#        kaiju_out = "output/results/minion/{sample}.kaiju.out"
#    threads: 20
#    params:
#        db = config["kaiju_db"]
#    shell:
#        """
#        kaiju -a mem \
#              -z {threads} \
#              -t {params.db}/nodes.dmp \
#              -f {params.db}/kaiju_db_*.fmi \
#              -i {input.unclassified} \
#              -o {output.kaiju_out} \
#              -v
#        """
#
#rule kaiju_add_taxon_names:
#    input:
#        "output/results/minion/{sample}.kaiju.out"
#    output:
#        "output/results/minion/{sample}.names.out"
#    params:
#        db=config["kaiju_db"]
#    conda:
#        "envs/kaiju.yaml"
#    shell:
#        """
#        kaiju-addTaxonNames \
#            -t {params.db}/nodes.dmp \
#            -n {params.db}/names.dmp \
#            -i {input} \
#            -o {output}
#        """