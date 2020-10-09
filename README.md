# MinEASY

####  From fastq to polished consensus sequenses in one go
MinEASY can process multiple samples in one line of code:
- Mixed samples cointaing multiple species from bulk and eDNA
- Multiplexed barcodes
- Multiple samples in one run
- Outputs Medaka polished consensus sequences

### Installation

All dependencies are included with execption of the BLAST+ commandline application. If the BLAST function is desired it can be downloaded from  [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/).

```sh
$ conda install mineasy
$ conda activate mineasy
```

### Dependencies

MinEASY runs on all your favorite sequence processing tools:

| Tool | function |
| ------ | ------ |
| Nanofilt | Filter raw reads on quality and readlength |
| Qcat | Demultiplex samples |
| CD-hit | Cluster reads from samples containing multiple species |
| Minimap2 | Align (clustered) reads |
| Racon | Make first consensus sequences |
| Medaka | Polish consensus sequences |
| Medaka | SNP calling (to be verified for mixed samples) |
| BLAST+ | Optional, needs additional install [NCBI BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK52640/) |


### Usage
Example 
```sh 
$ mineasy -d -l 800 -m 1200 -q 10 -c 0.80 -n 250 -M 
```
Will: Demultiplex, filter for readlength 800-1200 bp and quality score 10, cluster reads at 80% ID, make consensuses of clusters larger then 250 sequences, polish with Medaka.
| Command | Function | 
| ------ | ------ |
| -h | help | 
| -d |  demultiplex |
| -q | quality score |
| -l | minimum length |
| -m | maximum length |
| -c | clustering percentage, 0.8 = 80% identity |
| -w | clustering wordlength |
| -n | clustersize default 100 |
| -M | polish consensus with Medaka |
| -v | variant calling with Medaka |
| -B | yourblastdatabase.fasta |
| -b | /path/to/existing/blast/database | 
| -i | gives info about % sequences assigned to clusters |
| -p | plot readlength distribution histogram |
| -r | re-cluster consensus sequences |
| -f | folder structure: your fastq files are already demultiplexed and stored in barcode folders |

