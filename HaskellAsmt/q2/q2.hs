--
-- Assignment : 4
-- Author : Nicholas Gardi
-- Email : ngardi2@uwo.ca
--
--given arguments a and n , computes the result a^n 
--without using any of the built-in power operators or any library functions 
--

pow:: Integer->Integer->Integer
pow a n  |(n==1) = a
         |even n = (pow a ( div n 2))*(pow a ( div n 2)) 
         |odd n  = a * (pow a (n-1))
