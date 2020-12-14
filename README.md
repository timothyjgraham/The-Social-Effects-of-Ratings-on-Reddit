# The-Social-Effects-of-Ratings-on-Reddit

This repository contains code in Python and R to reproduce the analysis in the following paper:

*Davis & Graham (2020). 'Emotional Consequences and Attention Rewards: The Social Effects of Ratings on Reddit'. Information, Communication and Society.*

The paper has two research questions and five files with Python and R code related to these questions:

RQ1: How do vote scores on a comment affect the emotional valence of the comment author’s subsequent contributions?

- `Reddit user data collection FINAL.ipynb` provides Python code to collect Reddit users' comment history.
- `Parallelised_VL_granger_all_users_FINAL.R` provides R code to run Variable Lag Granger Causality (VLGC) on the user data.
- `Import_VLGranger_results_all_users.R` provides R code to import the results of VLGC (previous step) and reproduce the analysis.

RQ2: How do vote scores on a comment affect the subsequent level of interaction with that comment from community members?

- `RQ2_analysis.R` provides R code to reproduce the analysis of *direct replies* (RQ2)
- `Python_analysis.ipynb` provides Python code to reproduce the analysis of *entire reply trees* (RQ2)

Unfortunately we are not able to upload datasets due to Reddit API Terms of Service. If you would like further information about the data, please contact us.

Notes:

- The code is in R and Python because we needed tools from both languages to get this work done.
- The code is not well optimised, despite some optimisation using parallelisation. Sorry!
- Following the previous dot point, the construction of reply trees using the code in `Python_analysis.ipynb` takes several days. Again, sorry!
