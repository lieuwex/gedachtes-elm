module Main exposing (..)

import Html exposing (program)
import Model exposing (..)
import View exposing (view)
import API exposing (getList, addToList)
import List exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Entries res -> case res of
            Ok entries -> ({ model | entries = entries }, Cmd.none)
            Err _ -> (model, Cmd.none)

        NewEntry res -> case res of
            Ok entry ->
                let entries = append model.entries [entry]
                in ({ model | entries = entries }, Cmd.none)
            Err _ -> (model, Cmd.none)

        Input str ->
            ({ model | input = str }, Cmd.none)

        KeyDown key ->
            if key == 13 then
                ({ model | input = "" }, addToList model.input)
            else
                (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : (Model, Cmd Msg)
init =
    (Model [] "", getList)

main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
