module ApplicationHelper
  def gravatar_for(email, options = { size: 80 })
    hash = Digest::MD5::hexdigest(email.strip.downcase)
    "http://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=mm"
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
    Project.all
  end

  def roots
    @roots = Document.roots.where('project_id = ?', @project.id).order(:created_at)
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
    text = options[:text] || (options[:delete] ? 'Remove' : 'Connect with')
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
end
