module ApplicationHelper

  include ArticlesHelper

  def gravatar_for(email, options = {size: 80})
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=retro"
  end

  def current_user_details
    if current_user.present?
      if current_user.first_name.present?
        ([current_user.first_name, current_user.last_name].join(' '))
      else
        (current_user.email).split('@').first
      end
    else
      'Something is wrong'
    end
  end

  def user_details(id)
    user = User.find_by_id(id)
    if user.present?
      if user.first_name.present?
        ([user.first_name, user.last_name].join(' '))
      else
        (user.email).split('@').first
      end
    else
      'Anonymous'
    end
  end

  #def user_details(id)
  #  user = User.find_by_id(id)
  #  if user.present?
  #    first = user.try(:first_name)
  #    last = user.try(:last_name)
  #    str = first.to_s + last.to_s
  #    if first && last
  #      [first, last].join(' ')
  #    elsif !first && !last
  #      # User has not filled in their profile
  #      user.email.split('@').first
  #    else
  #      str
  #    end
  #  else
  #    'Anonymous'
  #  end
  #end


  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_projects
    Project.order(created_at: :desc)
  end

  def roots
    @roots = Document.roots.where('project_id = ?', @project.id).order(:created_at)
  end

  def date_format(date)
    date.strftime("#{date.day.ordinalize} %b %Y")
  end

  def social_button(provider, options={})
    provider = provider.downcase
    display_name = {
        'github' => 'GitHub',
        'gplus' => 'Google+'
    }

    fa_icon = {
        'github' => 'github-alt',
        'gplus' => 'google-plus'
    }

    options[:url] ||= root_path
    text = options[:text] || (options[:delete] ? 'Remove' : '')
    path = options[:delete] ? "/auth/destroy/#{current_user.authentications.where(provider: provider).first.id}" :
        "/auth/#{provider}#{"?origin=#{CGI.escape(options[:url].gsub(/^[\/]*/, '/'))}" if options[:url].present?}"

    raw <<-HTML
    <div data-no-turbolink>
      <a class="btn btn-block btn-social btn-#{provider} #{options[:extra_class]}"  #{'method="delete" ' if options[:delete]}href=#{path}>
        <i class="fa fa-#{fa_icon[provider]}"></i> #{text} #{display_name[provider]}
      </a>
    </div>
    HTML
  end

  def supported_third_parties
    %w{ github gplus }
  end

  def valid_email?(email)
    !!(email =~ /\A([^@\s]+)@((?:[\w]+\.)+[a-z]{2,})\z/i)
  end

  def custom_css_btn(text, icon_class, path, options={})
    s = ''
    options.each do |k, v|
      if v.is_a?(Hash)
        # Bryan: this extra level is to support data tags
        v.each do |key, value|
          s = %Q{#{s} #{k}-#{key.to_s.gsub(/_/, '-')}="#{value}"}
        end
      else
        s = %Q{#{s} #{k.to_s}="#{v}"}
      end
    end
    # Bryan: data-link-text attribute is used to find this element in the tests
    raw <<-HTML
    <a href="#{path}"#{s} data-link-text="#{text.downcase}">
      <div class="doc-option">
        <div class="doc-option-icon"><i class="#{icon_class}"></i></div>
        <div class="doc-option-text">#{text}</div>
      </div>
    </a>
    HTML
  end

  def count_down
    if Event.exists?
      @events = []
      Event.where(['category = ?', 'Scrum']).each do |event|
        @events << event.current_occurences
      end
      @events = @events.flatten.sort_by { |e| e[:time] }
      one_event = @events[0]
      @event = nested_hash_value(one_event, :event)
      @event_time = nested_hash_value(one_event, :time).to_datetime
      countdown = Time.now.to_datetime.distance_to(@event_time)
      @minutes_left = countdown[:minutes]
      @hours_left = countdown[:hours]
      @days_left = countdown[:days]
    end
  end
end
