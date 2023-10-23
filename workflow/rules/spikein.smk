rule norm:
    input:
        "RESULTS/MAPPED/DEDUP/sentinel"
    output:
        "RESULTS/MAPPED/DEDUP/spike-in-normalization.txt"
    shell:
        """
        scripts/spikein.py RESULTS/MAPPED/DEDUP {input} {output}
        """
