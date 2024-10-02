# DMRichR-FAIRification

Bioinformatics tools often prioritize humans or human-related model organisms, overlooking the needs of environmentally relevant species, which limits their use in ecological research. This gap is particularly challenging when implementing existing software, as inadequate documentation can delay the innovative use of environmental models, such as in modern risk assessment for chemicals causing aberration in methylation patterns. 

Ensuring fairness in ecological and evolutionary studies is already constrained by limited resources, and this imbalance in tool availability further hinders comprehensive ecological research. 

To address these gaps, we adapted the DMRichR package, a tool for epigenetic studies, for use with custom genomes, specifically for the crustacean Daphnia, a keystone grazer in aquatic ecosystems. 

This adaptation involved the modification of specific code, computing three new species-specific packages (BSgenome, TxDb, and org.db), and computing a CpG islands track using the makeCGI package. 

Additional adjustments to the DMRichR package were also necessary to ensure proper functionality. 

The developed workflow can now be applied not only to different Daphnia species that were previously unsupported, but also to other species for which annotated reference genomes are available.


Here is the schematic of this FAIRification:
(add figure here)
