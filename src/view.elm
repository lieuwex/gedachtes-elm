module View exposing (view)

import Model exposing (..)
import Date exposing (Date)
import Date.Format exposing (format)
import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Util exposing (sameDate)
import List.Extra exposing (groupWhile)

-- VIEW

date : Date -> Html msg
date d =
    let formatted = format "%Y-%m-%d %H:%M:%S" d
    in div [] [text formatted]

entry : Model -> Entry -> Html Msg
entry model x =
    let
        editing =
            model.editing
            |> Maybe.map (\id -> x.id == id)
            |> Maybe.withDefault False
    in
        div [ class "entry" ]
        [ date x.date
        , div [onClick (Change x)]
            [
            if editing then
                input
                    [ value model.editInput
                    , onInput EditInput
                    , onKeyDown EditKeyDown
                    ] []
            else
                text x.content
            ]
        ]

view : Model -> Html Msg
view model =
    let
        content =
            [ h1 [] [text "entries"]
            , input
                [ id "entryInput"
                , onInput NewInput
                , onKeyDown NewKeyDown
                , value model.input
                ] []
            ]
        entries =
            model.entries
            |> List.reverse
            |> groupWhile (\a b -> sameDate a.date b.date)
            |> List.map (\x -> hr [] [] :: List.map (entry model) x)
            |> List.concat
            |> List.drop 1
    in
        List.append content entries
        |> div []

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.Decode.map tagger keyCode)
