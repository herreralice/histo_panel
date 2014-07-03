-------------------------------------------
-- Imports
-------------------------------------------

require "lbase/class"

require "itf"
local itf_utils = require "itf/utils"
local s_defstyle = require "itf/default_style"

local AxesStyle = Class{}

-------------------------------------------
-- Public Methods
-------------------------------------------

function AxesStyle:Constructor ()
  assert(self.interface)

  -- Test application methods
  local IAxesPanelApp = nil
    IAxesPanelApp = require "geresimlib/components/histogram/panel/iaxespanelapp"
  IAxesPanelApp:TestObject(self.interface)

  self.controls = {}
  
  -- Local axis data.
  self.axes_style = {}

  self.current_axis = "X"

  self:_BuildInterface()
end

function AxesStyle:Destroy ()
end

function AxesStyle:GetHandle ()
  return self.controls.handle:GetHandle()
end

-- Updates the interface.
-- Input:
--    axes_style = [table] : Axes style table following the format:
--    {
--      X = { 
--         logarithmic_distribution = [boolean], -- 'true' se deve usar distribuição logarítmica, 
--                                                  -- 'false' caso deva usar distribuição linear 
--     
--         display_format = { 
--           format = [string], -- ‘Contagem’ ou ‘Percentual’ 
--           fractional_part_digits = [number], -- número de casas decimais. Se for -1, -- será assumido um cálculo automático de casas decimais. Default: -1. 
--           font = { 
--             fontface = [string], -- nome do fonte 
--             size = [number], -- tamanho do fonte 
--             bold = [boolean], -- ‘true’, se fonte em negrito 
--             italic = [boolean], -- ‘true’, se fonte em itálico 
--           }, 
--         }, 
--       }, 
--       Y = { 
--         display_format = { 
--           font = { 
--             fontface = [string], -- nome do fonte 
--             size = [number], -- tamanho do fonte 
--             bold = [boolean], -- ‘true’, se fonte em negrito 
--             italic = [boolean], -- ‘true’, se fonte em itálico 
--           }, 
--         }, 
--         limits = { 
--           automatic_range = [boolean], -- 'true' se deve usar limites automáticos. Default: ‘true’. 
--             min_value = [number], -- valor mínimo caso ‘automatic_range’ seja 'false'. 
--         max_value = [number], -- valor máximo caso ‘automatic_range’ seja 'false'. 
--           }, 
--           unit = [string], -- unidade da propriedade associada ao eixo. 
--           manual_label = { 
--             enabled = [boolean], 
--             text = [string], -- o texto da legenda manual, 
--           }, 
--         }, 
--       }, 
--    } 
--
function AxesStyle:Update (axes_style)
  print "AxesStyle Update"

  self.axes_style = utils.CloneTable(axes_style)
  print "self.axes_style:"
  utils.PrintTable(self.axes_style)

  if self.axes_style["X"].intervals.size ~= nil then
    self.controls.txt_tam.value = self.axes_style["X"].intervals.size
  end
  if self.axes_style["X"].intervals.num ~= nil then
    self.controls.txt_num.value = self.axes_style["X"].intervals.num
  end

  if self.axes_style["X"].logarithmic_distribution then
    self.controls.ddl_scale:SetValueAt(2)
  else
    self.controls.ddl_scale:SetValueAt(1)
  end

  if self.axes_style["X"].display_format.format == "Decimal" then
    self.controls.ddl_format:SetValueAt(1)
  elseif self.axes_style["X"].display_format.format == "Notacao Cientifica" then
    self.controls.ddl_format:SetValueAt(2)
  end

  local format_dig = self.axes_style["X"].display_format.fractional_part_digits
  if format_dig <= 8 then
    self.controls.ddl_numdec:SetValueAt(format_dig+2)
  end

  if not self.axes_style["X"].limits.automatic_range then
    self.controls.frm_lim:SetValue(true)
    self.controls.txt_min.value = self.axes_style["X"].limits.min_value
    self.controls.txt_max.value = self.axes_style["X"].limits.max_value
  end

   if self.axes_style["X"].manual_label.enabled then
    self.controls.frm_axestxt:SetValue(true)
    self.controls.txt_axestxt.value = self.axes_style["X"].manual_label.text
   end

  if self.axes_style["Y"].display_format.format == "Contagem" then
    self.controls.ddl_yformat:SetValueAt(1)
  elseif self.axes_style["Y"].display_format.format == "Percentual" then
    self.controls.ddl_yformat:SetValueAt(2)
  end

  format_dig = self.axes_style["Y"].display_format.fractional_part_digits
  if format_dig <= 8 then
    self.controls.ddl_ynumdec:SetValueAt(format_dig+2)
  end

  if self.axes_style["Y"].manual_label.enabled then
    self.controls.frm_yaxestxt:SetValue(true)
    self.controls.txt_yaxestxt.value = self.axes_style["Y"].manual_label.text
  end
