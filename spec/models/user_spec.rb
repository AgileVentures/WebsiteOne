# frozen_string_literal: true

RSpec.describe User, type: :model do
  include_examples 'presentable'

  subject { build_stubbed :user }

  it 'includes Filterable module' do
    expect(User.ancestors).to include(Filterable)
  end

  context 'associations' do
    it { is_expected.to have_many(:subscriptions).autosave(true) }

    it { is_expected.to have_one :karma }

    it { is_expected.to have_many(:authentications).dependent(:destroy) }

    it { is_expected.to have_many(:projects) }

    it { is_expected.to have_many(:documents) }

    it { is_expected.to have_many(:articles) }

    it { is_expected.to have_many(:event_instances) }

    it { is_expected.to have_many(:commit_counts) }

    it { is_expected.to have_many(:status) }
  end

  it { is_expected.to accept_nested_attributes_for :status }

  it { is_expected.to respond_to :status_count }

  it 'should have valid factory' do
    expect(create(:user)).to be_valid
  end

  it 'should be invalid without email' do
    expect(build_stubbed(:user, email: '')).to_not be_valid
  end

  it 'should be invalid with an invalid email address' do
    expect(build(:user, email: 'user@foo,com')).to_not be_valid
  end

  it 'should be valid with all the correct attributes' do
    expect(subject).to be_valid
  end

  it 'should reject duplicate email addresses' do
    user = create(:user)
    expect(build(:user, email: user.email)).to_not be_valid
  end

  it 'should reject email addresses identical up to case' do
    upcased_email = subject.email.upcase
    _existing_user = create(:user, email: upcased_email)
    expect(build(:user, email: subject.email)).to_not be_valid
  end

  it 'should be invalid without password' do
    expect(build_stubbed(:user, password: '')).to_not be_valid
  end

  it 'should be invalid without matching password confirmation' do
    expect(build_stubbed(:user, password_confirmation: 'invalid')).to_not be_valid
  end

  it 'should be invalid with short password' do
    expect(build_stubbed(:user, password: 'aaa', password_confirmation: 'aaa')).to_not be_valid
  end

  it 'should respond to is_privileged?' do
    expect(build(:user)).to respond_to(:is_privileged?)
  end

  it "should return false if 'Settings.privileged_users' is not setup" do
    Settings.privileged_users = nil
    expect(create(:user).is_privileged?).to be false
  end

  describe 'scopes' do
    context '#mail_receiver' do
      let!(:user1) { create(:user, receive_mailings: false) }
      let!(:user2) { create(:user, receive_mailings: true) }

      it { expect(User).to respond_to(:mail_receiver) }

      it { expect(User.mail_receiver).to include(user2) }

      it { expect(User.mail_receiver).to_not include(user1) }
    end

    context '#allow_to_display' do
      let!(:user1) { create(:user, display_profile: false) }
      let!(:user2) { create(:user, display_profile: true) }

      it { expect(User).to respond_to(:allow_to_display) }

      it { expect(User.allow_to_display).to include(user2) }

      it { expect(User.allow_to_display).to_not include(user1) }
    end
  end

  describe 'slug generation' do
    subject { build(:user, slug: nil) }
    it 'should automatically generate a slug' do
      subject.save
      expect(subject.slug).to_not eq nil
    end

    it 'should be manually adjustable' do
      slug = 'this-is-a-slug'
      subject.slug = slug
      subject.save
      expect(User.find(subject.id).slug).to eq slug
    end

    it 'should be remade when the display name changes' do
      subject.save
      slug = subject.slug
      subject.update(first_name: 'Shawn')
      expect(subject.slug).to_not eq slug
    end

    it 'should not be affected by multiple saves' do
      subject.save
      slug = subject.slug
      subject.save
      expect(subject.slug).to eq slug
    end
  end

  describe 'geocoding' do
    subject { build(:user, last_sign_in_ip: '85.228.111.204') }

    before(:each) do
      Geocoder.configure(lookup: :test, ip_lookup: :test)
      sweden_address = [
        {
          ip: '85.228.111.204',
          country_code: 'SE',
          country_name: 'Sweden',
          region_code: '28',
          region_name: 'Västra Götaland',
          city: 'Alingsås',
          zipcode: '44139',
          latitude: 57.9333,
          longitude: 12.5167,
          metro_code: '',
          areacode: ''
        }.as_json
      ]

      Geocoder::Lookup::Test.add_stub('127.0.0.1', sweden_address)
      Geocoder::Lookup::Test.add_stub('0.0.0.0', sweden_address)
      Geocoder::Lookup::Test.add_stub('85.228.111.204', sweden_address)

      Geocoder::Lookup::Test.add_stub(
        '50.78.167.161', [
          {
            ip: '50.78.167.161',
            country_code: 'US',
            country_name: 'United States',
            region_code: 'WA',
            region_name: 'Washington',
            city: 'Seattle',
            zipcode: '',
            latitude: 47.6062,
            longitude: -122.3321,
            metro_code: '819',
            areacode: '206'
          }.as_json
        ]
      )
    end

    # TODO: These tests are up for refactoring
    it 'should perform geocode' do
      subject.save
      expect(subject.latitude).to_not eq nil
      expect(subject.longitude).to_not eq nil
      expect(subject.city).to_not eq nil
      expect(subject.country_name).to_not eq nil
      expect(subject.country_code).to_not eq nil
    end

    it 'should set user location' do
      subject.save
      expect(subject.latitude).to eq 57.9333
      expect(subject.longitude).to eq 12.5167
      expect(subject.city).to eq 'Alingsås'
      expect(subject.country_name).to eq 'Sweden'
      expect(subject.country_code).to eq 'SE'
    end

    it 'should change location if ip changes' do
      subject.save
      subject.update(last_sign_in_ip: '50.78.167.161')
      expect(subject.city).to eq 'Seattle'
      expect(subject.country_name).to eq 'United States'
      expect(subject.country_code).to eq 'US'
    end
  end
  # End refactoring block

  describe '#followed_project_tags' do
    it 'returns project tags for projects with project title and tags and a scrum tag' do
      project_1 = build_stubbed(:project, title: 'Big Boom', tag_list: ['Big Regret', 'Boom', 'Bang'])
      project_2 = build_stubbed(:project, title: 'Black hole', tag_list: [])
      allow(subject).to receive(:following_projects).and_return([project_1, project_2])
      expect(subject.followed_project_tags).to eq ['big regret', 'boom', 'bang', 'big boom', 'black hole', 'scrum']
    end
  end

  describe '#gravatar_url' do
    let(:email) { ' MyEmailAddress@example.com  ' }
    let(:user_hash) { '0bc83cb571cd1c50ba6f3e8a78ef1346' }
    let(:user) { User.new(email: email) }

    it 'should construct a link to the image at gravatar.com' do
      regex = %r{^https://.*gravatar.*#{user_hash}}
      expect(user.gravatar_url).to match(regex)
    end

    it 'should be able to specify image size' do
      expect(user.gravatar_url(size: 200)).to match(/\?s=200&/)
    end
  end

  describe '.param_filter' do
    let(:params) { {} }

    context 'has filters' do
      before(:each) do
        @user1 = create(:user, latitude: 59.33, longitude: 18.06)
        @user2 = create(:user, latitude: -29.15, longitude: 27.74)
        @project = create(:project)
      end

      it 'filters users for project' do
        @user1.follow @project
        @user2.stop_following @project
        params['project_filter'] = @project.id

        results = User.param_filter(params).allow_to_display

        expect(results).to include(@user1)
        expect(results).not_to include(@user2)
      end
    end

    context 'no filters' do
      subject { User.param_filter(params).allow_to_display }

      before(:each) do
        create(:user, first_name: 'Bob', created_at: 5.days.ago)
        create(:user, first_name: 'Marley', created_at: 2.days.ago)
        create(:user, first_name: 'Janice', display_profile: false)
      end

      it 'ordered by creation date' do
        expect(subject.first.first_name).to eq('Bob')
      end

      it 'filtered by the display_profile property' do
        results = subject.map(&:first_name)
        expect(results).to include('Marley')
        expect(results).not_to include('Janice')
      end
    end

    describe '.find_by_github_username' do
      it 'returns the user if it exists' do
        user_with_github = create(:user, github_profile_url: 'https://github.com/sampritipanda')
        user_without_github = create(:user, github_profile_url: nil)
        expect(User.find_by_github_username('sampritipanda')).to eq user_with_github
      end

      it 'returns nil if no user exists' do
        expect(User.find_by_github_username('unknown-guy')).to be_nil
      end
    end

    describe 'user online?' do
      let(:user) { @user }

      before(:each) do
        @user = create(:user, updated_at: '2014-09-30 05:00:00 UTC')
      end

      after(:each) do
        Delorean.back_to_the_present
      end

      it 'returns true if touched in last 10 minutes' do
        Delorean.time_travel_to(Time.parse('2014-09-30 05:09:00 UTC'))
        expect(user).to be_online
      end

      it 'returns false if touched more then 10 minutes ago' do
        Delorean.time_travel_to(Time.parse('2014-09-30 05:12:00 UTC'))
        expect(user.online?).to eq false
      end
    end
  end

  describe 'incomplete profile' do
    let(:user) { create(:user, :with_karma, updated_at: '2014-09-30 05:00:00 UTC') }

    it 'returns true if bio empty' do
      user.bio = ''
      expect(user.incomplete?).to be_truthy
    end

    it 'returns true if skills empty' do
      user.skill_list = ''
      user.save
      expect(user.incomplete?).to be_truthy
    end

    it 'returns true if first_name empty' do
      user.first_name = ''
      expect(user.incomplete?).to be_truthy
    end

    it 'returns true if skills empty' do
      user.last_name = ''
      expect(user.incomplete?).to be_truthy
    end

    it 'returns false if all are complete' do
      expect(user.incomplete?).to be_falsey
    end

    it 'returns true with nil values' do
      expect(User.new.incomplete?).to be_truthy
    end
  end

  context 'karma' do
    describe '#commit_count_total' do
      subject(:user) { create(:user, :with_karma) }

      let!(:commit_count) { create(:commit_count, user: user, commit_count: 369) }

      context 'single commit count' do
        it 'returns totals commits over all projects' do
          expect(user.commit_count_total).to eq 369
        end
      end

      context 'multiple commit count' do
        let!(:commit_count_2) { create(:commit_count, user: user, commit_count: 123) }
        it 'returns totals commits over all projects' do
          expect(user.commit_count_total).to eq 492
        end
      end
    end

    describe '#number_hangouts_started_with_more_than_one_participant' do
      subject(:user) { create(:user, :with_karma) }

      let!(:event_instance) { create(:event_instance, user: user) }
      context 'single event instance' do
        it 'returns total number of hangouts started with more than one participant' do
          expect(user.number_hangouts_started_with_more_than_one_participant).to eq 1
        end
      end

      context 'two event instances' do
        let!(:event_instance2) { create(:event_instance, user: user) }
        it 'returns total number of hangouts started with more than one participant' do
          expect(user.number_hangouts_started_with_more_than_one_participant).to eq 2
        end
      end
    end

    describe '#hangouts_attended_with_more_than_one_participant' do
      subject(:user) { create(:user, :with_karma, hangouts_attended_with_more_than_one_participant: 1) }
      it 'returns 1' do
        expect(user.hangouts_attended_with_more_than_one_participant).to eq 1
      end
    end

    describe '#profile_completeness' do
      subject(:user) { create(:user, :with_karma) }
      it 'calculates profile completeness' do
        expect(user.profile_completeness).to eq 6
      end
    end

    describe '#activity' do
      subject(:user) { create(:user, :with_karma) }
      it 'calculates sign in activity' do
        expect(user.activity).to eq 0
      end
    end

    describe '#membership_length' do
      subject(:user) { create(:user, :with_karma) }
      it 'calculates membership length' do
        expect(user.membership_length).to eq 0
      end
    end

    describe '#membership_type' do
      subject(:user) { create(:user, :with_karma) }

      it 'returns membership type' do
        expect(user.membership_type).to eq 'Basic'
      end

      context 'premium member' do
        subject(:user) { create(:user, :with_karma) }
        subject(:plan) { create(:plan, name: 'Premium') }
        let!(:premium) { create(:subscription, user: user, plan: plan) }

        it 'returns premium' do
          expect(user.membership_type).to eq 'Premium'
        end
      end
    end

    describe '#karma_total' do
      subject(:user) { create(:user, :with_karma) }
      it 'returns 0 when user initially created' do
        expect(user.karma_total).to eq 0
      end
      context 'once associated karma object is created' do
        subject(:user) { build(:user, :with_karma, karma: FactoryBot.create(:karma, total: 50)) }
        it 'returns non zero' do
          expect(user.karma_total).to eq 50
        end
      end
    end
  end

  context 'destroying user' do
    it 'should soft destroy' do
      user = User.new({ email: 'doh@doh.com', password: '12345678' })
      user.save!
      user.destroy!
      expect(user.deleted_at).to_not eq nil
    end
  end

  context 'creating user' do
    it 'should not override existing karma' do
      user = User.new({ email: 'doh@doh.com', password: '12345678' })
      user.karma = Karma.new(total: 50)
      user.save!
      expect(user.karma.total).to eq 50
    end
  end

  context 'supporting current subscription' do
    subject(:user) { create(:user, :with_karma) }
    let(:premium) { create(:plan, name: 'Premium') }
    let(:premium_mob) { create(:plan, name: 'Premium Mob') }
    let(:premium_f2f) { create(:plan, name: 'Premium F2F') }
    let(:payment_source) { PaymentSource::PayPal.create(identifier: '75e') }
    let(:now) { DateTime.now }

    # presence of type (no longer used) in the Subscriptions model is confusing ...
    # should get rid of all the STI classes ...

    let!(:subscription1) do
      create(:subscription, user: user, plan: premium, started_at: 2.days.ago, ended_at: 1.day.ago)
    end
    let!(:subscription2) do
      create(:subscription, user: user, plan: premium_mob, started_at: 1.day.ago,
                            payment_source: payment_source)
    end

    it 'returns subscription that has started and has not ended' do
      expect(user.current_subscription.id).to eq subscription2.id
    end

    it 'asks subscription for identifier' do
      expect(subject.stripe_customer_id).to eq '75e'
    end

    # this nails an issue that we were checking < and not <= but
    # it doesn't seem to capture that we need to_i's to get the date
    # equality comparison to work ...
    context 'just started a new plan' do
      before do
        subscription2.ended_at = now
        subscription2.save
      end
      let!(:subscription3) do
        create(:subscription, user: user, plan: premium_f2f, started_at: now, payment_source: payment_source)
      end

      it 'returns subscription that has started right now and has not ended' do
        expect(user.current_subscription.id).to eq subscription3.id
      end
    end
  end
end
