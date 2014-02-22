# Bryan: already downcased
def css_selector_for(container)
  case container
    when 'navigation bar' || 'navbar'
      '#nav'

    when 'articles sidebar'
      '#articles-sidebar'

    when 'projects sidebar'
      '#sidebar'

    else
      pending
  end
end

Then(/^(.*) within the (.*)$/) do |s, container|
  case container.downcase
    # Bryan: when xxx for more control

    when 'mercury editor'
      page.driver.within_frame('mercury_iframe') { step(s) }

    else
      page.within(css_selector_for(container)) { step (s) }
  end
end
