module Contracts where

import DateUtils (Date, Days)

newtype Currency = Currency String deriving (Show, Eq)

data Contract = BaseContract {date_ :: Date, amount :: Double, currency :: Currency} | CompoundContract {contracts :: [Contract]} deriving (Show, Eq)

zcb :: Date -> Double -> Currency -> Contract
-- The combinator for the Contract TypeClass
zcb = BaseContract

andC :: Contract -> Contract -> Contract
c1 `andC` c2 = CompoundContract [c1, c2]

give :: Contract -> Contract
give c = case c of
  BaseContract {} ->
    let newDate = date_ c
        newAmount = -(amount c)
        newCurrency = currency c
     in zcb newDate newAmount newCurrency
  CompoundContract {} -> CompoundContract (map give (contracts c))

andGive :: Contract -> Contract -> Contract
andGive c d = c `andC` give d
