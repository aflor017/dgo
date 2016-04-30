suppressMessages({

  context("hierarchical parameter names")

  state_hier_names <- paste0("state", sort(unique(states$state)))[-1]
  hier_names <- c(state_hier_names, "femalemale")

  test_that('hier_name and ZZ dimnames match', {
    data(states)
    expect_identical(hier_names, d_mod$hier_names)
    expect_identical(hier_names, dimnames(d_mod$ZZ)[[2]])
    expect_identical(dimnames(d_mod$ZZ)[[3]], "prop_evangelicals")
    expect_identical(dimnames(d_mod$ZZ_prior)[[3]], "prop_evangelicals")
  })

  context("hierarchical parameter counts")

  test_that('hier_names is a P- or S-vector', {
    expect_identical(length(hier_names), d_mod$P)
    expect_identical(length(hier_names), d_mod$S)
  })

  context("hierarchical modifier is numeric")

  test_that('values in ZZ are also numeric', {
    expect_true(is.numeric(d_mod$ZZ))
  })

  test_that('modifier values appear in the correct rows of ZZ', {
    data(states)
    data.table::setDT(states)
    data.table::setkeyv(states, c("state", "year"))
    states$state_label <- paste0("state", states$state)
    zz <- reshape2::acast(states[, .(year, state_label, prop_evangelicals)],
                          year ~ state_label ~ "prop_evangelicals",
                          value.var = 'prop_evangelicals', drop = FALSE)
    # omit first hierarchical parameter
    zz <- zz[, -1L, , drop = FALSE]
    expect_identical(zz, d_mod$ZZ[, -dim(d_mod$ZZ)[2], , drop = FALSE])
  })

  test_that('elements in ZZ corresponding to the grouping variable are zeroed', {
    expect_identical(d_mod$ZZ[, length(hier_names), 1L],
                     setNames(rep(0, 3), unique(states$year)))
  })

  context("hierarchical modifier is character")

  test_that('character values of modifier are dummied', {
    # in legacy code, gave this error: Error in shape_hierarchical_data(level2,
    # level2_modifiers, group_grid_t,  : non-numeric values in hierarchical data.
    # Factor handling probably failed.  Possible quick fix: omit or manually dummy
    # out any factors in 'level2_modifiers' or 'level2_period1_modif iers'.
    d_mod <- min_modifier_call(modifier_names = "region",
                              t1_modifier_names = "region")
    expect_true(is.numeric(d_mod$ZZ))
  })

  test_that('elements in ZZ corresponding to the grouping variable are zeroed', {
    expect_identical(d_mod$ZZ[, length(hier_names), 1L],
                     setNames(rep(0, 3), unique(states$year)))
  })

  context("hierarchical modifier variable is factor")

  test_that('factor values of modifier are dummied', {
    data(states)
    states$region <- as.factor(states$region)
    d_mod <- min_modifier_call(modifier_names = "region",
                              t1_modifier_names = "region")
    expect_true(is.numeric(d_mod$ZZ))
  })

  test_that('elements in ZZ corresponding to the grouping variable are zeroed', {
    expect_identical(d_mod$ZZ[, length(hier_names), 1L],
                     setNames(rep(0, 3), unique(states$year)))
  })

})
