module Image exposing (main)

{-| -}

import Html exposing (Html)
import Html.Attributes as Attr
import Theme
import Ui
import Ui.Font
import Ui.Prose


main : Html msg
main =
    Ui.layout
        [ Ui.Font.family [ Ui.Font.typeface "Garamond EB" ]
        ]
        (Ui.column
            [ Ui.width (Ui.px 600)
            , Ui.centerX
            , Ui.paddingXY 0 100
            , Ui.spacing 80
            ]
            [ Theme.h1 "Images"
            , Ui.text "A Normal 200/300 image, defaults to width fill"
            , Ui.image
                []
                { source = "https://picsum.photos/id/237/200/300"
                , description = ""
                }
            , Ui.text "A Normal 200/300 image, shrinks to content size with width shrink"
            , Ui.image
                [ Ui.width Ui.shrink
                , Theme.rulerLeft 300
                , Theme.rulerTop 200
                ]
                { source = "https://picsum.photos/id/237/200/300"
                , description = ""
                }
            , Ui.text "Constrained to 100/100"
            , Ui.el
                [ -- Annotations
                  Theme.rulerLeft 100
                , Theme.rulerTop 100
                ]
                (Ui.image
                    [ Ui.width (Ui.px 100)
                    , Ui.height (Ui.px 100)
                    ]
                    { source = "https://picsum.photos/id/237/200/300"
                    , description = ""
                    }
                )
            , Ui.text "Width to 600"
            , Ui.el
                [ -- Annotations
                  Theme.rulerLeft 100
                , Theme.rulerTop 600
                ]
                (Ui.image
                    [ Ui.width (Ui.px 600)
                    ]
                    { source = "https://picsum.photos/id/237/200/300"
                    , description = ""
                    }
                )
            , Ui.text "Image with fallback (success, no size given)"
            , Ui.el
                [ -- Annotations
                  Theme.rulerLeft 100
                , Theme.rulerTop 100
                ]
                (Ui.imageWithFallback
                    []
                    { source = "https://picsum.photos/id/237/200/300"
                    , fallback = Ui.el [] (Ui.text "MG")
                    }
                )
            , Ui.text "Image with fallback (success, 100x100)"
            , Ui.el
                [ -- Annotations
                  Theme.rulerLeft 100
                , Theme.rulerTop 100
                ]
                (Ui.imageWithFallback
                    [ Ui.width (Ui.px 100)
                    , Ui.height (Ui.px 100)
                    ]
                    { source = "https://picsum.photos/id/237/200/300"
                    , fallback = Ui.el [] (Ui.text "MG")
                    }
                )
            , Ui.text "Image with fallback (failure, 100x100)"
            , Ui.el
                [ -- Annotations
                  Theme.rulerLeft 100
                , Theme.rulerTop 100
                ]
                (Ui.imageWithFallback
                    [ Ui.width (Ui.px 100)
                    , Ui.height (Ui.px 100)
                    ]
                    { source = "https://picsum.photos/fdafdafdsafds"
                    , fallback = Ui.el [] (Ui.text "MG")
                    }
                )
            , Ui.text "Portrait"
            , Ui.el
                [ Ui.circle
                , Ui.width (Ui.px 100)
                , Ui.height (Ui.px 100)
                , Ui.background (Ui.rgb 0 0 0)
                , Ui.clip
                ]
                (Ui.imageWithFallback
                    [ Ui.width Ui.fill
                    , Ui.height Ui.fill
                    ]
                    { source = "https://picsum.photos/id/237/200/300"
                    , fallback =
                        Ui.el [ Ui.Font.color (Ui.rgb 255 255 255) ]
                            (Ui.text "MG")
                    }
                )
            , Ui.el
                [ Ui.circle
                , Ui.width (Ui.px 100)
                , Ui.height (Ui.px 100)
                , Ui.background (Ui.rgb 0 0 0)
                , Ui.clip
                ]
                (Ui.imageWithFallback
                    [ Ui.width Ui.fill
                    , Ui.height Ui.fill
                    ]
                    { source = "https://picsum.photos/ifadsfdafd"
                    , fallback =
                        Ui.el
                            [ Ui.Font.color (Ui.rgb 255 255 255)
                            , Ui.centerX
                            , Ui.centerY
                            ]
                            (Ui.text "MG")
                    }
                )
            ]
        )
