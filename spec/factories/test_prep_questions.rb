# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :test_prep_question do
    test_prep_sub_category_id 1
    question_text "MyString"
    solution_url "MyString"
  end
end
