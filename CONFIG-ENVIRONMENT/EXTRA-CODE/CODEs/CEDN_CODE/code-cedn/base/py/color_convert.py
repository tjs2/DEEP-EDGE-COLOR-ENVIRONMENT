import colorspace as c

def color_convert(bgr, color):

  converted = bgr

  if (c.ColorTransFormation.RGB != c.ColorTransFormation[color]):
    converted = c.convert_color_from_bgr(bgr, c.ColorTransFormation[color])

  return converted
