#library(pacifichakemse)
load_all("../pacifichakemse")
library(here)

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir, "mse_attainment99")

ss_model_yr <- 2018
ss_model_output_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                 "extdata", paste0("SS3_", ss_model_yr))
ss_model_data_csv_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                   "extdata", "csv-data")

fns <- "00_us_0_can_0"

plotnames <- "Unfished baseline"

# List of vectors (of two) of the same length as the number of scenarios, one vector for each scenario.
# For each vector of two e.g. c(a, b): a is the Canadian attainment proportion, b is the US attainment proportion
# When doing zero attainment coastwide, we must use 0.02 instead of 0 because the EM will crash the stock.
# Below 0.006, the minimizer will begin to give NaNs in the objective function for various years.
attains <- list(c(0, 0))

# List of vectors (of two) of the same length as the number of scenarios, one vector for each scenario.
# For each vector of two e.g. c(a, b): the new catch in the OM is c_new * b + a
# If instead of a 2-element vector, a single value is given, the expanded catch in the OM will be
# c_new * 0.5 unless below catch_floor in which case it will be c_new = catch_floor.
# To apply no TAC, use c(0, 1).
# In any event, if the calculation is greater than c_new, c_new will be used instead
tacs <- list(c(0, 1))

# A vector with one element for each scenario, which is additional proportion of the stock to be
# moved from space 2 to space 1 (into Canada). If a single value instead of a vector, that value
# will be used for all scenarios.
movein_increases <- 0
# A vector with one element for each scenario, which is additional proportion of the stock to be
# moved from space 1 to space 2 (out of Canada). If a single value instead of a vector, that value
# will be used for all scenarios.
moveout_decreases <- 0

# A vector with one element for each scenario, or a single value to use for all scenarios
sel_changes <- 0

run_mses(ss_model_output_dir = ss_model_output_dir,
         ss_model_data_csv_dir = ss_model_data_csv_dir,
         load_extra_mcmc = FALSE,
         overwrite_ss_rds = FALSE,
         n_runs = 20,
         n_sim_yrs = 30,
         fns = fns,
         plot_names = plotnames,
         tacs = tacs,
         attains = attains,
         hcr_lower = 0.1,
         hcr_upper = 0.4,
         hcr_fspr = 0.4, # Turn off the F_spr part of the HCR by setting this to zero
         random_seed = 99,
         c_increases = movein_increases,
         m_increases = moveout_decreases,
         sel_changes = sel_changes,
         results_root_dir = results_root_dir,
         results_dir = results_dir,
         catch_floor = 180000,
         save_all_em = TRUE,
         verbose = FALSE)