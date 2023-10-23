rule tmp:
    input:
        deduped_files 
    output:
        "RESULTS/MAPPED/DEDUP/sentinel"
    shell:
        """
        touch {output}
        """