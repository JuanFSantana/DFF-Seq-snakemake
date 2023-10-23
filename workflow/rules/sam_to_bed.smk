rule bed:
    input:
        "RESULTS/MAPPED/{sample}.sam"
    output:
        "RESULTS/MAPPED/{sample}.bed"
    params:
        threads=config["threads"]
    shell:
        """
        tools/samtools/samtools view -O BAM -f 0x3 {input} | tools/samtools/samtools sort -n -@ {params.threads} | tools/bedtools2/bin/bamToBed -bedpe -mate1 | awk 'BEGIN{{FS=OFS="\t"}} $9 == "+" {{ print $1,$2,$6,$7,$8,"-" }} $9 == "-" {{ print $1,$5,$3,$7,$8,"+" }}' > {output}
        """
