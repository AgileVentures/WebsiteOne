require 'spec_helper'

describe 'layouts/application.html.erb' do
  before do
    @user = FactoryGirl.create(:user)
    view.stub(:current_user).and_return(@user)
  end

  context 'meta tags' do
    all_selectors = %w(
      meta[charset="utf-8"]
      meta[http-equiv=X-UA-Compatible][content="IE=edge"]
      meta[name="viewport"]
      meta[name="keywords"]
      meta[name="description"]
      meta[name="author"]
      meta[property="og:title"]
      meta[property="og:type"]
      meta[property="og:url"]
      meta[property="og:description"]
      meta[property="og:image"]
      meta[name="twitter:card"]
      meta[name="twitter:title"]
      meta[name="twitter:description"]
      meta[name="twitter:url"]
    )
    all_selectors.each do |css_selector|
      it "should have selector #{css_selector}" do
        render
        rendered.should have_css css_selector, visible: false
      end
    end
  end

  it 'should include css & js files' do
    render
    rendered.should have_xpath("//link[contains(@href, '.css')]")
    rendered.should have_xpath("//script[contains(@src, '.js')]")
  end

  it 'should include the Google analytics script' do
    dummy = Object.new
    Rails.should_receive(:env).and_return(dummy)
    dummy.should_receive(:production?).and_return(true)
    render
    rendered.should have_xpath("//script[text()[contains(.,#{GA.tracker})]]")
  end

  it 'should not have div nested inside p' do
    should_not have_selector('p>div')
  end

  it 'should not have extra escaped html' do
    should_not =~ /&lt;/
    should_not =~ /&gt;/
    should_not =~ /&amp;/
  end

  it 'should render a navbar' do
    render
    rendered.should have_selector('div.navbar')
  end

  it 'should render links to site features' do
    render
    #TODO Y replace href with project_path helper
    rendered.should have_link 'Projects', :href => projects_path
  end

  it 'should render a footer' do
    render
    rendered.should have_selector('footer')
    rendered.should have_text ('AgileVentures - Crowdsourced Learning')
  end

  it 'should return 200 for all link visits' do
    StaticPage.stub_chain(:friendly, :find).and_return(stub_model(StaticPage, title: 'A static page'))
    render
    rendered.within('div.navbar') do |header|
      links = header.all('a').map { |el| el[:href] }
      links.each do |link|
        visit link
        page.status_code.should == 200
      end
    end
  end

  context 'not signed in as registered user' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should render login & sign-up links' do
      render
      rendered.within('header#main_header') do |header|
        header.should have_link 'Log in', :href => new_user_session_path
        header.should have_link 'Sign up', :href => new_user_registration_path
      end
    end
  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    it 'should render navigation links' do
      render
      rendered.should have_css('#user-gravatar', :visible => true)
      rendered.should have_link 'My account', :href => user_path(@user), :visible => false
      rendered.within('div.navbar') do |header|
        header.should_not have_link 'Log in', :href => new_user_session_path
        header.should_not have_link 'Sign up', :href => new_user_registration_path
      end
    end

    it 'should return 200 on link visit' do
      visit edit_user_registration_path
      page.status_code.should == 200
    end

  end

  context 'within the site footer' do
    before(:each) { render }

    it 'should render a link to the "About Us" page' do
      rendered.within('#footer') do |footer|
        footer.should have_link 'About Us', :href => static_page_path('About Us')
      end
    end

    it 'should render a link to the "Getting Started" page' do
      rendered.within('#footer') do |footer|
        footer.should have_link 'Getting Started', :href => static_page_path('Getting Started')
      end
    end

    it 'should render a link to the AgileVentures Facebook page' do
      rendered.within('#footer') do |footer|
        footer.should have_link 'Facebook', href: 'https://www.facebook.com/agileventures'
      end
    end

    it 'should render a link to the AgileVentures Twitter page' do
      rendered.within('#footer') do |footer|
        footer.should have_link 'Twitter', href: 'https://twitter.com/AgileVentures'
      end
    end

    context 'Contact Us form' do
      it 'renders a form' do
        rendered.within('#footer') do |selection|
          expect(selection).to have_css('#contact_form')
        end
      end

      it 'should render the email information' do
        rendered.within('#footer') do |selection|
          expect(selection).to have_content('Send a traditional email to info@agileventures.org, or use the contact form.')
          expect(selection).to have_link 'info@agileventures.org', href: 'mailto:info@agileventures.org'
        end
      end

      it 'shows  required labels' do
        rendered.within('#contact_form') do |selection|
          expect(selection).to have_text('Name')
          expect(selection).to have_text('Email')
          expect(selection).to have_text('Message')
        end

      end

      it 'shows required fields' do
        rendered.within('#contact_form') do |selection|
          expect(selection).to have_field('name')
          expect(selection).to have_field('email')
          expect(selection).to have_field('message')
        end
      end

      it 'shows Send message button ' do
        rendered.within('#contact_form') do |selection|
          expect(selection).to have_button('send')
        end
      end
    end
  end

end

