# Search CSV for Term and Categorise

##Introduction & Problem Solved

We wanted a foolproof way to search for conditions in a csv file of anonymised data and categorise it using a medical specialty category that we determine.

We intially did this manually, but there was too much room for error and it was too laborious. There had to be a better way!

So I TDD'd this approach where you can provide a CSV file of anonymised patient data with a presenting complaint. You can then search the whole file for a specific presenting complaint, and select the category you want it to have. Eg a presenting complaint of "cough" should be categorised as "Respiratory". The programme will categorise these and then generate one new csv file with the new data. It is operated in irb/pry.

## Getting Started / Installation

1 Clone this repository `git clone https://github.com/B-raw/search_and_categorise.git` and `cd` into it

2 Create two new folders: `mkdir programme_inputs programme_output`

3 Add your .csv file to the programme_inputs folder
  * Your CSV file should have a single header row

5 In terminal, open irb or pry

6 `require 'csv'`

7 `require_relative 'models/search_and_categorise_csv'`

8 `search_categorise_csv = SearchAndCategoriseCSV.new`

9 `search_categorise_csv.import_csv_template("./path/to/csv/file")`

10 `search_categorise_csv.categorise('pneumonia', "Respiratory")` ad infinitum

9 `search_categorise_csv.create_file_with_categorised_data("my_new_filename")` This will create a .csv file in programme_outputs called my_new_filename.csv which contains the new categorised data.

## Use case example
I have the following csv data:

```
Age on Arrival,Referral Source,Triage Category,Presenting Complaint,Category1,Category2
1,General Practitioner,3 - Urgent,?pneumonia,,
0,NHS 24,4 - Standard,? wheeze/bronch,,
2,Self Referral to A&E,3 - Urgent,?abdo pain,,
2,General Practitioner,4 - Standard,?apendicitis,,
```

I need to categorise wheeze as Respiratory, so I run:

`search_replace_csv.categorise("wheeze", "Respiratory")`

The programme finds "wheeze", and adds "Respiratory" in the next column.

The csv output would be:
```
Age on Arrival,Referral Source,Triage Category,Presenting Complaint,Category1,Category2
1,General Practitioner,3 - Urgent,?pneumonia,,
0,NHS 24,4 - Standard,? wheeze/bronch,Respiratory,
2,Self Referral to A&E,3 - Urgent,?abdo pain,,
2,General Practitioner,4 - Standard,?apendicitis,,
```

## Running the tests

I developed this programme using a TDD approach.

You can see the tests in the spec folder.

To run the tests, enter `rspec` into the terminal from the root directory.

```
SearchAndCategoriseCSV
  can return a string of email text with certain inputs
  can create a separate header array
  can create a separate body array
  can search the presenting complaint for a term and categorise it
  doesn't care about capitalisation
  won't duplicate the same category over and over
  won't return, missing other similar terms
  can save the output to a file

Finished in 0.00544 seconds (files took 0.12926 seconds to load)
8 examples, 0 failures
```

## Authors

B-raw

## License

Whatevs. Use it if you want.

This project is licensed under the [MIT License](http://choosealicense.com/licenses/mit/)
