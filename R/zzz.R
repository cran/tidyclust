# nocov start

.onLoad <- function(libname, pkgname) {
  make_hier_clust()
  make_k_means()

  s3_register("generics::required_pkgs", "cluster_fit")
  s3_register("generics::required_pkgs", "cluster_spec")

  # - If tune isn't installed, register the method (`packageVersion()` will error here)
  # - If tune >= 0.1.6.9001 is installed, register the method
  should_register_tune_args_method <- tryCatch(
    expr = utils::packageVersion("tune") >= "0.1.6.9001",
    error = function(cnd) TRUE
  )

  if (should_register_tune_args_method) {
    # `tune_args.cluster_spec()` moved from tune to parsnip
    vctrs::s3_register("generics::tune_args", "cluster_spec", tune_args_cluster_spec)
  }

  # - If tune isn't installed, register the method (`packageVersion()` will error here)
  # - If tune >= 0.1.6.9002 is installed, register the method
  should_register_tunable_method <- tryCatch(
    expr = utils::packageVersion("tune") >= "0.1.6.9002",
    error = function(cnd) TRUE
  )

  if (should_register_tunable_method) {
    # `tunable.cluster_spec()` and friends moved from tune to parsnip
    vctrs::s3_register("generics::tunable", "cluster_spec", tunable_cluster_spec)
    vctrs::s3_register("generics::tunable", "k_means", tunable_k_means)
  }

  ns <- rlang::ns_env("tidyclust")
  makeActiveBinding(
    "tidyclust_color",
    function() {
      opt <- getOption("tidymodels.dark", NULL)

      if (!is.null(opt)) {
        if (isTRUE(opt)) {
          return(tidyclust_color_dark)
        } else {
          return(tidyclust_color_light)
        }
      }

      tidyclust_color_light
    },
    ns
  )

  # Modified version of the cli .onLoad()
  # We can't use cli::symbol$tick because the width of the character
  # looks awful when you output it alongside info / warning characters
  makeActiveBinding(
    "tidyclust_symbol",
    function() {
      # If `cli.unicode` is set we use that
      opt <- getOption("cli.unicode", NULL)

      if (!is.null(opt)) {
        if (isTRUE(opt)) {
          return(tidyclust_symbol_utf8)
        } else {
          return(tidyclust_symbol_ascii)
        }
      }

      # Otherwise we try to auto-detect
      if (cli::is_utf8_output()) {
        tidyclust_symbol_utf8
      } else if (is_latex_output()) {
        tidyclust_symbol_ascii
      } else if (is_windows()) {
        tidyclust_symbol_windows
      } else {
        tidyclust_symbol_ascii
      }
    },
    ns
  )
}


# vctrs:::s3_register()
s3_register <- function(generic, class, method = NULL) {
  stopifnot(is.character(generic), length(generic) == 1)
  stopifnot(is.character(class), length(class) == 1)

  pieces <- strsplit(generic, "::")[[1]]
  stopifnot(length(pieces) == 2)
  package <- pieces[[1]]
  generic <- pieces[[2]]

  caller <- parent.frame()

  get_method_env <- function() {
    top <- topenv(caller)
    if (isNamespace(top)) {
      asNamespace(environmentName(top))
    } else {
      caller
    }
  }
  get_method <- function(method, env) {
    if (is.null(method)) {
      get(paste0(generic, ".", class), envir = get_method_env())
    } else {
      method
    }
  }

  method_fn <- get_method(method)
  stopifnot(is.function(method_fn))

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(package, "onLoad"),
    function(...) {
      ns <- asNamespace(package)

      # Refresh the method, it might have been updated by `devtools::load_all()`
      method_fn <- get_method(method)

      registerS3method(generic, class, method_fn, envir = ns)
    }
  )

  # Avoid registration failures during loading (pkgload or regular)
  if (!isNamespaceLoaded(package)) {
    return(invisible())
  }

  envir <- asNamespace(package)

  # Only register if generic can be accessed
  if (exists(generic, envir)) {
    registerS3method(generic, class, method_fn, envir = envir)
  }

  invisible()
}

# nocov end
