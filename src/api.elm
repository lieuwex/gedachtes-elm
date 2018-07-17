module API exposing (..)

import Http exposing (..)
import Model exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (date)

addToList : String -> Cmd Msg
addToList entry =
    let
        trimmed = String.trim entry
        body = Http.stringBody "text/plain" trimmed
    in
        if String.length trimmed > 0 then
            Http.post "http://94.209.156.25:1337/" body entryDecoder
            |> Http.send NewEntry
        else
            Cmd.none

getList : Cmd Msg
getList =
    Http.get "http://94.209.156.25:1337/" entriesDecoder
    |> Http.send Entries

entryDecoder : Decoder Entry
entryDecoder =
    map2 Entry
    (field "date" date)
    (field "content" string)

entriesDecoder : Decoder (List Entry)
entriesDecoder = list entryDecoder
