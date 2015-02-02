'use strict'

app.factory 'Results', ($http) ->
  url =
    get: '/direct/item'
    add: '/cart/add/'
    remove: '/cart/delete/'
    cart: '/cart'
    search: '/direct/item'
    list: '/direct/list'
    empty: '/cart/empty'
    sendBid: '/direct/deal/send'
    updateCart: '/cart/update'

  cartTotal: (price) ->
    price = price + price

  get: ->
    $http.get(url.get)

  add: (bid) ->
    $http.get(url.add + bid)

  delete: (bidId) ->
    $http.get(url.remove + bidId)

  empty: ->
    $http.get(url.empty)

  cart: ->
    $http.get(url.cart)

  sendFilter: (theFilter) ->
    $http.get(url.search + '?' + theFilter)

  list: (theFilter) ->
    $http.get(url.list + theFilter)

  sendBid: (array) ->
    $http.post(url.sendBid)

  updateCart: (array) ->
    $http(
      method: 'POST'
      url: url.updateCart
      data: array
    )


app.factory 'AdvertiserService', ($http) ->
  url =
    get: '/direct/advertiser/get'
    all: '/direct/advertiser/list'
    set: '/direct/advertiser/set/'

  get: ->
    $http.get(url.get)

  all: ->
    $http.get(url.all)

  set: (id) ->
    $http.get(url.set + id)


