rule bedgraph:
    input:
        bed="RESULTS/MAPPED/DEDUP/{sample}.dedup",
        spikein="RESULTS/MAPPED/DEDUP/spike-in-normalization.txt",
    params:
        chrom_sizes=f"genomes/{main_genome}-{spikein_genome}.chrom.sizes"
    output:
        "RESULTS/MAPPED/DEDUP/BEDGRAPH/{sample}.bg"
    run:
        with open(input.spikein, "r") as spikein_file:
            for line in spikein_file:
                fields = line.strip().split("\t")
                sample_name = fields[0]
                norm_factor = fields[10]

                if normalization == True:
                    norm_factor = 1

                # check if the sample name matches the current {sample}
                if sample_name == wildcards.sample:
                    # use norm_factor to generate bigwig
                    shell(
                        """
                        mkdir -p RESULTS/MAPPED/DEDUP/BEDGRAPH
                        tools/bedtools2/bin/genomeCoverageBed -i {input.bed} -g {params.chrom_sizes} -bg -scale {norm_factor} > {output}
                        """
                    )
                    break