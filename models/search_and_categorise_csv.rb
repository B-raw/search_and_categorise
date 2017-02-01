class SearchAndCategoriseCSV
  attr_reader :csv_array, :header_array, :body_array

  def import_csv_template(csv_file)
    @csv_array = CSV.read(csv_file)
    @header_array = @csv_array[0]
    @body_array = @csv_array.drop(1)
  end

  def categorise(search_term, new_category)
    changed_entries = []
    @csv_array.each do | attendance |
      if attendance[3].nil?
        #do nothing
      elsif attendance[3].downcase.include?(search_term.downcase)
        if attendance.include?(new_category)
          #do nothing
        elsif attendance[4].nil?
          attendance[4] = new_category
          changed_entries.push(attendance)
        elsif attendance[5].nil?
          attendance[5] = new_category
          changed_entries.push(attendance)
        else
          attendance.push(new_category)
          changed_entries.push(attendance)
        end
      end
    end
    changed_entries
  end

  def current_output
    @csv_array
  end

  def create_file_with_categorised_data(filename)
    filename = "programme_output/" + filename + ".csv"
    CSV.open(filename, "w") do |csv|
      current_output.each do |row|
        csv << row
      end
    end
  end

end
