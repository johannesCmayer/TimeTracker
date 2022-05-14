module TimeTree where

import Data.List
import Data.List.Split
import Data.Time (NominalDiffTime, secondsToNominalDiffTime)
import Data.Time.Format
import Util

splitOnColumnLength = 11

data Tree = Node
  { time :: NominalDiffTime,
    name :: String,
    children :: [Tree]
  }
  deriving (Show, Eq)

-- TODO
-- toCumulativeTree :: Tree -> Tree
-- toList :: Tree -> [NominalDiffTime, [String]]

-- TODO detect terminal Size and use this instead of hardcoded 2 columns

mergeIntoTree :: NominalDiffTime -> [String] -> Tree -> Tree
mergeIntoTree t [] tree = tree
mergeIntoTree t (nodeName : nodeNames) (Node time name2 children)
  | length f > 1 = error ("Duplicate nodes:\n" ++ intercalate "\n" (map show f))
  | null f = Node time name2 (mergeIntoTree t nodeNames (Node ftime nodeName []) : children)
  | null nodeNames = Node time name2 (let (Node t2 n2 c2) = head f in (Node (t2 + ftime) n2 c2 : f'))
  | length f == 1 = Node time name2 (mergeIntoTree t nodeNames (head f) : f')
  | otherwise = error "this should never occour"
  where
    f = filter (\x -> name x == nodeName) children
    f' = filter (\x -> name x /= nodeName) children
    ftime = if null nodeNames then t else secondsToNominalDiffTime 0

visulaizeTree :: Tree -> String
visulaizeTree t = intercalate "\n" lines
  where
    x = paddColumn $ nodeColumn 0 t
    entries = map (\(x,y) -> y ++ "  " ++ x) x
    half = (length entries + 1) `div` 2
    splitIdx = if length entries <= splitOnColumnLength then splitOnColumnLength else half
    lines = map (\(x,y) -> unwords [x,y]) 
      (let (x,y) = splitAt splitIdx entries in zipPad x y)
    
padder :: Int -> String -> String
padder n s = s ++ replicate n ' '

padderL :: Int -> String -> String
padderL n s = replicate n ' ' ++ s

timeFormat :: NominalDiffTime -> String
timeFormat = formatTime defaultTimeLocale "%0h:%0M"

paddColumn :: [(String, String)] -> [(String, String)]
paddColumn t = do
  let (names, times) = unzip t
  let namesMaxLength = maximum $ map length names
  let timesMaxLength = maximum $ map length times
  [(padder (namesMaxLength - length n) n, padderL (timesMaxLength - length t) t)
    | (n, t) <- zip names times]

nodeColumn :: Int -> Tree -> [(String, String)]
nodeColumn indent (Node time name children)
  | name == "ROOT" = concatMap (nodeColumn indent) children
  | otherwise =
    (take indentation (cycle "| ") ++ name, timeFormat time) :
    concatMap (nodeColumn (indent + 1)) children
  where
    indentation = indent * 2

-- TODO Use break instead of this function
parseToCharset :: Eq a => [a] -> [a] -> [a]
parseToCharset [] [] = []
parseToCharset [] l = l
parseToCharset set [] = []
parseToCharset set (x : xs) =
  if x `elem` set
    then []
    else x : parseToCharset set xs

takeTreeString = parseToCharset ['+', '=', '@']

parseTree :: String -> [String]
parseTree x
  | '=' `elem` split = error $ "Invalid input: " ++ split
  | '+' `elem` split = error $ "Invalid input: " ++ split
  | otherwise = splitOn "/" split
  where
    split = takeTreeString x
