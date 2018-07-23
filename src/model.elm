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

type State
    = Normal
    | Editing Id Body

type alias Model =
    { entries: List Entry
    , input: String
    , state: State
    , now: Date
    }

type ApiMsg
    = Entries (Result Http.Error (List Entry))
    | NewEntry (Result Http.Error Entry)
    | ChangedEntry (Result Http.Error Entry)
    | RemovedEntry (Result Http.Error Entry)

type Msg
    = ApiMsg ApiMsg
    | EditInput String
    | EditKeyDown Int
    | NewInput String
    | NewKeyDown Int
    | Change Entry
    | Tick Time
