bakken.config ['AnalyticsProvider', (AnalyticsProvider) ->

  AnalyticsProvider.setAccount atob(GOOGLE_ANALYTICS)
  AnalyticsProvider.useAnalytics true

  AnalyticsProvider.setCookieConfig
    cookieDomain: '.bakken.fm'
    cookieName: 'stats'
    cookieExpires: 20000

  AnalyticsProvider.setDomainName 'beta.bakken.fm'

]
