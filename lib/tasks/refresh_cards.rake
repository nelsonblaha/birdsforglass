desc "refresh cards for all users"
task :refresh_cards => :environment do
  Authorization.all.each do |a|
    begin
      a.update_cards
    rescue
    end
  end
end
