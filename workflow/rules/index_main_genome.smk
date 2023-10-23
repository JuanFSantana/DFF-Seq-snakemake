rule index_main:
    input:
        path_main_genome=f"genomes/{main_genome}.fa"
    output:
        genome_index=f"genomes/{main_genome}.{number}.{extension}"
    params:
        threads=config["threads"]
    run:
        shell("""

        # Define the modified output without the .ebwtl extension
        genome_index_base=$(echo "{output.genome_index}" | sed 's/\\.[0-9]\\+\\.ebwt$//')

        # Run bowtie-build
        bowtie-build --threads {params.threads} {input.path_main_genome} $genome_index_base
        """)
