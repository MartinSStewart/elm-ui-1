module Ui.Table exposing
    ( Column, column, Cell, cell
    , header, withWidth
    , view, Config, columns
    , withRowKey, onRowClick, withRowAttributes
    , withScrollable
    , viewWithState
    , columnWithState, withVisibility, withOrder, withSummary
    , withRowState
    , withSort
    )

{-|

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
            ]

    viewTable model =
        Ui.Table.view [] myTable model.data


## Column Configuration

@docs Column, column, Cell, cell

@docs header, withWidth


## Table Configuration

@docs view, Config, columns

@docs withRowKey, onRowClick, withRowAttributes

@docs withScrollable


# Advanced Tables with State

@docs viewWithState

@docs columnWithState, withVisibility, withOrder, withSummary

@docs withRowState

@docs withSort

-}

import Internal.Flag as Flag
import Internal.Model2 as Two
import Internal.Style2 as Style
import Ui exposing (Attribute, Element)
import Ui.Events
import Ui.Font
import Ui.Lazy


{-| -}
type alias Config globalState rowState data msg =
    { toKey : data -> String
    , columns : List (Column globalState rowState data msg)
    , sort : Maybe (globalState -> List data -> List data)

    -- Row config
    , toRowState : Maybe (globalState -> Int -> Maybe rowState)
    , onRowClick : Maybe (data -> msg)
    , toRowAttrs : Maybe (Maybe rowState -> data -> List (Attribute msg))
    , stickHeader : Bool
    , stickRow : data -> Bool
    , stickFirstColumn : Bool
    , scrollable : Bool
    }


{-| -}
columns :
    List (Column globalState rowState data msg)
    -> Config globalState rowState data msg
columns cols =
    { toKey = \_ -> "keyed"
    , columns = cols
    , toRowState = Nothing
    , onRowClick = Nothing
    , toRowAttrs = Nothing
    , stickHeader = False
    , stickRow = \_ -> False
    , stickFirstColumn = False
    , scrollable = False
    , sort = Nothing
    }


{-| Adding a `key` to a row will automatically use `Keyed` under the hood.
-}
withRowKey : (data -> String) -> Config globalState rowState data msg -> Config globalState rowState data msg
withRowKey toKey cfg =
    { cfg | toKey = toKey }


{-| -}
withRowState :
    (globalState -> Int -> Maybe rowState)
    -> Config globalState rowState data msg
    -> Config globalState rowState data msg
withRowState toState cfg =
    { cfg | toRowState = Just toState }


{-| -}
onRowClick :
    (data -> msg)
    -> Config globalState rowState data msg
    -> Config globalState rowState data msg
onRowClick onClick cfg =
    { cfg | onRowClick = Just onClick }


{-| -}
withRowAttributes :
    (Maybe rowState -> data -> List (Attribute msg))
    -> Config globalState rowState data msg
    -> Config globalState rowState data msg
withRowAttributes toRowAttrs cfg =
    { cfg | toRowAttrs = Just toRowAttrs }


{-| -}
withSort : (globalState -> List data -> List data) -> Config globalState rowState data msg -> Config globalState rowState data msg
withSort sort cfg =
    { cfg | sort = Just sort }


{-| -}
withScrollable :
    { stickFirstColumn : Bool
    }
    -> Config globalState rowState data msg
    -> Config globalState rowState data msg
withScrollable input cfg =
    { cfg
        | scrollable = True
        , stickHeader = True
        , stickFirstColumn = input.stickFirstColumn
    }


{-| -}
type Column globalState rowState data msg
    = Column (ColumnDetails globalState rowState data msg)


type alias ColumnDetails globalState rowState data msg =
    { header : globalState -> Cell msg
    , width :
        Maybe
            { fill : Bool
            , min : Maybe Int
            , max : Maybe Int
            }
    , view : Int -> Maybe rowState -> data -> Cell msg
    , visible : Maybe (globalState -> Bool)
    , order : Maybe (globalState -> Int)
    , summary : Maybe (globalState -> List data -> Cell msg)
    }


