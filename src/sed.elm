module Sed exposing (isValidSed, sed)

import Regex exposing (..)

sedReg : Regex
sedReg =
    regex "^s([^\\s\\w])([^\\1]+?)\\1([^\\1]*?)(?:\\1(|ig?|gi?))?$"

isValidSed : String -> Bool
isValidSed =
    contains sedReg

sed : String -> String -> String
sed cmd orig =
    let matches = find (AtMost 1) sedReg cmd
    in case matches of
        [] -> orig
        match :: _ -> case match.submatches of
            _ :: Just matcher :: Just replacer :: _ ->
                let
                    reg = regex matcher
                    replaceFn = always replacer
                in
                    replace All reg replaceFn orig
            _ -> orig
