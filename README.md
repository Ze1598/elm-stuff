# elm-stuff
Example applications of Elm (mainly from the official docs with some improvements and explanations)

I highly recommend reading through the official [Elm guide](https://guide.elm-lang.org/). It is a complete overview of the main language features and by the end you will have a solid understanding of how you can work with Elm and how it can communicate with JavaScript.

I read through the guide and decided to write down notes about the language and save some of the example applications shown.

The [learnElm](https://github.com/Ze1598/elm-stuff/tree/master/learnElm) folder contains Elm scripts with notes about particular subjects of the language.

The [examples](https://github.com/Ze1598/elm-stuff/tree/master/examples) folder contains multiple examples that are shown throughout the official Elm guide. They have plenty of comments to explain what's going on in the code, and some include the improvements pointed out in the docs after the original example (for instance, the two way conversion in the temperatureConversion example). 
For most of the examples, you can run them with `elm reactor` in the terminal and then go to localhost:8000 to open the Main.elm file. 
For the examples that have a /js folder, this means the Elm script of that example is intended to be compiled to JS. Simply opening the index.html of that /js folder is enough to see the application running (the elm.js file is the compiled Elm script).

