module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (view)
import API exposing (getEntries, addEntry, removeEntry)
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
                in ({ model | entries = entries }, Cmd.none)
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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ApiMsg apiMsg ->
            updateApiMsg apiMsg model

        Input str ->
            ({ model | input = str }, Cmd.none)

        KeyDown key ->
            if key == 13 then
                ({ model | input = "" }, addEntry model.input |> Cmd.map ApiMsg)
            else
                (model, Cmd.none)

        Delete entry ->
            --TODO
            (model, removeEntry entry.id |> Cmd.map ApiMsg)

        Change entry ->
            --TODO
            (model, Cmd.none)

        Tick _ ->
            (model, Cmd.map ApiMsg getEntries)

subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (second*5) Tick

init : (Model, Cmd Msg)
init =
    (Model [] "", Cmd.map ApiMsg getEntries)

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
