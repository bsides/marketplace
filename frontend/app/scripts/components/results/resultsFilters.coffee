'use strict'

# Inputs a number and outputs an array with that length.
# (3 | array) => [0,1,2]
app.filter 'returnArray', ->
  (arrayLength) ->
    arrayLength = Math.ceil(arrayLength)
    arr = new Array(arrayLength)
    i = 0
    while i < arrayLength
      arr[i] = i
      i++

    arr

app.filter "filterPriceBetween", ->
  (items, min, max) ->
    return items if (min is 'all') or (typeof min is 'undefined')
    filtered = []
    type = ''
    if min
      if min.indexOf(',') > -1
        max = min.split(',')[1]
        min = min.split(',')[0]
      if min.indexOf('-') > -1
        min = min.split('-')[0]
        type = 'until'
      if min.indexOf('+') > -1
        min = min.split('+')[0]
        type = 'over'
    else
      min = parseFloat(min)
      max = parseFloat(max)

    if (typeof max isnt 'undefined') or (max is 0)
      angular.forEach items, (item, key) ->
        filtered.push item  if item.bid.value <= max and item.bid.value >= min
        return
    else
      if type == 'until'
        angular.forEach items, (item, key) ->
          filtered.push item  if item.bid.value <= min
          return
      if type == 'over'
        angular.forEach items, (item, key) ->
          filtered.push item  if item.bid.value >= min
          return

    filtered

app.filter 'filterWeek', ->
  (items, weekDayId) ->
    return items if (typeof weekDayId is 'undefined') or (weekDayId is '')
    filtered = []
    angular.forEach items, (item, key) ->
      filtered.push item if parseInt(item.week_day.id) is parseInt(weekDayId)
      return

    filtered

app.filter 'filterColor', ->
  (items, colorId) ->
    return items if (typeof colorId is 'undefined') or (colorId is '')
    filtered = []
    angular.forEach items, (item, key) ->
      filtered.push item if parseInt(item.color.id) is parseInt(colorId)
      return

    filtered
