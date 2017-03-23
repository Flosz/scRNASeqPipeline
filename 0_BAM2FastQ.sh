#!/bin/bash
# Convert BAM file to paired, zipped, read files. Assumes paired-end sequencing

INPUTDIR=$1
TMPDIR=$2
#LSB_JOBINDEX=$3

export REF_CACHE=/lustre/scratch117/cellgen/team218/TA/TemporaryFileDir
FILEStoMAP=($INPUTDIR/*.bam)
ARRAYINDEX=$(($LSB_JOBINDEX-1))
FILE=${FILEStoMAP[$ARRAYINDEX]}
SAMTOOLS=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/CRAM/samtools-1.3.1/samtools
BEDTOOLS=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/bedtools2/bin/bedtools
FASTQ1=$( basename $FILE )_1.fastq
FASTQ2=$( basename $FILE )_2.fastq

if [ ! -f $FASTQ1.gz ] || [ ! -f $FASTQ2.gz ] ; then

	#Get upmapped reads and write to fastq
	TMP=Tmp$LSB_JOBINDEX.bam
	TMP2=Tmp2_$LSB_JOBINDEX.bam
	$SAMTOOLS sort -n $FILE -o $TMP
	$SAMTOOLS view -b -F 256 $TMP -o $TMP2
#	$SAMTOOLS bam2fq -1 $TMPDIR/$FASTQ1 -2 $TMPDIR/$FASTQ2 -n $FILE
	$BEDTOOLS bamtofastq -i $TMP2 -fq $TMPDIR/$FASTQ1 -fq2 $TMPDIR/$FASTQ2
	

	gzip $TMPDIR/$FASTQ1
	gzip $TMPDIR/$FASTQ2
	rm $TMP
	rm $TMP2

fi
