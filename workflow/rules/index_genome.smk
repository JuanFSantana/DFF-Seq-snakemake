import os
import glob

rule index:
    input:
        path_main_genome=f"genomes/{main_genome}.fa",
        path_spikein_genome=f"genomes/{spikein_genome}.fa",
        path_main_chrom_sizes=f"genomes/{main_genome}.chrom.sizes",
        path_spikein_chrom_sizes=f"genomes/{spikein_genome}.chrom.sizes"
    output:
        genome_index=f"genomes/{main_genome}-{spikein_genome}.{number}.{extension}"
    params:
        threads=config["threads"]
    run:
        shell("""
        cat {input.path_main_genome} {input.path_spikein_genome} > genomes/{main_genome}-{spikein_genome}.fa
        cat {input.path_main_chrom_sizes} {input.path_spikein_chrom_sizes} > genomes/{main_genome}-{spikein_genome}.chrom.sizes
        genome_index_base=$(echo "{output.genome_index}" | sed 's/\\.[0-9]\\+\\.ebwt[l]*$//')
        bowtie-build --threads {params.threads} $genome_index_base.fa $genome_index_base
        """)
