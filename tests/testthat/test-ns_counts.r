suppressMessages({

  context("Compute design effects")
  #
  # item_data <- data.frame(
  #   "state" = state.abb[c(1, 2, 2, 3, 3, 3)],
  #   "weight" = treering[1:6],
  #   "year" = rep(1:2, each = 3),
  #   "race" = warpbreaks$wool[25:30],
  #   "educ" = warpbreaks$tension[c(1, 10, 20, 30, 40, 50)],
  #   "item" = rep(c(0L:1L), 3),
  #   "source" = rep(1L, 6))
  # test_item <- items(item_data, ids(state, year, "source"), items = "item", controls(groups = 'race'))
  #
  # # Unique combinations:
  # # AL x 1 x A (N=1)
  # # AK x 1 x A (N=2)
  # # AZ x 2 x B (n-3)
  #
  # expect_error(item$  compute_group_design_effects(items,
  #   list("survey_weight" = "weight")), "are not all positive-length strings")
  #
  # items_args <- list("survey_weight" = "weight", "geo_id" = "state", "groups" =
  #   "race", "time_id" = "year", "use_t" = c(1, 2))
  # items_design_fx = compute_group_design_effects(items, items_args)
  #
  # expect_is(items_design_fx$state, "factor")
  # expect_is(items_design_fx$race, "factor")
  # expect_is(items_design_fx$year, "integer")
  # expect_is(items_design_fx$def, "numeric")
  # expect_equal(items_design_fx$state, as.factor(c("AK", "AL", "AZ")))
  # expect_equal(items_design_fx$race, as.factor(c("A", "A", "B")))
  # expect_equal(items_design_fx$year, c(1, 1, 2))
  # expect_equal(round(items_design_fx$def, 4), c(1.0637, 1.0000, 1.0197))
  #
  # context("Compute design effects")
  #
  # expect_equal(create_design_effects(1), 1)
  # expect_equal(create_design_effects(c(1, NA)), 1)
  # expect_equal(create_design_effects(NA), 1)
  #
  # context("Get factor combinations")
  #
  # items_grid = make_group_grid(items, items_args$groups, items_args)
  # expect_equal(dim(items_grid), c(12, 3))
  # expect_equal(items_grid$year, rep(c(1,2), 6))
  # expect_equal(items_grid$state, as.factor(rep(c("AK", "AL", "AZ"),
  #   each = 2, times = 2)))
  # expect_equal(items_grid$race, as.factor(rep(c("A", "B"), each = 6)))
  #
  # context("Count group trials")
  #
  # items <- dplyr::bind_cols(items, create_gt_variables(items, "item"))
  # items$n_responses <- count_respondent_trials(items)
  # trial_counts <- count_group_trials(items, items_design_fx, items_grid, items_args)
  # all.equal(as.integer(trial_counts$year), as.integer(items_grid$year))
  # # NOTE: failing
  # all.equal(factor(trial_counts$state), items_grid$state)
  # # NOTE: failing
  # all.equal(trial_counts$race, as.character(items_grid$race))

})
