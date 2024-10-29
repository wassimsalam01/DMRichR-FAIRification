# If you simply wish to use the BSgenome, TxDb and org.db packages for other applications
# then simply run the following with the respective tarballs:
install.packages("BSgenome.Dpulex.NCBI.ASM2113471v1_1.0.0.tar.gz", repos = NULL, type = "source")
install.packages("TxDb.Dpulex.NCBI.ASM2113471v1.knownGene_1.0.tar.gz", repos = NULL, type = "source")
install.packages("org.Dpulex.eg.db_1.0.tar.gz", repos = NULL, type = "source")

# If running custom DMRichR, skip above step. Package installation is integrated in annotationDatabases.R

# Package installation
devtools::install_github("wassimsalam01/DMRichR")
devtools::install_github("wassimsalam01/annotatr", force = TRUE)
devtools::install_github("wassimsalam01/dmrseq", force = TRUE)
devtools::install_github("wassimsalam01/ChIPseeker", force = TRUE)
# Reload R session here before running the code below!
# Setup
setwd("/path/to/cytosine-reports")
# In working directory must be present:
# BSgenome, TxDb and org.db tarballs (if not already installed)
# sample_info.xlsx
# Cytosine Reports (.CpG_report.txt.gz)
# CGI-Dpulex.txt

# Execution
DMRichR::DM.R(genome = "Dpulex",
              coverage = 1,
              perGroup = 0.6,
              minCs = 3,
              maxPerms = 10,
              maxBlockPerms = 10,
              cutoff = 0.05,
              testCovariate = "Group",
              cores = 1,
              GOfuncR = FALSE,
              cytosineReportFormat = "nf-core/methylseq")
