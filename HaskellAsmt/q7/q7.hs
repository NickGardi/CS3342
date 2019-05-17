-- 
-- Assignment : 4 
-- Author : Nicholas Gardi 
-- Email : ngardi2@uwo.ca 
-- 
-- function l33t that converts strings to l33t-speak 
--



module L33t
  ( l33t
  ) where

import Data.Char (chr, ord)

-- CHAR FUNCTIONS 
isLower :: Char -> Bool
isLower char = lowercaseChars `contains` char
  where
    lowercaseChars = ['a' .. 'z']

isUpper :: Char -> Bool
isUpper char = uppercaseChars `contains` char
  where
    uppercaseChars = ['A' .. 'Z']

toUpper :: Char -> Char
toUpper c =
  if isLower c
    then chr (ord c - ord 'a' + ord 'A')
    else c

toLower :: Char -> Char
toLower c =
  if isUpper c
    then chr (ord c - ord 'A' + ord 'a')
    else c





-- checks if a character is a letter.
isLetter :: Char -> Bool
isLetter char = letters `contains` char
  where
    letters = ['a' .. 'z'] ++ ['A' .. 'Z']

-- checks if a character is a vowel.
isVowel :: Char -> Bool
isVowel char = vowels `contains` char
  where
    vowels :: [Char]
    vowels = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U']

-- checks if a character is a consonant.
isConsonant :: Char -> Bool
isConsonant char = isLetter char && not (isVowel char)

-- checks if a character is 'e' or 'E'.
isE :: Char -> Bool
isE char = char == 'e' || char == 'E'

-- checks if a character is 'i or 'I'.
isI :: Char -> Bool
isI char = char == 'i' || char == 'I'

-- L33t speak requirements:
--  All consonants are converted to (or left as) uppercase
--  e and E are converted to the number 3
--  i and I are converted to the number 1
--  All other vowels are converted to (or left as) lowercase
--  An exclamation mark is translated to !!!111oneone
--  All other characters are left unchanged

l33t :: String -> String
l33t "" = ""
l33t (c:cs)
  | isConsonant c = toUpper c : l33t cs		 -- Consonants are converted to uppercase.
  | isE c = '3' : l33t cs			 -- Convert e and E to number 3.
  | isI c = '1' : l33t cs                        -- Convert i and I to number 1.
  | isVowel c = toLower c : l33t cs              -- Other vowels are converted to lowercase.
  | c == '!' = "!!!111oneone" ++ l33t cs	 -- Exclamation marks are converted to !!!111oneone.
  | otherwise = c : l33t cs			 -- All other characters are left unchanged.



-- checks if a character is in a give list of characters.
contains :: [Char] -> Char -> Bool
contains [] _ = False
contains (c:cs) char = c == char || contains cs char

