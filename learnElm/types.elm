-- Pipe operator: `x |>` f is equivalente to `f x`
sanitizeInput : String -> Maybe Int
sanitizeInput input = 
    String.toInt (String.trim input)
-- is equivalent to
sanitizeInput : String -> Maybe Int
sanitizeInput input = 
    input
    |> String.trim
    |> String.toInt
---------------------------------------------------------------------------------------------------
-- For instance, the following function takes two parameters, two Floats. Thus, the type
-- annotations uses the arrows to separate arguments, sort of as if the function only takes
-- one parameter at a time even though the function receives two. Hence, the type annotation
-- for this `hypotenuse` function can be read as "`hypotenuse` receives a Float parameter, 
-- followed by a second Float parameter, which then returns a Float "
hypotenuse : Float -> Float -> Float
hypotenuse a b =
    sqrt (a^2 + b^2)
-- Looking at the String.length type annotation, which is
String.length -- <function> : String -> Int
-- we can see that length receives a single String parameter and then returns a single Int value
-- (the length of the string received)

-- Equally, a type annotation can cite a type variable, usually called `a` or `b`, simply to
-- represent the parameter the function is looking for. In the case of List.reverse
List.reverse -- <function> : List a -> List a
-- The function takes and returns only a List parameter that does not specify the data type of
-- what is inside the List. As long as it receives a List, it's all good and will return that
-- List reversed
List.reverse [1,2,3,4] -- [4,3,2,1]
List.reverse ["a","b","c"] -- ["c", "b", "a"]
---------------------------------------------------------------------------------------------------
-- There is also something called constrained types, which means only certain types can be used
-- to fill a type need:
-- * number permits Int and Float
-- * appendable permits String and List a
-- * comparable permits Int, Float, Char, String, and lists/tuples of comparable values
-- * compappend permits String and List comparable
---------------------------------------------------------------------------------------------------
-- Type aliases are a simply a name to represent custom annotations. In the following example,
-- the `Person` type alias represents a record with one String field (`name`) and one Int field
-- (`Age`)
type alias Person =
    { name : String
    , age : Int
    }
-- And now `Person` can be used in the type annotation of the `isOldEnoughToVote` function. The
-- function receives a `Person` as its only parameter (i.e., a record with `name` and `age` fields)
-- and returns a Bool
-- Without the type alias
isOldEnoughToVote : { name : String, age : Int } -> Bool
-- With the type alias
isOldEnoughToVote : Person -> Bool
isOldEnoughToVote person = 
    person.age >= 18
---------------------------------------------------------------------------------------------------
-- When creating a type alias for records, Elm generates an additioanl Record Constructor. These
-- constructors allow for the creation of new records of that type using a syntax similar to that
-- of function calls
type alias Person =
    { name : String
    , age : Int
    }
-- With the `Person` type alias/record constructor, we can now easily create `Person` records
Person "José" 22 -- { age = 22, name = "José" }
Person "Michael" 46 -- { age = 46, name = "Michael" }
---------------------------------------------------------------------------------------------------
-- Custom Types creates a new type as needed. For example, imagine a chat room, where there are
-- registered users and visitors. Then we can create a `User` type and specify what kind (variants)
-- of users are possible. Furthermore, we can also specify the data associated to each variant.
-- In this case `Regular` users have a String and an Int (say name and id), while `Visitor`s only
-- have a String (name). `Anonymous` are another type of `User`, but with no data associated
type User 
    = Regular String Int
    | Visitor String
    | Anonymous
-- And now users can be created as such
Regular "Michael" 1 -- Regular "Michael" 1 : User
Visitor "jim" -- Visitor "jim" : User
Anonymous -- Anonymous : User
-- And you can create a custom type for the messages like so
type Msg
    = PressedEnter
    | ChangedDraft String
    | ReceivedMessage { user : User, message : String }
    | ClickedExit
---------------------------------------------------------------------------------------------------
-- We can also use a switch `case` statement for conditional behavior based on which variant is
-- received. Again with the `User` custom type, we have `Regular`, `Visitor` or `Anonymous` users:
type User 
    = Regular String Int
    | Visitor String
    | Anonymous
showName : User -> String
showName user =
    case user of
        Regular name id ->
            "Regular user " ++ name
        
        Visitor name ->
            "Visitor " ++ name
        
        Anonymous ->
            "Anonymous user"
-- Note: when there is unused data like the `id` for the first case branch, that unused data can be
-- called simply `_` (underscore) to show explicitly that it won't be used. Its existence is
-- acknowledged, but will not be used
-- The function takes one `User` as its sole parameter and then returns a custom message for each
-- type
showName (Regular "Michael" 1) -- "Regular user Michael"
showName (Visitor "jim") -- "Visitor jim"
showName (Anonymous) -- "Anonymous user"
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Example of combining custom types, type aliases and record constructors
-- Create the user custom type
type User 
    = Regular String Int
    | Visitor String
    | Anonymous
-- Create a Regular user
michael : User
michael = Regular "Michael" 1 -- Regular "Michael" 1 : User
-- Create a type alias for a finished message, which includes the name of who created it and
-- the message text
type alias FinishedMessage = {user: User, message: String}
-- Now create a custom type for the messages
type Msg
    = PressedEnter
    | ChangedDraft String
    | ReceivedMessage FinishedMessage
    | ClickedExit
-- To create a ReceivedMessage, first we create a finished message
messageFinished : FinishedMessage
messageFinished = 
    { user =  michael
    , message = "That's what she said"
    }
-- { message = "That's what she said", user = Regular "Michael" 1 } : FinishedMessage
-- And now we finally create the received message
messageReceived : Msg
messageReceived = ReceivedMessage messageFinished
-- ReceivedMessage { message = "That's what she said", user = Regular "Michael" 1 } : Msg