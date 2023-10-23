zipped_main_genome = str(main_genome) + ".fa.gz"

rule download_main:
    output:
        path_main_genome=f"genomes/{main_genome}.fa",
        path_main_chrom_sizes=f"genomes/{main_genome}.chrom.sizes"
    shell:
        """
        mkdir -p genomes
        # Construct the UCSC download URLs
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{main_genome}/bigZips/{main_genome}.fa.gz
 
        # chrom sizes
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{main_genome}/bigZips/{main_genome}.chrom.sizes
        
        # unzip
        gunzip -c {zipped_main_genome} > {output.path_main_genome}

        # move files and tag spike in genome
        mv {main_genome}.chrom.sizes {output.path_main_chrom_sizes}
        """

