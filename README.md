final project.txt
https://github.com/mk1258/FMT-Jodi-Sarah-Marcela/tree/main

1. cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh
# copies file into home directory
2. chmod +x ~/fastp-single.sh
#
3. head fastp-single.sh
# opens file
4. mkdir trimmed_fastqs
# makes directory "trimmed_fastqs"
5. ./fastp-single.sh 150 /tmp/gen711_project_data/fastp-single.sh trimmed_fastqs
./fastp.sh 150 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs
./fastp.sh 150 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs
# shows contents of file
6. conda activate qiime2-2022.8
# activate qiime environment

qiime tools import --type "SampleData[PairedEndSequencesWithQuality]" --input-format CasavaOneEightSingleLanePerSampleDirFmt --input-path /home/users/mk1258/trimmed_fastqs  --output-path /home/users/mk1258/trimmed_fastqs/FMT_trimmed_fastqs

Lab notebook10

###activate genomics environment
# conda activate genomics

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


Lab notebook 11

###denoising
# qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats1.qza --o-table feature_table1.qza --o-representative-sequences rep-seqs1.qza

# qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt2.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats2.qza --o-table feature_table2.qza --o-representative-sequences rep-seqs2.qza

###metadata tabulate
# qiime metadata tabulate --m-input-file denoising-stats1.qza --o-visualization denoising-stats1.qzv

# qiime metadata tabulate --m-input-file denoising-stats2.qza --o-visualization denoising-stats2.qzv

###feature table tabulate
# qiime feature-table tabulate-seqs --i-data rep-seqs1.qza --o-visualization rep-seqs1.qzv

# qiime feature-table tabulate-seqs --i-data rep-seqs2.qza --o-visualization rep-seqs2.qzv

###Make directory for graphs
# mkdir FMT-merged

###merge sequences
# qiime feature-table merge-seqs --i-data rep-seqs1.qza --i-data rep-seqs2.qza --o-merged-data FMT_merged/merged.rep-seqs.qza

###Classify data and assign taxonomy
# qiime feature-classifier classify-sklearn --i-classifier /tmp/gen711_project_data/reference_databases/classifier.qza --i-reads FMT_merged/merged.rep-seqs.qza --o-classification FMT_merged/FMT-taxonomy.qza

###Create Bar graphs
# qiime taxa barplot --i-table feature_table1.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_barplots/barplot-1.qzv

# qiime taxa barplot --i-table feature_table2.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_barplots/barplot-2.qzv

###copy file to home directory
# cp /tmp/gen711_project_data/FMT_3/sample-metadata.tsv .

###Metadata and background info
# qiime taxa barplot --i-table feature_table1.qza --m-metadata-file sample-metadata.tsv  --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_barplots/barplot-1.qzv

# qiime taxa barplot --i-table feature_table2.qza --m-metadata-file sample-metadata.tsv  --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_barplots/barplot-2.qzv

###Feature table filter samples
# qiime feature-table filter-samples --i-table feature_table1.qza --m-metadata-file sample-metadata.tsv --o-filtered-table new_samples_table1.qza

# qiime feature-table filter-samples --i-table feature_table2.qza --m-metadata-file sample-metadata.tsv --o-filtered-table new_samples_table2.qza
