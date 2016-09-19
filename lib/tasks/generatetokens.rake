namespace :generatetokens do
    desc 'Find purchase records'
    task :find_purchase_records => :environment do
        puts "Finding purchase records"
        emptypurchases = Purchase.where( :confirm_token => nil).count 
        puts "Found #{emptypurchases} without a confirmation token"
        Purchase.where( :confirm_token => nil).all.each do |purchase|
            purchase.confirm_token = SecureRandom.uuid
            purchase.save
        end
    end

    desc "Run all generatetokens tasks"
    task :all_purchases => [:find_purchase_records]
end