'use strict'

String::padLeft = (l, c) ->
  Array(l - @length + 1).join(c or " ") + this

###*
 # @ngdoc overview
 # @name marketplaceApp
 # @description
 # # marketplaceApp
 #
 # Main module of the application.
###
root = exports ? this

root.app = angular
  .module('marketplaceApp', [
    'ui.bootstrap'
    'marketplace.templates'
    'ui-templates'
    'multi-select'
    'ui-multiselect'
    'ngAnimate'
    'ngAria'
    'ngCookies'
    'ngMessages'
    'ngResource'
    'ngRoute'
    'ngSanitize'
    'ngTouch'
    # 'angularMoment'
    'LocalStorageModule'
  ])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        redirectTo: '/search'
      .when '/home',
        redirectTo: '/search'
      .when 'ofertas',
        redirectTo: '/search'
      .when '/search',
        templateUrl: 'scripts/components/search/searchView.html'
        controller: 'SearchCtrl'
      .when '/results',
        templateUrl: 'scripts/components/results/resultsView.html'
        controller: 'ResultsCtrl'
      .when '/purchases',
        templateUrl: 'scripts/components/purchases/purchasesView.html'
        controller: 'PurchasesCtrl'
      .when '/bids',
        templateUrl: 'scripts/components/bids/bidsView.html'
        controller: 'BidsCtrl'
      .when '/campaigns',
        templateUrl: 'scripts/components/campaigns/campaignsView.html'
        controller: 'CampaignsCtrl'
      .when '/login',
        templateUrl: 'scripts/shared/login/loginView.html'
        controller: 'LoginCtrl'
      .otherwise
        redirectTo: '/'


  .config (localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix 'markeplace'
    localStorageServiceProvider.setStorageType 'localStorage'

  .config ($httpProvider) ->
    # We need to setup some parameters for http requests
    # These three lines are all you need for CORS support
    # $httpProvider.defaults.useXDomain = true
    # $httpProvider.defaults.withCredentials = true
    # delete $httpProvider.defaults.headers.common['X-Requested-With']

    # Intercept POST requests, convert to standard form encoding
    $httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded;charset=utf-8"
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'
    # $httpProvider.defaults.transformRequest.unshift (data, headersGetter) ->
    #   key = undefined
    #   result = []
    #   for key of data
    #     result.push encodeURIComponent(key) + "=" + encodeURIComponent(data[key])  if data.hasOwnProperty(key)
    #   result.join "&"

    ###*
    The workhorse; converts an object to x-www-form-urlencoded serialization.
    # @param {Object} obj
    # @return {String}
    ###
    # coffeelint: disable=max_line_length
    # param = (obj) ->
    #   query = ''
    #   name = undefined
    #   value = undefined
    #   fullSubName = undefined
    #   subName = undefined
    #   subValue = undefined
    #   innerObj = undefined
    #   i = undefined
    #   for name of obj
    #     value = obj[name]
    #     if value instanceof Array
    #       i = 0
    #       while i < value.length
    #         subValue = value[i]
    #         fullSubName = name + '[' + i + ']'
    #         innerObj = {}
    #         innerObj[fullSubName] = subValue
    #         query += param(innerObj) + '&'
    #         ++i
    #     else if value instanceof Object
    #       for subName of value
    #         subValue = value[subName]
    #         fullSubName = name + '[' + subName + ']'
    #         innerObj = {}
    #         innerObj[fullSubName] = subValue
    #         query += param(innerObj) + '&'
    #     else query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&'  if value isnt 'undefined' and value isnt null
    #   (if query.length then query.substr(0, query.length - 1) else query)

    # # Override $http service's default transformRequest
    # $httpProvider.defaults.transformRequest = [(data) ->
    #   (if angular.isObject(data) and String(data) isnt '[object File]' then param(data) else data)
    # ]
    # return
    # coffeelint: enable=max_line_length

  .config ($locationProvider) ->
    $locationProvider.html5Mode(true)


###*
 # MomentJS setup
###
  # .run (amMoment) ->
  #   amMoment.changeLocale 'pt-br'

  # .constant 'angularMomentConfig',
  #   timezone: 'Sao Paulo'

  # .constant 'CONSTANTS',
  #   GO_CART: ->
  #     window.location.href='/bids'
  #     return


###*
 # @ngdoc object
 # @name marketplace.app:helpers
 # @description
 # # helpers
 # Helpers of the marketplace
###
root.app.helpers =
  ###*
   # @ngdoc function
   # @name marketplace.app.helpers:output
   # @description
   # # helpers
   # Helpers of the marketplace
  ###
  output: (json, withSyntaxHighlight = true) ->
    if withSyntaxHighlight?
      json = JSON.stringify(json, 'undefined', 2)
    else
      return JSON.stringify(json, 'undefined', 2)

    json = json.replace(/&/g, '&').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    # coffeelint: disable=max_line_length
    result = json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
      # coffeelint: enable=max_line_length
      cls = 'number'
      if /^"/.test(match)
        if /:$/.test(match)
          cls = 'key'
        else
          cls = 'string'
      else if /true|false/.test(match)
        cls = 'boolean'
      else cls = 'null'  if /null/.test(match)
      '<span class="' + cls + '">' + match + '</span>'

    result
