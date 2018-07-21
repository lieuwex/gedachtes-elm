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

type State
    = Normal
    | Editing Id Body

type alias Model =
    { entries: Entries
    , input: String
    , state: State
    }

type ApiMsg
    = Entries (Result Http.Error Entries)
    | NewEntry (Result Http.Error Entry)
    | ChangedEntry (Result Http.Error Entry)
    | RemovedEntry (Result Http.Error Entry)

type Msg
    = ApiMsg ApiMsg
    | EditInput String
    | EditKeyDown Int
    | NewInput String
    | NewKeyDown Int
    | Delete Entry
    | Change Entry --TODO
    | Tick Time
