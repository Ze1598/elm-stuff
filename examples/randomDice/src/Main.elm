module Main exposing (..)

-- Press a button to generate a random number between 1 and 6

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


{-| Once the user clicks the "Roll" button, send a `Roll` variant `Msg`.

The `Roll` variant commands the program to "roll the dice", i.e., generate a random integer between 1 and 6. Generating this integer triggers a new `Msg` of the `NewFace` variant.

The `NewFace` variant updates the die face (the integer) stored in the model and doesn't provide further commands for the program.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