end

-------------------------------------------
-- Private Methods
-------------------------------------------

-- Builds ui controls and layout.
--
function AxesStyle:_BuildInterface ()
  print "AxesStyle _BuildInterface"

  local vgap = s_defstyle.element_vgap
  local hgap = s_defstyle.element_hgap
  local lgap = s_defstyle.label_gap
  local frame_gap = s_defstyle.frame_gap.frame2

  --Intervalos.Tamanho
  self.controls.tgl_tam = itf:Toggle {
    title = I"Tamanho do intervalo:",
    size = 120,
    action = function(ih, state)
      if (state == 1) then
        self.controls.txt_tam.active = 1
        self.controls.txt_num.active = 0
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.txt_tam = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXJS TEXT TAM")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  --Intervalos.Numero
  self.controls.tgl_num = itf:Toggle {
    title = I"Numero de intervalos:",
    size = 120,
    action = function(ih, state)
      if (state == 1) then
        self.controls.txt_tam.active = 0
        self.controls.txt_num.active = 1
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.txt_num = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    active = 0,
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXIS TEXT NUM")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  --Intervalos.Tamanho/Numero
  self.controls.intv_radio = itf:Radio {
    iup3.vbox {
      iup3.hbox {
        self.controls.tgl_tam:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.txt_tam, 
    --    self.controls.ibut_act_dea_prod:GetHandle(),
        alignment = "ACENTER",
      },
      iup3.fill{size=vgap, expand="NO"},
      iup3.hbox {
        self.controls.tgl_num:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.txt_num, 
     --   self.controls.ibut_act_dea_inje:GetHandle(),
        alignment = "ACENTER",
      },
    };
    value = self.controls.tgl_tam:GetHandle(),
  }
  --Intervalos.Escala
  self.controls.lbl_scale = itf:Label {
    title = I"Escala:",
  }
  local lst_scale = { I"Linear", I"Logaritmica"}
  self.controls.ddl_scale = itf:DropdownList {
    action = function(lst, dist, id, state)
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    end
  }
  self.controls.ddl_scale:AddItems(lst_scale)
  self.controls.ddl_scale:SetValueAt(1)
  --Intervalos
  self.controls.frm_intv = itf:Frame{
    contents = iup3.vbox {
      self.controls.intv_radio:GetHandle(),
      iup3.fill{size=vgap, expand="NO"},
      iup3.hbox {
        self.controls.lbl_scale:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.ddl_scale:GetHandle(),
        alignment = "ACENTER",
      }
    },
    title = I"Intervalos:",
    expand = "YES",
    style = "frame4",
  }
  --Valores.Formato
  self.controls.lbl_format = itf:Label {
    title = I"Formato:",
  }
  local lst_format = {I"Decimal", I"Notacao Cientifica"}
  self.controls.ddl_format = itf:DropdownList {
    action = function(lst, dist, id, state)
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    end
  }
  self.controls.ddl_format:AddItems(lst_format)
  --Valores.NumDec
   self.controls.lbl_numdec = itf:Label {
    title = I"Num. decimais:",
  }
  local lst_numdec = { I"Automatico", 
                       I"1", 
                       I"0.1",
                       I"0.01",
                       I"0.001",
                       I"0.0001",
                       I"0.00001",
                       I"0.000001"
                      }
  self.controls.ddl_numdec = itf:DropdownList {
    action = function(lst, dist, id, state)
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    end
  }
  self.controls.ddl_numdec:AddItems(lst_numdec)
  --Valores
  self.controls.frm_val = itf:Frame{
    contents = iup3.hbox {
      iup3.hbox {
        self.controls.lbl_format:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.ddl_format:GetHandle(),
        alignment = "ACENTER",
      },
      iup3.fill{size=hgap, expand="NO"},
      iup3.hbox {
        self.controls.lbl_numdec:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.ddl_numdec:GetHandle(),
        alignment = "ACENTER",
      }
    },
    title = I"Valores",
    expand = "YES",
    style = "frame4",
  }

  --Limites Manuais
  self.controls.lbl_min = itf:Label {
    title = I"Valor minimo:",
  }
  self.controls.lbl_max = itf:Label {
    title = I"Valor maximo:",
  }
  self.controls.txt_min = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXJS TEXT MIN")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.txt_max = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXJS TEXT MAX")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.frm_lim = itf:CheckFrame{
    title = I"Limites Manuais:",
    contents = iup3.vbox {
      iup3.hbox {
        self.controls.lbl_max:GetHandle(),
        iup3.fill{size=hgap, expand = "NO"},
        self.controls.txt_max,
      },
      iup3.fill{size=vgap, expand = "NO"},
      iup3.hbox {
        self.controls.lbl_min:GetHandle(),
        iup3.fill{size=hgap, expand = "NO"},
        self.controls.txt_min,
      }
    },
    expand = "YES",
    style = "frame4",
    action = function(tog, state)
    --  if (state == 1) then
      print("CURRENT AXES FRM_LIM")
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    --end
    end,
  }

  --Texto do eixo manual
  self.controls.lbl_axestxt = itf:Label {
    title = I"Texto:",
  }
  self.controls.txt_axestxt = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXJS TEXT AXESTEXT")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.frm_axestxt = itf:CheckFrame{
    title = I"Texto do eixo manual",
    contents = iup3.hbox {
        self.controls.lbl_axestxt:GetHandle(),
        iup3.fill{size=hgap, expand = "NO"},
        self.controls.txt_axestxt,
    },
    expand = "YES",
    style = "frame4",
    action = function(tog, state)
    --  if (state == 1) then
      print("CURRENT AXES AXES_TXT")
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    --end
    end,
  }

  --Eixo
  self.controls.box_xaxis = iup3.vbox {
    iup3.vbox {
      iup3.fill{size=vgap, expand = "NO"},
      self.controls.frm_intv:GetHandle(),
      iup3.fill{size=frame_gap, expand = "NO"},
      self.controls.frm_val:GetHandle(),
      iup3.fill{size=frame_gap, expand = "NO"},
      self.controls.frm_lim:GetHandle(),
      iup3.fill{size=vgap, expand = "NO"},
      self.controls.frm_axestxt:GetHandle(),
      iup3.fill{size=vgap, expand = "NO"},
    },
    expand = "HORIZONTAL",
  }

     --Valores.Formato
  self.controls.lbl_yformat = itf:Label {
    title = I"Formato:",
  }
  local lst_yformat = {I"Contagem", I"Percentual"}
  self.controls.ddl_yformat = itf:DropdownList {
    action = function(lst, dist, id, state)
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    end
  }
  self.controls.ddl_yformat:AddItems(lst_yformat)
  --Valores.NumDec
   self.controls.lbl_ynumdec = itf:Label {
    title = I"Num. decimais:",
  }
  local lst_ynumdec = { I"Automatico", 
                       I"1", 
                       I"0.1",
                       I"0.01",
                       I"0.001",
                       I"0.0001",
                       I"0.00001",
                       I"0.000001"
                      }
  self.controls.ddl_ynumdec = itf:DropdownList {
    action = function(lst, dist, id, state)
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    end
  }
  self.controls.ddl_ynumdec:AddItems(lst_numdec)
  --Valores
  self.controls.frm_yval = itf:Frame{
    contents = iup3.hbox {
      iup3.hbox {
        self.controls.lbl_yformat:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.ddl_yformat:GetHandle(),
        alignment = "ACENTER",
      },
      iup3.fill{size=hgap, expand="NO"},
      iup3.hbox {
        self.controls.lbl_ynumdec:GetHandle(),
        iup3.fill{size=hgap, expand="NO"},
        self.controls.ddl_ynumdec:GetHandle(),
        alignment = "ACENTER",
      }
    },
    title = I"Valores",
    expand = "YES",
    style = "frame4",
  }
    --Texto do eixo manual
  self.controls.lbl_yaxestxt = itf:Label {
    title = I"Texto:",
  }
  self.controls.txt_yaxestxt = iup3.text{
    visiblecolumns = 8,
    expand = "NO",
    k_any = function(txt, c)
      if c == iup.K_CR then
        print("CURRENT AXJS TEXT TAM")
        self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
      end
    end,
  }
  self.controls.frm_yaxestxt = itf:CheckFrame{
    title = I"Texto do eixo manual",
    contents = iup3.hbox {
        self.controls.lbl_yaxestxt:GetHandle(),
        iup3.fill{size=hgap, expand = "NO"},
        self.controls.txt_yaxestxt,
    },
    expand = "YES",
    style = "frame4",
    action = function(tog, state)
    --  if (state == 1) then
      print("CURRENT AXES AXES_TXT")
      self.axes_style[self.current_axis] = self:_GetCurrentAxesData()
    --end
    end,
  }

    self.controls.box_yaxis = iup3.vbox {
    iup3.vbox {
      iup3.fill{size=vgap, expand = "NO"},
      self.controls.frm_yval:GetHandle(),
      iup3.fill{size=frame_gap, expand = "NO"},
      self.controls.frm_yaxestxt:GetHandle(),
      iup3.fill{size=vgap, expand = "NO"},
    },
    expand = "HORIZONTAL",
  }

  -- Axis options box
    if self.current_axis == "X" then
    self.controls.box_axis = iup3.zbox{
      self.controls.box_xaxis,
      expand = "HORIZONTAL",
    }
  else
    self.controls.box_axis =  iup3.zbox{
      self.controls.box_yaxis,
      expand = "HORIZONTAL",
    }
  end

  self.controls.box_axis = iup3.zbox{
      self.controls.box_xaxis,
      self.controls.box_yaxis,
      expand = "HORIZONTAL",
    }

  self.controls.frame_main = itf:ListFrame {
    contents = iup3.vbox {
      self.controls.box_axis
    },
    title = I"Eixo"..":",
    expand = "YES",
    style = "frame4",
    action = function(lst, axis, id, status)
   -- print(lst, axis, id, status)
    --  if status == 1 then
        self.current_axis = axis
        print ("self.current_axis:".. self.current_axis)
        if self.current_axis == "X" then
          self.controls.box_axis.valuepos = 0
        else
          self.controls.box_axis.valuepos = 1
        end
  --    end
    end
  }
  local lst_axes = {I"X", I"Y"}
  self.controls.frame_main:AddItems(lst_axes)

  self.controls.handle = self.controls.frame_main

