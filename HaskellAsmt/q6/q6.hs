-- 
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
-- Merge sort 
--

--merge function takes 2 sorted arrays and recursively merges them together 

merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] b = b
merge (a:as) (b:bs)
  | a < b     = a:(merge as (b:bs))
  | otherwise = b:(merge (a:as) bs)




--msort function divides a list into halves, recursively merge sorts the 2 halves, 
--then merges back together using merge


mSort :: (Ord a) => [a] -> [a]
mSort [] = []
mSort [a] = [a]
mSort a =
  merge (mSort halfOne) (mSort halfTwo)
    where halfOne = take ((length a) `div` 2) a
          halfTwo = drop ((length a) `div` 2) a
