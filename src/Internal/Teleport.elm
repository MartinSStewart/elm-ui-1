module Internal.Teleport exposing
    ( persistentClass, persistentId
    , Box, Data(..), Event, Trigger(..), decode, encodeCss, stringToTrigger
    )

{-| This is data that is teleported to the central state.

@docs persistentClass, persistentId

-}

import Animator
import Json.Decode as Decode
import Json.Encode as Encode


persistentClass : String -> String -> String
persistentClass group instance =
    "elm-ui-persistent-" ++ group ++ "-" ++ instance


persistentId : String -> String -> Encode.Value
persistentId group instance =
    Encode.object
        [ ( "group", Encode.string group )
        , ( "instance", Encode.string instance )
        ]



-- ENCODER


encodeCss : Animator.Css -> Encode.Value
encodeCss css =
    Encode.object
        [ ( "hash", Encode.string css.hash )
        , ( "keyframes", Encode.string css.keyframes )
        , ( "transition", Encode.string css.transition )
        , ( "props", Encode.list encodeProp css.props )
        ]


encodeProp : ( String, String ) -> Encode.Value
encodeProp ( key, value ) =
    Encode.object
        [ ( "key", Encode.string key )
        , ( "value", Encode.string value )
        ]



-- DECODER


type Data
    = Css Animator.Css


type Trigger
    = OnHover
    | OnRender
    | OnFocus
    | OnFocusWithin
    | OnActive
    | OnDismount


stringToTrigger : String -> Maybe Trigger
stringToTrigger str =
    case str of
        "on-rendered" ->
            Just OnRender

        "on-focused" ->
            Just OnRender

        "on-hovered" ->
            Just OnHover

        "on-focused-within" ->
            Just OnFocusWithin

        _ ->
            Nothing


type alias Box =
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    }


type alias Event =
    { timestamp : Float
    , data : List Data
    }


decode : Decode.Decoder Event
decode =
    Decode.map2 Event
        (Decode.field "timeStamp" Decode.float)
        (Decode.field "target"
            (Decode.field "data-elm-ui"
                (Decode.list decodeData)
            )
        )


decodeData : Decode.Decoder Data
decodeData =
    Decode.map Css decodeCss


decodeCss : Decode.Decoder Animator.Css
decodeCss =
    Decode.map4 Animator.Css
        (Decode.field "hash" Decode.string)
        (Decode.field "keyframes" Decode.string)
        (Decode.field "transition" Decode.string)
        (Decode.field "props" (Decode.list decodeProp))


decodeProp : Decode.Decoder ( String, String )
decodeProp =
    Decode.map2 (\key value -> ( key, value ))
        (Decode.field "key" Decode.string)
        (Decode.field "value" Decode.string)
