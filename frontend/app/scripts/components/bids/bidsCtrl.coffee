'use strict'

app.controller 'BidsCtrl', ($scope, $rootScope, $log, $filter, $modal, localStorageService, Results, Total) ->

  # Try to get results
  $scope.getCartData = []

  # Coloca o total do carrinho numa variável global
  $scope.cartTotal = Total.get()

  # Carrega os resultados ou retorna erro caso não der
  handleAllResults = (data, status) ->
    if status == 200 and Object.keys(data).length > 0

      # Precisamos que data.ads seja um array desde já, mesmo se vazio
      angular.forEach data, (value, keys) ->
        angular.forEach value.items, (newValue, newKeys) ->
          if newValue.ads is null
            newValue.ads = [
              comment: ''
              date: '' #$filter('date') new Date(), 'dd-MM-yyyy'
              price: parseFloat(newValue.features.bid.value).toFixed(2)
            ]
            newValue.quantity = 1
          else
            newValue.quantity = newValue.ads.length

      localStorageService.set('localCartData', data)
      localValue = localStorageService.get('localCartData')
      if angular.equals(data, localValue)
        $scope.getCartData = localValue
      else
        localStorageService.remove('localCartData')
        localValue = {}
        $scope.getCartData = data

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
  $scope.newComment = (bid, index) ->
    $scope.commentType = ->
      if typeof index is 'undefined' then true else false

    commentModal = $modal.open(
      templateUrl: 'scripts/shared/utils/modalCommentView.html'
      controller: 'ModalCommentCtrl'
      size: 'sm'
      backdrop: 'true'
      windowClass: 'modal-comment'
      resolve:
        bid: ->
          if $scope.commentType() then bid else bid.ads[index]
        id: ->
          if $scope.commentType() then bid.id else index
        title: ->
          'Observações'
        comment: ->
          if $scope.commentType() then bid.comment else bid.ads[index].comment
        labelOk: ->
          'Salvar'
        labelCancel: ->
          'Apagar'
    )
    commentModal.result.then ((result) ->
      if result is false
        # não faremos nada aqui
        bid.comment = '' if $scope.commentType()
        bid.ads[index].comment = '' unless $scope.commentType()
      else
        bid.comment = result if $scope.commentType()
        bid.ads[index].comment = result unless $scope.commentType()
    )

  # Date utilities
  $scope.disabledDates = (date, mode, weekdayId) ->
    if (mode is 'day' and (date.getDay() is 0 and weekdayId is 7))
      false
    else
      mode is 'day' and (date.getDay() isnt weekdayId)

  $scope.toggleMinDate = ->
    $scope.minDate = (if $scope.minDate then null else new Date())
  $scope.toggleMinDate()

  $scope.maxDate = '31-12-2016'

  $scope.dateOpened = {}
  $scope.openDate = ($event, index) ->
    $event.preventDefault()
    $event.stopPropagation()
    $scope.dateOpened[index] = true

  $scope.dateOptions =
    format: 'dd-MM-yyyy'
    showWeeks: false
    onClose: (e) ->
    datepickerPopupConfig:
      showButtonBar: false

  $scope.dateFormats = ['dd-MM-yyyy', 'dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate']
  $scope.dateFormat = $scope.dateFormats[0]

  # Transform into array for ng-repeat
  $scope.range = (n) ->
    Array.apply(null, {length: n}).map(Number.call, Number)

  $scope.errorClose = ->
    delete $scope.getCartData

  $scope.cartTotalFn = ->
    total = 0
    angular.forEach $scope.getCartData, (v, k) ->
      angular.forEach v.items, (va, ke) ->
        total = total + va.quantity * va.features.bid.value

    $scope.cartTotal = Total.update(total)

  # Ads
  $scope.addQty = (obj) ->
    if obj.quantity < 10
      obj.ads.push(
        comment: ''
        date: '' #$filter('date') new Date(), 'dd-MM-yyyy'
        price: parseFloat(obj.features.bid.value).toFixed(2)
      )
      obj.quantity = obj.quantity + 1
    Results.updateCart($scope.getCartData)
      .success((data) ->
        # No sucesso, continua
      )
      .error((data) ->
      )

  $scope.delQty = (obj, index) ->
    if obj.quantity > 1
      if typeof index is 'undefined'
        obj.ads.pop()
      else
        obj.ads.splice(index, 1)

      obj.quantity = obj.quantity - 1
    Results.updateCart($scope.getCartData).success(->)

  $scope.sendCart = ->
    # Primeiro alteramos o carrinho com novos ads
    Results.updateCart($scope.getCartData).success((data) ->
      # E no seu sucesso enviamos a proposta. Esse é somente um GET.
      Results.sendBid($scope.getCartData)
        .success((data) ->
          $scope.getCartData =
            status: 200
            message: 'Sua proposta foi enviada. Obrigado!'
            sent: true
            type: 'success'
        )
        .error((data) ->
          $scope.getCartData =
            status: 500
            message: 'Erro ao enviar a proposta. Por favor, tente novamente.'
            error: true
            type: 'danger'
        )
    )

  # Modal para confirmação de remoção do carrinho todo
  $scope.removeBid = (obj) ->
    # A model do advertiser selecionado
    confirmModal = $modal.open(
      templateUrl: 'scripts/shared/utils/modalConfirmView.html'
      controller: 'ModalCtrl'
      size: 'sm'
      backdrop: 'static'
      resolve:
        theId: ->
          obj
        title: ->
          'Confirmação'
        message: ->
          'O conteúdo do seu carrinho referente ao jornal será apagado!'
        labelOk: ->
          'Tudo bem!'
        labelCancel: ->
          'Cancelar'
    )
    confirmModal.result.then ((isConfirmed) ->
      if isConfirmed
        $scope.removeThisBid(obj)
    )

  # Remove this bid
  $scope.removeThisBid = (object) ->
    angular.forEach object.items, (value, key) ->
      Results.delete(value.hash).success((data) ->
        Results.cart().success(handleAllResults)
      )

  $rootScope.removeBid = $scope.removeBid

  # Apaga o conteúdo do carrinho
  $scope.eraseCart = ->
    Results.empty().success((data) ->
      $scope.cartTotal = Total.reset()
      $rootScope.isAddedToCart = {}
      $rootScope.searchData = []
    )

  do getAddedToCart = ($rootScope) ->
    $rootScope.$on 'rootScope:emit', (event, data) ->
      $rootScope.isAddedToCart = data

  # Regions
  $scope.checkRegions = (data) ->
    if data.state.length < 1
      regionMessage = 'Não existem regiões configuradas para esse item'
    else
      regionMessage = ''

    regionModal = $modal.open(
      templateUrl: 'scripts/shared/utils/modalRegionView.html'
      controller: 'ModalRegionCtrl'
      size: 'sm'
      backdrop: 'static'
      resolve:
        title: ->
          'Regiões'
        message: ->
          regionMessage
        regions: ->
          data.state
        labelOk: ->
          'Ok'
        labelCancel: ->
          'Cancelar'
    )
    regionModal.result.then ((isConfirmed) ->
      if isConfirmed
        $log.info 'fechou'
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
