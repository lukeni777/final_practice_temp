# src/03_model.R
library(asfactorpkg)
library(tidyverse)
library(tidymodels)
library(docopt)

'This script trains a k-NN model on penguin data

Usage:
  03_model.R --input=<input_path> --output=<output_path>
' -> doc

opt <- docopt(doc)

# Load the data
data <- read_csv(opt$input)


data <- as_factor_column(data, "species")


# Split the data
set.seed(123)
data_split <- initial_split(data, strata = species)
train_data <- training(data_split)
test_data  <- testing(data_split)

# Define the model
penguin_model <- nearest_neighbor(mode = "classification", neighbors = 5) %>%
  set_engine("kknn")

# Create the workflow
penguin_workflow <- workflow() %>%
  add_model(penguin_model) %>%
  add_formula(species ~ .)

# Fit the model
penguin_fit <- penguin_workflow %>%
  fit(data = train_data)

# Save model
saveRDS(penguin_fit, opt$output)

print(" Model training complete. Model saved.")
