devtools::install_github("wassimsalam01/DMRichR")
# Custom dmrseq, annotatr and ChIPseeker are installed upon execution of DMRichR when choosing Dpulex genome
library(DMRichR)
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
