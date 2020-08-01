# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "csv"


filename = File.dirname(File.dirname(File.expand_path(__FILE__))) + '/db/zip_code_database.csv'
CSV.foreach(filename, headers: true) do |row|
  s = row['state']
  state = State.find_or_create_by(abbr: s)
  if s == 'CO'
    cities = [row['primary_city']]
    acs = row['acceptable_cities'] ? row['acceptable_cities'].split(',') : []
    acs.each do |c|
      cities << c.strip
    end

    zip = row['zip']

    code = PostalCode.find_or_create_by(code: zip)
    cities.each do |c|
      city = City.find_or_create_by(name: c, state_id: state.id)
      CityPostalCode.find_or_create_by(city_id: city.id, postal_code_id: code.id)
    end
  end
end
