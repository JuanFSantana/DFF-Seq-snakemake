
zipped_main_genome = str(main_genome) + ".fa.gz"
zipped_spikein_genome = str(spikein_genome) + ".fa.gz"

rule download_genome:
    output:
        path_main_genome=f"genomes/{main_genome}.fa",
        path_spikein_genome=f"genomes/{spikein_genome}.fa",
        path_main_chrom_sizes=f"genomes/{main_genome}.chrom.sizes",
        path_spikein_chrom_sizes=f"genomes/{spikein_genome}.chrom.sizes"
    shell:
        """
        mkdir -p genomes
        # Construct the UCSC download URLs
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{main_genome}/bigZips/{main_genome}.fa.gz
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{spikein_genome}/bigZips/{spikein_genome}.fa.gz

        # chrom sizes
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{main_genome}/bigZips/{main_genome}.chrom.sizes
        curl -O http://hgdownload.soe.ucsc.edu/goldenPath/{spikein_genome}/bigZips/{spikein_genome}.chrom.sizes
        
        # unzip
        gunzip -c {zipped_main_genome} > {output.path_main_genome}
        gunzip -c {zipped_spikein_genome} > {output.path_spikein_genome}.tmp

        # move files and tag spike in genome
        mv {main_genome}.chrom.sizes {output.path_main_chrom_sizes}
        awk '/^>/ {{print $1 ".spikein" $2; next}} 1' {output.path_spikein_genome}.tmp > {output.path_spikein_genome}
        awk -F'\t' -v OFS='\t' '{{ $1 = $1 ".spikein" }}1' {spikein_genome}.chrom.sizes > {output.path_spikein_chrom_sizes}

        rm -f {zipped_main_genome};
        rm -f {zipped_spikein_genome};
        rm -f {spikein_genome}.chrom.sizes;
        rm -f {main_genome}.chrom.sizes;
        rm -f genomes/{spikein_genome}.fa.tmp;
        rm -f {main_genome}.fa.gz;
        rm -f {spikein_genome}.fa.gz;
        """

