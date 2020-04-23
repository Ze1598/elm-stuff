port module Main exposing (..)

-- Receive input from the user and save it on localStorage
-- Writing and retrieval is done by JS, hence the exchange
-- of JSON objects between JS and Elm (rather, the compiled
-- Elm-compiled JS file)

-- To run this script, first compile it to JS
-- >elm make src/Main.elm output=elm.js
-- Then load the compiled file in an HTML file, and add
-- the necessary JS code to establish the interoperability.
-- At the end, simply open the HTML file to run the application
-- Note: the following JS code assumes there is a <div>
-- with a myapp id

-- var storedData = localStorage.getItem("myapp-model");
-- var flags = storedData ? JSON.parse(storedData) : null;

-- var app = Elm.Main.init({
--     node: document.getElementById("myapp"),
--     flags: flags
-- });

-- app.ports.setStorage.subscribe(function (state) {
--     localStorage.setItem("myapp-model", JSON.stringify(state));
-- });

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Json.Encode as E



-- MAIN


main : Program E.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { name : String
    , email : String
    }



-- `init` loads the information from the localStorage through a JSON
-- object that JS passes as a flag
-- If the decoding is successful, then save the decoded record as the\
-- model, otherwise create the model by hand, with both of its fields as\
-- empty strings


init : E.Value -> ( Model, Cmd Msg )
init flags =
    ( case D.decodeValue decoder flags of
        Ok model ->
            model

        Err _ ->
            { name = "", email = "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NameChanged String
    | EmailChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameChanged name ->
            ( { model | name = name }
            , Cmd.none
            )

        EmailChanged email ->
            ( { model | email = email }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput NameChanged, value model.name ] []
        , input [ type_ "text", placeholder "Email", onInput EmailChanged, value model.email ] []
        ]



-- PORTS


port setStorage : E.Value -> Cmd msg



-- We want to `setStorage` on every update, so this function adds
-- the setStorage command on each step of the update function.
-- `updateWithStorage` uses `update` to update the new information stored in\
-- the `model` and then sends that encodes that updated model in JSON to\
-- pass it on ot JS


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg oldModel =
    let
        ( newModel, cmds ) =
            update msg oldModel
    in
    ( newModel
    , Cmd.batch [ setStorage (encode newModel), cmds ]
    )



-- JSON ENCODE/DECODE
-- Create a JSON object, transforming both the of the model's fields into\
-- Strings (`name` and `email`)


encode : Model -> E.Value
encode model =
    E.object
        [ ( "name", E.string model.name )
        , ( "email", E.string model.email )
        ]



-- Decode the JSON object received from the JS flags, converting both fields\
-- into Strings


decoder : D.Decoder Model
decoder =
    D.map2 Model
        (D.field "name" D.string)
        (D.field "email" D.string)
