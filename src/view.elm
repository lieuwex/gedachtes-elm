module View exposing (view)

import Browser
import Model exposing (..)
import Time exposing (Posix, Zone)
import DateFormat
import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Util exposing (sameDate)
import List.Extra exposing (groupWhile)

date : Zone -> Posix -> String
date =
    DateFormat.format
        [ DateFormat.yearNumber
        , DateFormat.text "-"
        , DateFormat.monthFixed
        , DateFormat.text "-"
        , DateFormat.dayOfMonthFixed
        , DateFormat.text " "
        , DateFormat.hourMilitaryFixed
        , DateFormat.text ":"
        , DateFormat.minuteFixed
        , DateFormat.text ":"
        , DateFormat.secondFixed
        ]

entry : Model -> Entry -> Html Msg
entry model x =
    let
        (editing, editInput) =
            case model.state of
                Normal -> (False, "")
                Editing id input -> (id == x.id, input)
    in
        div [ class "entry" ]
        [ div [] [text (date model.zone x.date)]
        , div [onClick (Change x)]
            [ if editing then
                input
                    [ value editInput
                    , onInput EditInput
                    , onKeyDown EditKeyDown
                    ] []
              else
                text x.content
            ]
        ]

withCleared : Model -> List (Attribute Msg) -> List (Attribute Msg)
withCleared model attributes =
    case model.cleared of
        True -> value "" :: attributes
        False -> attributes

view : Model -> Browser.Document Msg
view model =
    let
        entriesToday =
            List.filter (\x -> sameDate model.zone x.date model.now) model.entries

        entriesInfo =
            "today: "
            ++ String.fromInt (List.length entriesToday)
            ++ "/"
            ++ String.fromInt (List.length model.entries)

        content =
            [ h1 [] [text "entries"]
            , div [id "entriesInfo"] [text entriesInfo]
            , input
                (withCleared model [ id "entryInput"
                , onInput NewInput
                , onKeyDown NewKeyDown
                , onFocus NewFocus
                , autofocus True
                ]) []
            ]

        entries =
            model.entries
            |> List.sortBy (.date >> Time.posixToMillis)
            |> List.reverse
            |> groupWhile (\a b -> sameDate model.zone a.date b.date)
            |> List.map (\(x, xs) -> hr [] [] :: entry model x :: List.map (entry model) xs)
            |> List.concat
            |> List.drop 1 -- Remove the first <hr>
    in
        { title =
            "thoughts | "
            ++ String.fromInt (List.length entries)
            ++ " entries"
        , body = List.append content entries
        }

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
  on "keydown" (Json.Decode.map tagger keyCode)
