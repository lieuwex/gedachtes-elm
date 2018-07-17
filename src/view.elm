module View exposing (view)

import Model exposing (..)
import Date exposing (Date)
import Date.Format exposing (format)
import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- VIEW

date : Date -> Html msg
date d =
    let formatted = format "%Y-%m-%d %H:%M:%S" d
    in div [] [text formatted]

entry : Entry -> Html msg
entry x =
    div [ class "entry" ]
    [ date x.date
    , div [] [text x.content]]

view : Model -> Html Msg
view model =
    let
        content =
            [ h1 [] [text "entries"]
            , input
                [ id "entryInput"
                , onInput Input
                , onKeyDown KeyDown
                , value model.input
                ] []
            ]
        entries =
            model.entries
            |> List.reverse
            |> List.map entry
    in
        List.append content entries
        |> div []

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.Decode.map tagger keyCode)
