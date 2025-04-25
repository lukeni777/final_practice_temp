# Run everything
all: report.html

# Step 1: Run the script to load & clean the data
data/clean/penguins_clean.csv: src/01_load_data.R
	mkdir -p data/clean
	Rscript src/01_load_data.R --output_path=data/clean/penguins_clean.csv


data/clean/penguins_ready.csv results/bill_length_boxplot.png: src/02_methods.R data/clean/penguins_clean.csv
	mkdir -p data/clean results
	Rscript src/02_methods.R \
		--input="data/clean/penguins_clean.csv" \
		--output="data/clean/penguins_ready.csv" \
		--fig1="results/bill_length_boxplot.png"

output/penguin_model.rds: src/03_model.R data/clean/penguins_ready.csv
	mkdir -p output
	Rscript src/03_model.R \
		--input="data/clean/penguins_ready.csv" \
		--output="output/penguin_model.rds"

results/confusion_matrix.csv: src/04_results.R output/penguin_model.rds data/clean/penguins_ready.csv
	mkdir -p results
	Rscript src/04_results.R \
		--input_model="output/penguin_model.rds" \
		--input_data="data/clean/penguins_ready.csv" \
		--output_cm="results/confusion_matrix.csv"


report.html: report.qmd data/clean/penguins_ready.csv results/bill_length_boxplot.png output/penguin_model.rds results/confusion_matrix.csv
	quarto render report.qmd --output report.html



# Optional: Clean up all outputs
clean:
	rm -rf data/clean/*.csv report.html
	rm -rf results
	rm -rf output
