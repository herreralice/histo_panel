-------------------------------------------
-- Imports
-------------------------------------------

require "lbase/class"

require "itf"
local itf_utils = require "itf/utils"
local s_defstyle = require "itf/default_style"

local SeriesStyle = Class{}

function SeriesStyle:Constructor ()
  assert(self.interface)

  -- Test application methods
  local ISeriesPanelApp = nil
  ISeriesPanelApp = require "geresimlib/components/histogram/panel/iseriespanelapp"
  ISeriesPanelApp:TestObject(self.interface)

  self.controls = {}
  
  -- Local axis data.
  self.series_style = {}

  self.current_series = "Série 1"
  
  self:_BuildInterface()
end

function SeriesStyle:Destroy ()
end

function SeriesStyle:GetHandle ()
  return self.controls.handle:GetHandle()
end

-- Updates the interface.
-- Input:
--    series_style = [table] : Axes style table following the format:
--    { 
--    current_seriess = [string], -- nome da série selecionada 
--    series = { 
--      ["Série 1"] = { 
--        show_ accumulated = [boolean], 
--        show_prob_distribution_curve = [boolean], 
--        filter = [string], 
--        manual_label = { 
--          enabled = [boolean], 
--          text = [string], -- o texto da legenda manual, 
--        }, 
--      }, 
--      ... 
--    }, 
--   } 
--
function SeriesStyle:Update (series_style)
  print "SeriesStyle Update"

  self.series_style = utils.CloneTable(series_style)
  print "self.series_style:"
  utils.PrintTable(self.series_style)

  self.current_series = self.series_style.current_series
  self.controls.handle:SetValue(self.current_series)
  self:_UpdateSeriesControls()
end

-------------------------------------------
-- Private Methodss
-------------------------------------------

-- Builds ui controls and layout.
--
function SeriesStyle:_BuildInterface ()
  print "SeriesStyle _BuildInterface"

  local vgap = s_defstyle.element_vgap
  local hgap = s_defstyle.element_hgap
  local lgap = s_defstyle.label_gap
  local frame_gap = s_defstyle.frame_gap.frame2

  --Acumulado
  self.controls.tgl_acu = itf:Toggle {
    title = I"Acumulado",
    size = 120,
    action = function(ih, state)
     -- if (state == 1) then
       print("CURRENT SERIE ACUM")
       self.series_style.series[self.current_series] = self:_GetCurrentSerieData()
    --  end
    end,
  }
  --Curva distb
    self.controls.tgl_cur = itf:Toggle {
    title = I"Curva de distribuição de probabilidade",
    size = 200,
    action = function(ih, state)
    --  if (state == 1) then
       print("CURRENT SERIE CUR")
       self.series_style.series[self.current_series] = self:_GetCurrentSerieData()
     --end
    end,
  }

  --Filtro
  self.controls.lbl_filter = itf:Label {
    title = I"Filtro:",
  }
  local lst_filter = {I"Todas as células", I"Somente ativas", I"Somente células canhoneadas"}
  self.controls.ddl_filter = itf:DropdownList {
    action = function(lst, dist, id, state)
    --  if (state == 1) then
       print("CURRENT SERIE DDL")
       self.series_style.series[self.current_series] = self:_GetCurrentSerieData()
     --end
    end,
  }
  self.controls.ddl_filter:AddItems(lst_filter)

  --Legenda Manuais
  self.controls.lbl_leg = itf:Label {
    title = I"Texto",
  }
  self.controls.txt_leg = iup3.text{
    visiblecolumns = 20,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT SERIE TEXT")
       self.series_style.series[self.current_series] = self:_GetCurrentSerieData()
      end
    end,
  }
  self.controls.frm_lim = itf:CheckFrame{
    title = I"Legenda manual",
    contents = iup3.hbox {
        self.controls.lbl_leg:GetHandle(),
        iup3.fill{size=hgap, expand = "NO"},
        self.controls.txt_leg,
    },
    action = function(tog, state)
    --  if (state == 1) then
      print("CURRENT SERIE LEGMAN")
      self.series_style.series[self.current_series] = self:_GetCurrentSerieData()
    --end
    end,
    expand = "YES",
    style = "frame4",
  }

  self.controls.box_axis = iup3.vbox{
    self.controls.tgl_acu:GetHandle(),
    iup3.fill{size=vgap, expand="NO"},
    self.controls.tgl_cur:GetHandle(),
    iup3.fill{size=vgap, expand="NO"},
    iup3.hbox {
      self.controls.lbl_filter:GetHandle(),
      iup3.fill{size=hgap, expand="NO"},
      self.controls.ddl_filter:GetHandle(),
      alignment = "ACENTER",
    },
    iup3.fill{size=frame_gap, expand="NO"},
     self.controls.frm_lim:GetHandle(),
    expand = "HORIZONTAL",
  }

    self.controls.frame_main = itf:ListFrame {
    contents = iup3.vbox {
      self.controls.box_axis
    },
    title = I"Série"..":",
    expand = "YES",
    style = "frame4",
    action = function(lst, serie, id, status)
      if status == 1 then
        self.current_series = serie
        print ("self.current_series:".. self.current_series)
        self:_UpdateSeriesControls()
      end
    end
  }
  local lst_series = {I"Série 1", I"Série 2"}
  self.controls.frame_main:AddItems(lst_series)

  self.controls.handle = self.controls.frame_main
end

function SeriesStyle:_UpdateSeriesControls ()
  print "SeriesStyle _UpdateSeriesControls"

  --Acumulado
  if self.series_style.series[self.current_series].show_accumulated then
    self.controls.tgl_acu:SetValue(true) 
  else
    self.controls.tgl_acu:SetValue(false) 
  end

  --Curva distb  
  if self.series_style.series[self.current_series].show_prob_distribution_curve then
    self.controls.tgl_cur:SetValue(true) 
  else
    self.controls.tgl_cur:SetValue(false) 
  end

  --Filtro
  if self.series_style.series[self.current_series].filter == "Todas as células" then
    self.controls.ddl_filter:SetValueAt(1) 
  elseif self.series_style.series[self.current_series].filter == "Somente ativas" then
    self.controls.ddl_filter:SetValueAt(2) 
  elseif self.series_style.series[self.current_series].filter == "Somente células canhoneadas"then
    self.controls.ddl_filter:SetValueAt(3) 
  end

  --Legenda Manuais
  if self.series_style.series[self.current_series].manual_label.enabled then
    self.controls.frm_lim:SetValue(true)
  else
    self.controls.frm_lim:SetValue(false)
  end
  self.controls.txt_leg.value = self.series_style.series[self.current_series].manual_label.text
end


-- Gets current serie data.
--
function SeriesStyle:_GetCurrentSerieData ()
  print "SeriesStyle _GetCurrentSerieData"

  local lst_filter = {I"Todas as células", I"Somente ativas", I"Somente células canhoneadas"}

  local serie_data = {}

  serie_data.show_accumulated = self.controls.tgl_acu:GetValue(true)
  serie_data.show_prob_distribution_curve = self.controls.tgl_cur:GetValue(true)
  serie_data.filter = lst_filter[self.controls.ddl_filter:GetValue()]
  serie_data.manual_label = {}
  serie_data.manual_label.enabled = self.controls.frm_lim:GetValue()
  serie_data.manual_label.text = self.controls.txt_leg.value

  return serie_data
end

return SeriesStyle