-- Don't bother running this file, instead copy and paste it to the console
-- >elm repl

-- Basic function definition
greet name = "Hello " ++ name ++ "."
greetJose = greet "José"
---------------------------------------------------------------------------------------------------
-- Function definition with multiple parameters
madlib name adjective = "The ostentatious " ++ name ++ " wears " ++ adjective ++ " shorts."
madlibCat = madlib "cat" "cool"
madlibButterfly = madlib ("butter" ++ "fly") "metallic"
---------------------------------------------------------------------------------------------------
-- Function with conditional logic
condGreet name gender = 
    if String.toLower gender == "m" then
        "Greetings Sir " ++ name
    else
        "Greetings Ma'am " ++ name
greetJoker = condGreet "Joker" "M"
greetMimi = condGreet "Mimi" "f"
---------------------------------------------------------------------------------------------------
-- Lists's values must all have the same type
namesList = ["Alice", "Bob", "Chuck"]
namesListIsEmpty = List.isEmpty namesList -- False
namesListLength = List.length namesList -- 3
namesListReversed = List.reverse namesList -- ["Chuck","Bob","Alice"]
---------------------------------------------------------------------------------------------------
-- List of numbers
numbersList = [4, 2, 1, 3]
numbersListSorted = List.sort numbersList -- [1,2,3,4]
-- Map example
increment n = n + 1
numbersListInc = List.map increment numbersList -- [5,3,2,4]
---------------------------------------------------------------------------------------------------
-- Recursive function
factorial x = 
    if x == 1 then
        1
    else
        x * factorial (x-1)
factorial5 = factorial 5 -- 120
---------------------------------------------------------------------------------------------------
-- Tuples example
verifyName name = 
    if String.length name <= 20 then
        (True, "Name checks out")
    else
        (False, "Don't let them in")
verifyNameValid = verifyName "José Costa" -- (True, "Name checks out")
verifyNameInvalid = verifyName "fnlsdjvnrjv jflksjvçgkçjkjegkljr" -- (False, "Don't let them in")
---------------------------------------------------------------------------------------------------
-- Records in Elm work as hash maps and allow for data of different types
recordExample = 
    { first = "José"
    , last = "Costa"
    , age = 22
    }
recordExampleFirst = recordExample.first -- "José"
recordExampleLast = recordExample.last -- "Costa"
recordExampleAge = recordExample.age -- 22
-- Record fields can be access with "field access functions"
recordA = 
    { first = "Person"
    , last = "A"
    }
recordB = 
    { first = "Person"
    , last = "B"
    }
recordC = 
    { first = "Person"
    , last = "C"
    }
-- Create the "field access function" to access a field called `last`
recordsLastField = List.map .last [recordA, recordB, recordC] -- ["A","B","C"]
-- And to update values (creates a new record!)
recordExampleUpdated = { recordExample | last = "Silva"}
-- To update multiple records with the same logic
updateRecord record = 
    { record | first = "Record"}
recordAUpdated = updateRecord recordA -- { first = "Record", last = "A" }
recordBUpdated = updateRecord recordB -- { first = "Record", last = "B" }
recordCUpdated = updateRecord recordC -- { first = "Record", last = "C" }