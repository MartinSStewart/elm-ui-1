module Tables exposing (main)

{-| -}

import Browser
import Html exposing (Html)
import Theme
import Ui
import Ui.Events
import Ui.Font
import Ui.Table


main =
    Browser.sandbox
        { init = {}
        , view = view
        , update = update
        }


type alias Model =
    {}


type Msg
    = Clicked
    | Hovered
    | Exited


update msg model =
    case Debug.log "MSG" msg of
        Clicked ->
            model

        Hovered ->
            model

        Exited ->
            model


alignedDollars name getFloat =
    Ui.Table.columnWithAlignment
        { header = \_ -> Ui.Table.header name
        , widths = ( Ui.Table.defaultWidth, Ui.Table.defaultWidth )
        , view =
            \i rowState row ->
                case String.split "." (String.fromFloat (getFloat row)) of
                    [] ->
                        ( Ui.Table.cell [ Ui.Font.alignRight ]
                            (Ui.text "0")
                        , Ui.Table.cell []
                            (Ui.text ".00")
                        )

                    [ dollars ] ->
                        ( Ui.Table.cell [ Ui.Font.alignRight ]
                            (Ui.text dollars)
                        , Ui.Table.cell []
                            (Ui.text ".")
                        )

                    [ dollars, cents ] ->
                        ( Ui.Table.cell [ Ui.Font.alignRight ]
                            (Ui.text dollars)
                        , Ui.Table.cell []
                            (Ui.text ("." ++ cents))
                        )

                    _ ->
                        ( Ui.Table.cell [ Ui.Font.alignRight ]
                            (Ui.text "0")
                        , Ui.Table.cell []
                            (Ui.text ".00")
                        )
        }


myTable =
    Ui.Table.columns
        [ Ui.Table.column
            { header = Ui.Table.header "Name"
            , view =
                \row ->
                    Ui.Table.cell []
                        (Ui.text row.name)
            }
        , Ui.Table.column
            { header = Ui.Table.header "Occupation"
            , view =
                \row ->
                    Ui.Table.cell []
                        (Ui.text row.occupation)
            }
            |> Ui.Table.withVisibility
                (\{ visibleOccupation } ->
                    visibleOccupation
                )
        , alignedDollars "Salary, aligned" .salary
        , Ui.Table.column
            { header =
                Ui.Table.cell
                    [ Ui.Font.alignRight
                    , Ui.borderWith
                        { top = 0
                        , left = 0
                        , right = 0
                        , bottom = 1
                        }
                    ]
                    (Ui.text "Salary")
            , view =
                \row ->
                    Ui.Table.cell [ Ui.Font.alignRight ]
                        (Ui.text (String.fromFloat row.salary))
            }
            |> Ui.Table.withWidth
                { fill = True
                , min = Nothing
                , max = Nothing
                }
            |> Ui.Table.withSummary
                (\_ rows ->
                    let
                        total =
                            List.sum (List.map .salary rows)
                    in
                    ("Total: " ++ String.fromFloat total)
                        |> Ui.text
                        |> Ui.Table.cell [ Ui.Font.alignRight ]
                )
        ]
        |> Ui.Table.withSort
            (\{ sortedBySalary } rows ->
                if sortedBySalary then
                    List.sortBy (\row -> row.salary) rows

                else
                    rows
            )
        |> Ui.Table.withRowState
            (\global index row ->
                if index == 0 || index == 10 then
                    Just True

                else
                    Nothing
            )
        |> Ui.Table.withRowAttributes
            (\maybeRowState row ->
                case maybeRowState of
                    Just _ ->
                        [ Ui.background (Ui.rgb 255 0 0)
                        , Ui.Events.onMouseEnter Hovered
                        , Ui.Events.onMouseLeave Exited
                        , Ui.Events.onClick Clicked
                        ]

                    Nothing ->
                        []
            )


data =
    List.concat <|
        List.repeat 10
            [ { name = "John"
              , occupation = "Programmer"
              , salary = 1098080980900
              }
            , { name = "Jane"
              , occupation = "Designer"
              , salary = 1000900890890898989
              }
            , { name = "Bob"
              , occupation = "Manager"
              , salary = 1000
              }
            ]


type alias State =
    { sortedBySalary : Bool
    , visibleOccupation : Bool
    }


state =
    { visibleOccupation = True
    , sortedBySalary = False
    }


hidden =
    { visibleOccupation = False
    , sortedBySalary = False
    }


sorted =
    { visibleOccupation = True
    , sortedBySalary = True
    }


view : Model -> Html Msg
view mode =
    Ui.layout []
        (Ui.column
            [ Ui.width (Ui.px 1200)
            , Ui.centerX
            , Ui.padding 100
            , Ui.spacing 100
            ]
            [ Theme.h1 "Row"
            , Ui.Table.viewWithState [] myTable state data
            , Theme.h1 "Scrollable!"
            , Ui.Table.viewWithState
                [ Ui.inFront
                    (Ui.el
                        [ Ui.width (Ui.px 200)
                        , Ui.height (Ui.px 200)
                        , Ui.alignRight
                        , Ui.background (Ui.rgb 255 0 0)
                        ]
                        Ui.none
                    )
                , Ui.height (Ui.px 400)
                ]
                (myTable
                    |> Ui.Table.withScrollable { stickFirstColumn = False }
                )
                state
                data
            , Theme.h1 "Hidden columns!"
            , Ui.Table.viewWithState
                []
                myTable
                hidden
                data
            , Theme.h1 "Sorted by salary!"
            , Ui.Table.viewWithState
                []
                myTable
                sorted
                data
            ]
        )
