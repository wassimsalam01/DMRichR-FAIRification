# Discover CpG islands (CGI) using Daphnia pulex BSgenome library
# Reference Links:
# https://genome.ucsc.edu/goldenPath/customTracks/custTracks.html
# https://www.haowulab.org/software/makeCGI/index.html

# Download & install
download.file(url = "https://www.haowulab.org/software/makeCGI/makeCGI_1.3.4.tar.gz",
              destfile = "makeCGI_1.3.4.tar.gz")
install.packages("makeCGI_1.3.4.tar.gz", repos = NULL, type = "source")

# 1) Load in the libraries
library(makeCGI)
library(BSgenome.Dpulex.NCBI.ASM2113471v1)
# 2) Set up default parameters
# Dpulex
.CGIoptions = CGIoptions()
.CGIoptions$rawdat.type = "BSgenome"
.CGIoptions$package = "BSgenome.Dpulex.NCBI.ASM2113471v1"
.CGIoptions$species = "Dpulex"
.CGIoptions$cutoff.CpG = 0.975

# 3) Start running:
makeCGI(.CGIoptions)

# Result is saved to CGI-Dpulex.txt