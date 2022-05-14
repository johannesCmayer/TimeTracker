{-# LANGUAGE OverloadedStrings #-}

module Parse where

import Data.List.Split
import Data.String.Utils (strip)
import Data.Time
import System.Environment
import TimeTree

fi :: (Integral a, Num b) => a -> b
fi = fromIntegral

parseCSV :: String -> [[String]]
parseCSV = map (map (strip . filter (/= '"')) . splitOn ",") . lines

filterTimeLog :: UTCTime -> UTCTime -> [(UTCTime, NominalDiffTime, [String])] -> [(UTCTime, NominalDiffTime, [String])]
filterTimeLog start end = filter (\(t, _, _) -> t >= start && t <= end)

parseTimeLog :: [[String]] -> UTCTime -> [(UTCTime, NominalDiffTime, [String])]
parseTimeLog xs now =
  zip3 utc diffs graphs
  where
    v = validateTimeLog xs
    (timeStrs, graphStrs) = unzip (map (\a -> (a !! 0, a !! 1)) xs)
    utc = map parseToUTC timeStrs ++ [now]
    diffs = timeDifferences utc
    graphs = map parseTree graphStrs

parseToUTC :: String -> UTCTime
parseToUTC s = zonedTimeToUTC zonedTime
  where
    [timeZoneStr, dateStr, timeStr] = splitOn "  " s
    timeZone = read timeZoneStr :: TimeZone
    day = let [y, m, d] = map read (splitOn "-" dateStr) in fromGregorian y (fi m) (fi d)
    time = let [h, m, s] = map read (splitOn ":" timeStr) in TimeOfDay h m (fi s)
    localTime = LocalTime day time
    zonedTime = ZonedTime localTime timeZone

-- TODO split out validation checks
timeDifferences :: [UTCTime] -> [NominalDiffTime]
timeDifferences [] = []
timeDifferences [x] = []
timeDifferences (x1 : x2 : xs)
  | diff < [secondsToNominalDiffTime 0] = error $ "Time log is not sorted at\n" ++ show x2 ++ "\n" ++ show x1
  | otherwise = diff
  where
    diff = diffUTCTime x2 x1 : timeDifferences (x2 : xs)

validateLn :: [String] -> Bool
validateLn x
  | length x /= 2 = error $ "Line does not have two columns: " ++ show x
  | otherwise = True

validateTimeLog :: [[String]] -> Bool
validateTimeLog xs =
  all id $ map validateLn xs