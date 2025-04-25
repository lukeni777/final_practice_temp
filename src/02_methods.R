# src/02_methods.R

library(tidyverse)
library(readr)
library(docopt)

'This script performs EDA and feature engineering

Usage:
  02_methods.R --input=<input_path> --output=<output_path> --fig1=<fig1_path>
' -> doc

opt <- docopt(doc)

# Read and prepare
data <- read_csv(opt$input)

# Summary (optional debug log)
glimpse(data)
print(data %>% summarise(mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm)))

# Create and save plot
plot <- ggplot(data, aes(x = species, y = bill_length_mm, fill = species)) +
  geom_boxplot() +
  theme_minimal()

ggsave(opt$fig1, plot, width = 6, height = 4)

# Feature engineering
data <- data %>%
  select(species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  mutate(species = as.factor(species))

# Save output
write_csv(data, opt$output)

print(" 02_methods.R complete")
