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
get /home/users/jms1418/FMT_merged/barplot-1.qzv desktop
get /home/users/jms1418/FMT_merged/barplot-2.qzv desktop
### Create filtered phylogenetic trees
For sequence 1:
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences rep-seqs1.qza --o-alignment alignments --o-masked-alignment masked-alignment --o-tree unrooted-tree --o-rooted-tree rooted-tree --p-n-threads 4
For sequence 2:
qiime phylogeny align-to-tree-mafft-fasttree --i-sequences rep-seqs.qza --o-alignment alignments2 --o-masked-alignment masked-alignment2 --o-tree unrooted-tree2 --o-rooted-tree rooted-tree2 --p-n-threads 4
For sequence 1:
qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree.qza --i-table feature_table1.qza --p-sampling-depth 500 --m-metadata-file sample-metadata.tsv --p-n-jobs-or-threads 4 --output-dir core-metrics
For sequence 2:
qiime diversity core-metrics-phylogenetic --i-phylogeny rooted-tree2.qza --i-table feature_table.qza --p-sampling-depth 500 --m-metadata-file sample-metadata.tsv --p-n-jobs-or-threads 4 --output-dir core-metrics2
For sequence 1:
qiime feature-table relative-frequency --i-table core-metrics/rarefied_table.qza --o-relative-frequency-table core-metrics/realativerarefied_table
For sequence 2:
qiime feature-table relative-frequency --i-table core-metrics2/rarefied_table.qza --o-relative-frequency-table core-metrics2/realative_rarefied_table2
For sequence 1:
qiime diversity pcoa-biplot --i-features core-metrics/realativerarefied_table.qza --i-pcoa core-metrics/unweighted_unifrac_pcoa_results.qza --o-biplot core-metrics/unweighted_unifrac_pcoa_biplot
For sequence 2:
qiime diversity pcoa-biplot --i-features core-metrics2/realative_rarefied_table2.qza --i-pcoa core-metrics2/unweighted_unifrac_pcoa_results.qza --o-biplot core-metrics2/unweighted_unifrac_pcoa_biplot2
For sequence 1:
qiime emperor biplot --i-biplot core-metrics/unweighted_unifrac_pcoa_biplot.qza --m-sample-metadata-file sample-metadata.tsv --o-visualization core-metrics/unweighted_unifrac_pcoa_biplot
For sequence 2:
qiime emperor biplot --i-biplot core-metrics2/unweighted_unifrac_pcoa_biplot2.qza --m-sample-metadata-file sample-metadata.tsv --o-visualization core-metrics2/unweighted_unifrac_pcoa_biplot2
For sequence 1:
qiime diversity alpha-group-significance --i-alpha-diversity core-metrics/shannon_vector.qza --m-metadata-file sample-metadata.tsv --o-visualization core-metrics/alpha-group-significance
For sequence 2:
qiime diversity alpha-group-significance --i-alpha-diversity core-metrics2/shannon_vector.qza --m-metadata-file sample-metadata.tsv --o-visualization core-metrics2/alpha-group-significance2

get /home/users/jms1418/core-metrics/alpha-group-significance.qzv desktop

get /home/users/jms1418/core-metrics2/alpha-group-significance2.qzv desktop

get /home/users/jms1418/core-metrics/unweighted_unifrac_pcoa_biplot.qzv desktop

get /home/users/jms1418/core-metrics2/unweighted_unifrac_pcoa_biplot2.qzv desktop

get /home/users/jms1418/core-metrics/bray_curtis_emperor.qzv desktop

get /home/users/jms1418/core-metrics2/bray_curtis_emperor2.qzv desktop

get /home/users/jms1418/core-metrics/jaccard_emperor.qzv desktop

get /home/users/jms1418/core-metrics2/jaccard_emperor2.qzv desktop

get /home/users/jms1418/core-metrics/unweighted_unifrac_emperor.qzv desktop

get /home/users/jms1418/core-metrics2/unweighted_unifrac_emperor2.qzv desktop

get /home/users/jms1418/core-metrics/weighted_unifrac_emperor.qzv desktop

get /home/users/jms1418/core-metrics2/weighted_unifrac_emperor2.qzv desktop
