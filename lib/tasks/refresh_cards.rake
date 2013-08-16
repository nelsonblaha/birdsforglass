desc "refresh cards for all users"
task :refresh_cards => :environment do
  Authorization.all.each do |a|
    a.update_cards
  end
end
