# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :to_do_item do
    user_id 1
    assigned_by_id 1
    description "MyString"
    date_due "2014-03-04 22:39:49"
    completed false
    date_complete "2014-03-04 22:39:49"
    verified false
    date_verified "2014-03-04 22:39:49"
    notes "MyText"
  end
end
