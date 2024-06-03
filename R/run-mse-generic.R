# Load libraries, get user name and set up user settings and folders
# Check that all files and directories exist
library(devtools)
library(here)

user <- Sys.info()[["user"]]

# `pacifichakemse_repo_dir` is the directory in which the `pacifichakemse`
# repository has been cloned from GitHub.

# `ss_model_dir` is the location of the outer model directory for the
# assessment model. It will have an `mcmc` subdirectory that may or may not
# have an `sso` subdirectory within it. If the model was run with "extra mcmc"
# turned on, there will be an `sso` directory in which the posteriors.sso and
# other output files are located. If "extra mcmc" was not included in the model
# run, those files will be directly in the `mcmc` directory

# `results_root_dir` is the directory name in which all output from the MSE
# runs will be stored

if(user == "grandin"){
  pacifichakemse_repo_dir <- "~/github/pacific-hake/pacifichakemse"
  ss_model_dir <- "/srv/hake/models/2024/02-version/01-base-models/01-base"
  results_root_dir <- file.path(pacifichakemse_repo_dir, "results")
}else if(user == "your_username_here"){
  # pacifichakemse_repo_dir <-
  # ss_model_dir <-
  # results_root_dir <-
}else{
  pacifichakemse_repo_dir <- "~/github/pacific-hake/pacifichakemse"
  ss_model_dir <- "/srv/hake/models/2024/02-version/01-base-models/01-base"
  results_root_dir <- file.path(pacifichakemse_repo_dir, "results")
}

if(!dir.exists(pacifichakemse_repo_dir)){
  stop("The hake MSE package repository directory does not exist:\n",
       pacifichakemse_repo_dir,
       call. = FALSE)
}

if(!dir.exists(ss_model_dir)){
  stop("The hake model directory does not exist:\n",
       ss_model_dir,
       call. = FALSE)
}

rds_fn <- file.path(ss_model_dir,
                    paste0(basename(ss_model_dir), ".rds"))
if(!file.exists(rds_fn)){
  stop("The hake model RDS file does not exist:\n",
       rds_fn,
       call. = FALSE)
}

load_all(pacifichakemse_repo_dir)

assess_url <- file.path(
  "https://raw.githubusercontent.com",
  "pacific-hake",
  "hake-assessment",
  # To get or change the following commit number, go to
  # https://github.com/pacific-hake/hake-assessment and click the latest
  # release (2024 final at time of comment) on the right hand side of the
  # page, then click the commit number (in this case 462d13b). On the page
  # it goes to, click the "Browse files" button. Copy the SHA value from
  # the URL field in the browser and paste below.
  "462d13bfc58f1cff3e42c4b43cbca7983f27202d")

assess_tables_dir <- file.path(assess_url,
                               "data-tables")

