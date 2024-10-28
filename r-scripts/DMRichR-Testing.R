# Setup
setwd("/path/to/cytosine-reports")
# In working directory must be present:
# BSgenome, TxDb and org.db packages (.tar.gz) (if not already installed)
# sample_info.xlsx
# Cytosine Reports (.CpG_report.txt.gz)
# CGI-Dpulex.txt

# Package installation
devtools::install_github("wassimsalam01/DMRichR")
devtools::install_github("wassimsalam01/annotatr", force = TRUE)
devtools::install_github("wassimsalam01/dmrseq", force = TRUE)
devtools::install_github("wassimsalam01/ChIPseeker", force = TRUE)

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