end


-- Gets current serie data.
--
function AxesStyle:_GetCurrentAxesData ()
  print "AxesStyle _GetCurrentAxesData"

  local axes_data = {}

  if self.current_axis  == "X" then
    local lst_format = {I"Decimal", I"Notacao Cientifica"}

    axes_data.intervals = {}
    axes_data.intervals.size = self.controls.txt_tam.value
    axes_data.intervals.num = self.controls.txt_num.value
    if self.controls.ddl_scale:GetValue() == 2 then
      axes_data.logarithmic_distribution = true
    else
      axes_data.logarithmic_distribution = false
    end
    axes_data.display_format = {}
    axes_data.display_format.format = lst_format[self.controls.ddl_format:GetValue()]
    axes_data.display_format.fractional_part_digits = self.controls.ddl_numdec:GetValue() - 2
    axes_data.limits = {}
    axes_data.limits.automatic_range = not self.controls.frm_lim:GetValue()
    axes_data.limits.min_value = self.controls.txt_min.value
    axes_data.limits.max_value = self.controls.txt_max.value
    axes_data.manual_label = {}
    axes_data.manual_label.enabled = self.controls.frm_axestxt:GetValue()
    axes_data.manual_label.text = self.controls.txt_axestxt.value
  else
    local lst_format = {I"Contagem", I"Percentual"}
    axes_data.display_format = {}
    axes_data.display_format.format = lst_format[self.controls.ddl_yformat:GetValue()]
    axes_data.display_format.fractional_part_digits = self.controls.ddl_ynumdec:GetValue() - 2
    axes_data.manual_label = {}
    axes_data.manual_label.enabled = self.controls.frm_yaxestxt:GetValue()
    axes_data.manual_label.text = self.controls.txt_yaxestxt.value
  end
  return axes_data
end

return AxesStyle