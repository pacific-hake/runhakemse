#library(pacifichakemse)
load_all("../pacifichakemse")
library(here)

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir,
                         "om_attainment_recr_hcr_default_catch")

fns <- "02_us_100_can_100"

plotnames <- "Full attainment coastwide"

run_oms(# `n_runs` will be changed to 1 in the code if `include_recruitment`
        # is FALSE because all runs will be the same
        n_runs = 100,
        yr_future = 50,
        fns = fns,
        n_surveys = 2,
        b_futures = 0,
        c_increases = 0,
        m_increases = 0,
        sel_changes = 0,
        # For `catch_in` to work, `hcr_apply` must be FALSE (unless it is 0)
        # Comment it out to use default catch
        #catch_in = 1e6,
        # `attain` is the attainment proportion for (Canada, US)
        attain = c(1, 1),
        # if `tac` is a vector of 2 values: c(a, b): the new catch
        # in the OM is catch * b + a. If a single value, the expanded catch in
        # the OM will be catch * 0.5 unless below `catch_floor` (180,000 by
        # default) in which case it will be catch = `catch_floor`.
        tac = c(0, 1),
        hcr_apply = TRUE,
        hcr_lower = 0.1,
        hcr_upper = 0.4,
        hcr_fspr = 0.4,
        # If `random_recruitment` is TRUE, add random normal recruitment
        # deviations to the projection years, if FALSE, only stock-recruit
        # based recruitment is included with zero deviations
        random_recruitment = TRUE,
        catch_floor = 180000,
        plot_names = plotnames,
        random_seed = 12345,
        results_root_dir = results_root_dir,
        results_dir = results_dir)