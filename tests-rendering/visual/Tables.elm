module Tables exposing (main)

{-| -}

import Html exposing (Html)
import Theme
import Ui
import Ui.Font
import Ui.Table


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
                        (Ui.text (String.fromInt row.salary))
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
                    ("Total: " ++ String.fromInt total)
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


main : Html msg
main =
    Ui.layout []
        (Ui.column
            [ Ui.width (Ui.px 800)
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
