module Sed exposing (isValidSed, sed)

import Regex exposing (..)

sedReg : Regex
sedReg =
    Maybe.withDefault
        Regex.never
        (fromString "^s([^\\s\\w])([^\\1]+?)\\1([^\\1]*?)(?:\\1(|ig?|gi?))?$")

isValidSed : String -> Bool
isValidSed =
    contains sedReg

sed : String -> String -> String
sed cmd orig =
    let matches = findAtMost 1 sedReg cmd
    in case matches of
        [] -> orig
        match :: _ -> case match.submatches of
            _ :: Just matcher :: Just replacer :: _ ->
                let
                    reg = fromString matcher
                    replaceFn = always replacer
                in case reg of
                    Just r -> replace r replaceFn orig
                    Nothing -> orig
            _ -> orig
