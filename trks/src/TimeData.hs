module TimeData where

import Data.Char
import Data.Time
import Data.Time.Calendar
import Data.Time.Clock.POSIX
import Data.Time.LocalTime
import GHC.Real (reduce)
import System.Environment
import System.IO

-- splitOnString _ "" = []
-- splitOnString delimiter string =
--   let (first, rest) = break (== delimiter) string
--    in first :
--       case rest of
--         "" -> []
--         _ -> splitOnString delimiter (drop 1 . dropWhile (/= delimiter) $ rest)
--        itOn ::
--         Eq a => a -> [a] -> [[a]]

-- splitOn :: Eq a => a -> [a] -> [[a]]
-- splitOn _ [] = []
-- splitOn delim str =
--   let (firstline, remainder) = break (== delim) str
--    in firstline : case remainder of
--         [] -> []
--         x ->
--           if x == [delim]
--             then [[]]
--             else splitOn delim (tail x)

-- ============================= File IO =============================

-- =================================================== TIME ===================================================

-- type Time = (Int, Int, Int, Int, Int, Int)
--
-- type Entry = (Time, String)
--
-- mkTimeZero :: Time
-- mkTimeZero = (0, 0, 0, 0, 0, 0)
--
-- parseDateTime :: String -> Time
-- parseDateTime s =
--   let [year, month, day, hour, minute, second] = map read (splitOn "-" (split !! 1)) ++ map read (splitOn ":" (split !! 2))
--    in (year, month, day, hour, minute, second)
--   where
--     split = splitOn " " s
--
-- timeRangeFromDateTime :: (Int, Int, Int, Int, Int, Int) -> (Int, Int, Int, Int, Int, Int) -> (Int, Int, Int, Int, Int, Int)
-- timeRangeFromDateTime (year, month, day, hour, minute, second) (year', month', day', hour', minute', second') =
--   let (year_diff, month_diff, day_diff, hour_diff, minute_diff, second_diff) =
--         (year' - year, month' - month, day' - day, hour' - hour, minute' - minute, second' - second)
--    in (year_diff, month_diff, day_diff, hour_diff, minute_diff, second_diff)
--
-- addDate :: Time -> Time -> Time
-- addDate (year, month, day, hour, minute, second) (year', month', day', hour', minute', second') =
--   let (year_diff, month_diff, day_diff, hour_diff, minute_diff, second_diff) =
--         timeRangeFromDateTime (year, month, day, hour, minute, second) (year', month', day', hour', minute', second')
--    in (year + year_diff, month + month_diff, day + day_diff, hour + hour_diff, minute + minute_diff, second + second_diff)
--
-- addTime :: Time -> Time -> Time
-- addTime (year, month, day, hour, minute, second) (year', month', day', hour', minute', second') =
--   (year + year', month + month', day + day', hour + hour', minute + minute', second + second')
--
-- paddWithZero :: Int -> Int -> String
-- paddWithZero pad n
--   | n == 0 = "0" ++ show n
--   | otherwise = take (floor ((fromIntegral pad) - (logBase 10 (fromIntegral n)))) (cycle "0") ++ show n
--
-- prettyStringifyDateTime :: (Int, Int, Int, Int, Int, Int) -> String
-- prettyStringifyDateTime (year, month, day, hour, minute, second) =
--   let prettyPrintTime =
--         ( if day /= 0 || month /= 0 || year /= 0
--             then show year ++ "-" ++ show month ++ "-" ++ show day ++ " "
--             else ""
--         )
--           ++ show hour
--           ++ ":"
--           ++ show minute
--    in prettyPrintTime

-- ahello

-- ====================================== Verification ================================
-- TODO make sure the data is in order
-- Research how to you can formally define a specification and check if a file actually
-- respects the format