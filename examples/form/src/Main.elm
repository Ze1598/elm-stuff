module Main exposing (..)

-- Input a user name and password. Make sure the password matches
-- >elm reactor

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Char exposing (isDigit, isUpper, isLower)

-- MAIN
main = Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }

init : Model
init = Model "" "" ""

-- UPDATE
type Msg
    = Name String
    | Password String
    | PasswordAgain String

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }
        
        Password password ->
            { model | password = password }
        
        PasswordAgain password ->
            { model | passwordAgain = password }

-- VIEW
-- The HTML shown, three input fields plus a div with the password match result
-- All of these HTML elements are created by helped functions (`viewInput` and)
-- `viewValidation`
view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]

-- Create an input element based on the attributes received
-- <input type=t placeholder=p value=v onInput=toMsg />
viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []

-- Create a div for the password matching notification
-- <div style="color:color;">text</div>
viewValidation : Model -> Html msg
viewValidation model =
    -- Don't show a validation message while the user has not typed a
    -- password in both fields
    if String.length model.password == 0 || String.length model.passwordAgain == 0 then
        div [ style "color" "white"] [ text "" ]
    else
        let passwordValidation = validatePassword model
        in div [ style "color" (Tuple.first passwordValidation)] [ text (Tuple.second passwordValidation) ]

-- Validate the password matching
-- Password needs to be longer than 8 characters, contain at least 1 upper
-- case character, 1 lower case and 1 digit
validatePassword : Model -> (String, String)
validatePassword model =
    -- Mismatched password
    if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
    -- Short password
    else if String.length model.password < 9 then
        ("orange", "Password needs to be longer than eight characters")
    -- Missing uper case character
    else if not (String.any isLower model.password) then
        ("orange", "Password must contain at least one lower case character")
    -- Missing lower case character
    else if not (String.any isUpper model.password) then
        ("orange", "Password must contain at least one upper case character")
    -- Missing digit
    else if not (String.any isDigit model.password) then
        ("orange", "Password must contain at least one digit")
    -- Good password
    else
        ("green", "OK")