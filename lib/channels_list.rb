# frozen_string_literal: true

module ChannelsList
  if ENV['LIVE_ENV'] == 'production'
    CHANNELS = {
      asyncvoter: 'C2HGJF54G',
      autograder: %w(C0UFNHRAB C02AHEA5P),
      betasaasers: 'C02AHEA5P',
      'binghamton-university-bike-share': 'C033Z02P9',
      codealia: 'C0297TUQC',
      communityportal: 'C02HVF1TP',
      cs169: 'C02A6835V',
      'dda-pallet': 'C2QM5N48P',
      educhat: 'C02AD0LG0',
      'esaas-mooc': 'C02A6835V',
      eventmanager: 'C39J4DTP0',
      'agileventures-community': %w(C3Q9A5ZJA C02P3CAPA),
      metplus: 'C0VEPAPJP',
      localsupport: 'C0KK907B5',
      'osra-support-system': 'C02AAM8SY',
      'github-api-gem': 'C02QZ46S9',
      oodls: 'C03GBBASJ',
      phoenixone: 'C7JANJXC4',
      projectscope: 'C1NJX7KM1',
      redeemify: 'C1FQZHJJX',
      refugee_tech: 'C0GUTH7RS',
      'rundfunk-mitbestimmen': 'C5LCQSJMA',
      secondappinion: 'C03D6RUR7',
      'shf-project': 'C2SBUUNRY',
      'snow-angels': 'C03D6RUR7',
      takemeaway: 'C04B0TN0S',
      teamaidz: 'C03DA8NH0',
      visualizer: 'C3NE9JQJX',
      websiteone: 'C029E8G80',
      websitetwo: 'C0ASA1X98',
      'wiki-ed-dashboard': 'C36MNPWTD',
      general: 'C0285CSUF',
      pairing_notifications: 'C02BNVCM1',
      standup_notifications: 'C02B4QH1C',
      premium_mob_trialists: 'GBNRMP4KH',
      premium_extra: 'G33RPEG8K',
      'human-connection': 'CEANP62HG',
      'weekend-heretics': 'CAW8XPFG8',
      'new-members': 'C02G8J689',
      retrospectives: 'CCWNMMHHT',
      refactoring: 'CBZCZP3GA'
    }.freeze
    GITTER_ROOMS = {
      'saasbook/MOOC': '544100afdb8155e6700cc5e4',
      'saasbook/AV102': '55e42db80fc9f982beaf2725',
      'AgileVentures/agile-bot': '56b8bdffe610378809c070cc'
    }.freeze
  else
    CHANNELS = {
      'multiple-channels': %w(C69J9GC1Y C29J4QQ9W),
      cs169: 'C29J4CYA2',
      websiteone: 'C29J4QQ9W',
      localsupport: 'C69J9GC1Y',
      general: 'C0TLAE1MH',
      pairing_notifications: 'C29J3DPGW',
      standup_notifications: 'C29JE6HGR',
      premium_extra: 'C29J4QQ9M',
      premium_mob_trialists: 'C29J4QQ9F',
      'new-members': 'C02G8J699'
    }.freeze
    GITTER_ROOMS = {
      'saasbook/MOOC': '56b8bdffe610378809c070cc',
      'saasbook/AV102': '56b8bdffe610378809c070cc',
      'AgileVentures/agile-bot': '56b8bdffe610378809c070cc'
    }.freeze
  end
end
