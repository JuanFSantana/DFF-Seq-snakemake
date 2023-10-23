rule dedup:
    input:
        "RESULTS/MAPPED/{sample}.bed"
    output:
        "RESULTS/MAPPED/DEDUP/{sample}.dedup"  
    params:
        sample_key="config/sampleskey.csv"
    shell:
        """
        mkdir -p RESULTS/MAPPED/DEDUP
        ./scripts/dff-dedup {input} {params.sample_key} > {output}
        """

