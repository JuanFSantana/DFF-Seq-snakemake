#!/usr/bin/env python3

import os
import sys
from glob import glob
from multiprocessing import Manager
import concurrent.futures

import pandas as pd

manager = Manager()
count_dict = manager.dict()

def spike_in(bed_file: str) -> None:
    sample_name = os.path.basename(bed_file).split('.dedup')[0]
    main_counts = 0
    spike_counts = 0
    with open(bed_file, "r") as bed:
        for line in bed.readlines():
            columns = line.split("\t")
            chromosome = columns[0]
            try:
                main, spike = chromosome.split(".spikein")
                spike_counts += 1
            except ValueError:
                main = chromosome
                main_counts += 1
    count_dict[sample_name] = [main_counts, spike_counts]

def dataframe():
    df = pd.DataFrame(columns=['sample', 'total', 'main-genome', 'spikein-genome', 'library size correction',
                            'corrected main-genome', 'corrected spikein-genome', 'spike-in correction', 
                            'final corrected main-genome', 'final corrected main-genome', 'final correction factor']) 
    
    for key, value in count_dict.items():
        df = df.append({'sample': key, 'total': sum(value), 'main-genome': value[0], 'spikein-genome': value[1]}, ignore_index=True)

    df['library size correction'] = df['total'].mean() / df['total']
    df['corrected main-genome'] = df['main-genome'] * df['library size correction']
    df['corrected spikein-genome'] = df['spikein-genome'] * df['library size correction']
    df['spike-in correction'] = df['corrected spikein-genome'].mean() / df['corrected spikein-genome']
    df['final correction factor'] = df['library size correction'] * df['spike-in correction']
    df['final corrected main-genome'] = df['main-genome'] * df['final correction factor']
    df['final corrected spikein-genome'] = df['spikein-genome'] * df['final correction factor']

    output_dir = os.path.join(os.getcwd(), "RESULTS/MAPPED/DEDUP/")

    df.to_csv(output_dir + 'spike-in-normalization.txt', sep='\t', index=False)


if __name__ == '__main__':
    dir_path = sys.argv[1]
    bed_files = glob(dir_path + "/*.dedup")

    with concurrent.futures.ProcessPoolExecutor() as executor:
        list(executor.map(spike_in, bed_files))

    dataframe()   
    


