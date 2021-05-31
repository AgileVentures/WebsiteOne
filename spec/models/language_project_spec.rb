# frozen_string_literal: true

RSpec.describe LanguageProject, type: :model do
  it 'validate uniqueness of language name' do
    new_language = Language.create(name: 'New language')
    language_with_same_name = Language.create(name: 'New language')
    expect(language_with_same_name).to_not be_valid
  end

  it 'validates uniqueness of languages' do
    new_project = FactoryBot.create(:project)
    new_language = Language.create(name: 'New language')
    found_language = Language.find_by(name: new_language.name)
    language_in_join_table = new_project.languages.create(name: found_language.name)
    expect(language_in_join_table).to_not be_valid
  end
end