{-| -}
type alias Cell msg =
    { attrs : List (Attribute msg)
    , child : Element msg
    }


{-| -}
cell : List (Attribute msg) -> Element msg -> Cell msg
cell =
    Cell


default :
    { padding : Attribute msg
    , paddingFirstRow : Attribute msg
    , fontAlignment : Attribute msg
    , borderHeader : Attribute msg
    }
default =
    { padding =
        Ui.paddingXY 16 8
    , paddingFirstRow =
        Ui.paddingWith
            { top = 16
            , left = 16
            , right = 16
            , bottom = 8
            }
    , fontAlignment = Ui.Font.alignLeft
    , borderHeader =
        Ui.borderWith
            { top = 0
            , left = 0
            , right = 0
            , bottom = 1
            }
    }


{-| A simple header with some default styling.

Feel free to make your own!

This is the same as

    Ui.Table.cell
        [-- some minimal defaults
        ]
        (Ui.text "Header text")

-}
header : String -> Cell msg
header str =
    cell
        [ default.padding
        , default.borderHeader
        , Ui.height Ui.fill
        ]
        (Ui.text str)


{-| -}
column :
    { header : Cell msg
    , view : data -> Cell msg
    }
    -> Column globalState rowState data msg
column input =
    Column
        { header = \_ -> input.header
        , view = \_ _ data -> input.view data
        , width = Nothing
        , visible = Nothing
        , order = Nothing
        , summary = Nothing
        }


{-| -}
columnWithState :
    { header : globalState -> Cell msg
    , view : Int -> Maybe rowState -> data -> Cell msg
    }
    -> Column globalState rowState data msg
columnWithState input =
    Column
        { header = input.header
        , view = input.view
        , width = Nothing
        , visible = Nothing
        , order = Nothing
        , summary = Nothing
        }


{-| -}
withWidth :
    { fill : Bool
    , min : Maybe Int
    , max : Maybe Int
    }
    -> Column globalState rowState data msg
    -> Column globalState rowState data msg
withWidth width (Column col) =
    Column { col | width = Just width }


{-| -}
withSummary : (globalState -> List data -> Cell msg) -> Column globalState rowState data msg -> Column globalState rowState data msg
withSummary toSummaryCell (Column col) =
    Column
        { col
            | summary = Just toSummaryCell
        }


{-| -}
withVisibility : (globalState -> Bool) -> Column globalState rowState data msg -> Column globalState rowState data msg
withVisibility toVisibility (Column col) =
    Column { col | visible = Just toVisibility }


{-| -}
withOrder : (globalState -> Int) -> Column globalState rowState data msg -> Column globalState rowState data msg
withOrder toOrder (Column col) =
    Column { col | order = Just toOrder }


{-| -}
view :
    List (Attribute msg)
    -> Config () () data msg
    -> List data
    -> Element msg
view attrs config data =
    viewWithState attrs config () data


{-| -}
viewWithState :
    List (Attribute msg)
    -> Config globalState rowState data msg
    -> globalState
    -> List data
    -> Element msg
viewWithState attrs config state data =
    let
        headerRow =
            Ui.Lazy.lazy2
                renderHeader
                state
                config

        rows =
            Ui.Lazy.lazy4 viewTableBody config cols state data

        cols =
            getColumns config state
    in
    Two.element Two.NodeAsTable
        Two.AsColumn
        (Two.style "display" "grid"
            :: Two.attrIf config.scrollable
                (Two.classWith Flag.overflow Style.classes.scrollbars)
            :: Two.style "grid-template-columns"
                (gridTemplateColumns state cols "")
            :: Two.style "grid-auto-rows"
                "minmax(min-content, max-content)"
            :: Ui.width Ui.fill
            :: attrs
        )
        [ headerRow
        , rows
        , if List.any hasSummary config.columns then
            Ui.Lazy.lazy4 renderSummary config cols state data

          else
            Ui.none
        ]


hasSummary : Column globalState rowState data msg -> Bool
hasSummary (Column col) =
    case col.summary of
        Nothing ->
            False

        Just _ ->
            True


