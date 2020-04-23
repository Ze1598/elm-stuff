-- The idea behind for generating random values starts with creation of a `Generator` that
-- specifies how to generate those random values
import Random

probability : Random.Generator Float
probability =
    Random.float 0 1

roll : Random.Generator Int
roll =
    Random.int 1 6

usuallyTrue : Random.Generator Bool
usuallyTrue =
    Random.weighted (80, True) [ (20, False) ]

-- None of the functions above generate values on their own, rather they have specified how
-- to generate a float between 0 and 1, how to generate an integer between 1 and 6 and how
-- to generate a boolean value, knowing that 80% of the time it should be `True`. These
-- functions create a command (`Cmd`) that generates a message (`Msg` ) to be passed to the
-- `update` function in applications
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Example to create a slot machine
import Random

-- The possible symbols for each slot
type Symbol
    = Cherry
    | Seven
    | Bar
    | Grapes

-- Generator for picking a random symbol for one of the slots
symbol : Random.Generator Symbol
symbol =
    Random.uniform Cherry [ Seven, Bar, Grapes ]

-- A `Spin` is a record that contains the symbol generated for each slot
type alias Spin =
    { one : Symbol
    , two : Symbol
    , three : Symbol
    }

-- Function responsible for executing the random generator command (`Cmd`)
-- (creates a `Spin` record by randomly picking a symbol for each of the three slots with
-- the `symbol` function)
spin : Random.Generator Spin
spin =
    Random.map3 Spin symbol symbol symbol
-- To get the actual `Spin` record we would need to call something like
-- `Random.generate NewSpin spin` in the application, knowing that the `Msg` has a `NewSpin`
-- variant