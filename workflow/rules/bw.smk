rule bigwig:
    input:
        "RESULTS/MAPPED/DEDUP/BEDGRAPH/{sample}.bg"
    output:
        bw="RESULTS/MAPPED/DEDUP/BIGWIG/{sample}.bw"
    params:
        chrom_sizes=f"genomes/{main_genome}-{spikein_genome}.chrom.sizes"
    shell:
        """
        mkdir -p RESULTS/MAPPED/DEDUP/BIGWIG
        tools/bedGraphToBigWig {input} {params.chrom_sizes} {output.bw}
        """


