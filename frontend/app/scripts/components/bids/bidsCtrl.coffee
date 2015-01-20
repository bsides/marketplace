'use strict'

app.controller 'BidsCtrl', ($scope, $rootScope, $log, $filter, localStorageService, Results) ->

  # Try to get results
  $scope.getCartData = []

  # Coloca o total do carrinho numa variável global
  if typeof $rootScope.cartTotal != 'undefined'
    $scope.cartTotal = $rootScope.cartTotal
  else
    $rootScope.cartTotal = 0
    $scope.cartTotal = $rootScope.cartTotal

  # Carrega os resultados ou retorna erro caso não der
  handleAllResults = (data, status) ->
    if status == 200 and Object.keys(data).length > 0
      # angular.forEach data, (value, key) ->
      #   value.itemsfront = []
      #   angular.forEach value.items, (val, k) ->
      #     value.itemsfront.push(val)

      #   value.publisher = value.features.publisher.id
      localStorageService.set('localCartData', data)
      localValue = localStorageService.get('localCartData')
      if angular.equals(data, localValue)
        $scope.getCartData = localValue
      else
        localStorageService.remove('localCartData')
        localValue = {}
        $scope.getCartData = data

      # Precisamos que data.ads seja um array desde já, mesmo se vazio
      angular.forEach $scope.getCartData, (value, keys) ->
        angular.forEach value.items, (newValue, newKeys) ->
          if newValue.ads is null
            newValue.ads = [
              comment: ''
              date: $filter('date') new Date(), 'dd-MM-yyyy'
              price: parseFloat(newValue.features.bid.value).toFixed(2)
            ]
            newValue.quantity = 1

    else if Object.keys(data).length == 0
      $scope.getCartData =
        status: 500
        message: 'Não existem itens no carrinho, por favor, busque ofertas primeiro.'
        error: true
        type: 'warning'
    else
      $scope.getCartData =
        status: 500
        message: 'Erro ao retornar os dados. Por favor, tente novamente mais tarde.'
        error: true
        type: 'danger'


  # Link para search
  $scope.goSearch = ->
    window.location.href = "/search"

  # Deal with them
  Results.cart().success(handleAllResults)

  # Comments
  $scope.isCommenting = {}
  $scope.toggleComment = (hash, isConfirmed, id) ->
    # Caso seja comentário global do item, não passamos id
    id = '' if typeof id is 'undefined'

    # Se for para salvar
    if isConfirmed
      $scope.isCommenting[hash + id] = not $scope.isCommenting[hash + id]
    else
      hash.comment = '' if typeof hash.comment isnt 'undefined'
      $scope.isCommenting[hash + id] = not $scope.isCommenting[hash + id]

  $scope.saveComment = (hash) ->

  # Date utilities
  $scope.clearDate = ->
    $scope.theDate = null

  $scope.disabledDates = (date, mode, weekdayId) ->
    mode is "day" and (date.getDay() isnt weekdayId)

  $scope.toggleMinDate = ->
    $scope.minDate = (if $scope.minDate then null else new Date())
  $scope.toggleMinDate()

  $scope.dateOpened = {}
  $scope.openDate = ($event, index) ->
    $event.preventDefault()
    $event.stopPropagation()
    $scope.dateOpened[index] = true

  $scope.dateOptions =
    format: 'dd-MM-yyyy'
    onClose: (e) ->

  $scope.dateFormats = ['dd-MM-yyyy', 'dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
  $scope.dateFormat = $scope.dateFormats[0]

  # Transform into array for ng-repeat
  $scope.range = (n) ->
    Array.apply(null, {length: n}).map(Number.call, Number)

  # Remove this bid
  $scope.removeBid = (object) ->
    angular.forEach object.items, (value, key) ->
      Results.delete(value.hash).success((data) ->
        Results.cart().success(handleAllResults)
      )

  $rootScope.removeBid = $scope.removeBid

  $scope.errorClose = ->
    delete $scope.getCartData

  $scope.cartTotalFn = ->
    total = 0
    angular.forEach $scope.getCartData, (v, k) ->
      angular.forEach v.items, (va, ke) ->
        total = total + va.quantity * va.features.bid.value

    $scope.cartTotal = total
    $rootScope.cartTotal = total
    total

  # Ads
  $scope.addQty = (obj) ->
    if obj.quantity < 10
      obj.ads.push(
        comment: ''
        date: $filter('date') new Date(), 'dd-MM-yyyy'
        price: parseFloat(obj.features.bid.value).toFixed(2)
      )
      obj.quantity = obj.quantity + 1

  $scope.delQty = (obj, index) ->
    if obj.quantity > 1
      if typeof index is 'undefined'
        obj.ads.pop()
      else
        obj.ads.splice(index, 1)

      obj.quantity = obj.quantity - 1

  $scope.sendCart = ->
    # Primeiro alteramos o carrinho com novos ads
    Results.updateCart($scope.getCartData).success((data) ->
      $log.info 'Alterou carrinho com sucesso. Agora vamos enviar a proposta.'
      # E no seu sucesso enviamos a proposta. Esse é somente um GET.
      Results.sendBid($scope.getCartData).success((data) ->
        $log.info 'Enviou a proposta com sucesso.'
      )
    )

  # Data coming from server
  # $scope.bidData = [
  #   {
  #     id: 231
  #     name: 'Folha de SP'
  #     comment: ''
  #     items: [
  #       id: 7
  #       category: 'Destaques'
  #       determination: 'Capa'
  #       format: 'Página Inteira'
  #       color: 'Cromia'
  #       price: 12012.00
  #       weekdays: ['Seg', 'Ter', 'Dom']
  #       quantity: 1
  #       comment: ''
  #     ]
  #   }
  #   {
  #     id: 32
  #     name: 'O Globo'
  #     comment: ''
  #     items: [
  #       {
  #         id: 438
  #         category: 'Esportes'
  #         determination: 'Padrão'
  #         format: 'Meia página'
  #         color: 'Cromia'
  #         price: 11030.50
  #         weekdays: ['Qua']
  #         quantity: 1
  #         comment: ''
  #       }
  #       {
  #         id: 43
  #         category: 'Finanças'
  #         determination: 'Padrão'
  #         format: 'Rodapé'
  #         color: 'Cromia'
  #         price: 1000.00
  #         weekdays: ['Sáb']
  #         quantity: 1
  #         comment: ''
  #       }
  #       {
  #         id: 4
  #         category: 'Cultura'
  #         determination: 'Capa'
  #         format: 'Meia página'
  #         color: 'PB'
  #         price: 56000.53
  #         weekdays: ['Sáb', 'Dom']
  #         quantity: 1
  #         comment: ''
  #       }
  #     ]
  #   }
  #   {
  #     id: 3213
  #     name: 'Estadão'
  #     comment: ''
  #     items: [
  #       {
  #         id: 9
  #         category: 'Esportes'
  #         determination: 'Padrão'
  #         format: 'Metade vertical'
  #         color: 'PB'
  #         price: 11030.50
  #         weekdays: ['Qua']
  #         quantity: 1
  #         comment: ''
  #       }
  #       {
  #         id: 10
  #         category: 'Política'
  #         determination: 'Padrão'
  #         format: 'Página inteira'
  #         color: 'Cromia'
  #         price: 45000.50
  #         weekdays: ['Seg', 'Ter', 'Qua', 'Qui', 'Sex']
  #         quantity: 1
  #         comment: ''
  #       }
  #     ]
  #   }
  # ]
