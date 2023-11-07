rule trimgalore:
    input: 
        r1=lambda wildcards: samples[wildcards.sample][0],
        r3=lambda wildcards: samples[wildcards.sample][2]
    output: 
        r1="RESULTS/TRIMMED/{sample}_val_1.fq",
        r3="RESULTS/TRIMMED/{sample}_val_2.fq"
    params:
        minimum_read_length=config["minimum_read_length"],
        threads=config["threads"]
    shell: 
        """
        mkdir -p RESULTS/TRIMMED
        tools/TrimGalore/trim_galore --paired {input.r1} {input.r3} --quality 0 --adapter AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
            --length {params.minimum_read_length} --dont_gzip \
            -o RESULTS/TRIMMED/ > /dev/null 2>&1
        
        # Renaming the files to use the sample names from the CSV
        mv RESULTS/TRIMMED/$(basename {input.r1} .fastq.gz)_val_1.fq RESULTS/TRIMMED/{wildcards.sample}_val_1.fq
        mv RESULTS/TRIMMED/$(basename {input.r3} .fastq.gz)_val_2.fq RESULTS/TRIMMED/{wildcards.sample}_val_2.fq
        """