gridTemplateColumns : globalState -> List (Column globalState rowState data msg) -> String -> String
gridTemplateColumns state cols str =
    case cols of
        [] ->
            str

        (Column col) :: remain ->
            gridTemplateColumns state remain (str ++ " " ++ columnToGridTemplate col)


columnToGridTemplate : ColumnDetails globalState rowState data msg -> String
columnToGridTemplate col =
    case col.width of
        Nothing ->
            "minmax(min-content, max-content)"

        Just w ->
            case w.min of
                Nothing ->
                    case w.max of
                        Nothing ->
                            if w.fill then
                                "1fr"

                            else
                                "minmax(min-content, max-content)"

                        Just max ->
                            if w.fill then
                                "minmax(1fr, "
                                    ++ String.fromInt max
                                    ++ "px)"

                            else
                                "minmax(min-content, "
                                    ++ String.fromInt max
                                    ++ "px)"

                Just min ->
                    case w.max of
                        Nothing ->
                            if w.fill then
                                "minmax("
                                    ++ String.fromInt min
                                    ++ "px , 1fr)"

                            else
                                "minmax("
                                    ++ String.fromInt min
                                    ++ "px , max-content)"

                        Just max ->
                            "minmax("
                                ++ String.fromInt min
                                ++ "px , "
                                ++ String.fromInt max
                                ++ ")"


renderHeader : globalState -> Config globalState rowState data msg -> Element msg
renderHeader state config =
    let
        cols =
            getColumns config state
    in
    Two.element Two.NodeAsTableHead
        Two.AsRow
        [ Two.style "display" "contents" ]
        [ Two.element Two.NodeAsTableRow
            Two.AsRow
            [ Two.style "display" "contents"
            ]
            (case cols of
                [] ->
                    []

                first :: remaining ->
                    renderColumnHeader config state True first
                        :: List.map
                            (renderColumnHeader config state False)
                            remaining
            )
        ]


renderColumnHeader : Config globalState rowState data msg -> globalState -> Bool -> Column globalState rowState data msg -> Element msg
renderColumnHeader cfg state isFirstColumn (Column col) =
    let
        { attrs, child } =
            col.header state

        stickyColumn =
            cfg.stickFirstColumn && isFirstColumn
    in
    Two.element Two.NodeAsTableHeaderCell
        Two.AsEl
        (default.padding
            :: default.fontAlignment
            :: Two.attrIf
                cfg.stickHeader
                (Two.class
                    Style.classes.stickyTop
                )
            :: Two.attrIf
                stickyColumn
                (Two.class
                    Style.classes.stickyLeft
                )
            :: Two.attrIf
                (cfg.stickHeader || stickyColumn)
                (Ui.background (Ui.rgb 255 255 255))
            :: Two.attrIf
                (cfg.stickHeader || stickyColumn)
                (if cfg.stickHeader && stickyColumn then
                    Two.style "z-index" "2"

                 else
                    Two.style "z-index" "1"
                )
            :: attrs
        )
        [ child ]


hasColumnMods : Column globalState rowState data msg -> Bool
hasColumnMods (Column col) =
    col.visible /= Nothing || col.order /= Nothing


getColumns : Config globalState rowState data msg -> globalState -> List (Column globalState rowState data msg)
getColumns config state =
    if List.any hasColumnMods config.columns then
        config.columns
            |> List.filter
                (\(Column col) ->
                    case col.visible of
                        Nothing ->
                            True

                        Just isVisible ->
                            isVisible state
                )
            |> List.sortBy
                (\(Column col) ->
                    case col.order of
                        Nothing ->
                            0

                        Just getOrder ->
                            getOrder state
                )

    else
        config.columns


viewTableBody :
    Config globalState rowState data msg
    -> List (Column globalState rowState data msg)
    -> globalState
    -> List data
    -> Element msg
viewTableBody config cols state data =
    let
        sorted =
            case config.sort of
                Nothing ->
                    data

                Just sortFn ->
                    sortFn state data
    in
    Two.elementKeyed Two.NodeAsTableBody
        Two.AsRow
        [ Two.style "display" "contents" ]
        (List.indexedMap
            (viewRowWithKey config cols state)
            sorted
        )


