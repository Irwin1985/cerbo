module Ssah.Comm where

import Data.List
import Data.Maybe
import Data.Tuple.Select

import Ssah.Utils
import Ssah.Yahoo


data CommDerived = CommDerived (Maybe Float) (Maybe Float) deriving (Show)

commDerivedTuple (CommDerived startPrice endPrice) =
  (startPrice, endPrice)
  
data Comm = Comm Sym Bool String String String String Ticker String (Maybe CommDerived) deriving (Show)


mkComm :: [[Char]] -> Comm
mkComm ["comm", sym, fetch, ctype, unit, exch, gepic, yepic, name] = 
    Comm sym bfetch ctype unit exch gepic yepic name Nothing
    where bfetch = (fetch == "W")


commTuple (Comm sym fetch ctype unit exch gepic yepic name derived) =
  (sym, fetch, ctype, unit, exch, gepic, yepic, name, derived)

commSym :: Comm -> Sym
commSym c = sel1 $ commTuple c



findComm :: [Comm] -> Sym -> Comm
findComm comms sym =
  case hit of
    Just value -> value
    Nothing -> error ("ERR: findComm couldn't find Comm with Sym " ++ sym)
  where
    hit = find (\c -> sym == (commSym c)) comms

findTicker :: [Comm] -> Sym -> Ticker
findTicker comms sym =
  yepic $ findComm comms sym
               
fetchRequired :: Comm -> Bool
fetchRequired c = sel2 $ commTuple c

commType c = sel3 $ commTuple c

commCurrency :: Comm -> String
commCurrency c = sel4 $ commTuple c

yepic :: Comm -> String
yepic c = sel7 $ commTuple c

commTicker = yepic

getComms inputs = makeTypes mkComm "comm" inputs

  
yepics comms = map yepic $ filter fetchRequired comms    

deriveComm :: Dstamp -> Dstamp -> [StockQuote] -> Comm -> Comm
deriveComm start end quotes comm =
  Comm sym fetch ctype unit exch gepic yepic name derived
  where
    (sym, fetch, ctype, unit, exch, gepic, yepic, name, _) = commTuple comm
    startPrice = getStockQuote start yepic quotes
    endPrice = getStockQuote end yepic quotes
    derived = Just (CommDerived startPrice endPrice)
  
deriveComms start end quotes comms  =
  map (deriveComm start end quotes) comms

commDerived c =
  commDerivedTuple der
  where
    oops = error ("commDerived can't look up: " ++ (show c))
    der = doOrDie (sel9 $ commTuple c) oops


commStartPrice comm =  sel1 $ commDerived comm

commStartPriceOrDie comms sym =
  doOrDie (commStartPrice comm) ("Can't find start price for:'" ++ sym ++ "'")
  where
    comm = findComm comms sym
  
commEndPrice comm = sel2 $ commDerived comm

commEndPriceOrDie comms sym =
  doOrDie (commEndPrice comm) ("Can't find end price for:" ++ sym)
  where
    comm = findComm comms sym

{-
-- FIXME LOW use this function more (esp in the above cases)
findCommOrDie comms sym =
  doOrDie comm oops
  where
    comm = findComm comms sym
    oops = "findCommOrDie couldn't find sym:'" ++ sym ++ "'"
-}