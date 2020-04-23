module Main exposing (..)

-- Press a button to send a GET request for random cat GIFs
-- >elm reactor

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



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


{-| The program sends a GET request for a cat gif on start-up (calls the `getRandomCatGif` which returns a `Cmd`)
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomCatGif )



-- UPDATE


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)


{-| If the new `Msg` is a `MorePlease` variant, it means a new gif should be fetched; but if the variant is `GotGif`, there's no need to send more requests, no matter if the previous request ended in success or failure.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( Loading, getRandomCatGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



-- SUBSCRIPTIONS


{-| There is nothing to subscribe to.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        ]


{-| `viewGif` is responsible for managing most of the HTML, depending on the state of the `model` and consequently of the ongoing GET request for a cat gif.

A failed request will let the user send a new request, an ongoing state displays a text message and, lastly, upon a succesfuly request the fetched gif is displayed, along with a button to fetch a new gif.

-}
viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div []
                [ text "I could not load a random cat for some reason. "
                , button [ onClick MorePlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
                , img [ src url ] []
                ]



-- HTTP


{-| Execute the GET request for a cat gif.

Expect to receive the response as JSON, and when it arrives extract the gif URL using the `gifDecoder`function as a String. Finally, that String is passed to the `GotGif` variant of `Msg`.

-}
getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


{-| Access the `data` field of the JSON object, and then get the value of the `image_url` key, as a String.

The `field` functions take two parameters: the name of the field being accessed and the function to apply next. In this case, we access the `data` field and then apply to it another call the `field` function. This second call accesses the `image_url` field and whatever is found there is turned into a String.

-}
gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)



-- Sample of the JSON response for a successful request
-- {
--   "data": {
--     "type": "gif",
--     "id": "l2JhxfHWMBWuDMIpi",
--     "title": "cat love GIF by The Secret Life Of Pets",
--     "image_url": "https://media1.giphy.com/media/l2JhxfHWMBWuDMIpi/giphy.gif",
--     "caption": "",
--     ...
--   },
--   "meta": {
--     "status": 200,
--     "msg": "OK",
--     "response_id": "5b105e44316d3571456c18b3"
--   }
-- }
