FactoryGirl.define do
  factory :post do
    content 'Hello there this is a content'
    photo Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/images/1.png')))

  end
end
