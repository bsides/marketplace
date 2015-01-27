'use strict'

app.factory 'Total', () ->

  # Inicialização
  total: 0

  # Métodos
  get: ->
    @total
  reset: ->
    @total = 0
  add: (number) ->
    @total = @total + number
  remove: (number) ->
    @total = @total - number
  update: (number) ->
    @total = number

# Não implementado
app.factory 'Cart', ->

  isAdding: {}
  isAdded: {}

  add: (item, index) ->
    # Ações ao adicionar:
    # 1 - Loading no botão, para preparar para a chamada ajax
    # 2 - envia dados para o carrinho
    # 3 - no sucesso, desabilita o botão de adicionar, adiciona ícone de "adicionado" e desliga loading
    # 4 - acrescenta quantidade e atualiza valor ao carrinho

    # 1 - Loading no botão, para preparar para a chamada ajax
    @isAdding[index] = true

    # 2 - envia dados para o carrinho
    Results.add(item.hash).success((data) ->
      # 3 - no sucesso, desabilita o botão de adicionar, adiciona ícone de "adicionado" e desliga loading
      @isAdded[index] = true
      @isAdding[index] = false
      # 4 - acrescenta quantidade e atualiza valor ao carrinho
      # $rootScope.cartTotal = parseFloat($rootScope.cartTotal) + parseFloat(item.bid.value)
      Total.add(parseFloat(item.bid.value))
    ).error((data) ->

    )


  get: ->

  reset: ->

  remove: ->

  edit: (item) ->

  update: (item) ->
    edit(item)

  # Métodos utilitários



app.factory 'DateUtils', ->

  minimum: null
  maximum: '2016-12-31'
  formats = ['dd-MM-yyyy', 'dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
  format = @formats[0]
  opened: {}
  options:
    format: 'dd-MM-yyyy'
    showWeeks: false
    onClose: (e) ->
    datepickerPopupConfig:
      showButtonBar: false

  filterByWeekday: (date, mode, weekdayId) ->
    if (mode is 'day' and (date.getDay() is 0 and weekdayId is 7))
      false
    else
      mode is 'day' and (date.getDay() isnt weekdayId)

  toggleMinDate: ->
    @minDate = (if @minDate then null else new Date())

  openDate: ($event, index) ->
    $event.preventDefault()
    $event.stopPropagation()
    @opened[index] = true

