module Lib where

-- TODO show cumulative tree, and create splecial self nodes that show the time
--      of the node itself such that you can see that, even if the node has children
-- TODO make "  " the spacing in time file and change parsing
-- TODO Fix the durations being negative (leading entry, this is much more serious)
-- TODO add showing tree for time period
-- TODO Fix the durations being negative (non leading entry)
-- TODO fix zero padding
-- TODO add functionality to show entries as accumulated list
-- TODO add sorting of tree
--  * sort by ammount of time (at every level)
--  * sort by latest added

import Data.Time
import Parse
import System.Environment
import TimeTree
  ( Tree (Node),
    mergeIntoTree,
    parseTree,
    visulaizeTree,
  )

getUserHome :: IO FilePath
getUserHome = do
  getEnv "HOME"

dataFilePath :: IO FilePath
dataFilePath = do
  home <- getUserHome
  return $ home ++ "/time_tracker/times.csv"

loadCSV :: FilePath -> IO [[String]]
loadCSV file = do
  csvData <- readFile file
  return $ parseCSV csvData

generateGraph :: [(UTCTime, NominalDiffTime, [String])] -> Tree
generateGraph = generateGraph' (Node (secondsToNominalDiffTime 0) "ROOT" [])

generateGraph' :: Tree -> [(UTCTime, NominalDiffTime, [String])] -> Tree
generateGraph' tree [] = tree
generateGraph' tree (t : ts) = do
  let (utc, time, name) = t
   in generateGraph' (mergeIntoTree time name tree) ts

previousMidnight :: UTCTime -> UTCTime
previousMidnight x = UTCTime (utctDay x) (secondsToDiffTime 0)

main :: IO ()
main = do
  r <- dataFilePath >>= loadCSV
  currentTime <- getCurrentTime
  let a = filterTimeLog (previousMidnight currentTime) currentTime (parseTimeLog r currentTime)
  let t = generateGraph a
  putStrLn $ visulaizeTree t