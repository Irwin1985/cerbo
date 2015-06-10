module Main where

--import qualified Ssah.Snap as MySnap

--main :: IO ()
--main = MySnap.snap

import Args
import Etb (mainEtb)
import Snap (snap1)

--main = mainEtb

main = do
  (opts, n) <- processCmdArgs
  let opt1 = if null opts then Normal else head opts
  case opt1 of
    Args -> print (opts, n)
    Normal -> mainEtb
    Snap -> snap1
