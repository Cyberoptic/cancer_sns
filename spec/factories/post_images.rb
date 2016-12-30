FactoryGirl.define do
  factory :post_image do
    post_images Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/images/a.jpg')))
  end
end
