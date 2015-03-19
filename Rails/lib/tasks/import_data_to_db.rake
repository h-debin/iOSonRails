namespace :db do
  desc "import data from another db"
  task :import => :environment do
    puts "you may should copy your private db into ROOT/db/* first"

    db = SQLite3::Database.new "db/news.db"
    db.execute( "select * from news" ) do |row|
      news = News.new(title: row[1],
              description: row[2],
              link: row[3],
              pub_date: DateTime.parse(row[4]),
              category: row[5],
              picture: row[6],
              le: row[7],
              hao: row[8],
              nu: row[9],
              ju: row[10],
              e: row[11],
              jing: row[12])
      if news.save
        print "+"
      else
        print "-"
      end
    end
  end
end
