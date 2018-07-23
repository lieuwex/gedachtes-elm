module Main exposing (main)

import Html exposing (program)
import Model exposing (..)
import View exposing (view)
import API exposing (getEntries, addEntry, removeEntry, changeEntry)
import List exposing (..)
import Time exposing (Time, second)
import Sed exposing (isValidSed, sed)
import List.Extra exposing (last)
import Date exposing (fromTime)
import Task

edit : Id -> Body -> Cmd Msg
edit id body =
    let trimmed = String.trim body
    in Cmd.map ApiMsg <|
        if String.isEmpty trimmed then
            removeEntry id
        else
            changeEntry id trimmed

updateApiMsg : ApiMsg -> Model -> (Model, Cmd Msg)
updateApiMsg msg model =
    case msg of
        Entries res -> case res of
            Err _ -> (model, Cmd.none)
            Ok entries -> ({ model | entries = entries }, Cmd.none)

        NewEntry res -> case res of
            Err _ -> (model, Cmd.none)
            Ok entry ->
                let entries = append model.entries [entry]
                in ({ model | entries = entries, input = "" }, Cmd.none)

        ChangedEntry res -> case res of
            Err _ -> (model, Cmd.none)
            Ok entry ->
                let fn x = if x.id == entry.id
                           then entry
                           else x
                    entries = map fn model.entries
                in ({ model | entries = entries }, Cmd.none)

        RemovedEntry res -> case res of
            Err _ -> (model, Cmd.none)
            Ok entry ->
                let entries = filter (\{id} -> id /= entry.id) model.entries
                in ({ model | entries = entries }, Cmd.none)

updateEditing : Msg -> Model -> (Model, Cmd Msg)
updateEditing msg model =
    case model.state of
        Normal -> (model, Cmd.none)
        Editing id input -> case msg of
            EditInput str ->
                ({ model | state = Editing id str }, Cmd.none)

            EditKeyDown key ->
                if key == 13 then
                    ({ model | state = Normal }, edit id input)
                else
                    (model, Cmd.none)

            _ -> (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ApiMsg apiMsg ->
            updateApiMsg apiMsg model

        EditInput _ ->
            updateEditing msg model
        EditKeyDown _ ->
            updateEditing msg model

        NewInput str ->
            ({ model | input = str }, Cmd.none)

        NewKeyDown key ->
            if key /= 13 || String.isEmpty model.input then -- nop
                (model, Cmd.none)
            else if isValidSed model.input then -- edit
                let x = last model.entries
                in case x of
                    Nothing -> (model, Cmd.none)
                    Just entry ->
                        let replaced = sed model.input entry.content
                        in ({ model | input = "" }, edit entry.id replaced)
            else -- new entry
                (model, addEntry model.input |> Cmd.map ApiMsg)

        Change entry ->
            ({ model | state = Editing entry.id entry.content }, Cmd.none)

        Tick time ->
            ({ model | now = fromTime time }, Cmd.map ApiMsg getEntries)

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (second*5) Tick

init : (Model, Cmd Msg)
init =
    let
        m =
            { entries = []
            , input = ""
            , state = Normal
            , now = fromTime 0
            }
    in
        (m, Task.perform Tick Time.now)

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
