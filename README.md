# FMT-Jodi-Sarah-Marcela
Sarah Holmes (FMT)
Marcela
Jodi
## what we are doing our project on
/tmp/gen711_project_data/FMT

Marcela Lab Notebook 9
1. cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh
# copies file into home directory
2. chmod +x ~/fastp-single.sh
#
3. head fastp-single.sh
# opens file
4. mkdir trimmed_fastqs
# makes directory "trimmed_fastqs"
5. ./fastp-single.sh 150 /tmp/gen711_project_data/fastp-single.sh trimmed_fastqs
# shows contents of file
6. conda activate qiime2-2022.8
# activate qiime environment

qiime tools import --type "SampleData[PairedEndSequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path /home/users/mk1258/trimmed_fastqs  --output-path /home/users/mk1258/trimmed_fastqs/FMT_trimmed_fastqs

qiime cutadapt trim-paired --i-demultiplexed-sequences FMT_trimmed_fastqs --p-cores 4 --p-front-f TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs/FMT_trimmed_fastqs.qza

qiime demux summarize --i-data FMT_trimmed_fastqs.qza --o-visualization  FMT_trimmed_fastqs/FMT_trimmed_fastqs.qzv 

qiime dada2 denoise-paired --i-demultiplexed-seqs qiime_out/${run}_demux_cutadapt.qza  --p-trunc-len-f ${trunclenf} --p-trunc-len-r ${trunclenr} --p-trim-left-f 0 --p-trim-left-r 0  --p-n-threads 4 --o-denoising-stats FMT_trimmed_fastqs/denoising-stats.qza --o-table FMT_trimmed_fastqs/feature_table.qza --o-representative-sequences FMT_trimmed_fastqs/rep-seqs.qza

qiime metadata tabulate --m-input-file FMT_trimmed_fastqs/denoising-stats.qza --o-visualization FMT_trimmed_fastqs/denoising-stats.qzv

qiime feature-table tabulate-seqs --i-data FMT_trimmed_fastqs/rep-seqs.qza --o-visualization FMT_trimmed_fastqs/rep-seqs.qzv


Marcela Lab notebook 10

#activate genomics environment
###conda activate genomics

###If you have not run fastp yet...
# cp /tmp/gen711_project_data/fastp-single.sh .
# chmod +x fastp-single.sh


###run fastp
# ./fastp-single.sh 120 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs2
# ./fastp-single.sh 120/tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs

###check the file sizes of the polyg trimmed fastq files
###Are any empty? Those will need to be removed from the directory
ls -shS
# ls
#run the following steps twice. Once for each output directory

###activate qiime
# conda activate qiime2-2022.8

###import fastqs into a single qiime file
# qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs --output-path FMT_trimmed_fastqs1

# qiime tools import --type "SampleData[SequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path trimmed_fastqs2 --output-path FMT_trimmed_fastqs2

###cutadapt
# qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastqs1.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs/FMT_cutadapt1.qza

# qiime cutadapt trim-single --i-demultiplexed-sequences FMT_trimmed_fastqs2.qza --p-front TACGTATGGTGCA --p-discard-untrimmed --p-match-adapter-wildcards --verbose --o-trimmed-sequences trimmed_fastqs2/FMT_cutadapt2.qza

###qiime demux summarize
# qiime demux summarize --i-data trimmed_fastqs/FMT_cutadapt1.qza --o-visualization trimmed_fastqs/FMT_demux1.qzv

# qiime demux summarize --i-data trimmed_fastqs2/FMT_cutadapt2.qza --o-visualization trimmed_fastqs2/FMT_demux2.qzv

###denoising
# qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats.qza --o-table feature_table.qza --o-representative-sequences rep-seqs.qza

# qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt2.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats.qza --o-table feature_table.qza --o-representative-sequences rep-seqs.qza

###metadata tabulate
# qiime metadata tabulate --m-input-file denoising-stats.qza --o-visualization denoising-stats.qzv

###feature table tabulate
# qiime feature-table tabulate-seqs --i-data rep-seqs.qza --o-visualization rep-seqs.qzv
