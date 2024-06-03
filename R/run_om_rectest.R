
library(devtools)
load_all("../pacifichakemse/")
library(here)

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir, "recruitment")

fns <- "sqrec"

plotnames <- "Area rec"

run_oms(# n_runs will be changed to 1 in the code if include_recruitment
        # is FALSE because all runs will be the same
        n_runs = 10,
        yr_future = 50,
        fns = fns,
        n_surveys = 2,
        b_futures = 0,
        c_increases = 0,
        m_increases = 0,
        sel_changes = 0,
        rec_sp = 2, #testing coastwide recruitment
        # For catch_in to work, hcr_apply must be FALSE (unless it is 0)
        # Comment it out to use default catch
        catch_in = 0,
        attain = c(1, 1), # Canada, US attainment 0-1
        tac = c(0, 1),
        hcr_apply = FALSE,
        hcr_lower = 0.1,
        hcr_upper = 0.4,
        hcr_fspr = 0.4,
        # If random_recruitment is TRUE, add random normal recruitment
        # deviations to the projection years, if FALSE, only stock-recruit
        # based recruitment is included with zero deviations
        random_recruitment = FALSE,
        plot_names = plotnames,
        random_seed = 12345,
        results_root_dir = results_root_dir,
        results_dir = results_dir)
