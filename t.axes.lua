require "itf"
itf:SetLibPath("../../lib/data")

print("Init Test")

local AxesStyle = require "geresimlib/components/histogram/panel/axespanel"

-- Interface
local IHistogramAxesStylePanelApp = require "geresimlib/components/histogram/panel/iaxespanelapp"

-- Interface test class
local Interface = Class{
  _implements = {
    IHistogramAxesStylePanelApp,
  }
}

function Interface:UpdateAxesStyle (axes_style)
  print "Axis table:"
  utils.PrintTable(axes_style)
end

-- Data acquisition methods
local function s_GetAxesTable ()
  return {
    X = { 
      logarithmic_distribution = true, -- 'true' se deve usar distribui��o logar�tmica,  -- 'false' caso deva usar distribui��o linear 
      intervals = {
        size = "0.25",   -- tamanho do intervalo
        num = "5",   -- numero de intervalos
      },
      display_format = { 
        format = "Notacao Cientifica", -- �Decimal� ou �Nota��o Cientifica� 
        fractional_part_digits = 4, -- n�mero de casas decimais. Se for -1, -- ser� assumido um c�lculo autom�tico de casas decimais. Default: -1. 
        font = { 
          fontface = "Arial", -- nome do fonte 
          size = 12, -- tamanho do fonte 
          bold = false, -- �true�, se fonte em negrito 
          italic = false, -- �true�, se fonte em it�lico 
        }, 
      }, 
      limits = { 
        automatic_range = false, -- 'true' se deve usar limites autom�ticos. Default: �true�. 
        min_value = "0.0", -- valor m�nimo caso �automatic_range� seja 'false'. 
        max_value = "1.0", -- valor m�ximo caso �automatic_range� seja 'false'. 
      }, 
      manual_label = { 
        enabled = true, 
        text = "eixo x", -- o texto da legenda manual, 
      }, 
    }, 
    Y = { 
      display_format = { 
        format = "Percentual", -- �Contagem� ou �Percentual� 
        fractional_part_digits = 3, -- n�mero de casas decimais. Se for -1, -- ser� assumido um c�lculo autom�tico de casas decimais. Default: -1. 
        font = { 
          fontface = "Arial", -- nome do fonte 
          size = 12, -- tamanho do fonte 
          bold = false, -- �true�, se fonte em negrito 
          italic = false, -- �true�, se fonte em it�lico 
        }, 
      }, 
      manual_label = { 
        enabled = false, 
        text = "eixo y", -- o texto da legenda manual, 
      }, 
    }, 
  }
end

-- Build panel and interface
local axesinterface = Interface{}
local axespaneliup = AxesStyle{interface = axesinterface}

local dlg = iup3.dialog{
  title = "Axes Panel",
  size = "300x",
  iup3.hbox{
    axespaneliup:GetHandle(),
    margin = "2x2",
  },
  show_cb = function(handle) handle.size = nil end,
  close_cb = function(handle) return iup.CLOSE end,
}

dlg:map()

axespaneliup:Update(s_GetAxesTable())

local _DEBUG_ITF = false

if _DEBUG_ITF then
  iup.Show(iup.LayoutDialog(dlg))
else
  dlg:showxy(iup.CENTER, iup.CENTER)
end

--if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
--end