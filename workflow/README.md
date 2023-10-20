Juan F. Santana, Ph.D. (juan-santana@uiowa.edu), University of Iowa, Iowa City, I.A.

# DFF-Seq snakemake pipeline

This DFF-Seq Snakemake pipeline processes paired-end FASTQ files and generates BigWig files. It includes deduplication of UMI-duplicated reads and offers options for both spike-in and library normalization. To customize the pipeline, please refer to the instructions in how to modify the config/config.yaml as explained below.

## Requirements

### Software

- snakemake
- python 3+

### Data files

- Three FASTQ files per sample: R1, R2, R3 - where R2 correspond to the UMI sequence.

### Usage

1. Clone the repository

2. Create working directory and move into it: 
```
mkdir -p path/to/project-workdir
cd path/to/project-workdir/workflow
```

3. Copy gzip FASTQ files into the `workflow` directory (perform next steps from inside this directory)

4. Install requirements by running: `setup_environment.py`

5. Modify `config/sampleskey.csv` (keep the header)

```
name,fastq_1,fastq_2,fastq_3
DMSO-TBP-1,Sample1_R1.fastq.gz,Sample1_R2.fastq.gz,Sample1_R3.fastq.gz
DMSO-TBP-2,Sample1_R1.fastq.gz,Sample1_R2.fastq.gz,Sample1_R3.fastq.gz
```

6. Edit the `config/config.yaml` file to specify parameters. Defaults:
```
- threads: 80
- minimum_read_length: 18
- main_genome:
  organism: hg38 # Specify the main genome to use (from UCSC)
- spikein_genome:
  organism: mm39 # If no spike-in was used, delete the assembly next to 'organism'. More information in `config/config.yaml`
- replicas: # If no replicas, delete the lines below 'replicas'
  'DMSO-polii-1-DMSO-polii-2': ['DMSO-polii-1', 'DMSO-polii-2']
  'DMSO-K4-1-DMSO-K4-2': ['DMSO-K4-1', 'DMSO-K4-2']
```

7. Run the pipeline: `snakemake --cores {integer}`

### Output

The pipeline generates the following output directories:

- `genomes` with bowtie indexed genomes
- `RESULTS` with the following structure:

```
RESULTS
├── TRIMMED
│   ├── .fq trimmed files
├── MAPPED
│   ├── .sam files
│   ├── .bed files
│   ├── DEDUP
│   │   ├── bed.dedup files
|   │   ├── BIGWIG
│   │   │   ├── .bw spike-in or library normalized files
|   │   │   ├── COMBINED
|   │   │   │   ├── .bw replicas combined
|   │   ├── BEDGRAPH
|   │   │   ├── .bg spike-in or library normalized files
```
