require "itf"
itf:SetLibPath("../../lib/data")

print("Init Test")

local SeriesStyle = require "geresimlib/components/histogram/panel/seriespanel"

-- Interface
local IHistogramSeriesStylePanelApp = require "geresimlib/components/histogram/panel/iseriespanelapp"

-- Interface test class
local Interface = Class{
  _implements = {
    IHistogramSeriesStylePanelApp,
  }
}

function Interface:UpdateSeriesStyle (series_style)
  print "Series table:"
  utils.PrintTable(series_style)
end

local function s_GetSeriesTable ()
  return {
    current_series = "Série 2", -- nome da série selecionada 
    series = { 
      ["Série 1"] = { 
        show_accumulated = true, 
        show_prob_distribution_curve = false, 
        filter = "Somente ativas", 
        manual_label = { 
          enabled = true, 
          text = "serie1", -- o texto da legenda manual, 
        }, 
      },
      ["Série 2"] = { 
        show_accumulated = false, 
        show_prob_distribution_curve = true, 
        filter = "Somente células canhoneadas", 
        manual_label = { 
          enabled = false, 
          text = "serie2", -- o texto da legenda manual, 
        }, 
      },
    }, 
  } 
end



-- Build panel and interface
local seriesinterface = Interface{}
local seriespaneliup = SeriesStyle{interface = seriesinterface}

local dlg = iup3.dialog{
  title = "Axes Panel",
  size = "300x",
  iup3.hbox{
    seriespaneliup:GetHandle(),
    margin = "2x2",
  },
  show_cb = function(handle) handle.size = nil end,
  close_cb = function(handle) return iup.CLOSE end,
}

dlg:map()

seriespaneliup:Update(s_GetSeriesTable())

local _DEBUG_ITF = false

if _DEBUG_ITF then
  iup.Show(iup.LayoutDialog(dlg))
else
  dlg:showxy(iup.CENTER, iup.CENTER)
end

--if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
--end