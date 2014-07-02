require "lbase/interface"

local IHistogramAxesStylePanelApp = Interface {
  _name = "IHistogramAxesStylePanelApp",

  -- UpdateAxesStyle (axis_style)
  -- Updates the component's axis style.
  -- In the profile component, the X axis table assumes the same format as the Y axes'.
  -- Input:
  --   axes_style = { 
  --  X = { 
  --    logarithmic_distribution = [boolean], -- 'true' se deve usar distribuição logarítmica, 
  --                                             -- 'false' caso deva usar distribuição linear 
  --
  --    display_format = { 
  --      format = [string], -- ‘Contagem’ ou ‘Percentual’ 
  --      fractional_part_digits = [number], -- número de casas decimais. Se for -1, -- será assumido um cálculo automático de casas decimais. Default: -1. 
  --      font = { 
  --        fontface = [string], -- nome do fonte 
  --        size = [number], -- tamanho do fonte 
  --        bold = [boolean], -- ‘true’, se fonte em negrito 
  --        italic = [boolean], -- ‘true’, se fonte em itálico 
  --      }, 
  --    }, 
  --  }, 
  --  Y = { 
  --    display_format = { 
  --      font = { 
  --        fontface = [string], -- nome do fonte 
  --        size = [number], -- tamanho do fonte 
  --        bold = [boolean], -- ‘true’, se fonte em negrito 
  --        italic = [boolean], -- ‘true’, se fonte em itálico 
  --      }, 
  --    }, 
  --    limits = { 
  --      automatic_range = [boolean], -- 'true' se deve usar limites automáticos. Default: ‘true’. 
  --        min_value = [number], -- valor mínimo caso ‘automatic_range’ seja 'false'. 
  --    max_value = [number], -- valor máximo caso ‘automatic_range’ seja 'false'. 
  --      }, 
  --      unit = [string], -- unidade da propriedade associada ao eixo. 
  --      manual_label = { 
  --        enabled = [boolean], 
  --        text = [string], -- o texto da legenda manual, 
  --      }, 
  --    }, 
  --  }, 
  --} 
  UpdateAxesStyle = true,
}

return IHistogramAxesStylePanelApp