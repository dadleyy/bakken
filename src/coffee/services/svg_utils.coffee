bakken.service 'SvgUtils', [() ->

  namespace = 'http://www.w3.org/2000/svg'

  createElement = (tag) ->
    document.createElementNS namespace, tag

  class SvgElement

    constructor: (@tag) ->
      @element = createElement @tag

    append: (child) ->
      @element.appendChild child


    setAttrs: (attrs) ->
      if angular.isObject
        @element.setAttributeNS null, attr, val for attr, val of attrs

  SvgUtils =

    create: (tag) ->
      new SvgElement tag

]
