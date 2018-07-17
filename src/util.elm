module Util exposing (..)

import Task exposing (Task, succeed, fail)

resultToTask : Result err val -> Task err val
resultToTask res =
    case res of
        Ok val -> succeed val
        Err err -> fail err
