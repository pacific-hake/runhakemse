# runhakemse

**Run the Pacific hake Management Strategy Evaluation (MSE)**

To get started, clone or download this repository and install the [hake-assessment](https://github.com/pacific-hake/hake-assessment)
and
[pacifichakemse](https://github.com/pacific-hake/pacifichakemse) packages.

``` r
devtools::install_github("https://github.com/pacific-hake/pacifichakemse")

# If you are installing from a local clone (1) navigate your working directory
# to the pacifichakemse clone and (2) run the 2nd line, both lines for Windows
# withr::local_options(pkg.build_extra_flags = FALSE)
# devtools::load_all()
```

## Loading the SS model output

The Operating Model (OM) is conditioned on the output of a previous Stock
Synthesis model and is loaded as follows. This loading step is the same
for both OM-only scenarios and full MSE with estimation model feedback
scenarios. This code is included in all R scripts included in this project.

``` r
ss_model_yr <- 2018
ss_model_output_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                 "extdata", paste0("SS3_", ss_model_yr))
ss_model_data_csv_dir <- file.path(system.file(package = "pacifichakemse", mustWork = TRUE),
                                   "extdata", "csv-data")

ss_model <- load_ss_model_data(ss_model_output_dir = ss_model_output_dir,
                               ss_model_data_csv_dir = ss_model_data_csv_dir,
                               load_extra_mcmc = FALSE,
                               overwrite_ss_rds = TRUE)
```

## Running an MSE with the Operating model only

The [biasadjust scenario](https://github.com/pacific-hake/runhakemse/blob/master/R/run_mse_biasadjust.R) is a script that runs OM loops only. There is no feedback with the Estimation Model (EM). The function used to run om-only loops is `run_oms()`.

When calling `run_oms()`, the argument `yr_future` is the number of years to run the operating model into the future, past the value you gave for `ss_model_yr` in the SS model output loading step above.

`b_futures` is the vector of bias adjustments to make in the OM, in the same order as the filenames given in `fns` in the script.

## Running an MSE with the Estimation model feedback

The [climate scenario](https://github.com/pacific-hake/runhakemse/blob/master/R/run_MSE_climate.R) is a script that runs full MSE loops with feedback from the EM.  The function used to run om-only loops is `run_mses()`.

When calling `run_mses()`, the argument `n_sim_yrs` is the number of years to run the operating model into the future, past the value you gave for `ss_model_yr` in the SS model output loading step above.

## Plotting

There is a standardized output object for each scenario which is the same for both OM-only and full MSE scenarios. It is generated for a single scenario using the following code (`biasadjust` is the name of the directory in the `results` directory):

``` r
ps_b <- load_mse_plot_data(scenario = "biasadjust",
                           overwrite_rds = TRUE,
                           om_only = TRUE,
                           short_term_yrs = 2018:2027,
                           long_term_yrs = 2027,
                           quants = c(0.025, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.975))
```
The `ps_b` object contains all input and outputs from all runs defined in the `biasadjust` script. The RDS files found in the `results/biasadjust` directory are read in and aggregated into a single RDS file and stored in the `results/biasadjust/plot_rds` directory. Once you've done this once, you can set `overwrite_rds` to FALSE (the default) to save a lot of time, until you re-run the MSE and have to re-generate the output.

All quantiles are calculated during this step, for all objects. The quantile vector can be modified here to make it run a little quicker, but then those quantiles will not be available later to plotting functions. The plotting functions do not calculate quantiles on the fly.

To run this code on all multiple scenarios at once, use the following code, where `scenarios` are the directory names.

``` r
ps <- create_plot_objects(scenarios = c("biasadjust",
                                        "climate",
                                        "hcr",
                                        "selectivity"),
                          om_only = c(TRUE, FALSE, FALSE, FALSE),
                          main_results_dir = "results",
                          overwrite_rds = overwrite_rds,
                          short_term_yrs = 2018:2027,
                          long_term_yrs = 2027)
# biasadjust
ps_b <- ps[[1]]
# climate
ps_c <- ps[[2]]
# hcr values
ps_h <- ps[[3]]
# selectivity
ps_s <- ps[[4]]
```

All plotting functions take these `ps` objects as arguments, which makes it very simple to modify plots, create new plotting functions, and create tables of outputs.

The `plot_timeseries()` function contains code to plot all timeseries outputs. For example, to plot the Spawning Biomass for the `biasadjust` scenario, you would do:

``` r
plot_timeseries(ps_b)
```

To show envelopes instead of dotted lines for the confidence intervals you would call it like this:

``` r
plot_timeseries(ps_b, ci_lines = FALSE)
```

To plot from 2010 onward only you would call:

``` r
plot_timeseries(ps_b, ci_lines = FALSE, yr_lim = c(2010, NA))
```

To plot by country you would call:

``` r
plot_timeseries(ps_b, ci_lines = FALSE, yr_lim = c(2010, NA), by_country = TRUE)
```

To change the confidence intervals you would call:

``` r
plot_timeseries(ps_b, ci_lines = FALSE, yr_lim = c(2010, NA), by_country = TRUE, ci = c(0.1, 0.9))
```

Note that when you change the confidence interval, those values must have been calculated inside the `ps` object prior or you will get an error.

To change the transparency on the background color of the facets for faceted plots you would call (range is 0-99):

``` r
plot_timeseries(ps_b, by_country = TRUE, facet_back_alpha = 50)
```

Or to remove the color completely:

``` r
plot_timeseries(ps_b, by_country = TRUE, facet_back_alpha = 0)
```

There are also arguments for whether or not to show the reference point lines (`show_ssb0`, `show_40_10`)

Look at [MSE document Rmd code](https://github.com/pacific-hake/runhakemse/blob/master/document_mse/mse_results.Rmd) and the [OM document Rmd code](https://github.com/pacific-hake/runhakemse/blob/master/document_om/om_results.Rmd) to see examples of the other plotting functions.

## Parallelism with batch scripts

Parallelism could not be integrated into the R code in this case, so there is a batch script for each scenario. Batch scripts can be run in parallel, by launching them manually. These are found [here](https://github.com/pacific-hake/runhakemse/tree/master/batch_scripts).

There is one extra batch script included for convenience, to create all the plot object files. It is called `create_plot_objects.bat` and can be run once all the other scripts have finished.

Note that `Rscript` must be on your `PATH` for these scripts to work.

## Building the MSE and OM documents included in the project

To build PDF documents from the Rmd files included in this project, open the Rmd file and click `Knit` (if in RStudio). This will create a PDF document with the same name inside the directory in which the Rmd file resides, and open a previewer showing the file once done.

Or, if you want to debug your document using `browser()` calls, or you are not using RStudio:

``` r 
setwd("document_mse")
bookdown::render_book("mse_results.Rmd")
```

This will create a PDF document called `_main.pdf` inside the directory in which the Rmd file resides, but will not open a previewer showing the file.

The same can be done for the OM document.