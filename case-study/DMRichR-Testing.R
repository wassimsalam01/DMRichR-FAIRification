devtools::install_github("wassimsalam01/DMRichR")
devtools::install_github("wassimsalam01/annotatr", force = TRUE)
devtools::install_github("wassimsalam01/dmrseq", force = TRUE)
devtools::install_github("wassimsalam01/ChIPseeker", force = TRUE)
setwd("/path/to/cytosine-reports")
# In working directory must be present:
# BSgenome seed file (if compiling BSgenome from scratch)
# sample_info.xlsx
# Cytosine Reports
# CGI-Dpulex.txt
DMRichR::DM.R(genome = "Dpulex",
              coverage = 1,
              perGroup = 0.6,
              minCs = 3,
              maxPerms = 1,
              maxBlockPerms = 1,
              cutoff = 0.05,
              testCovariate = "Group",
              cores = 1,
              GOfuncR = FALSE,
              cytosineReportFormat = "nf-core/methylseq")
