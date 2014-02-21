module ApplicationHelper
  def gravatar_for(email, options = { size: 80 })
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=mm"
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
        'gplus'  => 'Google+'
    }

    fa_icon = {
        'github' => 'github-alt',
        'gplus'  => 'google-plus'
    }

    options[:url] ||= root_path
    text = options[:text] || (options[:delete] ? 'Remove' : '')
    path = options[:delete] ? "/auth/destroy/#{current_user.authentications.where(provider: provider).first.id}" :
        "/auth/#{provider}#{"?origin=#{CGI.escape(options[:url].gsub(/^[\/]*/, '/'))}" if options[:url].present?}"

    raw <<-HTML
      <a class="btn btn-lg btn-block btn-social btn-#{provider}" #{'method="delete" ' if options[:delete]}href=#{path}>
        <i class="fa fa-#{fa_icon[provider]}"></i> #{text} #{display_name[provider]}
      </a>
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
end
