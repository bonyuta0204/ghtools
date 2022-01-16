module Main where

import Data.Semigroup (Option (Option), (<>))
import qualified Ghtools as GH
import Options.Applicative
import Ghtools.Request

newtype CmdOption = CmdOption
  { pr :: String
  }
  deriving (Show)

main :: IO ()
main = execute =<< execParser opts
  where
    opts =
      info
        (cmdParser <**> helper)
        ( fullDesc
            <> progDesc "Print a greeting for TARGET"
            <> header "hello - a test for optparse-applicative"
        )

execute :: CmdOption -> IO ()
execute (CmdOption pr) = print =<< GH.listPr pr

listPrOptions =
  CmdOption
    <$> argument str (metavar "PR")

cmdParser = subparser (command "list-pr" (info listPrOptions fullDesc))

listR = listPullsForCommitR


mapM :: Monad m => (a -> m b) -> [a] -> m [b]
mapM f as = foldr k (return []) as
            where
              k a r = do { x <- f a; xs <- r; return (x:xs) }
