module Layout exposing (main)

{-| -}

import Html exposing (Html)
import Theme
import Ui
import Ui.Font
import Ui.Prose


main : Html msg
main =
    Ui.layout Ui.default
        []
        (Ui.column
            [ Ui.width (Ui.px 800)
            , Ui.centerX
            , Ui.padding 100
            , Ui.spacing 100
            ]
            [ Theme.h1 "Row"
            , Theme.description "Hello"
            , Ui.el [ Theme.palette.pink ]
                (Ui.text "El's should be width fill by default")
            , Ui.row [ Theme.palette.pink ]
                [ Ui.text "Rows should be filled by default" ]
            , Theme.h2 "Wrapped row"
            , Ui.row [ Ui.spacing 20, Ui.wrap ]
                (List.repeat 100 smallBox)
            , row
            , row2
            , row3
            , Theme.h1 "Column"
            , column
            , column2
            , Ui.column [ Theme.palette.pink ]
                [ Ui.text "Columns should be filled by default" ]
            , Theme.h2 "Wrapped column"
            , Ui.column [ Ui.spacing 20, Ui.wrap, Ui.heightMax 600 ]
                (List.repeat 100 smallBox)
            , centered
            , nearby
            , scrollable
            ]
        )


smallBox =
    Ui.el
        [ Ui.width (Ui.px 20)
        , Ui.height (Ui.px 20)
        , Theme.palette.pink
        ]
        Ui.none


row =
    Ui.row [ Ui.spacing 80, Ui.height Ui.fill ]
        [ Ui.text "Hello"
        , Ui.el [ Theme.palette.pink ] (Ui.text "default is width fill")
        , Ui.el
            [ Ui.height (Ui.px 200)
            , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.rulerRight 200
            , Theme.rulerTop 200
            , Theme.palette.pink
            ]
            (Ui.text "Box:200px w/padding")
        , Ui.el
            [ Ui.height Ui.fill
            , Ui.heightMax 200
            , Theme.rulerRight 200
            , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.palette.pink
            ]
            (Ui.text "Height: fill, Max: 200px")
        , Ui.el
            [ Ui.height Ui.fill
            , Ui.heightMax 500
            , Theme.rulerRight 500
            , Ui.widthMax 800
            , Ui.padding 25
            , Theme.palette.pink
            , Ui.alignTop
            ]
            (Ui.text "Max height: 500px")
        ]


row2 =
    Ui.row
        [ Ui.spacing 80
        , Ui.height Ui.fill
        , Ui.padding 50
        , Ui.border 2
        ]
        [ Ui.text "Hello"
        , Ui.el
            [ Ui.height (Ui.px 200)
            , Ui.width (Ui.px 20)
            , Ui.padding 25
            , Theme.rulerRight 200
            , Theme.palette.pink
            ]
            (Ui.text "Height: 200px")
        , Ui.el
            [ Ui.height Ui.fill

            -- , Theme.rulerRight 500
            -- , Ui.widthMax 800
            -- , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.palette.pink
            ]
            (Ui.text "Height fill")
        ]


row3 =
    Ui.row
        [ Ui.spacing 80
        , Ui.height Ui.fill
        , Ui.padding 50
        , Ui.border 2
        ]
        [ Ui.text "Row Three"
        , Ui.el
            [ Ui.height (Ui.px 200)
            , Ui.width (Ui.px 20)
            , Ui.padding 25
            , Theme.rulerRight 200
            , Theme.palette.pink
            ]
            (Ui.text "Height: 200px")
        , Ui.el
            [ Ui.height Ui.fill

            -- , Theme.rulerRight 500
            -- , Ui.widthMax 800
            -- , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.palette.pink
            , Ui.width (Ui.px 800)
            , Ui.centerX
            ]
            (Ui.text "Center X, Width: 800px, Height fill")
        ]


column =
    Ui.column [ Ui.spacing 40, Ui.height (Ui.px 1500) ]
        [ Ui.text "Hello"
        , Ui.text "World"
        , Ui.el [ Theme.palette.pink ] (Ui.text "default is width fill")
        , Ui.el
            [ Ui.height (Ui.px 200)
            , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.rulerRight 200
            , Theme.palette.pink
            ]
            (Ui.text "Box:100px w/padding")
        , Ui.el [ Theme.rulerRight 200, Ui.width Ui.shrink ] <|
            Ui.el
                [ Ui.width (Ui.px 200)
                , Ui.height (Ui.px 200)
                , Ui.padding 40
                , Theme.palette.pink
                , Ui.clip
                ]
                (Ui.el
                    [ Ui.width (Ui.px 400)
                    , Ui.height (Ui.px 800)
                    ]
                    (Ui.text "Clipped at 200px X and Y")
                )
        , Ui.el
            [ Ui.height Ui.fill
            , Ui.heightMax 200
            , Theme.rulerRight 200
            , Ui.width (Ui.px 200)
            , Ui.padding 25
            , Theme.palette.pink
            ]
            (Ui.text "Max height: 200px")
        , Ui.el
            [ Ui.height Ui.fill
            , Theme.rulerTop 400
            , Ui.widthMax 400
            , Ui.padding 25
            , Theme.palette.pink
            , Ui.centerX
            ]
            (Ui.text "Height fill, Centered X, and width max of 400")
        ]


