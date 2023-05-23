import numpy as np
import os
import soundfile
import tqdm
import glob

# Here is a simple example about generating required train.tsv file.
files = glob.glob("/mnt/proj3/open-24-5/pengjy_new/Data/Data2/Libri/LibriSpeech/train*/*/*/*.flac")

files.sort()
f2 = open('train.tsv','w')

for fname in tqdm.tqdm(files):
    path = fname.replace("/mnt/proj3/open-24-5/pengjy_new/Data/Data2/Libri/LibriSpeech/","")
    frames = soundfile.info(str(fname)).frames
    f2.writelines(path+'\t'+str(frames)+'\n')

f2.close() 

