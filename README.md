# FMT-Jodi-Sarah-Marcela
Sarah Holmes (FMT)
Marcela
Jodi
## what we are doing our project on
/tmp/gen711_project_data/FMT

mkdir trimmed_fastqs

conda activate genomics

cp /tmp/gen711_project_data/fastp-single.sh ~/fastp-single.sh

chmod +x ~/fastp-single.sh

./fastp-single.sh 150 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-2 trimmed_fastqs
./fastp-single.sh 150 /tmp/gen711_project_data/FMT_3/fmt-tutorial-demux-1 trimmed_fastqs

conda activate qiime2-2022.8

qiime tools import \
--type "SampleData[PairedEndSequencesWithQuality]" \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--input-path trimmed_fastqs \
--output-path trimmed_fastqs/FMT_trimmed_fastqs 

qiime cutadapt trim-paired \
--i-demultiplexed-sequences trimmed_fastqs/FMT_trimmed_fastqs \
--p-cores 4 --p-front-f TACGTATGGTGCA  \
--p-discard-untrimmed --p-match-adapter-wildcards \
--verbose \
--o-trimmed-sequences trimmed_fastqs/FMT_trimmed_fastqs.qza

qiime demux summarize \
--i-data trimmed_fastqs/FMT_trimmed_fastqs.qza 
\--o-visualization trimmed_fastqs/FMT_trimmed_fastqs.qzv 

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs trimmed_fastqs/FMT_trimmed_fastqs.qza  \
    --p-trunc-len-f ${trunclenf} \
    --p-trunc-len-r ${trunclenr} \
    --p-trim-left-f 0 \
    --p-trim-left-r 0 \
    --p-n-threads 4 \
    --o-denoising-stats trimmed_fastqs/denoising-stats.qza \
    --o-table trimmed_fastqs/feature_table.qza \
    --o-representative-sequences trimmed_fastq/rep-seqs.qza

qiime metadata tabulate \
    --m-input-file trimmed_fastqs/denoising-stats.qza \
    --o-visualization trimmed_fastqs/denoising-stats.qzv

qiime feature-table tabulate-seqs \
        --i-data trimmed_fastqs/rep-seqs.qza \
        --o-visualization trimmed_fastqs/rep-seqs.qzv
