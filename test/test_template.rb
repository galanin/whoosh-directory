require 'test_helper'
# doc https://ruby-doc.org/stdlib-1.9.3/libdoc/minitest/spec/rdoc/MiniTest/Spec.html
# run test in console: bundle exec ruby -Itest test/test_template.rb

describe Staff::API do
  include Rack::Test::Methods

  let(:app) { Staff::API }

  it "your_test" do
    # your code
  end

end
