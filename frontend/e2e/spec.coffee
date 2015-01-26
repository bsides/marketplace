'use strict'

# AngularPage = require 'pages/angular.page.js'
# describe 'angular homepage', ->

#   beforeEach ->
#     page = new AngularPage()

describe 'Básicos para o site:', ->
  it 'deveria ter um título', ->
    browser.get 'http://marketplace.localhost'
    expect(browser.getTitle()).toEqual 'Marketplace'

  it 'deveria ter uma base URL', ->
    base = element(By.tagName('base'))
    expect(base.getAttribute('href')).toBe '/'

describe 'Autenticação do usuário:', ->
  params = browser.params

  it 'deveria logar com sucesso', ->
    element(By.id('username')).sendKeys params.login.user
    element(By.id('password')).sendKeys params.login.pass
    element(By.id('mainLoginButton')).click()
    expect(browser.getLocationAbsUrl()).toMatch('/search')
    return

describe 'Página de busca de ofertas:', ->
  browser.get 'http://marketplace.localhost/search'
  beforeEach ->
    @searchModal = element(By.css('.modal.fade.in'))
    @searchButton = element(By.css('.modal [ng-click="ok()"]'))

  it 'deveria abrir a procura assim que os dados carregarem', ->
    expect(@searchModal.isPresent()).toBe true
  it 'deveria estar apto a procurar sem nada selecionado', ->
    @searchButton.click()
    expect(@searchModal.isPresent()).toBe false


describe 'Página de carrinho de ofertas:', ->
