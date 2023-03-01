#!/usr/bin/ruby

require 'open-uri'
require 'csv'
	
puts "Welcome to the URL Checker 3000."
puts "Please input the full file name of the CSV file where you have listed the URLs that you want to check."
puts "It should be in the same directory as this script."

count = 0
error_count = 0
input_file = gets.chomp()
until File.exists?(input_file)
	puts "Nope, that's not a file. Remember to put the csv in the same directory as this script. Don't forget the file extension either."
	input_file = gets.chomp()
end	

begin
	exception_file_name = "article_exception" + Time.now.strftime('%Y-%m-%d_%H-%M-%S') + ".csv"
	CSV.foreach("#{input_file}") do |row|
		puts row[0]
				begin
					prod_page = open(row[0])
				rescue OpenURI::HTTPError => e
						CSV.open(exception_file_name, "a+") do |csv|
							csv << [row[0], e]
						end
						error_count += 1
				end		
		count += 1	
	end
end
puts "Done. #{count} URLs checked. #{error_count} error(s) found"
puts "You will find your results in: #{exception_file_name}"
puts "Thanks for using the URL Checker 3000. You now owe me #{count*1000} dollars."