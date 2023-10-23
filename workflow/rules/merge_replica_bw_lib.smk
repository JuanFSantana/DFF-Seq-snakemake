rule merge_bw_main:
    input:
        lambda wildcards: [f"RESULTS/MAPPED/DEDUP/BIGWIG/{sample}.bw" for sample in config['replicas'][wildcards.replica_set]]
    output:
        merged_bw="RESULTS/MAPPED/DEDUP/BIGWIG/COMBINED/{replica_set}.bw"
    params:
        chrom_sizes=f"genomes/{main_genome}.chrom.sizes",
        temp_bg="temp_{replica_set}.bg"
    shell:
        """
        mkdir -p RESULTS/MAPPED/DEDUP/BIGWIG/COMBINED
        tools/bigWigMerge {input} stdout | LC_COLLATE=C sort -k1,1 -k2,2n > {params.temp_bg}
        tools/bedGraphToBigWig {params.temp_bg} {params.chrom_sizes} {output.merged_bw}
        rm {params.temp_bg}
        """
