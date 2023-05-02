# FMT-Jodi-Sarah-Marcela

## Authors
Sarah Holmes 
Marcela
Jodi

## what we are doing our project on
/tmp/gen711_project_data/FMT

## Background

## Methods
### make directory trimmed_fastqs
mkdir trimmed_fastqs
mkdir trimmed_fastqs2
### move into environment genomics
conda activate genomics
### copy fastp-single.sh file into home directory
cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh
### change mode of the file 
chmod +x ~/fastp-single.sh
### cutoff poly-g lengths of FMT files and place into trimmed_fastqs
./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs2
./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs
### check that neither directory is empty
cd trimmed_fastqs
ls
cd trimmed_fastqs2
ls
### activate the qiime environment
conda activate qiime2-2022.8
### import the trimmed FASTQs into qiime files
qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs2 --output-path FMT_trimmed_fastq2
qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs --output-path FMT_trimmed_fastqs1
### remove primers and adapters of the trimmed fastq sequences
 qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastqs1.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs/FMT_cutadapt1.qza
 qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastq2.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs2/FMT_cutadapt2.qza
### make summary.qzv files for each sequence
qiime demux summarize --i-data trimmed_fastqs/FMT_cutadapt1.qza --o-visualization trimmed_fastqs/FMT_demux1.qzv
qiime demux summarize --i-data trimmed_fastqs2/FMT_cutadapt2.qza --o-visualization trimmed_fastqs2/FMT_demux2.qzv
### denoising - remove errors in the sequences
qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats1.qza --o-table feature_table1.qza --o-representative-sequences rep-seqs1.qza
qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats.qza --o-table feature_table.qza --o-representative-sequences rep-seqs.qza
### tabulate visualization
qiime metadata tabulate --m-input-file denoising-stats1.qza --o-visualization denoising-stats1.qzv
qiime metadata tabulate --m-input-file denoising-stats.qza --o-visualization denoising-stats2.qzv
### tabulate table visualization
qiime feature-table tabulate-seqs --i-data rep-seqs1.qza --o-visualization rep-seqs1.qzv
qiime feature-table tabulate-seqs --i-data rep-seqs.qza --o-visualization rep-seqs2.qzv
### make directory for graphs
mkdir FMT_trimmed
### merge the sequences for tables
qiime feature-table merge-seqs --i-data rep-seqs1.qza --i-data rep-seqs.qza --o-merged-data FMT_merged/merged.rep-seqs.qza
### classify data to a reference sequence 
qiime feature-classifier classify-sklearn --i-classifier /tmp/gen711_project_data/reference_databases/classifier.qza --i-reads FMT_merged/merged.rep-seqs.qza --o-classification FMT_merged/FMT-taxonomy.qza
### create bar graph 1
qiime taxa barplot --i-table feature_table1.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-1.qzv
### create bar graph 2
qiime taxa barplot --i-table feature_table.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-2.qzv

## Findings
### plot 1
https://view.qiime2.org/visualization/?type=html&src=ae7abd73-d1b0-4525-9b3d-57f461424987
### plot 2
https://view.qiime2.org/visualization/?type=html&src=7d8b9b0e-8727-4742-95da-f26bf93c3b2d
