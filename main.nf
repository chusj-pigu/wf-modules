process ANNOVAR {
    // Annotation by annovar
    tag "$sample"
    container 'annovar.sif'
    memory '24 GB'
    time '4h'

    input:
    tuple val(sample), path(vcf)

    output:
    tuple(val("$sample"), path("${sample}.annovar.hg38_multianno.vcf"))

    script:
    """
    /opt/annovar/table_annovar.pl $vcf /mnt/humandb -vcfinput -buildver hg38 -out ./${sample}.annovar -remove -protocol refgene,ensGene,knownGene,1000g2015aug_all,1000g2015aug_afr,1000g2015aug_amr,1000g2015aug_eas,1000g2015aug_eur,1000g2015aug_sas,esp6500siv2_all,esp6500siv2_ea,esp6500siv2_aa,ljb26_all,cosmic70,cosmic101,clinvar_20221231,avsnp151,nci60,exac03,exac03nontcga,dbscsnv11,gnomad41_exome -operation g,g,g,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f -nastring '.' -otherinfo
    """
}

process VCF2TSV {
    // Filter for important mutations, explode all annotation into different columns and replace Unicode Hex Character with character
    tag "$sample"
    container 'annovar.sif'
    memory '4 GB'
    time '2h'

    input:
    tuple val(sample), path(annotated_vcf)

    output:
    tuple(val("$sample"), path("${sample}.exploded_vcf.tsv"))

    script:
    """
    grep -e 'exonic' -e 'splicing' -e '^#' $annotated_vcf > ${sample}.temp
    vcf2tsv -g ${sample}.temp > ${sample}.exploded_vcf.tsv
    sed -i 's/\\\\x3b/;/g' ${sample}.exploded_vcf.tsv
    sed -i 's/\\\\x3d/=/g' ${sample}.exploded_vcf.tsv
    rm ${sample}.temp
    """
}

process FORMAT_ANNOTATE {
    // Select columns, format and add some annotations
    tag "$sample"
    container 'annovar.sif' 
    publishDir params.outdir
    memory '4 GB'
    time '2h'

    input:
    tuple val(sample), path(annotated_tsv)

    output:
    path "${sample}.annotated.tsv"

    script:
    """
    clair3_annovar_annotator_formatter.py $annotated_tsv $baseDir/bin/columns_clair3.conf ${sample}.annotated.tsv $baseDir/bin/gene_lists/
    """
}