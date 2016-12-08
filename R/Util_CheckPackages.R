checkPackages <- function(...) {
  list.of.packages <- c(...)
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  else
    print("packages are already installed.")
}