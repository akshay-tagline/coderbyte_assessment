class PeopleController
  require 'csv'

  CITY = {"LA" => "Los Angeles", "NYC" => "New York City", "A" => "Atlanta"}
  
  def initialize(params)
    @params = params
    @people_by_dollar = @params[:dollar_format]
    @people_by_percent = @params[:percent_format]
  end

  def normalize
    order = @params[:order].to_s

    result = parse_format(@people_by_dollar, "$") + parse_format(@people_by_percent, "%")
    result.sort!{|a, b| a["first_name"] <=> b["first_name"]}.map{|a| [a["first_name"], city_name(a["city"]), Date.parse(a["birthdate"]).strftime("%-m/%-d/%Y")].join(", ")}
  end

  def people_list
    parse_format(@people_by_dollar, "$") + parse_format(@people_by_percent, "%")
  end

  def people_sort_by_age
    age = @params[:birthdate]
    result = parse_format(@people_by_dollar, "$") + parse_format(@people_by_percent, "%")
    if age == :asc
      result.sort_by!{|p| Date.parse(p["birthdate"]) }.map{|a| [a["first_name"], city_name(a["city"]), Date.parse(a["birthdate"]).strftime("%d-%m-%Y")].join(", ")}
    elsif age == :desc
      result.sort_by!{|p| Date.today - Date.parse(p["birthdate"]) }.map{|a| [a["first_name"], city_name(a["city"]), Date.parse(a["birthdate"]).strftime("%d-%m-%Y")].join(", ")}
    else
      result
    end
  end

  private

  attr_reader :params

  def city_name(city)
    letters = city.extract_upper_case_letters
    city = letters.join("")
    CITY[city] || city
  end

  def parse_format(format, seperator)
    data = CSV.parse(format, :headers => true, col_sep: seperator, strip: true)
    data.map{|a| a.to_h}
  end
end

class String
  def extract_upper_case_letters
    self.scan /\p{Upper}/
  end
end
