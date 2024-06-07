source(here::here("R/run-mse-generic.R"))

results_root_dir <- here("results")
results_dir <- file.path(results_root_dir, "biasadjust")

fns <- "MSErun_move_nofishing_nobiasadj"

plotnames <- "Bias 0"
# Load the raw SS model inputs and outputs using the r4ss package and the same
# methods used in the `hake-assessment` package
# Create objects from the raw SS model inputs and outputs and
# only include those in this list. To add new SS model outputs,
# modify the `load_ss_model_data()` function
ss_model <- load_ss_model_data(data_tables_url = assess_tables_dir,
                               rds_fn = rds_fn)

run_oms(ss_model = ss_model,
        # n_runs will be changed to 1 in the code if include_recruitment
        # is FALSE because all runs will be the same
        n_runs = 20,
        yr_future = 50,
        fns = fns,
        n_surveys = 2,
        b_futures = 0,
        c_increases = 0,
        m_increases = 0,
        sel_changes = 0,
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
        random_recruitment = TRUE,
        plot_names = plotnames,
        random_seed = 12345,
        results_root_dir = results_root_dir,
        results_dir = results_dir)
