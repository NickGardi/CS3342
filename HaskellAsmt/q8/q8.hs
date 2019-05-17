import Data.Char (ord, toUpper, toLower)

-- 
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
-- converts Hexidecimal numbers to decimal 
-- doesnt account for x or X in the middle of the input (ex: 0x1234X1234) but it did not say we
-- had to in the assignment instructions
--


--conversions
hexConvert :: Char -> Integer
hexConvert ch
    | ch == 'x' = 0
    | ch == 'X' = 0
    | ch == '0' = 0
    | ch == '1' = 1
    | ch == '2' = 2
    | ch == '3' = 3
    | ch == '4' = 4
    | ch == '5' = 5
    | ch == '6' = 6
    | ch == '7' = 7
    | ch == '8' = 8
    | ch == '9' = 9
    | ch == 'A' = 10	
    | ch == 'B' = 11
    | ch == 'C' = 12
    | ch == 'D' = 13
    | ch == 'E' = 14
    | ch == 'F' = 15
    | ch == 'a' = 10
    | ch == 'b' = 11
    | ch == 'c' = 12
    | ch == 'd' = 13
    | ch == 'e' = 14
    | ch == 'f' = 15 
    | otherwise     = error "Non-hexadecimal digits present"


-- function that converts the string to a decimal using pattern matching
hexStrToDec :: String -> Integer
hexStrToDec [] = 0
-- math for the conversion
-- last = last element
-- init = all elements except last
hexStrToDec string = hexConvert (last string) + 16 * hexStrToDec (init string)
