desc "refresh cards for all users"
task :refresh_tokens => :environment do
  Authorization.all.each do |a|
    a.update_cards
  end
end
