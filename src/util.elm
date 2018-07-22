module Util exposing (..)

import Date exposing (Date, year, month, day)

sameDate : Date -> Date -> Bool
sameDate a b =
    year a == year b
    && month a == month b
    && day a == day b
