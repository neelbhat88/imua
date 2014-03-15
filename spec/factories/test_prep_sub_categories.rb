# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_prep_sub_category do
    test_prep_category_id 1
    name "MyString"
    description "MyText"
    level 1
  end
end
