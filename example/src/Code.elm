
import Http exposing (Error)
import Parser

url : String
url name =
  "https://raw.githubusercontent.com/Orasund/elm-ui-widget/master/example/src/Example/" ++ name ++ ".elm"

get : String -> (Result Error String -> msg) -> Cmd msg
get name msg =
Http.get
 { url = url name
  , expect =
      Http.expectString msg
  }

toAscii : String -> String
toAscii =
  String.foldr
    (\char ->
      (case char of
        ' ' -> "%20"
        '!' -> "%21"
        '"' -> "%22"
        '#' -> "%23"
        '$' -> "%24"
        '%' -> "%25"
        '&' -> "%26"
        '\'' -> "%27"
        '(' -> "%28"
        ')' -> "%29"
        '*' -> "%2A"
        '+' -> "%2B"
        ',' -> "%2C"
        '-' -> "%2D"
        '.' -> "%2E"
        '/' -> "%2F"
        ':' -> "%3A"
        ';' -> "%3B"
        '<' -> "%3C"
        '=' -> "%3D"
        '>' -> "%3E"
        '?' -> "%3F"
        '@' -> "%40"
        '[' -> "%5B"
        '\\' -> "%5C"
        ']' -> "%5D"
        '{' -> "%7B"
        '|' -> "%7C"
        '}' -> "%7D"
        _ -> String.fromChar char
      )
      |> String.append
    )

replaceModuleName : String -> String
replaceModuleName =
  case String.split "\n" of
    head :: tail ->
      toAscii "module Main exposing (main)" :: tail
      |> String.join "\n"
    [] -> ""

generateLink : 
  { title : String
  , html : String
  , packages : List (String,String)
  , elmVersion : String
  } -> String -> String
generateLink {title,html,packages,elmVersion} elmCode =
  "https://ellie-app.com/a/example/v1?"
    ++ "title=" ++ toAscii title
    ++ "&elmcode=" ++ toAscii elmCode
    ++ "&packages=" ++ toAscii