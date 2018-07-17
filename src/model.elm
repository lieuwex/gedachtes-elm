module Model exposing (..)

import Date exposing (Date)
import Http
import Time exposing (Time)

type alias Entry =
    { date: Date
    , content: String
    }

type alias Model =
    { entries: List Entry
    , input: String
    }

type Msg
    = Entries (Result Http.Error (List Entry))
    | NewEntry (Result Http.Error Entry)
    | Input String
    | KeyDown Int
    | Tick Time
