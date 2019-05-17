--
-- Assignment : 4
-- Author : Nick Gardi
-- Email : ngardi2@uwo.ca
--
-- a function mult that multiplies two numbers using only the addition operator
--



--recursive addition of x, y times
mult :: Integer -> Integer -> Integer
mult x y	|(y>0)		= x + mult (y-1) x
		|otherwise	= 0	

