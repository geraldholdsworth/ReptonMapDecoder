object OptionsForm: TOptionsForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Preferences'
  ClientHeight = 305
  ClientWidth = 200
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clAqua
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object rg_CharRef: TRadioGroup
    Left = 4
    Top = 3
    Width = 192
    Height = 60
    Hint = 
      'When saving a level as a CSV, are the characters referenced as P' +
      'C Repton 2 does, or as a reference into the Atlas?'
    Caption = 'Save CSV characters'
    ItemIndex = 0
    Items.Strings = (
      'As references into atlas'
      'As PC references')
    TabOrder = 0
    OnClick = rg_CharRefClick
  end
  object rg_puzzlepiece: TRadioGroup
    Left = 4
    Top = 67
    Width = 192
    Height = 60
    Hint = 
      'When an character can not be determined, does the application co' +
      'py and stretch it onto the high res map, or just place a puzzle ' +
      'piece?'
    Caption = 'Replace Unknown Characters'
    Color = clBlack
    ItemIndex = 0
    Items.Strings = (
      'As copied from grab'
      'As Puzzle Piece graphic')
    ParentBackground = False
    ParentColor = False
    TabOrder = 1
    OnClick = rg_puzzlepieceClick
  end
  object GroupBox1: TGroupBox
    Left = 4
    Top = 131
    Width = 192
    Height = 170
    Caption = 'Probability Matches'
    TabOrder = 2
    object Label5: TLabel
      Left = 3
      Top = 16
      Width = 135
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Character Match:'
    end
    object lb_prob_match: TLabel
      Left = 138
      Top = 16
      Width = 50
      Height = 16
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label10: TLabel
      Left = 3
      Top = 68
      Width = 135
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Repton Match:'
    end
    object lb_repton_match: TLabel
      Left = 138
      Top = 68
      Width = 50
      Height = 16
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label12: TLabel
      Left = 3
      Top = 118
      Width = 135
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Pixel Match:'
    end
    object lb_pixel_match: TLabel
      Left = 138
      Top = 118
      Width = 50
      Height = 16
      AutoSize = False
      Caption = '0%'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clAqua
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object pixel_match_slider: TTrackBar
      Left = 3
      Top = 138
      Width = 185
      Height = 24
      Hint = 
        'When finding the origin of a map, in an editor window, this is t' +
        'he probability of a match for a single pixel.'
      Max = 100
      Frequency = 5
      ShowSelRange = False
      TabOrder = 0
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = pixel_match_sliderChange
    end
    object prob_match_slider: TTrackBar
      Left = 3
      Top = 36
      Width = 185
      Height = 24
      Hint = 
        'Threshold at which a character is recognised. Matches with a per' +
        'centage below this will be '#39'unrecognised'#39'.'
      Max = 100
      Frequency = 5
      ShowSelRange = False
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = prob_match_sliderChange
    end
    object repton_match_slider: TTrackBar
      Left = 3
      Top = 88
      Width = 185
      Height = 24
      Hint = 
        'When determining whether a game/editor screen is PC Repton 1 or ' +
        '2, the application searches for the position of Repton in the st' +
        'atus panel.'
      Max = 100
      Frequency = 5
      ShowSelRange = False
      TabOrder = 2
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = repton_match_sliderChange
    end
  end
end
