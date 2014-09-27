bakken.directive 'rbDynamicContent', ['$compile', ($compile) ->

  rbDynamicContent =
    replace: true
    templateUrl: 'directives.dynamic_content'
    scope:
      content: '='
    link: ($scope, $element, $attrs) ->
      html = $compile($scope.content)($scope)
      $element.append(html)

]
