## -----------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(tidyclust)

## -----------------------------------------------------------------------------
kmeans_spec <- k_means(num_clusters = 3) |>
  set_engine("stats")

kmeans_spec

## -----------------------------------------------------------------------------
set.seed(1234)
kmeans_fit <- fit(kmeans_spec, ~., data = mtcars)
kmeans_fit

## -----------------------------------------------------------------------------
extract_cluster_assignment(kmeans_fit)

## -----------------------------------------------------------------------------
extract_centroids(kmeans_fit)

## -----------------------------------------------------------------------------
predict(kmeans_fit, new_data = mtcars[1:5, ])

## -----------------------------------------------------------------------------
augment(kmeans_fit, new_data = mtcars)

## -----------------------------------------------------------------------------
sse_within_total(kmeans_fit, mtcars)
sse_ratio(kmeans_fit, mtcars)
silhouette_avg(kmeans_fit, mtcars)

## -----------------------------------------------------------------------------
hclust_spec <- hier_clust(num_clusters = 3) |>
  set_engine("stats")

hclust_fit <- fit(hclust_spec, ~., data = mtcars)

extract_cluster_assignment(hclust_fit)
extract_centroids(hclust_fit)

## -----------------------------------------------------------------------------
library(recipes)
library(workflows)

rec <- recipe(~., data = mtcars) |>
  step_normalize(all_predictors())

wf <- workflow() |>
  add_recipe(rec) |>
  add_model(k_means(num_clusters = 3))

wf_fit <- fit(wf, data = mtcars)
augment(wf_fit, new_data = mtcars)

