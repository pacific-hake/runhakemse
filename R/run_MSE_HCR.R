#library(pacifichakemse)
load_all("../pacifichakemse")
library(here)

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir, "mse_hcr")

fns <- c("01_chr",
         "02_jmc",
         "03_realized",
         "04_floor50")

plotnames <- c("Base HCR scenario",
               "Historical TAC",
               "Realized",
               "Floor 50")

# List of vectors (of two) of the same length as the number of scenarios,
# one vector for each scenario.
# For each vector of two e.g. c(a, b): a is the Canadian attainment
# proportion, b is the US attainment proportion
attains <- list(c(1, 1),
                c(1, 1),
                c(1, 1),
                c(1, 1))

# List of vectors (of two) of the same length as the number of scenarios,
# one vector for each scenario.
# For each vector of two e.g. c(a, b): the new catch in the OM is
# c_new * b + a
# If instead of a 2-element vector, a single value is given, the expanded
# catch in the OM will be
# c_new * 0.5 unless below catch_floor in which case it will be
# c_new = catch_floor.
# To apply no TAC, use c(0, 1).
# In any event, if the calculation is greater than c_new, c_new will be
# used instead
tacs <- list(c(0, 1), # Base
             c(139482.707564733, 0.378286338688197), # JMC
             c(177193.540429722, 0.184425110839867), # Realized
             0) # Floor 50%

# A vector with one element for each scenario, which is additional
# proportion of the stock to be moved from space 2 to space 1 (into Canada).
# If a single value instead of a vector, that value will be used for all
# scenarios.
movein_increases <- 0
# A vector with one element for each scenario, which is additional
# proportion of the stock to be moved from space 1 to space 2 (out of
# Canada). If a single value instead of a vector, that value will be used
# for all scenarios.
moveout_decreases <- 0

# A vector with one element for each scenario, or a single value to use
# for all scenarios
sel_changes <- 0

run_mses(n_runs = 10,
         n_sim_yrs = 30,
         fns = fns,
         plot_names = plotnames,
         tacs = tacs,
         attains = attains,
         hcr_lower = 0.1,
         hcr_upper = 0.4,
         # Turn off the F_spr part of the HCR by setting this to zero
         hcr_fspr = 0.4,
         # Seed for generating all the individual run seeds
         random_seed = 12345,
         # Use this as a seed to run a single run. Uses the first file
         # fns[1] only (for debugging seeds that fail)
         #single_seed = 166372,
         f_space = c(0.2612, 0.7388),
         c_increases = movein_increases,
         m_increases = moveout_decreases,
         sel_changes = sel_changes,
         results_root_dir = results_root_dir,
         results_dir = results_dir,
         catch_floor = 180000,
         save_all_em = FALSE,
         verbose = FALSE)
