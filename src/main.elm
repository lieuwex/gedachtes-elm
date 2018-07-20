module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (view)
import API exposing (getEntries, addEntry, removeEntry, changeEntry)
import List exposing (..)
import Time exposing (Time, second)

updateApiMsg : ApiMsg -> Model -> (Model, Cmd Msg)
updateApiMsg msg model =
    case msg of
        Entries res -> case res of
            Ok entries -> ({ model | entries = entries }, Cmd.none)
            Err _ -> (model, Cmd.none)

        NewEntry res -> case res of
            Ok entry ->
                let entries = append model.entries [entry]
                in ({ model | entries = entries, input = "" }, Cmd.none)
            Err _ -> (model, Cmd.none)

        ChangedEntry res -> case res of
            Ok entry ->
                let
                    fn = (\x ->
                        if x.id == entry.id then
                            entry
                        else
                            x
                    )
                    entries = map fn model.entries
                in ({ model | entries = entries }, Cmd.none)
            Err _ -> (model, Cmd.none)

        RemovedEntry res -> case res of
            Ok entry ->
                let entries = filter (\{id} -> id /= entry.id) model.entries
                in ({ model | entries = entries }, Cmd.none)
            Err _ -> (model, Cmd.none)

updateEditing : Msg -> Model -> (Model, Cmd Msg)
updateEditing msg model =
    case model.editing of
        Nothing -> (model, Cmd.none)
        Just id -> case msg of
            EditInput str ->
                ({ model | editInput = str }, Cmd.none)

            EditKeyDown key ->
                if key /= 13 then
                    (model, Cmd.none)
                else
                    let
                        m = { model | editInput = "", editing = Nothing }
                        trimmed = String.trim model.editInput
                        fn =
                            if String.isEmpty trimmed then
                                (\id _ -> removeEntry id)
                            else
                                changeEntry
                    in
                        (m, fn id model.editInput |> Cmd.map ApiMsg)

            _ -> (model, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ApiMsg apiMsg ->
            updateApiMsg apiMsg model

        -- TODO
        EditInput _ ->
            updateEditing msg model
        EditKeyDown _ ->
            updateEditing msg model

        NewInput str ->
            ({ model | input = str }, Cmd.none)

        NewKeyDown key ->
            if key == 13 then
                (model, addEntry model.input |> Cmd.map ApiMsg)
            else
                (model, Cmd.none)

        Delete entry ->
            --TODO
            (model, removeEntry entry.id |> Cmd.map ApiMsg)

        Change entry ->
            let m =
                { model |
                    editing = Just entry.id,
                    editInput = entry.content
                }
            in (m, Cmd.none)

        Tick _ ->
            (model, Cmd.map ApiMsg getEntries)

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (second*5) Tick

init : (Model, Cmd Msg)
init =
    (Model [] "" "" Nothing, Cmd.map ApiMsg getEntries)

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
