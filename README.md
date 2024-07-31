
## New paper (including Decona) available as preprint on Biorxiv

### **High resolution species detection: accurate long read eDNA metabarcoding of North Sea fish using Oxford Nanopore sequencing**

Karlijn Doorenspleet, Lara Jansen, Saskia Oosterbroek, Oscar Bos, Pauline Kamermans, Max Janse, Erik Wurz, Albertinka Murk, Reindert Nijland

doi: https://doi.org/10.1101/2021.11.26.470087

# Decona [![Twitter URL](https://img.shields.io/twitter/url/https/twitter.com/SaskiaO13.svg?style=social&label=Follow%20%40SaskiaO13)](https://twitter.com/SaskiaO13)

**Version 1.4**
- Installation process edited
- Primer trimming with **Cutadapt** added
- Basic OTU calling function added (across barcodes if applicable)
- **-i** changed to input path
- Compatiblity issue with Dorado generated fastq's solved
- Bugs fixed

##  From demultiplexing to consensus for Nanopore amplicon data
Decona can process multiple samples in one line of code:
- Mixed samples containing multiple species from bulk and eDNA
- Mixed amplicons in one barcode
- Multiplexed barcodes
- Multiple samples in one run
- Outputs (Medaka polished) consensus sequences

<img src="https://raw.githubusercontent.com/Saskia-Oosterbroek/decona/master/Decona_1-4_overview.JPG" width="600" />

## Presentation at DNAQUA International Conference
[![](http://img.youtube.com/vi/e3mw2UuAdC8/0.jpg)](http://www.youtube.com/watch?v=e3mw2UuAdC8 "")

- 00:00 general introduction
- 02:20 Decona's core principles
- 04:40 Examples from our own research
  - 2000 bp fish mitochondrial marker
  - Contaminated sponge COI
  - Within species variation: porpoise eDNA from seawater 3.5 kb mitochondrial marker

## Installation
Decona is only supported for use with Linux, the Ubuntu command line app for Windows also works but is recommended only for use with smaller datasets.

Decona is sensitive to installation version of dependencies. To keep things simple the installer will create a virtual Conda environment for you containing everything you need.

Download the latest release (version 1.3) or clone the repository (version 1.4)

```sh
$ tar xjvf decona-0.1.3.tar.bz2
$ ./decona/bin/install.sh
$ conda activate decona
```

If installation fails you can manually create the environment:
```sh
conda create medaka=1.11.3 python=3.8.10 cutadapt=4.8 racon=1.4.20 NanoFilt=2.8.0 cd-hit=4.8.1 blast=2.15.0 --channel conda-forge --channel bioconda --name decona1.4
```
This will create the correct environment but you have to copy the “decona” file(script) to the environment bin (~/miniconda3/envs/decona1.4/bin) manually. If you activate the environment 
```conda activate decona1.4```  you should be able to run the program calling ```decona -h ``` which should give the help section.

It is possible you will get an accessibility warning in that case you can grant access to the file by running ```chmod +x ~/miniconda3/envs/decona1.4/bin/decona ```


## Dependencies

Decona runs on all your favourite sequence processing tools:
| Tool | version |  function |
| ------ | ------ | ------ |
| Nanofilt | 2.8.0 | Filter raw reads on quality and read length |
| Cutadapt | 4.8 | (Optionally) trim primer sequences |
| CD-hit | 4.8.1 | Cluster reads from samples containing multiple species / amplicons |
| Minimap2 | 2.17 | Align clustered reads |
| Racon | 1.4.13 | Make consensus sequences |
| Medaka | 1.11.3 | (Optionally) polish consensus sequences |
| Blast | 2.15.0 | (Optionally) blast consensus sequences |


## Usage
**Decona works on all fastq files in your working directory.** It is a good idea to have an empty directory with just the files you want to run. A results folder will appear in your working directory after a successful run.
Example
```sh
$ decona -d -l 800 -m 2100 -q 10 -c 0.95 -n 100 -M
```
Will: Demultiplex, filter for read length 800-2100 bp and quality score 10, cluster reads at 95% ID, make consensuses of clusters larger than 100 sequences, polish with Medaka.

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
|  -c    | clustering percentage (default 0.8 for 80% identity) |
|  -w    | clustering wordlength (default 5) |
|  -n    | clustersize (default 100) |
|  -i    | gives info about % sequences assigned to clusters |
|  -r    | re-cluster consensus sequences (use a second round of clustering)|
|  -g    | clustering algorithm: 1 or 0 (default 1) |
|       | If set to 1, the program will cluster reads into the most similar cluster that meets the threshold (accurate but slow mode)|
|       | If set to 0 a sequence is clustered to the first cluster that meets the threshold (fast cluster)|
| **-R**  | **Randomly subsample each clusters till maximum size of n (optional, not used by default)** |
|  **-k**   | **set custom kmer length, short reads require smaller kmer length (default 15)** |
| Polishing | |
|  -M    | polish consensus with Medaka |
|  -s    | snip/variant calling with Medaka |
| BLAST | Optional, needs additional install: [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/) |
|  -B    | yourblastdatabase.fasta |
|  -b    | /path/to/existing/blast/database/existing-data-base-file.fasta |

## Warning
**Selecting the right stringency for the clustering setting is very important.** If it is set too low, species will be clustered together; if it is set too high, species will be lost as more singletons emerge. R9 and R10 data absolutely require different stringencies. Genetic markers with more or less genetic variation will also need to be clustered with higher or lower stringency. **It is advisable to conduct several small runs to determine the appropriate level of stringency for your amplicon.**

## Running Decona on the example data

To run Decona on the example data:
```sh
decona -f -l 800 -m 2100 -q 10 -c 0.80 -n 25 -M -i ~/computer/work_dir/example_data/
```
from within the directory `example_data/`. It will generate output in the directory `data/`.

