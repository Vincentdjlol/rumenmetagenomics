library(tidyverse)
library(vegan)

setwd("/students/2025-2026/groepjenaamvincentbertnaomy/results/kraken/minionfullreports")
files <- c("minion_T0.report", "minion_T1.report", "minion_T2.report")

read_minion <- function(file, timepoint) {
  df <- read_tsv(file, comment = "#", col_names = FALSE, show_col_types = FALSE)
  n <- ncol(df)
  colnames(df)[1] <- "perc"
  colnames(df)[2] <- "tot_all"
  colnames(df)[3] <- "tot_lvl"
  colnames(df)[(n-2)] <- "lvl_type"
  colnames(df)[(n-1)] <- "taxid"
  colnames(df)[n] <- "name"
  
  df_samples <- df %>%
    filter(lvl_type == "G") %>%
    mutate(name = trimws(name)) %>%
    select(name, matches("_lvl$"))
  mat <- df_samples %>%
    column_to_rownames("name") %>%
    as.matrix()
  mat <- t(mat)
  mat <- as.data.frame(mat)
  rownames(mat) <- paste0("minion_", timepoint, "_", seq_len(nrow(mat)))
  return(mat)}

comm_list_minion <- list(
  read_minion(files[1], "T0"),
  read_minion(files[2], "T1"),
  read_minion(files[3], "T2"))

minion_matrix <- bind_rows(comm_list_minion)
minion_matrix[is.na(minion_matrix)] <- 0
minion_matrix <- as.data.frame(lapply(minion_matrix, as.numeric))
rownames(minion_matrix) <- rownames(bind_rows(comm_list_minion))
minion_matrix <- decostand(minion_matrix, method = "total")

setwd("/students/2025-2026/groepjenaamvincentbertnaomy/results/kraken/miseq_full")
files <- list.files(pattern = "*L001.report")

read_kraken <- function(file){
  read_tsv(file, col_names = FALSE, comment = "", show_col_types = FALSE) %>%
    transmute(
      sample = file,
      percent = X1,
      rank = X4,
      taxon = X6) %>%
    filter(rank == "G")}
df <- map_dfr(files, read_kraken)

miseq_matrix <- df %>%
  select(sample, taxon, percent) %>%
  pivot_wider(names_from = taxon, values_from = percent, values_fill = 0)
miseq_matrix <- as.data.frame(miseq_matrix)
miseq_matrix$sample <- miseq_matrix$sample %>%
  str_replace(".*(T[0-9]).*", "\\1")
miseq_matrix$sample <- paste0("miseq_", miseq_matrix$sample, "_", seq_len(nrow(miseq_matrix)))
rownames(miseq_matrix) <- miseq_matrix$sample
miseq_matrix$sample <- NULL
miseq_matrix[is.na(miseq_matrix)] <- 0

all_taxa <- union(colnames(minion_matrix), colnames(miseq_matrix))
align_cols <- function(mat, all_cols) {
  missing_cols <- setdiff(all_cols, colnames(mat))
  for (col in missing_cols) {
    mat[[col]] <- 0}
  mat <- mat[, all_cols]
  return(mat)}

minion_matrix <- align_cols(minion_matrix, all_taxa)
miseq_matrix  <- align_cols(miseq_matrix, all_taxa)
comm_matrix <- bind_rows(minion_matrix, miseq_matrix)
comm_matrix[is.na(comm_matrix)] <- 0
comm_matrix <- as.data.frame(comm_matrix)

metadata <- data.frame(
  sample = rownames(comm_matrix),
  time = str_extract(rownames(comm_matrix), "T[0-9]"),
  method = ifelse(grepl("^minion", rownames(comm_matrix)), "minion", "miseq"))
metadata$time <- factor(metadata$time)
metadata$method <- factor(metadata$method)

dist_matrix <- vegdist(comm_matrix, method = "bray")
adonis_combieresultaat <- adonis2(dist_matrix ~ time + method,
                         data = metadata,
                         permutations = 999)

print(adonis_combieresultaat)