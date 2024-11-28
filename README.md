# Data & Codes
## DATA OVERVIEW
This repository contains the data and code used to generate the numerical results presented in the paper "Directional Alignment of Financial and Power Flows in Directed Single Cut Linked Interconnected Areas". It is made available to facilitate further research and allow readers to reproduce or build upon the authors' work.

## DATA FORMAT & DATA STRUCTURE
### Test system
The authors have provided the data for a 7-bus system in the standard MATPOWER case format, stored in the file "case7.m" [1]. For those wishing to understand the data format in more detail, the MATPOWER User's Manual is available for download at https://matpower.org/doc/.

### Methods
Two methods for calculating Locational Marginal Pricing (LMP) are implemented, based on the lossless and lossy DCOPF models described in [2]-[3], respectively.

### Code structure
The primary function to run is 'main.m' which generates the results. Two additional functions are included:
      'DCOPF_lossless.m' for the lossless LMP calculation.
      'DCOPF_lossy.m' for the lossy LMP calculation.

### Output Data
The output data includes the following:
      LMP (in $/MWh)
      Power Flow (in MW)
      Energy Component of LMP (denoted as τ in the file, in $/MWh)

## References
##### [1]	R. D. Zimmerman, C. E. Murillo-Sánchez and R. J. Thomas, "MATPOWER: steady-state operations, planning, and analysis tools for power systems research and education," IEEE Trans. Power Syst., vol. 26, no. 1, pp. 12-19, Feb. 2011.
##### [2]	E. Litvinov, T. Zheng, G. Rosenwald and P. Shamsollahi, "Marginal loss modeling in LMP calculation," IEEE Trans. Power Syst., vol. 19, no. 2, pp. 880-888, May 2004.
##### [3]	F. Li and R. Bo, "DCOPF-based LMP simulation: algorithm, comparison with ACOPF, and sensitivity," IEEE Trans. Power Syst., vol. 22, no. 4, pp. 1475-1485, Nov. 2007.
