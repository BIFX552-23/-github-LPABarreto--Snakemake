# count number of lines
#rule countlines:
#output: "ref1_1.fq.count"
#input: "reads/ref1_1.fq"
#shell:
# "echo $(( $(wc -l <reads/ref1_1.fq) / 4 )) > ref1_1.fq"

# count number of lines
#rule countlines2:
#output: "etoh60_1_1.fq.count"
#input: "reads/etoh60_1_1.fq"
#shell:
# "echo $(( $(wc -l <reads/etoh60_1_1.fq) / 4 )) > etoh60_1_1.fq"

# count number of sequences
#rule countreads:
 # output: "{myfile}.count"
 # input: "reads/{myfile}"
  #shell:
   # "echo $(( $(wc -l <{input}) / 4 )) > {output}"
  
# trim reads
#rule trimreads: 
  #output: "trimmed/{myfile}"
  #input: "reads/{myfile}"
  #shell:
    #"fastq_quality_trimmer -t 20 -l 100 -o {output} < {input}"

# count number of reads
rule countreads:
  output: "{indir}.{myfile}.fq.count"
  input: "{indir}/{myfile}.fq"
  shell:
    "echo $(( $(wc -l <{input}) / 4 )) > {output}"
  
# trim reads
rule trimreads:
  output: "trimmed/{myfile}.fq"
  input: "reads/{myfile}.fq"
  shell:
    "fastq_quality_trimmer -t 22 -l 100 -o {output} < {input}"

# align reads
rule kallisto_quant:
  output:
    h5 = "kallisto.{sample}/abundance.h5",
    tsv = "kallisto.{sample}/abundance.tsv",
    json = "kallisto.{sample}/run_info.json"
  input:
    idx = "transcriptome/Saccharomyces_cerevisiae.R64-1-1.kallisto_index",
    fq1 = "trimmed/{sample}_1.fq",
    fq2 = "trimmed/{sample}_2.fq"
  shell:
    "kallisto quant -i {input.idx} -o kallisto.{wildcards.sample} {input.fq1} {input.fq2}"

# kallisto index
rule kallisto_index:
  output:
    idx = "transcriptome/{strain}.kallisto_index",
    log = "transcriptome/{strain}.kallisto_log"
  input: "transcriptome/{strain}.cdna.all.fa.gz"
  shell:
    "kallisto index -i {output.idx} {input} >& {output.log}"
