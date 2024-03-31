module Input.Slide exposing (main)

{-| -}

import Browser
import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events
import Theme
import Ui
import Ui.Font
import Ui.Input
import Ui.Prose


main =
    Browser.document
        { init = \() -> ( { value = 0 }, Cmd.none )
        , update = update
        , view =
            \model ->
                { title = "Slider"
                , body = [ view model ]
                }
        , subscriptions = \_ -> Sub.none
        }


update msg model =
    case msg of
        SliderUpdated value ->
            ( { model | value = value }, Cmd.none )


type Msg
    = SliderUpdated Float


view model =
    Ui.layout
        [ Ui.Font.family [ Ui.Font.typeface "Garamond EB" ]
        ]
        (Ui.column
            [ Ui.width (Ui.px 600)
            , Ui.centerX
            , Ui.paddingXY 0 100
            , Ui.spacing 100
            ]
            [ Theme.h1 "Slider"
            , Ui.text (String.fromFloat model.value)
            , Ui.Input.sliderHorizontal
                [-- Ui.borderColor (Ui.rgba 0 0 0 1)
                 -- , Ui.border 1
                 -- , Ui.padding 5
                 -- , Ui.rounded 10
                 -- , Theme.rulerTop 100
                 -- , Ui.width (Ui.px 300)
                ]
                { onChange = SliderUpdated
                , min = 0
                , max = 500
                , value = model.value
                , thumb = Nothing
                , step = Nothing
                , label =
                    Ui.Input.labelHidden "Type something here..."
                }
            , Ui.Input.sliderVertical
                [ --     Ui.borderColor (Ui.rgba 0 0 0 1)
                  -- , Ui.border 1
                  -- , Ui.padding 2
                  -- , Ui.rounded 10
                  Ui.height (Ui.px 300)
                , Ui.centerX
                ]
                { onChange = SliderUpdated
                , min = 0
                , max = 500
                , value = model.value
                , thumb = Nothing
                , step = Nothing
                , label =
                    Ui.Input.labelHidden "Type something here..."
                }
            ]
        )
