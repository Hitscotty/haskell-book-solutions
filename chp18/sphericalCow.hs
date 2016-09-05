import Control.Monad(join)
import Control.Applicative ((*>))

bind :: Monad m => (a -> m b) -> m a -> m b
bind f a = join (fmap f a)

-------------------------------------------------------------------------------------------
sequencing :: IO ()
sequencing = do
  putStrLn "blah" >> putStrLn "another thing"
  
sequencing' :: IO ()
sequencing' =
  putStrLn "blah" >>
  putStrLn "another thing"

sequencing'' :: IO ()
sequencing'' =
  putStrLn "Blah" *>
  putStrLn "another thing"


binding :: IO ()
binding = do
  name <- getLine
  putStrLn name

binding' :: IO ()
binding' =
  getLine >>= putStrLn

-------------------------------------------------------------------------------------------
bindingAndSequencing :: IO ()
bindingAndSequencing = do
  putStrLn "name pls:"
  name <- getLine
  putStrLn (" y hello thar: " ++ name)

bindingAndSequencing' :: IO ()
bindingAndSequencing' =
  putStrLn "name pls:" >>
  getLine >>=
  \name -> putStrLn( "y hello thar: " ++ name)

twoBinds :: IO ()
twoBinds = do
  putStrLn "name pls:"
  name <- getLine
  putStrLn "age pls:"
  age <- getLine
  putStrLn ("ye helo thar: "
           ++ name ++ " who is: "
           ++ age ++ " years old")

twoBinds' :: IO ()
twoBinds' =
    putStrLn "name pls:" >>
    getLine >>=
    \name ->
      putStrLn "age pls:" >>
      getLine >>=
      \age ->
        putStrLn ("y hello thar:"
                 ++ name ++ " who is: "
                 ++ age ++ " years old.")
-------------------------------------------------------------------------------------------
{- example of the list Monad in use -}
twiceWhenEven :: [Integer] -> [Integer]
twiceWhenEven xs = do
  x <- xs
  if even x
    then [x*x, x*x]
    else [x*x]

twiceWhenEven' :: [Integer] -> [Integer]
twiceWhenEven' xs = do
  x <- xs
  if even x
    then [x*x,x*x]
    else []
-------------------------------------------------------------------------------------------
data Cow = Cow {
    name   :: String
  , age    :: Int
  , weight :: Int
  } deriving (Eq, Show)

noEmpty :: String -> Maybe String
noEmpty "" = Nothing
noEmpty str = Just str

noNegative :: Int -> Maybe Int
noNegative n | n >= 0 = Just n
             | otherwise = Nothing

weightCheck :: Cow -> Maybe Cow
weightCheck c =
  let w = weight c
      n = name c
  in if n == "Bess" && w > 499
     then Nothing
     else Just c

mkSphericalCow :: String -> Int -> Int -> Maybe Cow
mkSphericalCow name' age' weight' =
  case noEmpty name' of
    Nothing -> Nothing
    Just nammy ->
      case noNegative age' of
        Nothing -> Nothing
        Just agey ->
          case noNegative weight' of
            Nothing -> Nothing
            Just weighty ->
              weightCheck (Cow nammy agey weighty)

{- this is cleaned up with monad -}

mkSphericalCow' :: String -> Int -> Int -> Maybe Cow
mkSphericalCow' name' age' weight' = do
  nammy <- noEmpty name'
  agey <- noNegative age'
  weighty <- noNegative weight'
  weightCheck(Cow nammy agey weighty)

{- with (>>=) and nested lambdas -}

mkSphericalCow'' :: String -> Int -> Int -> Maybe Cow
mkSphericalCow'' name' age' weight' =
  noEmpty name' >>=
  \ nammy ->
    noNegative age' >>=
    \ agey ->
      noNegative weight' >>=
      \ weighty ->
      weightCheck (Cow nammy agey weighty)

-------------------------------------------------------------------------------------------

f :: Maybe Integer
f = Just 1

g :: Maybe String
g = Just "1"

h :: Maybe Integer
h = Just 10191

zed :: a -> b -> c -> (a, b, c)
zed = (,,)

doSomething = do
  a <- f
  b <- g
  c <- h
  return (zed a b c)

zed' :: Monad m => a -> b -> c -> m (a, b, c)
zed' a b c = return (a, b, c)

doSomething' = do
  a <- f
  b <- g
  c <- h
  zed' a b c

