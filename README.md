# DNAmodsWRemora
Evaluating the performance of [Remora](https://github.com/nanoporetech/remora) for detection of DNA modifications.

## Project Background
#### Several advantages of REMORA over [Megalodon](https://github.com/nanoporetech/megalodon) and [Guppy](https://pypi.org/project/ont-pyguppy-client-lib/) –
* Separates canonical base calling & modified base calling
* Reduces overall time
* High accuracy
* Simple training dataset, so detection of rare mods like 5hmC is possible with high accuracy

#### 5mC and 5hmC mods
5hmC is an oxidation product of 5mC.
References - [PMID:28769976](https://www.frontiersin.org/articles/10.3389/fgene.2017.00100/full), [PMID:23634848](https://epigeneticsandchromatin.biomedcentral.com/articles/10.1186/1756-8935-6-10)


## Pipeline
Figure represents the workflow for detection of `5mC` and `5hmC` mods using guppy basecaller using different remora modes.

<img width="815" alt="remora-pipeline" src="https://user-images.githubusercontent.com/66521525/201017778-982e3e5e-e1c2-4218-a270-d15711d15b75.png">


## Goals
Project was divided into 2 parts:
1. Understanding the 2 modes of remora (`mC mode (SINGLE mode)` and `mC+hmC (DUAL mode)` mode).
2. Using remora for detection of 5hmC modifications


## Results
2 major results of my project:
1. Performance is highly similar for the 2 modes. DUAL mode does no worse than the single mode in detecting 5mC modifications. (Benchmarked using [HG002](https://nanoporetech.com/resource-centre/human-hg002-gm24385-dataset))

<img width="917" alt="image" src="https://user-images.githubusercontent.com/66521525/201459082-544c07be-2e44-4a93-897c-c62e748b808c.png">

<img width="915" alt="image" src="https://user-images.githubusercontent.com/66521525/201459090-9e078ef6-5954-4841-a131-e9f27848e716.png">

2. 5hmC mods are clustered in the centromeres and telomeres. Observed in the [T2T-CHM13](https://github.com/marbl/CHM13) reference genome.

<img width="920" alt="image" src="https://user-images.githubusercontent.com/66521525/201459102-b2933439-174a-40ee-92fc-5880d28d8140.png">


## Future Work
1. How the biological function of 5hmC aligns with seeing it clustered in centromeres and telomeres.
2. See whether this trend is observed outside the X chromosome as well, since X has unique epigenetic characteristics.
3. Use T2T-CHM13 to build an epigenetic map of 5hmC across the centromeres and telomeres in more fine detail. Done for 5mC (Gershman et al, 2022)
4. Extend analysis to study 5hmC patterns across all of the HPRC assemblies to see how 5hmC patterns differ amongst individuals.
