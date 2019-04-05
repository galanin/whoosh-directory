RSpec::Matchers.define :has_status_200 do
  match do |actual|
    actual.status == 200
  end
end

