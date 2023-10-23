rule bowtie_main:
    input:
        r1="RESULTS/TRIMMED/{sample}_val_1.fq",
        r2="RESULTS/TRIMMED/{sample}_val_2.fq",
        genome_index=f"genomes/{main_genome}.{number}.{extension}"
    output:
        output_1="RESULTS/MAPPED/{sample}.sam",
        output_2="RESULTS/MAPPED/{sample}.log"
    params:
        minimum_read_length=config["minimum_read_length"],
        threads=config["threads"]
    run:
        shell("""
        # Define the modified output without the .ebwtl extension
        genome_index_base=$(echo "{input.genome_index}" | sed 's/\\.[0-9]\\+\\.ebwt$//')

        mkdir -p RESULTS/MAPPED
        tools/bowtie/bowtie -x $genome_index_base -1 {input.r1} -2 {input.r2} --fr --best --fullref --sam --allow-contain --chunkmbs 5000 --threads {params.threads} --minins {params.minimum_read_length} 1> {output.output_1} 2> {output.output_2}
        """)