column2 =
    Ui.column [ Ui.spacing 40, Ui.padding 50, Ui.border 2 ]
        [ Ui.text "Hello"
        , Ui.text "World"
        , Ui.el [ Theme.palette.pink ] (Ui.text "default is width fill")
        , Ui.el
            [ Ui.height (Ui.px 200)
            , Ui.width (Ui.px 400)
            , Ui.padding 25
            , Theme.rulerRight 200
            , Theme.palette.pink
            ]
            (Ui.text "Width: 600 + 25 padding")
        , Ui.el
            [ Theme.palette.pink
            ]
            (Ui.text "Width fill")
        , Ui.el
            [ Theme.palette.pink
            , Ui.centerX
            ]
            (Ui.text "Width fill")
        , Ui.el
            [ Theme.palette.pink
            , Ui.width Ui.shrink
            ]
            (Ui.text "Width fill")
        ]


centered =
    Ui.row
        [ Ui.centerX
        , Ui.spacing 50
        ]
        [ Ui.el
            []
            (Ui.text "Our software completes the Retrofit Assessment process, minimising the need for costly and time consuming surveys.")
        , Ui.el
            [ Ui.width (Ui.px 400)
            , Ui.height (Ui.px 400)
            , Theme.palette.pink
            ]
            Ui.none
        ]


nearby =
    Ui.column [ Ui.spacing 20 ]
        [ Ui.text "Behind content"
        , Ui.el
            [ Ui.behindContent (Ui.text "test") ]
            (Ui.el
                [ Ui.background (Ui.rgb 100 255 255)
                , Ui.height (Ui.px 20)
                ]
                Ui.none
            )
        , Ui.el
            [ Ui.behindContent (Ui.text "test")
            , Ui.background (Ui.rgb 100 255 255)
            ]
            (Ui.el
                [ Ui.height (Ui.px 20)
                ]
                Ui.none
            )
        , Ui.row [ Ui.spacing 20 ]
            [ box
                [ Ui.onRight
                    (tinybox [])
                , Ui.onRight
                    (tinybox [ Ui.centerY ])
                , Ui.onRight
                    (tinybox [ Ui.alignBottom ])
                , Ui.onLeft
                    (tinybox [])
                , Ui.onLeft
                    (tinybox [ Ui.centerY ])
                , Ui.onLeft
                    (tinybox [ Ui.alignBottom ])
                , Ui.below
                    (tinybox [])
                , Ui.below
                    (tinybox [ Ui.centerX ])
                , Ui.below
                    (tinybox [ Ui.alignRight ])
                , Ui.above
                    (tinybox [])
                , Ui.above
                    (tinybox [ Ui.centerX ])
                , Ui.above
                    (tinybox [ Ui.alignRight ])
                , Ui.inFront
                    (tinybox [])
                , Ui.inFront
                    (tinybox [ Ui.centerX ])
                , Ui.inFront
                    (tinybox [ Ui.alignRight ])
                , Ui.inFront
                    (tinybox [ Ui.centerY ])
                , Ui.inFront
                    (tinybox [ Ui.centerX, Ui.centerY ])
                , Ui.inFront
                    (tinybox [ Ui.alignRight, Ui.centerY ])
                , Ui.inFront
                    (tinybox [ Ui.alignBottom ])
                , Ui.inFront
                    (tinybox [ Ui.centerX, Ui.alignBottom ])
                , Ui.inFront
                    (tinybox [ Ui.alignRight, Ui.alignBottom ])
                ]
            ]
        ]


scrollable =
    Ui.column [ Ui.spacing 20 ]
        [ Ui.text "Scrollable"
        , Ui.column [ Ui.spacing 20, Ui.height (Ui.px 400), Ui.scrollable ]
            [ Ui.el
                [ Ui.height (Ui.px 800)
                , Theme.palette.pink
                ]
                (Ui.text "Scrollable container!")
            , box []
            ]
        , Ui.text "Scrollable top (The top is scrollable, but the box below isnt)"
        , Ui.column [ Ui.spacing 20, Ui.height (Ui.px 400) ]
            [ Ui.el [ Ui.scrollable, Ui.height Ui.fill ] <|
                Ui.el
                    [ Ui.height (Ui.px 800)
                    , Theme.palette.pink
                    ]
                    (Ui.text "Scrollable container!")
            , box []
            ]
        , Ui.text "Nearly the same as above, but scrollable part is content based"
        , Ui.column [ Ui.spacing 20, Ui.height (Ui.px 400) ]
            [ Ui.el [ Ui.scrollable, Ui.height Ui.fill ] <|
                Ui.el
                    [ Theme.palette.pink
                    ]
                    (Ui.text (String.repeat 100 "Scrollable container! "))
            , box []
            ]
        , Ui.text "Nearly the same as above, but scrollable part is content based"
        , Ui.el
            [ Ui.height (Ui.px 800)
            , Theme.rulerRight 800
            ]
          <|
            Ui.column [ Ui.spacing 20, Ui.height Ui.fill ]
                [ Ui.el [ Ui.scrollable, Ui.height Ui.fill ] <|
                    Ui.el
                        [ Theme.palette.pink
                        ]
                        (Ui.text (String.repeat 200 "Scrollable container! "))
                , box []
                ]
        ]


box attrs =
    Ui.el
        ([ Ui.width (Ui.px 200)
         , Ui.height (Ui.px 200)

         -- , Ui.padding 25
         -- , Theme.rulerRight 200
         -- , Theme.rulerTop 200
         , Ui.background Theme.black
         ]
            ++ attrs
        )
        Ui.none


tinybox attrs =
    Ui.el
        ([ Ui.width (Ui.px 20)
         , Ui.height (Ui.px 20)
         , Theme.palette.pink
         ]
            ++ attrs
        )
        Ui.none
