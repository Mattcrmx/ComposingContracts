module DateUtils where

import qualified Data.List as List (elemIndex)
import qualified Data.Map as Map (fromList, lookup)

-- TYPES DECLARATION
data Date = Date {year :: Int, month :: String, day :: Int, hour :: Int, minute :: Int} deriving (Show, Eq, Ord)

type Days = Double

-- CONSTANTS
monthsMap = Map.fromList [("Jan", 1), ("Feb", 2), ("Mar", 3), ("Apr", 4), ("May", 5), ("Jun", 6), ("Jul", 7), ("Aug", 8), ("Sept", 9), ("Oct", 10), ("Nov", 11), ("Dec", 12)]

monthsDaysMap = Map.fromList [("Jan", 31), ("Feb", 28), ("Mar", 30), ("Apr", 31), ("May", 30), ("Jun", 31), ("Jul", 30), ("Aug", 31), ("Sept", 30), ("Oct", 31), ("Nov", 30), ("Dec", 31)]

monthsList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]

cvtGMT :: String -> (Int, Int)
-- extracts the hour and the
-- min from a GMT string
-- e.g "1500GMT" yields (15, 0)
cvtGMT x =
  let hr = read (take 2 x) :: Int
      mn = read (take 2 (drop 2 x)) :: Int
   in (hr, mn)

date :: String -> Date
-- Returns a Date from a string
-- representing a date
date x =
  let dateList = words x
      (h, m) = cvtGMT (head dateList)
      d = read (dateList !! 1) :: Int
      mnt = dateList !! 2
      yr = read (dateList !! 3) :: Int
   in Date yr mnt d h m

cumSumLookup :: [String] -> Int
cumSumLookup [] = 0
cumSumLookup (x : xs) =
  let val = Map.lookup x monthsDaysMap
   in case val of
        Just n -> n + cumSumLookup xs
        Nothing -> 0

getMonthIndex :: String -> Int
-- Retrieve the index of the month
-- could be replaced by Data.Maybe.fromMaybe
-- but less understandable
getMonthIndex m =
  let monthIndex = List.elemIndex m monthsList
   in case monthIndex of
        Just n -> n
        Nothing -> 0

getStartMonth :: String -> Int
-- gets the starting date of a month
getStartMonth m =
  let monthIndex = getMonthIndex m
      (prevMonths, _) = splitAt monthIndex monthsList
      start = cumSumLookup prevMonths
   in start

dateToDays :: Date -> Days
-- converts a date to the number of days it represents
dateToDays d =
  let years_ = fromIntegral (365 * year d) -- consider no bissextile year for simplicity
      months_ = fromIntegral (getStartMonth (month d))
      days_ = fromIntegral (day d)
      hours_ = fromIntegral (hour d) / 24
      minutes_ = fromIntegral (minute d) / 1440
   in years_ + months_ + days_ + hours_ + minutes_

diff :: Date -> Date -> Days
-- Absolute difference between two dates
diff d1 d2 =
  let d1ToDays = dateToDays d1
      d2ToDays = dateToDays d2
   in d2ToDays - d1ToDays
