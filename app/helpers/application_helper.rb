# frozen_string_literal: true

module ApplicationHelper
  include ArticlesHelper
  include DisqusHelper

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

  def privileged_visitor?
    current_user&.is_privileged?
  end

  def static_page_path(page)
    "/#{StaticPage.url_for_me(page)}"
  end

  def is_in_static_page?(static_page_name)
    params[:controller] == 'static_pages' &&
      params[:action] == 'show' &&
      params[:id] == StaticPage.url_for_me(static_page_name)
  end

  def resource
    @resource ||= User.new({ karma: Karma.new })
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def current_projects
    Project.where(status: %w(active Active)).order('title ASC').order('commit_count DESC NULLS LAST')
  end

  def date_format(date)
    date.strftime("#{date.day.ordinalize} %b %Y")
  end

  DISPLAY_NAME = {
    'github' => 'GitHub',
    'gplus' => 'Google'
  }.freeze

  FA_ICON = {
    'github' => 'github-alt',
    'gplus' => 'google'
  }.freeze

  def social_button(provider, options = {})
    provider = provider.downcase
    options[:url] = root_path unless options[:url].present?

    options[:delete] ? remove_social_account_button(provider, options) : add_social_account_button(provider, options)
  end

  def add_social_account_button(provider, options)
    text = options[:text] || prefix
    path = "/auth/#{provider}?origin=#{CGI.escape(options[:url].gsub(%r{^/*}, '/'))}"

    # Underneath uses CSRF protection workaround provided by https://github.com/cookpad/omniauth-rails_csrf_protection
    button_to path, method: :post, class: "btn btn-block btn-social btn-#{provider} #{options[:extra_class]}" do
      raw <<-HTML
        <i class="fa fa-#{FA_ICON[provider]}"></i> #{text} #{DISPLAY_NAME[provider]}
      HTML
    end
  end

  def remove_social_account_button(provider, options)
    text = options[:text] || 'Remove'
    path = "/auth/destroy/#{current_user.authentications.where(provider: provider).first.id}"

    raw <<-HTML
    <div data-no-turbolink>
      <a class="btn btn-block btn-social btn-#{provider} #{options[:extra_class]}" method="delete" href="#{path}">
        <i class="fa fa-#{FA_ICON[provider]}"></i> #{text} #{DISPLAY_NAME[provider]}
      </a>
    </div>
    HTML
  end

  def prefix
    action_name == 'new' ? 'with' : ''
  end

  def supported_third_parties
    %w(github)
    # %w(github gplus) 
  end

  def valid_email?(email)
    !!(email =~ /\A([^@\s]+)@((?:\w+\.)+[a-z]{2,})\z/i)
  end

  def custom_css_btn(text, icon_class, path, options = {})
    s = ''
    options.each do |k, v|
      if v.is_a?(Hash)
        # Bryan: this extra level is to support data tags
        v.each do |key, value|
          s = %(#{s} #{k}-#{key.to_s.tr('_', '-')}="#{value}")
        end
      else
        s = %(#{s} #{k}="#{v}")
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
    @default_meta_description ||= '' \
                                  'AgileVentures is a project incubator that stimulates and supports development of social innovations, ' \
                                  'open source and free software. We are also a community for learning and personal development with members ' \
                                  'from across the world with various levels of competence and experience in software development. We hold ' \
                                  'scrum meetings and pair programming sessions every day with participants from all time zones and on all ' \
                                  'levels. Come and join us.'
  end

  def present(model)
    yield(model.presenter)
  end
end
