# FMT-Jodi-Sarah-Marcela

## Authors
Jodi Stetser
Sarah Holmes
Marcela Klofac

## what we are doing our project on
/tmp/gen711_project_data/FMT

## Background
We were interested in the effect that Fecal Microbiota Transplants (FMT) had on the wellbeing of individuals in need and the process that goes along with this variation of Microbiota Transfer Therapy (MTT). Kang and colleagues assessed the impact of FMT on the alteration of gut flora and subsequent improvements of gastointestinal (GI) symptoms in children with Autism Spectrum Disorder (ASD). 
ASD is a complex neurobiological disorder that impairs social interactions and communication skills. These issues lead to repeptitive, restricted, and stereotypical patterns of behavior, interests, and activities of those affected. The cause of this spectrum of disorders is complex due to the interplay of genetic and environmental factors on the severity of symptoms. Due to this lack of straightforward explanation, there is no Food and Drug Administration (FDA)-approved pharmaceutical treatment to aid in the management of symptoms.
However, the gut microbiota of the individual affected is suspected to play a role in this disorder. People with ASD often suffer from GI issues such as consipation, diarrhea, or a combination of both phenomena. Interestingly, the severity of these GI anomalies is correlated with the severity of ASD symptoms. In those with increasingly severe ASD, a lower abundance of fermentative bacteria and a lower overall bacterial diversity has been observed. This creates a dysbiotic relationship between gut microbiota and issues in metabolite regulation, affecting GI functioning and correlating to general neurobiological conditions incuding anxiety.

The purpose of Kang and colleagues' study was to offer FMT treatment to individuals with ASD and GI abnormalities to assess its impact on the microbial diversity of the gut flora and potential improvements in ASD and GI related symptoms. 18 children between 7 and 16 years old with ASD and existing GI symptoms participated in this 18 week study. ASD symptoms were assessed prior to the experiment through the Autism Diagnostic Interview Revised (ADI-R). As well, 20 age and gender matched neurotypical children without GI issues were represented as a control group and monitered for 18 weeks without treatment. 
In the experimental group, the children underwent two weeks of antibiotic treatment through the use of Vancomycin to ensure suppression of pathogenic bacteria in the gut. Prilosec, an acid pump inhibitor, was administered on the 12th day of treatment to manage stomach acid content. This was continued until the end of the treatment period. Next, the participants endured a 12-24 hour fasting period before peforming a bowel cleanse. Flushing the bowels with MoviPrep ensured the removal of remaining problematic gut bacteria and leftover antibiotics in the system. On the 16th day of the study, a high initial dose of Standardized Human Gut Microbiota (SHGM) was administered either orally or rectally to repopulate the gut microbiota. This high initial dose was then followed by daily, low maintenance, oral doses in combination with Prilosec for 7-8 weeks. This ensured the survivial of the SHGM in the stomach environment. Following treatment, the participants were monitered for an additional 8 weeks. GI symptoms were assessed through the Gastrointestinal Symptom Rating Scale (GSRS) and the Daily Stool Records (DSR). ASD symptoms were assessed through a combination of several surveys: the Parent Global Impressions-III (PGI-III), Childhood Autism Rating Scale (CARS), Aberrant Behavior Checklist (ABS), Social Responsiveness Scale (SRS), and the Vineland Adpative Behavior Scale II (VABS-II). Lastly, microbial analysis of gut flora diversity was performed using swabs and direct stool samples.
In our analysis, we compared the bacterial diversity, represented by the frequency of several bacterial species, between stool and swab samples. The bacteria types found in these two sample collections was further compared to donor sample controls of SHGM.
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
### CUTADAPT: Remove primers and adapter from the trimmed fastq sequences
For Sequence 1:
qiime cutadapt trim-single \
--i-demultiplexed-sequences trimmed_fastqs/FMT_trimmed_fastqs1.qza \
--p-front TACGTATGGTGCA \
--p-discard-untrimmed \
--p-match-adapter-wildcards \
--verbose \
--o-trimmed-sequences trimmed_fastqs/FMT_cutadapt1.qza

For Sequence 2:
qiime cutadapt trim-single \
--i-demultiplexed-sequences trimmed_fastqs2/FMT_trimmed_fastqs2.qza \
--p-front TACGTATGGTGCA \
--p-discard-untrimmed \
--p-match-adapter-wildcards \
--verbose \
--o-trimmed-sequences trimmed_fastqs2/FMT_cutadapt2.qza

### make summary.qzv files for each sequence
qiime demux summarize --i-data trimmed_fastqs/FMT_cutadapt1.qza --o-visualization trimmed_fastqs/FMT_demux1.qzv
qiime demux summarize --i-data trimmed_fastqs2/FMT_cutadapt2.qza --o-visualization trimmed_fastqs2/FMT_demux2.qzv
### denoising - remove errors & low quality reads in the sequences
qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs/FMT_cutadapt1.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats1.qza --o-table feature_table1.qza --o-representative-sequences rep-seqs1.qza
qiime dada2 denoise-single --i-demultiplexed-seqs trimmed_fastqs2/FMT_cutadapt2.qza --p-trunc-len 50 --p-trim-left 13 --p-n-threads 4 --o-denoising-stats denoising-stats2.qza --o-table feature_table2.qza --o-representative-sequences rep-seqs2.qza
### tabulate visualization
qiime metadata tabulate --m-input-file denoising-stats1.qza --o-visualization denoising-stats1.qzv
qiime metadata tabulate --m-input-file denoising-stats2.qza --o-visualization denoising-stats2.qzv
### tabulate table visualization
qiime feature-table tabulate-seqs --i-data rep-seqs1.qza --o-visualization rep-seqs1.qzv
qiime feature-table tabulate-seqs --i-data rep-seqs2.qza --o-visualization rep-seqs2.qzv
### make directory for graphs
mkdir FMT_trimmed
### merge the sequences for tables 
qiime feature-table merge-seqs --i-data rep-seqs1.qza --i-data rep-seqs2.qza --o-merged-data FMT_merged/merged.rep-seqs.qza
### classify data to a reference sequence & assign taxonomy
qiime feature-classifier classify-sklearn --i-classifier /tmp/gen711_project_data/reference_databases/classifier.qza --i-reads FMT_merged/merged.rep-seqs.qza --o-classification FMT_merged/FMT-taxonomy.qza
### create bar graph 1
qiime taxa barplot --i-table feature_table1.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-1.qzv
### create bar graph 2
qiime taxa barplot --i-table feature_table.qza --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization FMT_merged/barplot-2.qzv
### add metadata
qiime taxa barplot --i-table feature_table1.qza --m-metadata-file sample-metadata.tsv --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization my-barplot.qzv 
qiime taxa barplot --i-table feature_table2.qza --m-metadata-file sample-metadata.tsv --i-taxonomy FMT_merged/FMT-taxonomy.qza --o-visualization my-barplot2.qzv
### create feature table
qiime feature-table filter-samples --i-table feature_table1.qza --m-metadata-file metadata.tsv --o-filtered-table new_samples_table1.qza
qiime feature-table filter-samples --i-table feature_table2.qza --m-metadata-file metadata.tsv --o-filtered-table new_samples_table2.qza

## Findings
### plot 1
https://view.qiime2.org/visualization/?type=html&src=ae7abd73-d1b0-4525-9b3d-57f461424987
### plot 2
https://view.qiime2.org/visualization/?type=html&src=7d8b9b0e-8727-4742-95da-f26bf93c3b2d

## Database
classifier = /tmp/gen711_project_data/reference_databases/classifier.qza
