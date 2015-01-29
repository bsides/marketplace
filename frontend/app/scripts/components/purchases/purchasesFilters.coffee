'use strict'

app.filter 'filterNewspaper', ->
  (items, newspaperId) ->
    return items if (typeof newspaperId is 'undefined') or (newspaperId is '')
    filtered = []
    angular.forEach items, (item, key) ->
      filtered.push item if parseInt(item.id) is parseInt(newspaperId)
      return

    filtered

app.filter 'filterYear', ($filter) ->
  (items, year) ->
    return items if (typeof year is 'undefined') or (year is '')
    $filter('filter')(items, year)

app.filter 'filterAdvertiser', ->
  (items, advertiserId) ->
    return items if(typeof advertiserId is 'undefined') or (advertiserId is '')
    filtered = []
    angular.forEach items, (item, key) ->
      filtered.push item if parseInt(item.advertiserId) is parseInt(advertiserId)
      return

    filtered
