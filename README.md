# Decona

####  Demultiplex to polished consensus sequences for Nanopore
Decona can process multiple samples in one line of code:
- Mixed samples containing multiple species from bulk and eDNA
- Mixed amplicons in one barcode
- Multiplexed barcodes
- Multiple samples in one run
- Outputs Medaka polished consensus sequences

### Installation
Decona is sensitive to installation version of dependencies. To keep things simple the installer will create a virtual Conda environment for you containing everything you need. All dependencies are included with exception of the BLAST+ command line application. If the BLAST function is desired it can be downloaded from  [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/).

```sh
$ tar xjvf decona-0.1-0.tar.bz2
$ ./decona/bin/install.sh
$ conda activate decona
```

### Dependencies

Decona runs on all your favourite sequence processing tools:

| Tool | version |  function |
| ------ | ------ | ------ |
| Nanofilt | 2.3.0 | Filter raw reads on quality and read length |
| Qcat | 1.1.0 | Demultiplex samples |
| CD-hit | 4.8.1 | Cluster reads from samples containing multiple species / amplicons |
| Minimap2 | 2.17 | Align (clustered) reads |
| Racon | 1.4.13 | Make first consensus sequences |
| Medaka | 1.1.2 | Polish consensus sequences |
| Medaka | 1.1.2 | SNP calling (to be verified for mixed samples) |
| BLAST+ | 2.10.1 | Optional, needs additional install [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/) |


### Usage
Example 
```sh 
$ decona -d -l 800 -m 1200 -q 10 -c 0.80 -n 100 -M 
```
Will: Demultiplex, filter for read length 800-1200 bp and quality score 10, cluster reads at 80% ID, make consensuses of clusters larger than 100 sequences, polish with Medaka.
| Command | Function | 
| ------ | ------ |
| -h | help | 
| -v | version | 
| -p | plot read length distribution histogram. Not sure what your average read length is? Try this: $ decona -p |
| -d | demultiplex samples |
| -q | quality score (default 10) |
| -l | minimum length (default 300) |
| -m | maximum length |
| -c | clustering percentage, 0.8 = 80% identity (default 0.8) |
| -w | clustering word length (default 5 )   [ -n 7 for thresholds 0.88 ~ 0.9 / -n 6 for thresholds 0.85 ~ 0.88 / -n 5 for thresholds 0.80 ~ 0.85 ] |
| -n | cluster size: minimum amount of reads in a cluster to continue to consensus step (default 100) |
| -M | polish consensus with Medaka |
| -v | variant calling with Medaka |
| -B | yourblastdatabase.fasta, fasta file can be used as blast database. ([NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/) tool needs to be installed! |
| -b | /path/to/existing/blast/database Use this option if you already have a BLAST+ database on your system | 
| -i | gives an overview of the percentage of sequences assigned to the clusters |
| -r | re-cluster consensus sequences. It may happen that multiple clusters will arise containing one species. Reclustering will cluster the original fasta's based on the polished result at 99%. This may be especially important if you would like to do variant calling. |
| -f | folder structure: your fastq files are already demultiplexed and stored in barcode folders such as data already demultiplexed by MinION Mk1C. |
