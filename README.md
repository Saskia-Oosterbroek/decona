
## New paper (including Decona) available as preprint on Biorxiv

### **High resolution species detection: accurate long read eDNA metabarcoding of North Sea fish using Oxford Nanopore sequencing**

Karlijn Doorenspleet, Lara Jansen, Saskia Oosterbroek, Oscar Bos, Pauline Kamermans, Max Janse, Erik Wurz, Albertinka Murk, Reindert Nijland

doi: https://doi.org/10.1101/2021.11.26.470087 

# Decona [![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/SaskiaO13.svg?style=social&label=Follow%20%40SaskiaO13)](https://twitter.com/SaskiaO13)

**Version 0.1.2** bug fixes, multithreading enabled & less accurate quick clustering algorithm enabled.

For more elaborate explanations please see the "Wiki" in the menu bar.

##  From demultiplexing to consensus for Nanopore amplicon data  
Decona can process multiple samples in one line of code:
- Mixed samples containing multiple species from bulk and eDNA
- Mixed amplicons in one barcode
- Multiplexed barcodes
- Multiple samples in one run
- Outputs Medaka polished consensus sequences

<img src="https://raw.githubusercontent.com/Saskia-Oosterbroek/decona/master/Decona_overview.JPG" width="600" />

## Presentation at DNAQUA International Conference
[![](http://img.youtube.com/vi/e3mw2UuAdC8/0.jpg)](http://www.youtube.com/watch?v=e3mw2UuAdC8 "")

- 00:00 general introduction
- 02:20 Decona's core principles
- 04:40 Examples from our own research
  - 2000 bp fish mitochondrial marker
  - Contaminated sponge COI
  - Within species variation: porpoise eDNA from seawater 3.5 kb mitochondrial marker 

## Installation
Currently Decona is only supported for use with Linux, the Ubuntu command line app for Windows also works but is recommended only for use with smaller datasets.

Decona is sensitive to installation version of dependencies. To keep things simple the installer will create a virtual Conda environment for you containing everything you need. All dependencies are included with exception of the BLAST+ command line application. If the BLAST function is desired it can be downloaded from  [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/).

```sh
$ tar xjvf decona-0.1.2.tar.bz2
$ ./decona/bin/install.sh
$ conda activate decona
```


## Dependencies

Decona runs on all your favourite sequence processing tools:

| Tool | version |  function |
| ------ | ------ | ------ |
| Nanofilt | 2.3.0 | Filter raw reads on quality and read length |
| Qcat | 1.1.0 | Demultiplex samples |
| CD-hit | 4.8.1 | Cluster reads from samples containing multiple species / amplicons |
| Minimap2 | 2.17 | Align (clustered) reads |
| Racon | 1.4.13 | Make first consensus sequences |
| Medaka | 1.0.3 | Polish consensus sequences |
| Medaka | 1.0.3 | SNP calling (to be verified for mixed samples) |
| BLAST+ | 2.10.1 | Optional, needs additional install: [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/) |



## Usage
**Decona works on all fastq files in your working directory.** It is a good idea to have an empty directory with just the files you want to run. A results folder will appear in your working directory after a successful run.
Example 
```sh 
$ decona -d -l 800 -m 1200 -q 10 -c 0.80 -n 100 -M 
```
Will: Demultiplex, filter for read length 800-1200 bp and quality score 10, cluster reads at 80% ID, make consensuses of clusters larger than 100 sequences, polish with Medaka.
| Command | Function | 
| ------ | ------ |
| -h   | help |
|  -v   | version|
|  -T    | multithreading default 4 |
|  -p    | plot readlength distribution histogram (plots then exits program)|
|  -f    | folder structure: your fastq files are already demultiplexed and stored in barcode folders (such as output from Mk1C)|
| Filtering: | |
|  -d    | demultiplex |
|  -q    | quality score |
|  -l    | minimum length |
|  -m    | maximum length |
| Clustering | |
|  -c    | clustering percentage, 0.8 = 80% identity |
|  -w    | clustering wordlength |
|  -n    | clustersize default 100 |
|  -i    | gives info about % sequences assigned to clusters |
|  -r    | re-cluster consensus sequences (use a second round of clustering)|
|  -g    | clustering algorithm: 1 or 0, default 1. |
|       | If set to 1, the program will cluster reads into the most similar cluster that meets the threshold (accurate but slow mode)|
|       | If set to 0 a sequence is clustered to the first cluster that meets the threshold (fast cluster)|
| Polishing | |
|  -M    | polish consensus with Medaka |
|  -s    | snip/variant calling with Medaka |
| BLAST | |
|  -B    | yourblastdatabase.fasta |
|  -b    | /path/to/existing/blast/database/existing-data-base-file.fasta |
