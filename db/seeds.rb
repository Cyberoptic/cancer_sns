# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TREATMENTS = %w(手術療法 抗がん剤（化学療法） 放射線療法 ホルモン療法 先進医療 漢方 その他被保険療法)
TREATMENTS.each do |treatment|
  Treatment.create(name: treatment, default: true)
end if Treatment.count == 0
 
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')