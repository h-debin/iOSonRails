# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
__END__
1000.times do
  News.create(title:Faker::Name.name,
              link:Faker::Internet.url,
              pub_date:Faker::Time.between(2.days.ago, Time.now),
              image:Faker::Internet.url,
              video:Faker::Internet.url,
              text:Faker::Lorem.paragraph,
              category: Faker::Lorem.word,
              from_site: Faker::Lorem.word)
end
