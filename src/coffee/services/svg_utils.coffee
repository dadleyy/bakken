bakken.service 'SvgUtils', [() ->

  namespace = 'http://www.w3.org/2000/svg'

  createElement = (tag) ->
    document.createElementNS namespace, tag

  setAttrs = (attrs) ->
    for name in attrs do this.setAttributeNS(null, name, attrs[name])

  SvgUtils =

    create: (tag) ->
      createElement tag

    attr: (element, attrs) ->
      setAttrs.call element, attrs

]
