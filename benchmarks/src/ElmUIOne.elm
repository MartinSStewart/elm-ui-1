module ElmUI
One exposing
    ( elmUITwo1024
    , elmUITwo128
    , elmUITwo2048
    , elmUITwo24
    , elmUITwo256
    , elmUITwo4096
    , elmUITwo512
    , elmUITwo64
    , elmUITwo8192
    )

{-| -}

import Benchmark.Render
import Html
import Html.Attributes
import Element
import Element.Background
import Element.Font



{- START BENCHMARKS -}
{- Elm UI 2.0 -}


elmUITwo24 : Benchmark.Render.Benchmark Model Msg
elmUITwo24 =
    elmUITwo "elmUITwo24" 24


elmUITwo64 : Benchmark.Render.Benchmark Model Msg
elmUITwo64 =
    elmUITwo "elmUITwo64" 64


elmUITwo128 : Benchmark.Render.Benchmark Model Msg
elmUITwo128 =
    elmUITwo "elmUITwo128" 128


elmUITwo256 : Benchmark.Render.Benchmark Model Msg
elmUITwo256 =
    elmUITwo "elmUITwo256" 256


elmUITwo512 : Benchmark.Render.Benchmark Model Msg
elmUITwo512 =
    elmUITwo "elmUITwo512" 512


elmUITwo1024 : Benchmark.Render.Benchmark Model Msg
elmUITwo1024 =
    elmUITwo "elmUITwo1024" 1024


elmUITwo2048 : Benchmark.Render.Benchmark Model Msg
elmUITwo2048 =
    elmUITwo "elmUITwo2048" 2048


elmUITwo4096 : Benchmark.Render.Benchmark Model Msg
elmUITwo4096 =
    elmUITwo "elmUITwo4096" 4096


elmUITwo8192 : Benchmark.Render.Benchmark Model Msg
elmUITwo8192 =
    elmUITwo "elmUITwo8192" 8192



{- END BENCHMARKS -}


type alias Model =
    { index : Int
    , numberOfElements : Int
    , elements : List Int
    }


type Msg
    = Refresh
    | Tick Float


{-| -}
elmUITwo : String -> Int -> Benchmark.Render.Benchmark Model Msg
elmUITwo name count =
    { name = name
    , init =
        { index = 0
        , numberOfElements = count
        , elements = List.range 0 (count - 1)
        }
    , view =
        \model ->
            Ui.layout Ui.default
                []
                (Ui.column
                    [ Ui.spacing 8
                    , Ui.centerX
                    ]
                    (List.map (viewElTwo model.index) model.elements)
                )
    , update =
        \msg model ->
            case msg of
                Refresh ->
                    if model.index > model.numberOfElements then
                        { model | index = 0 }

                    else
                        { model | index = model.index + 1 }

                Tick i ->
                    if model.index > model.numberOfElements then
                        { model | index = 0 }

                    else
                        { model | index = model.index + 1 }
    , tick = Tick
    , refresh = Refresh
    }


viewElTwo selectedIndex index =
    Ui.el
        [ Ui.background
            (if selectedIndex == index then
                pinkTwo

             else
                whiteTwo
            )
        , Ui.Font.color
            (if selectedIndex /= index then
                pinkTwo

             else
                whiteTwo
            )
        , Ui.padding 24
        , Ui.width (Ui.px 500)

        -- , Ui.width (Ui.fillPortion ((selectedIndex |> modBy 2) + 1))
        , Ui.height (Ui.px 70)
        ]
        (if selectedIndex == index then
            Ui.text "selected"

         else
            Ui.text "Hello!"
        )


whiteTwo =
    Ui.rgb 255 255 255


pinkTwo =
    Ui.rgb 240 0 245
