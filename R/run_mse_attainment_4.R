#library(pacifichakemse)
load_all("../pacifichakemse")
library(here)

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir, "attainment")

ss_model_yr <- 2018
ss_model_output_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                 "extdata", paste0("SS3_", ss_model_yr))
ss_model_data_csv_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                   "extdata", "csv-data")

fns <- c("07_us_60_can_56",
         "08_us_77_can_70",
         "09_us_77_can_90")

plotnames <- c("US low attainment (60%), 56% CAN",
               "CAN high attainment (70%), 77% US",
               "CAN highest attainment (90%), 77% US")

# List of vectors (of two) of the same length as the number of scenarios, one vector for each scenario.
# For each vector of two e.g. c(a, b): a is the Canadian attainment proportion, b is the US attainment proportion
attains <- list(c(0.56, 0.6),
                c(0.7, 0.77),
                c(0.9, 0.77))

# List of vectors (of two) of the same length as the number of scenarios, one vector for each scenario.
# For each vector of two e.g. c(a, b): the new catch in the OM is c_new * b + a
# If instead of a 2-element vector, a single value is given, the expanded catch in the OM will be
# c_new * 0.5 unless below catch_floor in which case it will be c_new = catch_floor.
# To apply no TAC, use c(0, 1).
# In any event, if the calculation is greater than c_new, c_new will be used instead
tacs <- list(c(0, 1),
             c(0, 1),
             c(0, 1))

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
         n_runs = 30,
         n_sim_yrs = 30,
         fns = fns,
         plot_names = plotnames,
         tacs = tacs,
         attains = attains,
         c_increases = movein_increases,
         m_increases = moveout_decreases,
         sel_changes = sel_changes,
         results_root_dir = results_root_dir,
         results_dir = results_dir,
         catch_floor = 180000,
         save_all_em = TRUE,
         verbose = FALSE)