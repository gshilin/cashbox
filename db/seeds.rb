# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(1..9).each do |d|
  puts "Desk #{d}"
  desk = Cashdesk.find(d)
  (1..100).each do |s|
    shift = Shift.find_by(id: d)
    unless shift
      shift = Shift.create(state: 'inactive')
      desk.shifts << shift
    end
    (1..100).each do |x|
      case x % 4
        when 0
          income = Income.create(amount: rand(200), kind: 'cc', currency: 'ILS', success: true)
          shift.incomes << income
        when 1
          income = Income.create(amount: rand(200), kind: 'nis', currency: 'ILS', success: true)
          shift.incomes << income
        when 2
          income = Income.create(amount: rand(200), kind: 'usd', currency: 'USD', success: true)
          shift.incomes << income
        when 3
          income = Income.create(amount: rand(200), kind: 'eur', currency: 'EUR', success: true)
          shift.incomes << income
      end
    end
  end
end
