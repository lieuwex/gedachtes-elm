module Util exposing (..)

import Time exposing (Posix, Zone, toYear, toMonth, toDay)

sameDate : Zone -> Posix -> Posix -> Bool
sameDate zone a b =
    let
        year = toYear zone
        month = toMonth zone
        day = toDay zone
    in
        year a == year b
        && month a == month b
        && day a == day b
