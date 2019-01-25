The package provides Matlab code for the localization of summary statistics and experiments introduced in the manuscript "Assessing the dynamics of natural populations by fitting individual based models with approximate Bayesian computation" by Jukka Sirén and Samuel Kaski. The package includes also simulations from the individual-based model of bird population dynamics analyzed in the article. The code has been developed and tested with Matlab R2017b under Windows 10. 

--

The examples in the manuscript can be reproduced by following scripts:

Ricker map:
rickerExample.m
 -Creates simulated test data and simulated data for analysis, runs and compares different dimension reduction strategies.
rickerFigures.m
 -Produces the figures in the manuscript and the supplementary material

White-starred robin individual-based model:
WRexample.m
 -runs and compares different dimension reduction strategies.
WRFigures.m
 -Produces the figures in the manuscript and the supplementary material

g-and-k distribution:
gkExample.m
 -Creates simulated test data and simulated data for analysis, runs and compares different dimension reduction strategies.
gkFigures.m
 -Produces the figures in the manuscript and the supplementary material

--

The simulated test data and the simulated datasets for performing ABC with the White-starred robin individual based model are included in Matlab format (WRSimulations.mat). The file contains summaries for test data (Sobs4) and for simulated datasets (S4), as well as parameter values for test data (thetaobs) and simulated datasets (theta).

--

The figures in the article were drawn using functions in the package plotSpread from Matlab file exchange

https://se.mathworks.com/matlabcentral/fileexchange/37105-plot-spread-points--beeswarm-plot-/

Any inquiries about the code should be addressed to jukka.2.siren@aalto.fi