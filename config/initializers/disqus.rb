module Disqus
  if Rails.env.development? || Rails.env.test?
    DISQUS_SHORTNAME  = 'agileventures-dev'
    DISQUS_API_KEY = 'Mh9WLi09Ve752WaTu3xbfEpSXDHOluVNc2Cm8UnDVA5TTuKXUebEVq56cDlu0SBu'
    DISQUS_SECRET_KEY = 'bRtQeANt2qJQ9Y6CJZtA2I2g6dioHKDuPaX5US17JmRXmvMYcG69wZXeKaFmd8qJ'
  else
    DISQUS_SHORTNAME  = 'agileventures'
  end
end
