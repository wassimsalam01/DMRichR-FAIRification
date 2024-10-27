###### INSTALLATION ONLY ######
# IF using the already computed packages (.tar.gz), simply execute the following #
install.packages("BSgenome.Dpulex.NCBI.ASM2113471v1_1.0.0.tar.gz", repos = NULL, type = "source")
install.packages("TxDb.Dpulex.NCBI.ASM2113471v1.knownGene_1.0.tar.gz", repos = NULL, type = "source")
install.packages("org.Dpulex.eg.db_1.0.tar.gz", repos = NULL, type = "source")
###############################

# Computation of BSgenome, TxDb and org.db

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.18")

# R Version 4.3.2
BiocManager::install(c("AnnotationDbi","AnnotationHub","Biostrings","BSgenome","GenomicFeatures","rtracklayer"))
setwd("/path/to/seed-file")

# Download fna.gz sequence and export as 2bit file
download.file(url = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/134/715/GCF_021134715.1_ASM2113471v1/GCF_021134715.1_ASM2113471v1_genomic.fna.gz", destfile = "daphnia_pulex.fasta.gz")
pulex_fasta = Biostrings::readDNAStringSet("daphnia_pulex.fasta.gz")
pulex_2bit = file.path(getwd(), "GCF_021134715.1.2bit")
rtracklayer::export.2bit(pulex_fasta, pulex_2bit)

# Gene Transfer Format (GTF) file for building Transcript Database (TxDb)
download.file(url = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/134/715/GCF_021134715.1_ASM2113471v1/GCF_021134715.1_ASM2113471v1_genomic.gtf.gz", destfile = "daphnia_pulex.gtf.gz")

# Chromosome sizes info file
download.file(url = "https://hgdownload.soe.ucsc.edu/hubs/GCF/021/134/715/GCF_021134715.1/GCF_021134715.1.chrom.sizes.txt", destfile = "daphnia_pulex.chrom.sizes.txt")
chrom_info = read.csv(file = "daphnia_pulex.chrom.sizes.txt",
                      header = FALSE, sep = "\t", col.names = c("chr", "size"))

chrom_info = rbind(chrom_info[order(chrom_info$chr[1:12]), ], chrom_info[13, ])

# Computing BSgenome.Dpulex.NCBI.ASM2113471v1 library
BSgenome::forgeBSgenomeDataPkg("BSgenome.Dpulex.NCBI.ASM2113471v1-seed", verbose = TRUE)
# Quit R, and build the source package (tarball) with...
system('R CMD build BSgenome.Dpulex.NCBI.ASM2113471v1/')
system('R CMD check BSgenome.Dpulex.NCBI.ASM2113471v1_1.0.0.tar.gz')
system('R CMD INSTALL BSgenome.Dpulex.NCBI.ASM2113471v1_1.0.0.tar.gz')

# Install
install.packages("BSgenome.Dpulex.NCBI.ASM2113471v1_1.0.0.tar.gz", repos = NULL, type = "source")
library(BSgenome.Dpulex.NCBI.ASM2113471v1)

# Computing Transcript Database (TxDb) library
seqinfo_Dpulex = GenomeInfoDb::Seqinfo(seqnames = chrom_info$chr,
                                       seqlengths = chrom_info$size,
                                       isCircular = logical(13),
                                       genome = "Dpulex")
# Build metadata dataframe
name = c("Resource URL", "Type of Gene ID", "exon_nrow", "cds_nrow")
value = c("https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/134/715/GCF_021134715.1_ASM2113471v1/", "Entrez Gene ID", "159649", "113453")
pulex_metadata = data.frame(name, value)

txdb_pulex = GenomicFeatures::makeTxDbFromGFF(
  file = "daphnia_pulex.gtf.gz",
  format = "auto",
  dataSource = "NCBI",
  organism = "Daphnia pulex",
  taxonomyId = 6669,
  chrominfo = seqinfo_Dpulex,
  metadata = pulex_metadata
)

GenomicFeatures::makeTxDbPackage(
  txdb_pulex,
  version = "1.0",
  maintainer = "Wassim Salam <wassimsalam49@gmail.com>",
  author = "Wassim Salam",
  destDir = ".",
  pkgname = "TxDb.Dpulex.NCBI.ASM2113471v1.knownGene"
)

devtools::build(pkg = "TxDb.Dpulex.NCBI.ASM2113471v1.knownGene/")

# Install
install.packages("TxDb.Dpulex.NCBI.ASM2113471v1.knownGene_1.0.tar.gz", repos = NULL, type = "source")
library(TxDb.Dpulex.NCBI.ASM2113471v1.knownGene)

# Computing org.Dpulex.eg.db
org.Dp.eg.db = AnnotationHub::AnnotationHub()[["AH115573"]]
GIDkeys = keys(org.Dp.eg.db, "GID")
# Symbols/Gene Names Dataframe
DpSym = AnnotationDbi::select(
  org.Dp.eg.db,
  keys = GIDkeys,
  columns = c("GID", "ENTREZID", "SYMBOL", "GENENAME")
)
# Chromsomes Dataframe
DpChr = na.omit(AnnotationDbi::select(
  org.Dp.eg.db,
  keys = GIDkeys,
  columns = c("GID", "CHR")
))

# Obtained GO annotation list file from http://eggnog-mapper.embl.de/
# Options kept to default
# File uploaded: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/134/715/GCF_021134715.1_ASM2113471v1/GCF_021134715.1_ASM2113471v1_protein.faa.gz

emapper = read.csv(file = "emapper_for_orgdb.txt", header = TRUE, sep = "\t")

library(dplyr)
# Divide emapper DF into 2,
# because rows 1:1458 have SYMBOL/Gene name entries in GID column
emapper_mitochondrial = emapper[1:1458, ]
colnames(emapper_mitochondrial)[1] = "SYMBOL"
emapper_rest = emapper[1459:dim(emapper)[1], ]

# Create DF with the following columns,
# SYMBOL and ONTOLOGY will be dropped later
df = AnnotationDbi::select(
  org.Dp.eg.db,
  keys = GIDkeys,
  columns = c("GID", "GO", "EVIDENCE", "SYMBOL", "ONTOLOGY")
)

# Same reasoning as before
df_mitochondrial = df[1:46, ]
df_rest = df[47:dim(df)[1], ]

x = full_join(emapper_mitochondrial, df_mitochondrial) # join by SYMBOL and GO
col_order = c("GID","GO","EVIDENCE","SYMBOL","ONTOLOGY")
x = x[,col_order]
y = full_join(emapper_rest,df_rest) # join by GID and GO
DpGo = rbind(x,y)[,1:3]

# Remove duplicate entries
DpGo_unique <- filter(unique(DpGo), !is.na(GID))
# Replace NA in EVIDENCE with 'ND' (no biological data available, https://geneontology.org/docs/guide-go-evidence-codes/)
DpGo_unique <- DpGo_unique %>% mutate(EVIDENCE = ifelse(is.na(EVIDENCE), 'ND', EVIDENCE))
# Gene IDs without GO annotation have to be removed
DpGo_unique <- filter(DpGo_unique, !is.na(GO))

AnnotationForge::makeOrgPackage(
  gene_info = DpSym,
  chromosome = DpChr,
  go = DpGo_unique,
  version = "1.0",
  maintainer = "Wassim Salam <wassimsalam49@gmail.com>",
  author = "Wassim Salam <wassimsalam49@gmail.com>",
  outputDir = ".",
  tax_id = "6669",
  genus = "Daphnia",
  species = "pulex",
  goTable = "go"
)

devtools::build(pkg = "org.Dpulex.eg.db/")

# Install
install.packages("org.Dpulex.eg.db_1.0.tar.gz", repos = NULL, type = "source")
library(org.Dpulex.eg.db)
