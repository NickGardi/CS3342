--
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
-- explore how we can build both finite and infinite lists using list comprehensions 
--
--

-- A. list of odd numbers between 1 and 10
odds = [x*2-1 | x <- [1..10], x*2-1 <= 10]


-- B. infinite list of all positive even numbers 
positiveEvens = [x+2 | x <- [0..]]

-- C.  infinite list of all powers of 2
powersOfTwo =  [2^x | x <- [0..]]


-- D. list of the first n prime numbers
firstNPrimes :: Integral a => Int -> [a]
firstNPrimes n = take n [x | x <- [2..], isPrime x]





--helper for firstNPrimes
isPrime x
	| x <= 1 = False
	| otherwise = null [k | k <- [2.. x -1] , x `mod ` k == 0]
