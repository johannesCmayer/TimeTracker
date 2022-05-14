module Util where

lastN :: Int -> [a] -> [a]
lastN n xs = drop (length xs - n) xs

zipPad :: (Monoid a, Monoid b) => [a] -> [b] -> [(a, b)]
zipPad xs [] = zip xs (repeat mempty)
zipPad [] ys = zip (repeat mempty) ys
zipPad (x : xs) (y : ys) = (x, y) : zipPad xs ys
