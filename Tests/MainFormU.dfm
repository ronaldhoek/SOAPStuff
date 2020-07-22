object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 387
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    414
    387)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 331
    Top = 88
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Test'
    TabOrder = 0
    OnClick = Button1Click
  end
  object rgTests: TRadioGroup
    Left = 8
    Top = 8
    Width = 317
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Tests'
    TabOrder = 1
  end
  object mmResult: TMemo
    Left = 8
    Top = 119
    Width = 398
    Height = 260
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'mmResult')
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
end
