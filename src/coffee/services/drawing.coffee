bakken.service 'Drawing', [() ->

  mul_table = [ 1,57,41,21,203,34,97,73,227,91,149,62,105,45,39,137,241,107,3,173,39,71,65,238,219,101,187,87,81,151,141,133,249,117,221,209,197,187,177,169,5,153,73,139,133,127,243,233,223,107,103,99,191,23,177,171,165,159,77,149,9,139,135,131,253,245,119,231,224,109,211,103,25,195,189,23,45,175,171,83,81,79,155,151,147,9,141,137,67,131,129,251,123,30,235,115,113,221,217,53,13,51,50,49,193,189,185,91,179,175,43,169,83,163,5,79,155,19,75,147,145,143,35,69,17,67,33,65,255,251,247,243,239,59,29,229,113,111,219,27,213,105,207,51,201,199,49,193,191,47,93,183,181,179,11,87,43,85,167,165,163,161,159,157,155,77,19,75,37,73,145,143,141,35,138,137,135,67,33,131,129,255,63,250,247,61,121,239,237,117,29,229,227,225,111,55,109,216,213,211,209,207,205,203,201,199,197,195,193,48,190,47,93,185,183,181,179,178,176,175,173,171,85,21,167,165,41,163,161,5,79,157,78,154,153,19,75,149,74,147,73,144,143,71,141,140,139,137,17,135,134,133,66,131,65,129,1]
        
   
  shg_table = [0,9,10,10,14,12,14,14,16,15,16,15,16,15,15,17,18,17,12,18,16,17,17,19,19,18,19,18,18,19,19,19,20,19,20,20,20,20,20,20,15,20,19,20,20,20,21,21,21,20,20,20,21,18,21,21,21,21,20,21,17,21,21,21,22,22,21,22,22,21,22,21,19,22,22,19,20,22,22,21,21,21,22,22,22,18,22,22,21,22,22,23,22,20,23,22,22,23,23,21,19,21,21,21,23,23,23,22,23,23,21,23,22,23,18,22,23,20,22,23,23,23,21,22,20,22,21,22,24,24,24,24,24,22,21,24,23,23,24,21,24,23,24,22,24,24,22,24,24,22,23,24,24,24,20,23,22,23,24,24,24,24,24,24,24,23,21,23,22,23,24,24,24,22,24,24,24,23,22,24,24,25,23,25,25,23,24,25,25,24,22,25,25,25,24,23,24,25,25,25,25,25,25,25,25,25,25,25,25,23,25,23,24,25,25,25,25,25,25,25,25,25,24,22,25,25,23,25,25,20,24,25,24,25,25,22,24,25,24,25,24,25,25,24,25,25,25,25,22,25,25,25,24,25,24,25,18]

  grayscale = (r, g, b) ->
    parseInt (0.2125 * r) + (0.7154 * g) + (0.0721 * b), 10

  Drawing =
    desaturate: (canvas, width, height) ->
      context = canvas.getContext '2d'
      image_data = context.getImageData 0, 0, width, height
      pixel_data = image_data.data
      indx = 0
      while indx < pixel_data.length
        grey_scale = pixel_data[indx] * 0.3 + pixel_data[indx + 1] * 0.59 + pixel_data[indx + 2] * 0.11
        pixel_data[indx] = grey_scale * 0.75
        pixel_data[indx + 1] = grey_scale * 0.75
        pixel_data[indx + 2] = grey_scale * 0.75
        indx += 4

      context.putImageData image_data, 0, 0
	
    blur: (canvas, top_x, top_y, width, height, radius, iterations) ->
      radius |= 0
      iterations = 1  if isNaN(iterations)
      iterations |= 0
      iterations = 3  if iterations > 3
      iterations = 1  if iterations < 1
      context = canvas.getContext("2d")
      imageData = context.getImageData(top_x, top_y, width, height)
      pixels = imageData.data
      rsum = undefined
      gsum = undefined
      bsum = undefined
      asum = undefined
      x = undefined
      y = undefined
      i = undefined
      p = undefined
      p1 = undefined
      p2 = undefined
      yp = undefined
      yi = undefined
      yw = undefined
      idx = undefined
      wm = width - 1
      hm = height - 1
      wh = width * height
      rad1 = radius + 1
      r = []
      g = []
      b = []
      mul_sum = mul_table[radius]
      shg_sum = shg_table[radius]
      vmin = []
      vmax = []

      while iterations-- > 0
        yw = yi = 0
        y = 0
        while y < height
          rsum = pixels[yw] * rad1
          gsum = pixels[yw + 1] * rad1
          bsum = pixels[yw + 2] * rad1
          i = 1
          while i <= radius
            p = yw + (((if i > wm then wm else i)) << 2)
            rsum += pixels[p++]
            gsum += pixels[p++]
            bsum += pixels[p++]
            i++
          x = 0
          while x < width
            r[yi] = rsum
            g[yi] = gsum
            b[yi] = bsum
            if y is 0
              vmin[x] = ((if (p = x + rad1) < wm then p else wm)) << 2
              vmax[x] = ((if (p = x - radius) > 0 then p << 2 else 0))
            p1 = yw + vmin[x]
            p2 = yw + vmax[x]
            rsum += pixels[p1++] - pixels[p2++]
            gsum += pixels[p1++] - pixels[p2++]
            bsum += pixels[p1++] - pixels[p2++]
            yi++
            x++
          yw += (width << 2)
          y++
        x = 0
        while x < width
          yp = x
          rsum = r[yp] * rad1
          gsum = g[yp] * rad1
          bsum = b[yp] * rad1
          i = 1
          while i <= radius
            yp += ((if i > hm then 0 else width))
            rsum += r[yp]
            gsum += g[yp]
            bsum += b[yp]
            i++
          yi = x << 2
          y = 0
          while y < height
            pixels[yi] = (rsum * mul_sum) >>> shg_sum
            pixels[yi + 1] = (gsum * mul_sum) >>> shg_sum
            pixels[yi + 2] = (bsum * mul_sum) >>> shg_sum
            if x is 0
              vmin[y] = ((if (p = y + rad1) < hm then p else hm)) * width
              vmax[y] = ((if (p = y - radius) > 0 then p * width else 0))
            p1 = x + vmin[y]
            p2 = x + vmax[y]
            rsum += r[p1] - r[p2]
            gsum += g[p1] - g[p2]
            bsum += b[p1] - b[p2]
            yi += width << 2
            y++
          x++

      context.putImageData imageData, top_x, top_y

]