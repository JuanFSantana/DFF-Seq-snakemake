rule library_size:
    input:
        "RESULTS/MAPPED/DEDUP/sentinel"
    output:
        "RESULTS/MAPPED/DEDUP/library-normalization.txt"
    shell:
        """
        scripts/library_size_norm.py RESULTS/MAPPED/DEDUP {input} {output}
        """
