-- 
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
-- insertion sort 
--

-- insert takes an int and a sorted list and inserts the int in the correct location
insert :: Int -> [Int] -> [Int]
insert x [] = [x]
insert x (y:yy) | x < y     = x:y:yy
                | otherwise = y:(insert x yy)



-- isort takes a list and returns a sorted list
isort :: [Int] -> [Int]
isort [] = []
isort (x:xx) = insert x (isort xx)
