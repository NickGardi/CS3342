--
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
--same as pow from q2 but use pattern matching instead of guards 
--


pow' :: Integer -> Integer -> Integer
pow' n 1 = n
pow' n a = n * pow' n (a - 1)
