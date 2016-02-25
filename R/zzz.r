setClass("ItemVar", contains="character")
setMethod("initialize", "ItemVar", function(.Object, .Data) {
  if (!missing(.Data)) {
    if (!all(nchar(.Data) > 0)) stop("variable name is not a positive-length character")
    if (!length(.Data) > 0) stop("variable name is NULL")
    if (any(duplicated(.Data))) stop("duplicate variable name")
    .Object@.Data <- .Data
  }
  .Object
})

Target <- R6Class("Target",
  public = list(
    tbl = NULL,
    strata = NULL,
    weight = NULL,
    prop = NULL
  )
)

Filter <- R6Class("Filters",
  public = list(
    time = NULL,
    geo = NULL,
    min_t = NULL,
    min_survey = NULL)
)

Control <- R6Class(NULL,
  public = list(
    groups = NULL,
    constant_item = NULL,
    separate_t = NULL,
    delta_tbar_prior_mean = NULL,
    delta_tbar_prior_sd = NULL,
    innov_sd_delta_scale = NULL,
    innov_sd_theta_scale = NULL))

Modifier <- R6Class("Modifier",
  public = list(
    tbl_ = NULL,
    modifiers_ = NULL,
    t1_modifiers_ = NULL,
    time_ = NULL,
    geo_ = NULL,
    G_hier_ = NULL,
    WT = NULL,
    l2_only = NULL,
    NNl2 = NULL,
    SSl2 = NULL,
    group_design_matrix = NULL,
    ZZ = NULL,
    ZZ_prior = NULL),
  active = list(
    tbl = set_tbl,
    modifiers = set_modifiers,
    t1_modifiers = set_t1_modifiers,
    time = set_time,
    geo = set_geo,
    H_prior = get_H_prior))

Item <- R6Class("Item",
  public = list(
    MMM = NULL,
    control = NULL,
    filters = NULL,
    geo_ = NULL,
    group_counts = NULL,
    group_grid = NULL,
    group_grid_t = NULL,
    items_ = NULL,
    modifier = NULL,
    survey_ = NULL,
    targets = NULL,
    tbl_ = NULL,
    time_ = NULL),
  active = list(
    G = get_G,
    G_hier = get_G_hier,
    N = get_N,
    Q = get_Q,
    T = get_T,
    P = get_P,
    H = get_H,
    S = get_S,
    geo = set_geo,
    groups = set_groups,
    items = set_items,
    survey = set_survey,
    tbl = set_tbl,
    time = set_time,
    weight = set_weight))

Item$set("public", "has_hierarchy", function() {
  length(self$modifier$tbl) > 0
})

Item$set("public", "make_WT", function() {
  self$modifier$WT <- array(1, dim = c(self$T, self$G_hier, self$G))
})

Item$set("public", "get_names", function() {
  nm = Map(function(i) self[[i]], names(Item$public_fields)[grep("ItemVar", Item$public_fields)])
  unique(unlist(nm))
})

Item$set("public", "test_names", function(x) {
  stopifnot(inherits(x, "ItemVar"))
  for (s in x) {
    if (!s %in% names(self$tbl)) {
      stop(s, " is not a variable in item data")
    }
  }
})

Modifier$set("public", "test_names", function(x) {
  stopifnot(inherits(x, "ItemVar"))
  for (s in x) {
    if (!s %in% names(self$tbl)) {
      stop(s, " is not a variable in item data")
    }
  }
})

Item$set("public", "restrict", function() {
  self <- restrict_items(self)
  self <- restrict_modifier(self)
  self$tbl <- droplevels(self$tbl)
})

Item$set("public", "reweight", function() {
  if (inherits(self$targets$tbl, "data.frame")) {
    self <- weight(self)
  }
})

Item$set("public", "make_gt_variables", function() {
  gt_table <- create_gt_variables(self)
  self$tbl <- dplyr::bind_cols(self$tbl, gt_table)
})

Item$set("public", "find_missingness", function() {
  self$MMM <- make_missingness_array(self)
})

Item$set("public", "get_group_grid", function() {
  self$group_grid <- make_group_grid(self)
})

Item$set("public", "make_l2_only", function() {
  self$modifier$l2_only <- make_dummy_l2_only(self)
})

Item$set("public", "make_NNl2", function() {
  self$modifier$NNl2 <- make_dummy_l2_counts(self)
})

Item$set("public", "make_SSl2", function() {
  self$modifier$SSl2 <- make_dummy_l2_counts(self)
})

Item$set("public", "make_group_design", function() {
    self$modifier$group_design_matrix <- make_design_matrix(self)
})

Item$set("public", "make_ZZ", function() {
  self$modifier$ZZ <- make_hierarchical_array(self)
})

Item$set("public", "make_ZZ_prior", function() {
  self$modifier$ZZ_prior <- make_hierarchical_array(self)
})

Item$set("public", "check_groups", function(group_grid_t) {
  for (s in self$groups) {
    if (length(levels(group_grid_t[[s]])) < 2) {
      stop("no variation in group variable ", s)
    }
  }
})

Item$set("public", "list_groups", function() {
  self$group_grid <- make_group_grid(self)
})

Item$set("public", "list_groups_t", function() {
  self$group_grid_t <- make_group_grid_t(self)
})

Item$set("public", "group_n", function() {
  self$group_counts <- make_group_counts(self)
})
