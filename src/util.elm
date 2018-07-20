module Util exposing (..)

import Task exposing (Task, succeed, fail)
import Date exposing (Date, year, month, day)

resultToTask : Result err val -> Task err val
resultToTask res =
    case res of
        Ok val -> succeed val
        Err err -> fail err

sameDate : Date -> Date -> Bool
sameDate a b =
    year a == year b &&
    month a == month b &&
    day a == day b
