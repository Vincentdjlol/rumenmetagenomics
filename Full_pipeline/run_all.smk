rule all:
    shell:
        """
        snakemake -s snakefile.smk --jobs 10 --workflow-profile slurmprofile/ --use-conda
        snakemake -s Snakefilerumenminion.smk --jobs 10 --workflow-profile slurmprofile/ --use-conda
        """