viewRowWithKey :
    Config globalState rowState data msg
    -> List (Column globalState rowState data msg)
    -> globalState
    -> Int
    -> data
    -> ( String, Element msg )
viewRowWithKey config cols state index row =
    let
        rowState =
            case config.toRowState of
                Nothing ->
                    Nothing

                Just toState ->
                    toState state index
    in
    ( config.toKey row
    , Ui.Lazy.lazy5 viewRow config cols rowState row index
    )


viewRow :
    Config globalState rowState data msg
    -> List (Column globalState rowState data msg)
    -> Maybe rowState
    -> data
    -> Int
    -> Element msg
viewRow config cols state row rowIndex =
    let
        rowAttrs =
            case config.toRowAttrs of
                Nothing ->
                    []

                Just toAttrs ->
                    toAttrs state row
    in
    Two.element Two.NodeAsTableRow
        Two.AsRow
        (Two.style "display" "contents"
            :: (case config.onRowClick of
                    Nothing ->
                        Two.noAttr

                    Just onClick ->
                        Ui.Events.onClick (onClick row)
               )
            :: rowAttrs
        )
        (case cols of
            [] ->
                []

            first :: remaining ->
                Ui.Lazy.lazy6 viewCell config state rowIndex row True first
                    :: List.map
                        (Ui.Lazy.lazy6 viewCell config state rowIndex row False)
                        remaining
        )


viewCell : Config globalState rowState data msg -> Maybe rowState -> Int -> data -> Bool -> Column globalState rowState data msg -> Element msg
viewCell config state rowIndex row isFirstColumn (Column col) =
    let
        { attrs, child } =
            col.view rowIndex state row

        padding =
            if rowIndex == 0 then
                default.paddingFirstRow

            else
                default.padding
    in
    Two.element Two.NodeAsTableD
        Two.AsEl
        (padding
            :: Two.attrIf
                (config.stickFirstColumn && isFirstColumn)
                (Two.class
                    Style.classes.stickyLeft
                )
            :: Two.attrIf
                (config.stickFirstColumn && isFirstColumn)
                (Ui.background (Ui.rgb 255 255 255))
            :: Two.attrIf
                (config.stickFirstColumn && isFirstColumn)
                (Two.style "z-index" "1")
            :: attrs
        )
        [ child ]


renderSummary :
    Config globalState rowState data msg
    -> List (Column globalState rowState data msg)
    -> globalState
    -> List data
    -> Element msg
renderSummary config cols state rows =
    Two.element Two.NodeAsTableFoot
        Two.AsRow
        [ Two.style "display" "contents" ]
        [ Two.element Two.NodeAsTableRow
            Two.AsRow
            [ Two.style "display" "contents"
            ]
            (case cols of
                [] ->
                    []

                first :: remaining ->
                    renderSummaryColumn config state rows True first
                        :: List.map
                            (renderSummaryColumn config state rows False)
                            remaining
            )
        ]


renderSummaryColumn : Config globalState rowState data msg -> globalState -> List data -> Bool -> Column globalState rowState data msg -> Element msg
renderSummaryColumn config state rows isFirstColumn (Column col) =
    let
        { attrs, child } =
            case col.summary of
                Nothing ->
                    cell [] Ui.none

                Just sum ->
                    sum state rows

        padding =
            default.padding
    in
    Two.element Two.NodeAsTableD
        Two.AsEl
        (padding
            :: Two.attrIf
                config.stickHeader
                (Two.class
                    Style.classes.stickyBottom
                )
            :: Two.attrIf
                (config.stickFirstColumn && isFirstColumn)
                (Two.class
                    Style.classes.stickyLeft
                )
            :: Two.attrIf
                config.stickHeader
                (Ui.background (Ui.rgb 255 255 255))
            :: Two.attrIf
                (config.stickFirstColumn && isFirstColumn)
                (Two.style "z-index" "1")
            :: Ui.height Ui.fill
            :: attrs
        )
        [ child ]
