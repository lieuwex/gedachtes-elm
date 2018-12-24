module Model exposing (..)

import Time exposing (Posix, Zone)
import Http

type alias Id = String
type alias Body = String
type alias Entry =
    { id: Id
    , content: Body
    , date: Posix
    }

type State
    = Normal
    | Editing Id Body

type alias Model =
    { entries: List Entry
    , input: String
    , cleared: Bool
    , state: State
    , now: Posix
    , zone: Zone
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
    | NewFocus
    | NewInput String
    | NewKeyDown Int
    | Change Entry
    | SetZone Zone
    | Tick Posix
