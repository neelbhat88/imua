# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_prep_category do
    test_prep_subject_id 1
    name "MyString"
    level 1
  end
end
