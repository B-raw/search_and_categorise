require 'spec_helper'
require 'csv'

describe SearchAndCategoriseCSV do
  let(:search_and_categorise_csv) { SearchAndCategoriseCSV.new }

  it "can return a string of email text with certain inputs" do
    search_and_categorise_csv.import_csv_template("spec/test_files/test_cases.csv")
    expected_array = [["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"], ["0", "Self Referral to A&E", "3 - Urgent", " d and v", "Gastrointestinal", nil], ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil], ["4", "999 Emergency", "3 - Urgent", " ? allergic reaction", "Allergy", nil], ["2", "999 Emergency", "3 - Urgent", " infected chicken pox", "Infectious Disease", nil], ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", nil, nil], ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil], ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil], ["0", "General Practitioner", "3 - Urgent", "?bronch", nil, nil], ["1", "Self Referral to A&E", "8 - Suitable for redirection", "?ear infection ", nil, nil], ["1", "General Practitioner", "4 - Standard", "?infected lesion to chest ", nil, nil], ["11", "Self Referral to A&E", "4 - Standard", "tonsilitis", nil, nil], ["4", "St Johns", "2 - Very Urgent", "trans from SJH, femur #", nil, nil], ["1", "Self Referral to A&E", "3 - Urgent", "HI", nil, nil]]
    expect(search_and_categorise_csv.csv_array).to eq expected_array
  end

  it("can create a separate header array") do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/test_cases.csv")

    expected_header_array = ["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"]
    expect(search_replace_csv.header_array).to eq expected_header_array
  end

  it("can create a separate body array") do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/test_cases.csv")
    expected_body_array = [["0", "Self Referral to A&E", "3 - Urgent", " d and v", "Gastrointestinal", nil],
 ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
 ["4", "999 Emergency", "3 - Urgent", " ? allergic reaction", "Allergy", nil],
 ["2", "999 Emergency", "3 - Urgent", " infected chicken pox", "Infectious Disease", nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", nil, nil],
 ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
 ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil],
 ["0", "General Practitioner", "3 - Urgent", "?bronch", nil, nil],
 ["1", "Self Referral to A&E", "8 - Suitable for redirection", "?ear infection ", nil, nil],
 ["1", "General Practitioner", "4 - Standard", "?infected lesion to chest ", nil, nil],
 ["11", "Self Referral to A&E", "4 - Standard", "tonsilitis", nil, nil],
 ["4", "St Johns", "2 - Very Urgent", "trans from SJH, femur #", nil, nil],
 ["1", "Self Referral to A&E", "3 - Urgent", "HI", nil, nil]]
    expect(search_replace_csv.body_array).to eq expected_body_array
  end

  it "can search the presenting complaint for a term and categorise it" do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/4_test_cases.csv")
    search_replace_csv.categorise("wheeze", "Respiratory")

    expected_findings = [["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"],
 ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
 ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
 ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil]]

    expect(search_replace_csv.current_output).to eq expected_findings
  end

  it "doesn't care about capitalisation" do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/4_test_cases.csv")
    search_replace_csv.categorise("wHeEze", "Respiratory")

    expected_findings = [["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"],
 ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
 ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
 ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil]]

    expect(search_replace_csv.current_output).to eq expected_findings
  end

  it "won't duplicate the same category over and over" do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/4_test_cases.csv")
    search_replace_csv.categorise("wheeze", "Respiratory")
    search_replace_csv.categorise("wheeze", "Respiratory")
    search_replace_csv.categorise("wheeze", "Respiratory")

    expected_findings = [["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"],
 ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
 ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
 ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil]]

    expect(search_replace_csv.current_output).to eq expected_findings
  end

  it "won't return, missing other similar terms" do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/4_test_cases_2.csv")
    search_replace_csv.categorise("wheeze", "Respiratory")

    expected_findings = [["Age on Arrival", "Referral Source", "Triage Category", "Presenting Complaint", "Category1", "Category2"],
 ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
 ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
 ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
 ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil]]

    expect(search_replace_csv.current_output).to eq expected_findings
  end

  it("can save the output to a file") do
    search_replace_csv = SearchAndCategoriseCSV.new
    search_replace_csv.import_csv_template("spec/test_files/4_test_cases.csv")
    search_replace_csv.categorise("wheeze", "Respiratory")

    expected_findings = [["Age on Arrival",
       "Referral Source",
       "Triage Category",
       "Presenting Complaint",
       "Category1",
       "Category2"],
       ["1", "General Practitioner", "3 - Urgent", "?pneumonia", nil, nil],
       ["0", "NHS 24", "4 - Standard", "? wheeze/bronch", "Respiratory", nil],
       ["2", "Self Referral to A&E", "3 - Urgent", "?abdo pain", nil, nil],
       ["2", "General Practitioner", "4 - Standard", "?apendicitis", nil, nil]]

    search_replace_csv.create_file_with_categorised_data("search_and_categorise_csv")
    expect(File.file?('./programme_output/search_and_categorise_csv.csv')).to eq true
    expect(CSV.read('./programme_output/search_and_categorise_csv.csv')).to eq expected_findings
    if File.file?('./programme_output/search_and_categorise_csv.csv')
      File.delete('./programme_output/search_and_categorise_csv.csv')
    end
  end

end
