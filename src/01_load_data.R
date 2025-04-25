# 01_load_data.R

library(tidyverse)
library(palmerpenguins)
library(docopt)

'This script loads and cleans penguins data

Usage:
  01_load_data.R --output_path=<output_path>

' -> doc

# Parse command-line options
opt <- docopt(doc)

# Load and clean data
data <- penguins
data <- data %>% drop_na()

# Save to file
write_csv(data, opt$output_path)

print("1.Finished loading and cleaning penguins data")
