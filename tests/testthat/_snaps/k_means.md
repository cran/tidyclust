# bad input

    Code
      k_means(mode = "bogus")
    Condition
      Error in `modelenv::check_spec_mode_engine_val()`:
      ! 'bogus' is not a known mode for model `k_means()`.

---

    Code
      bt <- k_means(num_clusters = -1) %>% set_engine("stats")
      fit(bt, mpg ~ ., mtcars)
    Condition
      Error in `check_args()`:
      ! The number of centers should be >= 0.

---

    Code
      translate_tidyclust(k_means(), engine = NULL)
    Condition
      Error in `translate_tidyclust.default()`:
      ! Please set an engine.

---

    Code
      translate_tidyclust(k_means(formula = ~x))
    Condition
      Error in `k_means()`:
      ! unused argument (formula = ~x)

# printing

    Code
      k_means()
    Output
      K Means Cluster Specification (partition)
      
      Computational engine: stats 
      

---

    Code
      k_means(num_clusters = 10)
    Output
      K Means Cluster Specification (partition)
      
      Main Arguments:
        num_clusters = 10
      
      Computational engine: stats 
      

# updating

    Code
      k_means(num_clusters = 5) %>% update(num_clusters = tune())
    Output
      K Means Cluster Specification (partition)
      
      Main Arguments:
        num_clusters = tune()
      
      Computational engine: stats 
      

