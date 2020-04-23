module Main exposing (..)

-- Show the current time in your time zone

import Browser
import Html exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


{-| Initialize the application by commanding it to adjust the time zone to the user's time zone.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


{-| When the application first starts, the `Msg` will update the time zone (`AdjustTimeZone`); the remaining updates will be for updating the clock, once every second, triggered by the subscription.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


{-| Every second (1000 miliseconds), send the current time (POSIX, seconds passed since the epoch) in a `Tick` `Msg`.

`Time.every` takes two parameters: how long to wait until executing the function again (in miliseconds) and the function responsible for turning the time into a `Msg` (in this case the time will be sent as a `Tick` variant of `Msg`).
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


{-| The current time is not stored, rather, the current time (hour, minute and second) is calculated by converting the number of seconds since the first epoch (January 1, 1970, 00:00:00 (UTC)) to the user's time zone.
-}
view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
