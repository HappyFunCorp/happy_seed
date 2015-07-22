@app.controller '<%= class_name %>Ctrl' = ["$scope", "$http", "$location", ($scope, $http, $location) ->
  $scope.loaded = true

  $scope.message = "Hello from angular!"
]