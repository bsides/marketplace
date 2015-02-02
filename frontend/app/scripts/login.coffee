'use strict'

###*
 # @ngdoc overview
 # @name loginMarketplaceApp
 # @description
 # # loginMarketplaceApp
 #
 # Login module of the application.
###
root = exports ? this

root.app = angular
  .module('loginMarketplaceApp', [
    'ui.bootstrap'
    'marketplace.templates'
    'ui-templates'
    'ngAnimate'
    'ngAria'
    'ngCookies'
    'ngMessages'
    'ngResource'
    'ngRoute'
    'ngSanitize'
    'ngTouch'
  ])
  .config ($httpProvider) ->
    # We need to setup some parameters for http requests
    # These three lines are all you need for CORS support
    $httpProvider.defaults.useXDomain = true
    $httpProvider.defaults.withCredentials = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']

  .config ($locationProvider) ->
    $locationProvider.html5Mode(true)

###*
 # Login Controller
###
app.controller 'LoginCtrl', ($scope) ->
  $scope.isForgotten = false
  $scope.isSendEmail = false
  $scope.isNewPass = false

  $scope.resetPass = ->
    $scope.isForgotten = not $scope.isForgotten
    $scope.isSendEmail = false

  $scope.sendEmail = ->
    # backend
    $scope.isSendEmail = true

  $scope.autenticate = ->
