module AnimTimeline exposing (main)

{-| -}

import Animator
import Animator.Timeline as Timeline
import Browser
import Browser.Events
import Html
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode
import Theme
import Time
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
                { title = "Timeline animations"
                , body = [ view model ]
                }
        , update = update
        , subscriptions =
            \model ->
                if Timeline.isRunning model.timeline then
                    Browser.Events.onAnimationFrame Tick

                else
                    Sub.none
        }


init () =
    ( { ui = Ui.Anim.init
      , checked = False
      , email = ""
      , show = False
      , timeline = Timeline.init Left
      , position = Left
      }
    , Cmd.none
    )


type Msg
    = Ui Ui.Msg
    | Tick Time.Posix
    | Clicked
    | ShowClicked
    | GoTo Position


type alias Model =
    { ui : Ui.State
    , checked : Bool
    , email : String
    , show : Bool
    , timeline : Ui.Anim.Timeline Position
    , position : Position
    }


type Position
    = Left
    | Center
    | Right


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ui uiMsg ->
            let
                ( newUi, cmd ) =
                    Ui.Anim.update Ui
                        uiMsg
                        model.ui
            in
            ( { model | ui = newUi }, cmd )

        Tick time ->
            ( { model | timeline = Timeline.update time model.timeline }
            , Cmd.none
            )

        GoTo position ->
            ( { model
                | timeline =
                    Timeline.to (Animator.ms 2000)
                        position
                        model.timeline
                , position = position
              }
            , Cmd.none
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
    Ui.layout
        (Ui.default
            |> Ui.withAnimation
                { toMsg = Ui
                , state = model.ui
                }
        )
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
        , Ui.Events.onClick Clicked
        , Ui.inFront
            (Ui.column []
                [ Ui.text <| Debug.toString (Timeline.current model.timeline)
                , Ui.text <| Debug.toString (Timeline.arrived model.timeline)
                , Ui.text <| Debug.toString (Timeline.progress model.timeline)
                ]
            )
        ]
        (Ui.column
            [ Ui.width (Ui.px 800)
            , Ui.centerX
            , Ui.padding 100
            , Ui.spacing 100
            ]
            [ Theme.h1 "Click to animate"
            , Ui.row [ Ui.spacing 20 ]
                [ box [ Ui.Events.onClick (GoTo Left) ]
                , box [ Ui.Events.onClick (GoTo Center) ]
                , box [ Ui.Events.onClick (GoTo Right) ]
                ]
            , box
                [ Ui.Anim.onTimeline model.timeline <|
                    \state ->
                        case Debug.log "TIMELINE STATE" state of
                            Left ->
                                [ Ui.Anim.x 0
                                ]

                            Center ->
                                [ Ui.Anim.x 400
                                ]

                            Right ->
                                [ Ui.Anim.x 600
                                ]
                ]
            , box
                [ Ui.Anim.transition (Ui.Anim.ms 2000) <|
                    case model.position of
                        Left ->
                            [ Ui.Anim.x 0
                            ]

                        Center ->
                            [ Ui.Anim.x 400
                            ]

                        Right ->
                            [ Ui.Anim.x 600
                            ]
                ]
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
