Juan F. Santana, Ph.D. (juan-santana@uiowa.edu), University of Iowa, Iowa City, I.A.

# DFF-Seq snakemake pipeline 

This DFF-Seq Snakemake pipeline processes paired-end FASTQ files and generates BigWig files. It includes deduplication of UMI-duplicated reads and offers options for either spike-in or library normalization. To customize the pipeline, please refer to the instructions in how to modify the config/config.yaml as explained below.

## Requirements

### System

- snakemake
- python 3+
- Linux OS
- Internet connection for fetching genomes

### Data files

- The following sequences are used for adapter trimming:
 ```
Read1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCA 
Read3 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
```

- Three FASTQ files per sample: R1, R2, R3 - where R2 correspond to the UMI sequence in the following format:
```
@A00876:427:H3WF7DRX3:1:2101:1181:1000 2:N:0:CACCGG
GTAGGATA
+
FFFFFFFF
```

### Usage

1. Create working directory and move into it: 
```
mkdir -p path/to/project-workdir
cd path/to/project-workdir/
```
2. Clone the repository.  

3. Copy zipped FASTQ files into the `workflow` directory (perform next steps from inside this directory)

4. Install requirements by running: `setup_environment.py`

5. Modify `config/sampleskey.csv` (keep the header)

```
name,fastq_1,fastq_2,fastq_3
DMSO-TBP-1,Sample1_R1.fastq.gz,Sample1_R2.fastq.gz,Sample1_R3.fastq.gz
DMSO-TBP-2,Sample1_R1.fastq.gz,Sample1_R2.fastq.gz,Sample1_R3.fastq.gz
```

6. Edit the `config/config.yaml` file to specify parameters. Defaults:
```
- threads: 80 # Threads to be used per sample

- minimum_read_length: 18 # Shortest allowable length for reads during trimming and mapping

- main_genome:
  organism: hg38 # Specify the main genome to use (from UCSC)
- spikein_genome:
  organism: mm39 # If no spike-in was used, delete the assembly next to 'organism' and leave it blank. More information in `config/config.yaml`

- turn_off_normalization: True | False # By default, the application will perform spike-in normalization when both a main and spike-in genome are provided. Alternatively, it will apply library size normalization when a spike-in genome 
is not provided. If no normalization is desired, change 'turn_off_normalization' to: True.

- replicas: # If no replicas, delete the lines below 'replicas'
  'DMSO-polii-1-DMSO-polii-2': ['DMSO-polii-1', 'DMSO-polii-2']
  'DMSO-K4-1-DMSO-K4-2': ['DMSO-K4-1', 'DMSO-K4-2']

- extension: ebwt | ebwtl # Specify the extension of the bowtie indexed genome. If the genome(s) contain more than 4 billion nucleotides, specify: ebwtl, otherwise leave as: ebwt

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
│   │   │   ├── .bw files spike-in normalized | library normalized | no normalization
|   │   │   ├── COMBINED
|   │   │   │   ├── .bw replicas combined
|   │   ├── BEDGRAPH
|   │   │   ├── .bg files spike-in normalized | library normalized | no normalization
```
