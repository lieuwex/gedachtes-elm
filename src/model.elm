module Model exposing (..)

import Date exposing (Date)
import Http
import Time exposing (Time)

type alias Id = String
type alias Body = String
type alias Entry =
    { id: Id
    , content: Body
    , date: Date
    }
type alias Entries = List Entry

type alias Model =
    { entries: Entries
    , input: String
    }

type ApiMsg
    = Entries (Result Http.Error Entries)
    | NewEntry (Result Http.Error Entry)
    | ChangedEntry (Result Http.Error Entry)
    | RemovedEntry (Result Http.Error Entry)

type Msg
    = ApiMsg ApiMsg
    | Input String
    | Delete Entry
    | Change Entry --TODO
    | KeyDown Int
    | Tick Time
