
import csv

# Define the input file path
input_file = 'C:\\Users\\isak.skeie\\OneDrive - USN\\4.Semester\\Multivariate systems\\linea_dataexport (30).csv'

# Open the input CSV file and read its contents
with open(input_file, 'r') as infile:
    reader = csv.reader(infile)
    next(reader) # skip the header row
    data = list(reader)

# Extract the variables from the CSV file and convert them to floats
for row in data:
    print(float(row[0]))
