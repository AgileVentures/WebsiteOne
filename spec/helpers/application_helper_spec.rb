# frozen_string_literal: true

describe ApplicationHelper do
  it '#date_format returns formatted date 1st Jan 2015' do
    expect(date_format(Date.new(2015, 1, 1))).to eq('1st Jan 2015')
    expect(date_format(Date.new(2015, 5, 3))).to eq('3rd May 2015')
  end

  describe '#valid_email?' do
    it 'returns true if email is valid' do
      expect(valid_email?('valid@valid.com')).to be_truthy
    end

    it 'returns false if email is invalid' do
      expect(valid_email?('invalid')).to be_falsey
      expect(valid_email?('invalid@')).to be_falsey
      expect(valid_email?('invalid@invalid')).to be_falsey
      expect(valid_email?('invalid@invalid.')).to be_falsey
      expect(valid_email?('invalid@.invalid')).to be_falsey
      expect(valid_email?('invalid@invalid.i')).to be_falsey
    end
  end

  describe '#shared_meta_keywords' do
    before do
      @keywords = helper.shared_meta_keywords.split(',').map(&:squish)
    end

    it 'should contain AgileVentures' do
      expect(@keywords).to include 'AgileVentures'
    end

    it 'should contain pair programming' do
      expect(@keywords).to include 'pair programming'
    end

    it 'should contain crowdsourced learning' do
      expect(@keywords).to include 'crowdsourced learning'
    end
  end

  describe '#default_meta_description' do
    it 'should include the words AgileVentures' do
      expect(helper.default_meta_description).to include 'AgileVentures'
    end
  end

  describe '#custom_css_btn' do
    before(:each) do
      @custom_btn_html = helper.custom_css_btn 'this is a text', 'fa fa-icon', root_path, id: 'my-id',
                                                                                          class: 'btn-random'
    end

    it 'should render the text "this is a text"' do
      expect(@custom_btn_html).to have_css '[title="this is a text"]'
    end

    it 'should render the icon classes "fa fa-icon"' do
      expect(@custom_btn_html).to have_css '.fa.fa-icon'
    end

    it 'should have a link to the root path' do
      expect(@custom_btn_html).to have_link '', href: root_path
    end

    it 'should have the id="my-id" and class="btn-random"' do
      expect(@custom_btn_html).to have_css '#my-id.btn-random'
    end
  end

  describe '#social_button' do
    before(:each) do
      @user = stub_model(User)
      @user.stub_chain(:authentications, :where, :first, :id).and_return(100)
      helper.stub(current_user: @user)
    end

    it 'should render the correct provider' do
      btn_html = helper.social_button 'github'
      expect(btn_html).to have_css '.btn-github'
    end

    it 'should render the delete method if the option is specified' do
      btn_html = helper.social_button 'gplus', delete: true
      expect(btn_html).to have_css '[method=delete]'
    end
  end

  describe '#resource_name' do
    it 'should return :user' do
      expect(helper.resource_name).to eq(:user)
    end
  end

  describe '#resource' do
    it 'should return new user with karma' do
      expect(helper.resource).to be_instance_of(User)
      expect(helper.resource.karma).not_to be_nil
    end
  end
end
