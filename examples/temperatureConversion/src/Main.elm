module Main exposing (..)

import Browser
import Html exposing (Html, div, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { inputC : String
    , inputF : String
    }


init : Model
init =
    { inputC = ""
    , inputF = ""
    }



-- UPDATE


{-| `Msg`, i.e., user input, can either come from the Celsius input field (`ChangeC`)
or from the Fahrenheit's field (`ChangeF`).
-}
type Msg
    = ChangeC String
    | ChangeF String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeC newCelsius ->
            { model | inputC = newCelsius }

        ChangeF newFahrenheit ->
            { model | inputF = newFahrenheit }



-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ div []
            [ input [ value model.inputC, onInput ChangeC, style "width" "40px" ] []
            , text " °C = "
            , span [ style "color" (colorPicker model.inputC) ] [ text (celsiusToFahrenheit model.inputC) ]
            , text " °F"
            ]
        , div []
            [ input [ value model.inputF, onInput ChangeF, style "width" "40px" ] []
            , text " °F = "
            , span [ style "color" (colorPicker model.inputF) ] [ text (fahrenheitToCelsius model.inputF) ]
            , text " °C"
            ]
        ]


{-| Validate that the input is an actual number, by trying to cast
the String into a Float.
-}
validateInput : String -> Bool
validateInput input =
    case String.toFloat input of
        Just _ ->
            True

        Nothing ->
            False


{-| Convert the input temperature in Celsius degrees to Fahrenheit. If the input
is a number, then perform the conversion; otherwise return exclamation points.
-}
celsiusToFahrenheit : String -> String
celsiusToFahrenheit degrees =
    case String.toFloat degrees of
        Just temp ->
            String.fromFloat (temp * 1.8 + 32)

        Nothing ->
            "???"


{-| Convert the input temperature in Fahrenheit degrees to Celsius. If the input
is a number, then perform the conversion; otherwise return exclamation points.
-}
fahrenheitToCelsius : String -> String
fahrenheitToCelsius degrees =
    case String.toFloat degrees of
        Just temp ->
            String.fromFloat ((temp - 32) * 5 / 9)

        Nothing ->
            "???"


{-| Choose the color to style the conversion output. Display the output for valid
input in blue and in red for invalid input.
-}
colorPicker : String -> String
colorPicker input =
    if validateInput input == True then
        "blue"

    else
        "red"
