-- Decoders in Elm allow access to JSON fields
-- Let's say that we got this JSON object by making a GET request to a sample URL
-- {
--     "name": "Tom",
--     "age": 42
-- }
-- Then, we need the following two functions (decoders) to access the `name` and the `age` fields,
-- respectively
import Json.Decode exposing (Decoder, map2, field, string, int)
nameDecoder : Decoder String
nameDecoder =
    field "name" string
ageDecoder : Decoder Int
ageDecoder =
    field "age" int
-- The `field` function takes two arguments: the name of the field to be accessed and the funtion
-- to apply to that field.
-- In the above decoders, we acccess the `name` and extract its value as a String and access the
-- `age` to extract its value as a Int.
---------------------------------------------------------------------------------------------------
-- Now let's say by making the following GET request we receive the following JSON object
getExample : Cmd Msg
getExample =
    Http.get
        { url = "https://test.api.com/"
        , expect = Http.expectJson MsgVariant nameDecoder
        }
-- What the `expect` field is saying is that we will receive the response as JSON, and when it
-- arrives it should extract the value of the `name` field using the `nameDecoder` function, and
-- pass that value to the `Msg`
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- However, if we wanted to extract both fields from that initial JSON at once, the decoder
-- function would look like this (notice the usage of a type alias to make the code cleaner)
type alias Person =
    { name : String
    , age : Int
    }

personDecoder : Decoder Person
personDecoder =
    map2 Person
        (field "name" string)
        (field "age" int)
-- This new decoder combines two single decoders to extract two fields at once from the JSON response.
-- Plus, with the help of the `Person` type alias, we can specify that we are getting out a record
-- with a String and an Int fields.