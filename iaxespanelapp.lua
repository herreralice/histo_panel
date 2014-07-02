require "lbase/interface"

local IHistogramAxesStylePanelApp = Interface {
  _name = "IHistogramAxesStylePanelApp",

  -- UpdateAxesStyle (axis_style)
  -- Updates the component's axis style.
  -- In the profile component, the X axis table assumes the same format as the Y axes'.
  -- Input:
  --   axes_style = { 
  --  X = { 
  --    logarithmic_distribution = [boolean], -- 'true' se deve usar distribui��o logar�tmica, 
  --                                             -- 'false' caso deva usar distribui��o linear 
  --
  --    display_format = { 
  --      format = [string], -- �Contagem� ou �Percentual� 
  --      fractional_part_digits = [number], -- n�mero de casas decimais. Se for -1, -- ser� assumido um c�lculo autom�tico de casas decimais. Default: -1. 
  --      font = { 
  --        fontface = [string], -- nome do fonte 
  --        size = [number], -- tamanho do fonte 
  --        bold = [boolean], -- �true�, se fonte em negrito 
  --        italic = [boolean], -- �true�, se fonte em it�lico 
  --      }, 
  --    }, 
  --  }, 
  --  Y = { 
  --    display_format = { 
  --      font = { 
  --        fontface = [string], -- nome do fonte 
  --        size = [number], -- tamanho do fonte 
  --        bold = [boolean], -- �true�, se fonte em negrito 
  --        italic = [boolean], -- �true�, se fonte em it�lico 
  --      }, 
  --    }, 
  --    limits = { 
  --      automatic_range = [boolean], -- 'true' se deve usar limites autom�ticos. Default: �true�. 
  --        min_value = [number], -- valor m�nimo caso �automatic_range� seja 'false'. 
  --    max_value = [number], -- valor m�ximo caso �automatic_range� seja 'false'. 
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