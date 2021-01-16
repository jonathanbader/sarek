process MERGE_BAM {
    label 'cpus_8'

    tag "${meta.id}"
    //TODO publishDir
    
    input:
        tuple val(meta), path(bam)

    output:
        tuple val(meta), path("${meta.sample}.bam"), emit: bam
        val meta,                                    emit: tsv

    script:
    """
    samtools merge --threads ${task.cpus} ${meta.sample}.bam ${bam}
    """
}