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
