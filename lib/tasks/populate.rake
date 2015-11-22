namespace :db do
  desc 'Generate fake data'
  task load_fake_data: :environment do
    require_relative Rails.root.join('db/populate.rb')
  end
end
