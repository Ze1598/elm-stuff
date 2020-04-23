module Main exposing (..)

-- Make a GET request to load a book called "Public Opinion"
-- >elm reactor
-- Using `Browser.element` allows for the program to communicate with the outside world

import Browser
import Html exposing (Html, pre, text)
import Http



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success String


{-| `init` describes how to initalize the program.

In this case, the program starts by commanding the execution of an HTTP GET request. The command (`Cmd`) will eventually produce a `Msg` that is fed to the `update` function.

The result of the GET request is expected to be a String. In fact, the `expect` field is specifying that the result is expected to be a String and, when it arrives, it is turned into a `GotText` variant of `Msg`.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )



-- UPDATE

{-| `Msg` has a single variant, `GotText`, which contains information about the GET request's result. This result will have an associated `Http.Error` for failure and a `String` (the desired book) for success.
-}
type Msg
    = GotText (Result Http.Error String)


{-| `update` returns the updated model and the next command to be executed.

In this case, since the sole purpose was to get the book with the initial GET request, there is nothing more to do at this point. For a successful request, we stop because we got what we want; for a failed request we stop because we couldn't retrieve the book.

`update` first pattern matches the `Msg` variant and then pattern matches the type of result obtained, either a succesful response with the book (`Ok`) or a failed request (`Err`).
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


{-| In the case of this program there is nothing to subscribe to. As soon as there is a response
to the initial HTTP GET request, the model is updated accordingly and that's it.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            text "I was unable to load your book."

        Loading ->
            text "Loading..."

        Success fullText ->
            pre [] [ text fullText ]
