require "lbase/interface"

local IHistogramSeriesStylePanelApp = Interface {
  _name = "IHistogramSeriesStylePanelApp",

  -- UpdateSeriesStyle (series_style)
  -- Updates the component's series style.
  -- In the profile component, the X axis table assumes the same format as the Y axes'.
  -- Input:
  --  series_style = { 
  --  current_series = [string], -- nome da série selecionada 
  --  series = { 
  --    ["Série 1"] = { 
  --      show_ accumulated = [boolean], 
  --      show_prob_distribution_curve = [boolean], 
  --      filter = [string], 
  --      manual_label = { 
  --        enabled = [boolean], 
  --        text = [string], -- o texto da legenda manual, 
  --      }, 
  --    }, 
  --    ... 
  --  }, 
  --} 
  UpdateSeriesStyle = true,
}

return IHistogramSeriesStylePanelApp