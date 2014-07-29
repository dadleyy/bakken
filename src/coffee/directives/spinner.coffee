bakken.directive 'rbSpinner', ['Loop', (Loop) ->

  rbSpinner =
    replace: true
    restrict: 'EA'
    templateUrl: 'directives.spinner'
    scope:
      hidden: '='
    link: ($scope, $element, $attrs) ->
      svg = d3.select($element[0]).append('svg')
      playing = false
      loop_id = null
      grp = svg.append("g")
      path = svg.append("path")
      vert_count = 5
      orb_height = if $attrs['height'] then parseFloat($attrs['height']) else 100
      orb_width = if $attrs['width'] then parseFloat($attrs['width']) else 100
      o_radius = 60
      inner_radius = 40
      rotation = 0
      rotation_velocity = Math.PI / 5
      rad_indx = 0
      rad_velocity = rotation_velocity * 10

      toggle = () ->
        if $scope.hidden
          stop()
        else
          start()

      radiusMod = (dt) ->
        plus = Math.sin(rad_indx)
        rad_indx += rad_velocity * (dt or 0.02)
        rad_indx = 0  if rad_indx > Math.PI * 2
        plus * 10

      getColor = (time) ->
        parseInt Math.sin(time) * 25 + 180, 10

      colorFlux = (dt) ->
        time = new Date().getTime() * 0.001
        red = (if $scope.failed then 200 else getColor(time))
        green = (if $scope.failed then 80 else getColor(time + 2))
        blue = (if $scope.failed then 80 else getColor(time + 4))
        rgba = [red, green, blue, 1.0].join ','
        rgba_str = ['rgba(', rgba, ')'].join ''

      update = (dt) ->
        inc = (Math.PI * 2) / vert_count
        center = orb_width * 0.5
        outer_radius = o_radius + radiusMod(dt)
        p = ""
        outer_radius = o_radius  if outer_radius < o_radius
        i = 0

        while i < vert_count
          c_rads = (i * inc) + rotation
          c_xpos = (Math.cos(c_rads) * outer_radius) + center
          c_ypos = (Math.sin(c_rads) * outer_radius) + center
          c_coords = [
            Math.ceil(c_xpos)
            Math.ceil(c_ypos)
          ].join(" ")
          
          # the point position
          p_rads = ((i + 0.5) * inc) + rotation
          p_xpos = (Math.cos(p_rads) * inner_radius) + center
          p_ypos = (Math.sin(p_rads) * inner_radius) + center
          p_coords = [
            Math.ceil(p_xpos)
            Math.ceil(p_ypos)
          ].join(" ")

          if i is vert_count - 1
            p = ["M", p_coords, p].join ' '

          c = ["Q", c_coords, p_coords].join ' '
          p = [p, c].join ' '
          i++

        p += "Z"
        rotation += rotation_velocity * (dt or 0.01)
        rotation = 0  if rotation > Math.PI * 2
        path.attr d: p
        path.attr fill: colorFlux(dt)

      start = () ->
        if !playing
          playing = true
          loop_id = Loop.add update

      stop = () ->
        Loop.remove loop_id
        console.log('wtf')
        $element.css
          display: "none"

      $scope.$watch 'hidden', toggle
      start()
]
