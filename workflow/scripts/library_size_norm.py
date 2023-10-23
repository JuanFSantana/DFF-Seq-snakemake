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
    with open(bed_file, "r") as bed:
        for line in bed.readlines():
            main_counts += 1
    count_dict[sample_name] = [main_counts]

def dataframe():
    df = pd.DataFrame(columns=['sample', 'total', 'genome', 'library size correction','corrected genome']) 
    
    for key, value in count_dict.items():
        df = df.append({'sample': key, 'total': sum(value), 'genome': value[0]}, ignore_index=True)

    df['library size correction'] = df['total'].mean() / df['total']
    df['corrected genome'] = df['genome'] * df['library size correction']

    output_dir = os.path.join(os.getcwd(), "RESULTS/MAPPED/DEDUP/")

    df.to_csv(output_dir + 'library-normalization.txt', sep='\t', index=False)


if __name__ == '__main__':
    dir_path = sys.argv[1]
    bed_files = glob(dir_path + "/*.dedup")

    with concurrent.futures.ProcessPoolExecutor() as executor:
        list(executor.map(spike_in, bed_files))

    dataframe()   
    


