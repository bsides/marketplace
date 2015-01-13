'use strict'

app.controller 'PurchasesCtrl', ($scope) ->

  $scope.advertisers =  [
    {
      name: 'Cdv'
      id: 1
    }
    {
      name: 'Vdv'
      id: 2
    }
    {
      name: 'Adv'
      id: 3
    }
  ]

  $scope.newspapers =  [
    {
      name: 'O Globo'
      id: 1
    }
    {
      name: 'Estadão'
      id: 2
    }
    {
      name: 'Estado de São Paulo'
      id: 3
    }
    {
      name: 'Folha de São Paulo'
      id: 4
    }
  ]

  $scope.totalMonthly = 84024.00

  $scope.infoDate = '31/12/2014'

  $scope.purchaseData = [
    {
      id: 231
      name: 'Proposta 1'
      date: '14/12/2014'
      advertiser: 'Adv'
      price: 32012.00
      newspapers : [
        {
          id: 9
          name : 'O Globo'
          items: [
            {
              category: 'Destaques'
              determination: 'Capa'
              format: 'Página Inteira'
              date: '25/11/2014'
              price: 20000.00
              weekdays: ['Quarta']
            }
            {
              category: 'Destaques'
              determination: 'Capa'
              format: 'Página Inteira'
              date: '28/11/2014'
              price: 12012.00
              weekdays: ['Domingo']
            }
          ]
        }
      ]
    }
    {
      id: 153
      name: 'Proposta 2'
      date: '14/12/2014'
      advertiser: 'Adv'
      price: 52012.00
      newspapers : [
        {
          id: 9
          name : 'O Globo'
          items: [
            {
              category: 'Destaques'
              determination: 'Capa'
              format: 'Página Inteira'
              date: '25/11/2014'
              price: 20000.00
              weekdays: ['Quarta']
            }
            {
              category: 'Destaques'
              determination: 'Capa'
              format: 'Página Inteira'
              date: '28/11/2014'
              price: 12012.00
              weekdays: ['Domingo']
            }
          ]
        }
        {
          id: 7
          name : 'Estado de São Paulo'
          items: [
            {
              category: 'Destaques'
              determination: 'Capa'
              format: 'Página Inteira'
              date: '25/11/2014'
              price: 20000.00
              weekdays: ['Quarta']
            }
          ]
        }
      ]
    }
  ]
