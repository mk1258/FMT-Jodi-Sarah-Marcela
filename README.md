# FMT-Jodi-Sarah-Marcela

## Authors
Jodi Stetser
Sarah Holmes
Marcela Klofac

## what we are doing our project on
/tmp/gen711_project_data/FMT

## Background

## Methods
### make directory trimmed_fastqs
For sequence 1:

mkdir trimmed_fastqs

For sequence 2:

mkdir trimmed_fastqs2
### move into environment genomics
conda activate genomics
### copy fastp-single.sh file into home directory
cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh
### change mode of the file 
chmod +x ~/fastp-single.sh
### cutoff poly-g lengths of FMT files and place into trimmed_fastqs
For sequence 1:

./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs

For sequence 2:

./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs2
### check that neither directory is empty
For sequence 1:

cd trimmed_fastqs

ls

For sequence 2:

cd trimmed_fastqs2

ls
### activate the qiime environment
conda activate qiime2-2022.8
### import the trimmed FASTQs into qiime files
For sequence 1:

qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs --output-path FMT_trimmed_fastqs1

For sequence 2:

qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs2 --output-path FMT_trimmed_fastq2
### CUTADAPT: Remove primers and adapter from the trimmed fastq sequences
For sequence 1:

qiime cutadapt trim-single --i-demultiplexed-sequences trimmed_fastqs/FMT_trimmed_fastqs1.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs/FMT_cutadapt1.qza

For sequence 2:

qiime cutadapt trim-single --i-demultiplexed-sequences trimmed_fastqs2/FMT_trimmed_fastqs2.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs2/FMT_cutadapt2.qza
### make summary.qzv files for each sequence
For sequence 1:

qiime demux summarize --i-data trimmed_fastqs/FMT_cutadapt1.qza --o-visualization trimmed_fastqs/FMT_demux1.qzv

For sequence 2:

qiime demux summarize --i-data trimmed_fastqs2/FMT_cutadapt2.qza --o-visualization trimmed_fastqs2/FMT_demux2.qzv
### denoising - remove errors & low quality reads in the sequences
For sequence 1:

qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats1.qza --o-table feature_table1.qza --o-representative-sequences rep-seqs1.qza

For sequence 2:

qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats.qza --o-table feature_table.qza --o-representative-sequences rep-seqs.qza
### tabulate visualization
For sequence 1:

qiime metadata tabulate --m-input-file denoising-stats1.qza --o-visualization denoising-stats1.qzv

For sequence 2:

qiime metadata tabulate --m-input-file denoising-stats.qza --o-visualization denoising-stats2.qzv
### tabulate table visualization
For sequence 1:

qiime feature-table tabulate-seqs --i-data rep-seqs1.qza --o-visualization rep-seqs1.qzv

For sequence 2:

qiime feature-table tabulate-seqs --i-data rep-seqs.qza --o-visualization rep-seqs2.qzv
### make directory for graphs
mkdir FMT_trimmed
### merge the sequences for tables 
qiime feature-table merge-seqs --i-data rep-seqs1.qza --i-data rep-seqs.qza --o-merged-data FMT_merged/merged.rep-seqs.qza
### classify data to a reference sequence & assign taxonomy
qiime feature-classifier classify-sklearn --i-classifier /tmp/gen711_project_data/reference_databases/classifier.qza --i-reads FMT_merged/merged.rep-seqs.qza --o-classification FMT_merged/FMT-taxonomy.qza
### create bar graph 1
qiime taxa barplot --i-table feature_table1.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-1.qzv
### create bar graph 2
qiime taxa barplot --i-table feature_table.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-2.qzv
### download barplot files to computer
open new terminal
sftp ron login
get /home/users/jms1418/FMT_merged/barplot-1.qzv
get /home/users/jms1418/FMT_merged/barplot-2.qzv

## Findings
### Bar Graph of Sequence 1:
![level-2-bars](https://user-images.githubusercontent.com/130576738/235961767-09ddaa46-097f-4ecb-8c6c-b515664d36ef.svg)
### Bar Graph of Sequence 2:
![level-2-bars (1)](https://user-images.githubusercontent.com/130576738/235961798-3c69334c-9614-40b1-aeff-7525d826f4de.svg)


