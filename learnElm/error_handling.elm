-- `Maybe` is a type of two variants: `Nothing` for when there is no value or `Just a` for when
-- there's a value (no matter if it's String, Float, etc.)
type Maybe a
    = Just a
    | Nothing
-- Just 3.14 : Maybe Float
-- Just "hi" : Maybe String
-- Just True : Maybe Bool
-- Nothing   : Maybe a
---------------------------------------------------------------------------------------------------
-- For instance, when you want to model a user but some information may be given only at a
-- later time, one solution can be
type alias User =
    { name : String
    , age : Maybe Int
    }
-- This means `User`s will always have a name associated, but the age is optional, it might
-- be given along with the name, at a later time or perhaps never
sue : User
sue =
    { name = "Sue"
    , age = Nothing
    }
-- { age = Nothing, name = "s" } : User
tom : User
tom =
    { name = "Tom"
    , age = Just 24 
    }
-- { age = Just 24, name = "Tom" } : User
-- Then it is possible to code explicitly against the possible variants
canVote : User -> Bool
canVote user = 
    case user.age of
        Nothing -> False

        Just age ->
            age >= 18
---------------------------------------------------------------------------------------------------
-- Finally, don't overuse the `Maybe` type. While this is valid code
type alias Person =
    { name : String
    , age : Maybe Int
    , height : Maybe Float
    , weight : Maybe Float
    }
-- all that "optional" information could be extracted into its own type
type Person
    = Less String
    | More String Info

type alias Info = 
    { age : Int
    , height : Float
    , weight : Float
    }
-- This way the `Person`'s name is obligatory, period. The remaining information will
-- only appear in the `More` variant, which holds all that extra information in a
-- single record
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- The `Result` type is responsible for giving information when the compiler shows errors
type Result error value
    = Ok value
    | Err error
-- We can then use `Result` to display error messages
validAge : String -> Result String Int
validAge input = 
    case String.toInt input of
        Nothing ->
            Err "Enter a number!"
        
        Just age ->
            if age < 0 then
                Err "Enter a valid age"
            
            else if age > 135 then
                Err "Are you sure about that?"
            
            else
                Ok age
-- validAge "abc" -- Err "Enter a number!"
-- validAge "-13" -- Err "Enter a valid age"
-- validAge "24"  -- Ok 24
-- validAge "150" -- Err "Are you sure about that?"
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- More detailed Errors
-- The `Error` type is especially useful for dealing with HTTP requests
type Error
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Int
    | BadBody String
-- Ok "All happy ..." : Result Error String
-- Err Timeout        : Result Error String
-- Err NetworkError   : Result Error String