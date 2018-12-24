module API exposing (..)

import Http
import HttpBuilder exposing (..)
import Model exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Extra exposing (datetime)

getEntries : Cmd ApiMsg
getEntries =
    HttpBuilder.get "/entries/"
    |> withExpect (Http.expectJson entriesDecoder)
    |> send Entries

addEntry : Body -> Cmd ApiMsg
addEntry body =
    let trimmed = String.trim body
    in
        HttpBuilder.post "/entries/"
        |> withStringBody "text/plain" trimmed
        |> withExpect (Http.expectJson entryDecoder)
        |> send NewEntry

removeEntry : Id -> Cmd ApiMsg
removeEntry id =
    let url = "/entries/" ++ id
    in
        HttpBuilder.delete url
        |> withExpect (Http.expectJson entryDecoder)
        |> send RemovedEntry

changeEntry : Id -> Body -> Cmd ApiMsg
changeEntry id body =
    let
        url = "/entries/" ++ id
        trimmed = String.trim body
    in
        HttpBuilder.put url
        |> withStringBody "text/plain" trimmed
        |> withExpect (Http.expectJson entryDecoder)
        |> send ChangedEntry

entryDecoder : Decoder Entry
entryDecoder =
    map3 Entry
    (field "id" string)
    (field "content" string)
    (field "date" datetime)

entriesDecoder : Decoder (List Entry)
entriesDecoder = list entryDecoder
