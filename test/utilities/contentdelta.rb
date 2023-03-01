#!/usr/bin/ruby

require 'open-uri'
require 'csv'
require 'date'

puts "The Content Delta script will check the SEC publishing log for a list of URLS and will indicate if any of the pages have been updated since a particular date."
puts "First, input the full file name of the CSV file where you have listed the URLs that you want to check."
puts "It should be in the same directory as this script."

count = 0
delta_count = 0
input_file = gets.chomp()
until File.exists?(input_file)
	puts "Nope, that's not a file. Remember to put the csv in the same directory as this script. Don't forget the file extension either."
	input_file = gets.chomp()
end

puts "Next, enter the date that you want to start checking for updates from. Use YYYY-MM-DD format."

start_date = DateTime.parse(gets.chomp())
check_date = start_date

begin
	exception_file_name = "article_exception" + Time.now.strftime('%Y-%m-%d_%H-%M-%S') + ".csv"
	while !(check_date === date.today + 1) do
		log = Nokogiri::HTML('http://' + check_date.strftime('%Y-%m-%d'))
		CSV.foreach("#{input_file}") do |row|
				begin
					prod_content = pdoc.xpath('//a[@href="' + row[0] + '"]')
					if prod_content.length > 0
						exception_file_name << row[0]
						error_count += 1
					end
				end
		end
		check_date + 1
	end
end
puts "Done. #{check_date} day(s) checked. #{error_count} update(s) found"
puts "You will find your results in: #{exception_file_name}"
