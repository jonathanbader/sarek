process BWAMEM2_MEM {
    tag "${meta.id}"
    label 'process_high'

    publishDir "${params.outdir}/bwamem2/${meta.sample}",
        mode: params.publish_dir_mode,
        saveAs: { filename ->
                    if (filename.endsWith('.version.txt')) null
                    else filename }

    input:
        tuple val(meta), path(reads)
        path bwa
        path fasta
        path fai
        val options

    output:
        tuple val(meta), path("*.bam")

    script:
    CN = params.sequencing_center ? "CN:${params.sequencing_center}\\t" : ""
    readGroup = "@RG\\tID:${meta.run}\\t${CN}PU:${meta.run}\\tSM:${meta.sample}\\tLB:${meta.sample}\\tPL:ILLUMINA"
    extra = meta.status == 1 ? "-B 3" : ""
    """
    bwa-mem2 mem \
        ${options.args} \
        -R \"${readGroup}\" \
        ${extra} \
        -t ${task.cpus} \
        ${fasta} ${reads} | \
    samtools sort --threads ${task.cpus} -m 2G - > ${meta.id}.bam

    # samtools index ${meta.id}.bam

    echo \$(bwa-mem2 version 2>&1) > bwa-mem2.version.txt
    """
}