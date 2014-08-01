bakken.service 'SvgUtils', [() ->

  namespace = 'http://www.w3.org/2000/svg'

  createElement = (tag) ->
    document.createElementNS namespace, tag

  setAttrs = (attrs) ->
    this.setAttributeNS null, attr, value for attr, value in attrs

  SvgUtils =

    create: (tag) ->
      createElement tag

    attr: (element, attrs) ->
      setAttrs.call element, attrs

]
