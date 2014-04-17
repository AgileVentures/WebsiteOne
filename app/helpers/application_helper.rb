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
      user.display_name
    else
      'Anonymous'
    end
  end

  def resource_name
    :user
  end

  def static_page_path(page)
    "/#{StaticPage.url_for_me(page)}"
  end

  def is_in_static_page?(static_page_name)
    return params[:controller] == 'static_pages' &&
      params[:action] == 'show' &&
      params[:id] == StaticPage.url_for_me(static_page_name)
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
    <a href="#{path}"#{s} data-toggle="tooltip" data-placement="top" title="#{text}" class="btn btn-default btn-controls">
      <i class="#{icon_class}"></i>
    </a>
    HTML
  end

  def awesome_text_field(f, object_name, options = {})
    awesome_text_method(:text_field, f, object_name, options)
  end

  def awesome_text_area(f, object_name, options = {})
    awesome_text_method(:text_area, f, object_name, options)
  end

  def awesome_text_method(method_name, f, object_name, options = {})
    errors = f.object.errors.messages[object_name]
    result = "<div class=\"form-group#{' has-error has-feedback' if errors.present?}\">"
    result << f.label(object_name, options[:label_text], { class: 'control-label' }.merge(options[:label] || {}))
    result << f.send(method_name, object_name, { class: 'form-control' }.merge(options))
    result << "<span class=\"help-block control-label\">#{errors.join(', ')}</span>" if errors.present?
    result << '</div>'
    clean_html result
  end
  private :awesome_text_method

  def active_if(condition)
    condition ? 'active' : nil
  end

  def active_if_controller_is(controller_name)
    active_if(params[:controller] == controller_name)
  end

  def shared_meta_keywords
    'AgileVentures, pair programming, crowdsourced learning'
  end

  def default_meta_description
    @default_meta_description ||= '' +
        'AgileVentures is a project incubator that stimulates and supports development of social innovations, ' +
        'open source and free software. We are also a community for learning and personal development with members ' +
        'from across the world with various levels of competence and experience in software development. We hold ' +
        'scrum meetings and pair programming sessions every day with participants from all time zones and on all ' +
        'levels. Come and join us.'
  end
end
