import csv

def read_csv_file(filename):
    data = []
    with open(filename, 'rt') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            data.append(row)
    return data