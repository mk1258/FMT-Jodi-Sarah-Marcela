# FMT-Jodi-Sarah-Marcela

## Authors
Sarah Holmes 
Marcela
Jodi

## what we are doing our project on
/tmp/gen711_project_data/FMT

# METHODS
## make directory trimmed_fastqs
mkdir trimmed_fastqs
mkdir trimmed_fastqs2
## move into environment genomics
conda activate genomics
## copy fastp-single.sh file into home directory
cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh


chmod +x ~/fastp-single.sh

./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs2
./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs
# cutoff poly-g length of fmt into trimmed_fastqs



cd trimmed_fastqs
ls
cd trimmed_fastqs2
ls

conda activate qiime2-2022.8
# activate qiime environment

qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs2 --output-path FMT_trimmed_fastq2
qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs --output-path FMT_trimmed_fastqs1
# import trimmed FASTQs into qiime file 

 qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastqs1.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs/FMT_cutadapt1.qza
 qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastq2.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs2/FMT_cutadapt2.qza
# remove primer and adapters of sequences

qiime demux summarize --i-data trimmed_fastqs/FMT_cutadapt1.qza --o-visualization trimmed_fastqs/FMT_demux1.qzv
qiime demux summarize --i-data trimmed_fastqs2/FMT_cutadapt2.qza --o-visualization trimmed_fastqs2/FMT_demux2.qzv
# make summary.qzv file 

qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats1.qza --o-table feature_table1.qza --o-representative-sequences rep-seqs1.qza
qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats.qza --o-table feature_table.qza --o-representative-sequences rep-seqs.qza
# denoising

qiime metadata tabulate --m-input-file denoising-stats1.qza --o-visualization denoising-stats1.qzv
qiime metadata tabulate --m-input-file denoising-stats.qza --o-visualization denoising-stats2.qzv
# tabulate visualization

qiime feature-table tabulate-seqs --i-data rep-seqs1.qza --o-visualization rep-seqs1.qzv
qiime feature-table tabulate-seqs --i-data rep-seqs.qza --o-visualization rep-seqs2.qzv
# tabulate table visualization


