desc "Static data import"


namespace :db do
task :import_account, [:args] => :environment do |t, args|
  Rails.root.join
  Rails.application.eager_load!
  DatabaseCleaner.clean_with(:truncation, :only => [:users])#reset the id
  File.open('./lib/tasks/data/accounts') do |f|
    User.transaction do
      f.each_line do |l|
        name, account = l.split
        User.create!(
          name: name, nickname: name, account: account,
          password: account, password_confirmation: account
        )
      end
    end
  end
  puts "====All account import complete[#{Rails.env}]===="
end
end

