namespace :db do
  desc "clean up old news (2days ago)"
  task :cleanup => :environment do
    News.where(["pub_date < ?", 2.days.ago]).destroy_all
  end

  desc "import data from another db"
  task :import => :environment do
    puts "you may should copy your private db into ROOT/db/* first"

    db = SQLite3::Database.new "db/news.db"
    db.execute( "select * from news" ) do |row|
      news = News.new(title: row[1],
              description: row[2],
              pub_date: DateTime.parse(row[4]),
              link: row[5],
              category: row[6],
              picture: row[7],
              le: row[8],
              hao: row[9],
              nu: row[10],
              ai: row[11],
              ju: row[12],
              e: row[13],
              jing: row[14],
              emotion_type: row[15],
              main_emotion_value: row[16])
      if news.save
        print "+"
      else
        print "-"
      end
    end
  end
end
