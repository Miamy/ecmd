object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'cmd.exe'
  ClientHeight = 453
  ClientWidth = 611
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 600
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object splVert: TSplitter
    Left = 185
    Top = 0
    Width = 16
    Height = 453
    ExplicitHeight = 473
  end
  object sbHideLeft: TSpeedButton
    Left = 191
    Top = 212
    Width = 16
    Height = 30
    Flat = True
    OnClick = sbHideLeftClick
  end
  object pnlTools: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 453
    Align = alLeft
    TabOrder = 0
    OnResize = pnlToolsResize
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitHeight = 41
    object Splitter1: TSplitter
      Left = 1
      Top = 311
      Width = 183
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 305
      ExplicitWidth = 147
    end
    object pnlHistory: TPanel
      Left = 1
      Top = 1
      Width = 183
      Height = 310
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 304
      object lbHistory: TListBox
        Left = 0
        Top = 0
        Width = 183
        Height = 281
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnDblClick = lbHistoryDblClick
      end
    end
    object pnlTemplates: TPanel
      Left = 1
      Top = 314
      Width = 183
      Height = 138
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lbTemplates: TListBox
        Left = 0
        Top = 0
        Width = 183
        Height = 138
        Align = alClient
        BorderStyle = bsNone
        Color = clBlack
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnDblClick = lbTemplatesDblClick
      end
    end
  end
  object pnlConsole: TPanel
    Left = 201
    Top = 0
    Width = 410
    Height = 453
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 320
    ExplicitTop = 96
    ExplicitWidth = 185
    ExplicitHeight = 41
    object memConsole: TMemo
      Left = 0
      Top = 0
      Width = 410
      Height = 453
      Align = alClient
      Color = clBlack
      Font.Charset = OEM_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Terminal'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyDown = memConsoleKeyDown
      OnKeyPress = memConsoleKeyPress
      ExplicitLeft = -165
      ExplicitTop = 8
      ExplicitWidth = 577
      ExplicitHeight = 409
    end
  end
  object ilHideShow: TImageList
    DrawingStyle = dsTransparent
    Left = 48
    Top = 48
    Bitmap = {
      494C010102000800080010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000098300000983000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C8600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8600000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000983000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000098300000C860000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C860000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C86000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000098300000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000098300000C8600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C86000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C860000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009830
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009830
      0000C86000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C86000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C860
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C860
      0000983000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000983000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C86000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C860000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8600000983000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000098300000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C860000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C86000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C86000009830000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009830000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C8600000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C8600000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009830000098300000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FF9FF9FF00000000
      FF9FF8FF00000000FE1FF87F00000000FE1FF83F00000000F81FF81F00000000
      F81FF80F00000000E01FF80700000000E01FF80700000000F01FF81F00000000
      F81FF81F00000000FC1FF87F00000000FE1FF87F00000000FF1FF9FF00000000
      FF9FF9FF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end
