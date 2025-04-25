library(readr)
library(tibble)
library(dplyr)
library(yardstick)
library(workflows)
library(rsample)

library(docopt)

doc <- "
Usage: 04_results.R --input_model=<input_model> --input_data=<input_data> --output_cm=<output_cm>
"

opt <- docopt(doc)

# Load model and test data
penguin_fit <- readRDS(opt$input_model)
data <- read_csv(opt$input_data)

data <- data %>% mutate(species = as.factor(species))
# Split again for consistency
set.seed(123)
data_split <- initial_split(data, strata = species)
test_data <- testing(data_split)

# Predict
predictions <- predict(penguin_fit, test_data, type = "class") %>%
  bind_cols(test_data)

# Confusion matrix
conf_mat <- conf_mat(predictions, truth = species, estimate = .pred_class)

# After generating conf_mat
cm_tbl <- as.data.frame(conf_mat$table)


# Save it as a CSV table
write_csv(cm_tbl, opt$output_cm)

print("Confusion matrix saved as CSV.")

