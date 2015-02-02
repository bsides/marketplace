###*
 # @ngdoc function
 # @name marketplaceApp.controller:SearchCtrl
 # @description
 # # SearchCtrl
 # Controller principal do marketplace.
 # Retorna buscas, refaz modais de busca, usa serviços de resultados e listagens
 # Em um refactor, imagino retirar do $rootScope e colocar em serviços
 # as variáveis usadas globalmente
###

'use strict'

app.controller 'SearchCtrl', (
  $scope,
  $rootScope,
  $modal,
  $modalStack,
  $timeout,
  $q,
  $log,
  Results,
  AdvertiserService,
  Total
  ) ->

# TODO: rows with ng-repeat
# http://angularjs4u.com/filters/angularjs-template-divs-row/

  $scope.results = 'scripts/components/results/resultsView.html'
  $scope.canSearch = false

  # O que temos no carrinho hoje?
  $scope.cartTotal = Total.get()

  $scope.failedFilters = false
  $scope.failedItems = false

  # Variáveis de dados globais (dados persistentes entre páginas)

  # Pega os dados de busca mesmo se o usuário mudar de página
  if typeof $rootScope.searchData is 'undefined'
    $scope.searchData = []
  else
    $scope.searchData = $rootScope.searchData

  # Pega os parâmetros de busca mesmo se o usuário mudar de página
  if typeof $rootScope.filterData is 'undefined'
    $scope.filterData = []
  else
    $scope.filterData = $rootScope.filterData

  $scope.cartResults = []
  handleCartResults = (data, status) ->
    if status == 200
      $scope.cartResults = data
    else
      $scope.cartResults = 'Erro ao retornar os dados'

  Results.cart().success(handleCartResults)

  # Formatador de resultado
  $scope.formatResults = (data) ->
    counter = data.length unless typeof data is 'undefined'
    if counter > 1
      $scope.resultLabel = counter + ' resultados'
    else if counter == 1
      $scope.resultLabel = counter + ' resultado'
    else
      $scope.resultLabel = 'Sem resultados'


  $scope.goCart = ->
    window.location.href='/bids'

  $scope.newSearch = (size) ->
    modalInstance = $modal.open(
      templateUrl: 'scripts/components/filter/filterView.html'
      # controller: 'SearchCtrl'
      controller: 'FilterCtrl'
      size: 'lg'
      backdrop: 'static'
      resolve:
        advertisers: ->
          $scope.advertisers
        categories: ->
          $scope.categories
        weekdays: ->
          $scope.weekdays
        determinations: ->
          $scope.determinations
        regions: ->
          $scope.regions
        makeFilter: ->
          $scope.makeFilter
        superSearchString: ->
          $scope.superSearchString
        modalSelectedAdvertiser: ->
          $scope.selectedAdvertiser
    )

  $scope.makeFilter = (advertiserSelected) ->
    $scope.superSearchString = ''
    $scope.filterData = []
    $scope.isAdvertiserSelectable = true if $scope.advertisers.length > 1
    $scope.willOpenAdvertiserModal = advertiserSelected
    $scope.selectedAdvertiser = advertiserSelected

    angular.forEach $scope.categories, (value, key) ->
      if value.ticked
        $scope.superSearchString += '&category_id[]=' + value.id
        $scope.filterData.push(value)
    angular.forEach $scope.weekdays, (value, key) ->
      if value.ticked
        $scope.superSearchString += '&week_day_id[]=' + value.id
        $scope.filterData.push(value)
    angular.forEach $scope.determinations, (value, key) ->
      if value.ticked
        $scope.superSearchString += '&determination_id[]=' + value.id
        $scope.filterData.push(value)
    angular.forEach $scope.regions, (value, key) ->
      if value.ticked
        $scope.superSearchString += '&state_id[]=' + value.id
        $scope.filterData.push(value)

    $rootScope.filterData = $scope.filterData
    sendFilter($scope.superSearchString)
    return

  sendFilter = (data) ->
    Results.sendFilter(data).success((data) ->
      $rootScope.searchData = data
      $scope.searchData = data
    ).error((data) ->
      $scope.failedItems = true
      $scope.msg = "Falha ao carregar a lista de ofertas."
      $scope.msgType = "danger"
    )

  # Modal para confirmação de mudança de advertiser
  $scope.willOpenAdvertiserModal = {}
  watchAdvertiser = $scope.$watch 'selectedAdvertiser', (newValue, oldValue) ->
    if (newValue != $scope.willOpenAdvertiserModal) and (newValue != oldValue)
      # A model do advertiser selecionado
      confirmModal = $modal.open(
        templateUrl: 'scripts/shared/utils/modalConfirmView.html'
        controller: 'ModalCtrl'
        size: 'sm'
        backdrop: 'static'
        resolve:
          theId: ->
            $scope.selectedAdvertiser
          title: ->
            'Mudança de advertiser'
          message: ->
            'Ao alterar essa opção o conteúdo do seu carrinho será apagado.'
          labelOk: ->
            'Tudo bem!'
          labelCancel: ->
            'Cancelar'
      )
      confirmModal.result.then ((isConfirmed) ->
        if isConfirmed
          $scope.eraseCart()
        else
          $scope.selectedAdvertiser = oldValue
      )

  # Apaga o conteúdo do carrinho
  $scope.eraseCart = ->
    Results.empty().success((data) ->
      Total.reset()
      $scope.cartTotal = Total.get()
      $scope.searchData = []
      $rootScope.searchData = []
      $scope.isAddingToCart = {}
      $scope.isAddedToCart = {}
      $rootScope.isAddedToCart = {}
    )

  # Fix para selectbox de advertiser
  $scope.checkAdvertiser = ->
    $scope.willOpenAdvertiserModal = $scope.selectedAdvertiser

  # Listagem de dados do servidor ou local
  # É local depois da primeira lida.
  # Considerei que dificilmente o usuário precisará da listagem mais de uma vez por acesso
  if typeof $rootScope.listingAllData is 'undefined'
    determination = Results.list('/determination')
    advertiser = AdvertiserService.all()
    weekday = Results.list('/weekday')
    category = Results.list('/category')
    region = Results.list('/region')
    promise = $q.all([
      advertiser
      category
      weekday
      determination
      region
    ])
    .then ((data) ->
      $rootScope.listingAllData = data
      $scope.advertisers = data[0].data
      $scope.categories = data[1].data
      $scope.weekdays = data[2].data
      $scope.determinations = data[3].data
      $scope.regions = data[4].data
      # You can search now
      $scope.canSearch = true
      $scope.failedFilters = false

      $scope.isAdvertiserSelectable = true if $scope.advertisers.length > 1
    ), (data) ->
      $scope.failedFilters = true
      $scope.msg = "Falha ao carregar os filtros para a busca de ofertas."
      $scope.msgType = "danger"

  else
    $scope.advertisers = $rootScope.listingAllData[0].data
    $scope.categories = $rootScope.listingAllData[1].data
    $scope.weekdays = $rootScope.listingAllData[2].data
    $scope.determinations = $rootScope.listingAllData[3].data
    $scope.regions = $rootScope.listingAllData[4].data
    $scope.canSearch = true
    $scope.failedFilters = false
    $scope.isAdvertiserSelectable = true if $scope.advertisers.length > 1

  # Ordenação de resultado

  # Modo de Visualização
  # aceita "view-regular" ou "view-compact"
  $scope.viewMode = 'view-regular'

  # Ordenação começa de forma ascendente
  $scope.isOrderAsc = true
  $scope.toggleOrder = ->
    $scope.isOrderAsc = not $scope.isOrderAsc

  # Abre o modal em first load
  $scope.$watch '[searchData,canSearch]', ((newValue, oldValue) ->
    # Se o usuário puder procurar e não tiver procurado ainda
    if (newValue[0].length < 1) and (newValue[1])
      # Abre o modal caso não esteja aberto
      if typeof $modalStack.getTop() is 'undefined'
        $scope.newSearch()
        return
  ), true

  # Ações do carrinho

  # Utilitários
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
      # if isConfirmed
      #   $log.info 'fechou'
    )

  # Verifica se já foi adicionado
  if typeof $rootScope.isAddedToCart is 'undefined'
    $scope.isAddedToCart = {}
    $rootScope.isAddedToCart = {}
  else
    $scope.isAddedToCart = $rootScope.isAddedToCart

  $scope.isAddingToCart = {}

  # Adicionar
  # TODO: Refatorar
  $scope.addToCart = (item, index) ->
    # Ações ao adicionar:
    # 1 - Loading no botão, para preparar para a chamada ajax
    # 2 - envia dados para o carrinho
    # 3 - no sucesso, desabilita o botão de adicionar, adiciona ícone de "adicionado" e desliga loading
    # 4 - acrescenta quantidade e atualiza valor ao carrinho

    # 1 - Loading no botão, para preparar para a chamada ajax
    $scope.isAddingToCart[index] = true

    # 2 - envia dados para o carrinho
    Results.add(item.hash).success((data) ->
      # 3 - no sucesso, desabilita o botão de adicionar, adiciona ícone de "adicionado" e desliga loading
      $rootScope.isAddedToCart[index] = true
      $scope.isAddedToCart[index] = true
      $scope.isAddingToCart[index] = false
      # 4 - acrescenta quantidade e atualiza valor ao carrinho
      $scope.cartTotal = Total.add(parseFloat(item.bid.value))
    ).error((data) ->
      # TODO: tratar erro
    )

  # Remover
  $scope.removeFromCart = (bidId) ->
    Results.delete(bidId)
      .success((data) ->
      )
      .error((data) ->
        # TODO: tratar erro
      )

  # $scope.cart =
  #   add: (id) ->
  #     found = $filter('filter')($scope.searchData, {id: id}, true)
  #     if found.length
  #       console.log JSON.stringify(found[0])



  # Lógica para Advertiser

