module Anim exposing (main)

{-| -}

import Browser
import Html
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode
import Theme
import Ui exposing (..)
import Ui.Anim
import Ui.Events
import Ui.Font
import Ui.Gradient
import Ui.Input
import Ui.Keyed
import Ui.Layout
import Ui.Lazy
import Ui.Responsive


on str decoder =
    htmlAttribute <| Events.on str decoder


main =
    Browser.document
        { init = init
        , view =
            \model ->
                { title = "Transitions"
                , body = [ view model ]
                }
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init () =
    ( { ui = Ui.Anim.init
      , checked = False
      , email = ""
      , show = False
      }
    , Cmd.none
    )


type Msg
    = Ui Ui.Anim.Msg
    | Clicked
    | ShowClicked


update msg model =
    case msg of
        Ui uiMsg ->
            let
                ( newUI, cmd ) =
                    Ui.Anim.update Ui uiMsg model.ui
            in
            ( { model | ui = newUI }
            , cmd
            )

        Clicked ->
            ( model
            , Cmd.none
            )

        ShowClicked ->
            ( { model | show = not model.show }
            , Cmd.none
            )


type Breakpoints
    = Small
    | Medium
    | Large


breakpoints =
    Ui.Responsive.breakpoints Small
        [ ( 1200, Medium )
        , ( 2400, Large )
        ]


view model =
    Ui.Anim.layout
        { options = []
        , toMsg = Ui
        , breakpoints = Just breakpoints
        }
        model.ui
        [ Ui.Font.font
            { name = "EB Garamond"
            , fallback = [ Ui.Font.serif ]
            , variants =
                []
            , weight = 400
            , size = 32
            , lineSpacing = 18
            , capitalSizeRatio = 0.7
            }
        , Ui.Events.onClick
            Clicked
        ]
        (Ui.column
            [ Ui.width (Ui.px 800)
            , Ui.centerX
            , Ui.padding 100
            , Ui.spacing 100
            ]
            [ Theme.h1 "Row"
            , Theme.description "Hello"
            , Theme.h1 "Hovering animations are independent"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.pink
                        ]
                    ]
                ]
            , Theme.h1 "Border color works too"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                ]
            , Theme.h1 "Both work at the same time"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.grey
                        , Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.grey
                        , Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.backgroundColor Theme.grey
                        , Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                ]
            , Theme.h1 "Even if declared separately, both work at the same time  (Actually, this doesn't work!  And would be complicated to fix)"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.backgroundColor Theme.grey
                        ]
                    , Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.backgroundColor Theme.grey
                        ]
                    , Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.backgroundColor Theme.grey
                        ]
                    , Ui.Anim.hovered (Ui.Anim.ms 2000)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                ]
            , Theme.h1 "Intro animation"
            , Ui.row
                [ Ui.spacing 20
                , Ui.Events.onClick ShowClicked
                ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 200)
                        [ Ui.Anim.borderColor Theme.pink
                        ]
                    ]
                , if model.show then
                    box
                        [ Ui.Anim.keyframes
                            [ Ui.Anim.set [ Ui.Anim.opacity 0 ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.opacity 0.5 ]
                            ]
                        ]

                  else
                    Ui.none
                , if model.show then
                    box
                        [ Ui.Anim.intro (Ui.Anim.ms 2000)
                            { start =
                                [ Ui.Anim.opacity 0
                                , Ui.Anim.x -300
                                ]
                            , to =
                                [ Ui.Anim.opacity 1
                                , Ui.Anim.x 0
                                , Ui.Anim.scale 0.5
                                , Ui.Anim.rotation 0.2
                                ]
                            }
                        ]

                  else
                    Ui.none
                ]
            , Theme.h1 "Parent triggers"
            , let
                trigger =
                    Ui.Anim.onHover "hover-row"
              in
              Ui.row
                [ Ui.spacing 20
                , trigger.onHover
                ]
                [ box
                    [ trigger.keyframes
                        [ Ui.Anim.set [ Ui.Anim.opacity 0 ]
                        , Ui.Anim.step (Ui.Anim.ms 2000)
                            [ Ui.Anim.opacity 0.5 ]
                        ]
                    ]
                , box
                    [ trigger.keyframes
                        [ Ui.Anim.set [ Ui.Anim.opacity 0 ]
                        , Ui.Anim.step (Ui.Anim.ms 2000)
                            [ Ui.Anim.opacity 0.5 ]
                        ]
                    ]
                , box
                    [ trigger.keyframes
                        [ Ui.Anim.set [ Ui.Anim.opacity 0 ]
                        , Ui.Anim.step (Ui.Anim.ms 2000)
                            [ Ui.Anim.opacity 0.5 ]
                        ]
                    ]
                ]
            , Theme.h1 "A simple spinning animation (standard, linear, wobble)"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.keyframes
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                ]
                            ]
                        ]
                    ]
                , box
                    [ Ui.Anim.keyframes
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                    |> Ui.Anim.withTransition Ui.Anim.linear
                                ]
                            ]
                        ]
                    ]
                , box
                    [ Ui.Anim.keyframes
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                    |> Ui.Anim.withTransition
                                        (Ui.Anim.spring
                                            { wobble = 1
                                            , quickness = 0
                                            }
                                        )
                                ]
                            ]
                        ]
                    ]
                ]
            , Theme.h1 "Rotation on hover"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hovered (Ui.Anim.ms 1000)
                        [ Ui.Anim.rotation 1
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 1000)
                        [ Ui.Anim.rotation 1
                            |> Ui.Anim.withTransition Ui.Anim.linear
                        ]
                    ]
                , box
                    [ Ui.Anim.hovered (Ui.Anim.ms 1000)
                        [ Ui.Anim.rotation 1
                            |> Ui.Anim.withTransition
                                (Ui.Anim.spring
                                    { wobble = 1
                                    , quickness = 0
                                    }
                                )
                        ]
                    ]
                ]
            , Theme.h1 "A simple looping animation (on hover, standard, linear, wobble)"
            , Ui.row [ Ui.spacing 20 ]
                [ box
                    [ Ui.Anim.hoveredWith
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                ]
                            ]
                        ]
                    ]
                , box
                    [ Ui.Anim.hoveredWith
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                    |> Ui.Anim.withTransition Ui.Anim.linear
                                ]
                            ]
                        ]
                    ]
                , box
                    [ Ui.Anim.hoveredWith
                        [ Ui.Anim.loop
                            [ Ui.Anim.set
                                [ Ui.Anim.rotation 0
                                ]
                            , Ui.Anim.step (Ui.Anim.ms 2000)
                                [ Ui.Anim.rotation 1
                                    |> Ui.Anim.withTransition
                                        (Ui.Anim.spring
                                            { wobble = 1
                                            , quickness = 0
                                            }
                                        )
                                ]
                            ]
                        ]
                    ]
                ]

            -- , Ui.row [ Ui.spacing 20 ]
            --     (List.map
            --         (\wobble ->
            --             mini
            --                 [ Ui.Anim.keyframes
            --                     [ Ui.Anim.loop
            --                         [ Ui.Anim.set
            --                             [ Ui.Anim.rotation 0
            --                             ]
            --                         , Ui.Anim.step (Ui.Anim.ms 2000)
            --                             [ Ui.Anim.rotation 1
            --                                 |> Ui.Anim.withTransition
            --                                     (Ui.Anim.spring
            --                                         { wobble = wobble
            --                                         , quickness = 0
            --                                         }
            --                                     )
            --                             ]
            --                         ]
            --                     -- |> Ui.Anim.withStepTransition Ui.Anim.wobble 0.2
            --                     ]
            --                 ]
            --         )
            --         [ 0
            --         , 0.1
            --         , 0.2
            --         , 0.3
            --         , 0.4
            --         , 0.5
            --         , 0.6
            --         , 0.7
            --         , 0.8
            --         , 0.9
            --         , 1
            --         ]
            --     )
            ]
        )


mini attrs =
    Ui.el
        ([ Ui.width (Ui.px 30)
         , Ui.height (Ui.px 30)
         , Ui.background Theme.black
         , Ui.border 2
         , Ui.borderColor Theme.black
         ]
            ++ attrs
        )
        Ui.none


box attrs =
    Ui.el
        ([ Ui.width (Ui.px 200)
         , Ui.height (Ui.px 200)
         , Ui.background Theme.black
         , Ui.border 10
         , Ui.borderColor Theme.black
         ]
            ++ attrs
        )
        Ui.none
