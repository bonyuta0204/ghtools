module Ghtools.Git (
  getRepoName
) where

import System.Environment
import System.Process
import Text.Regex.Posix



-- get repository name from current directory
getRepoName :: IO String
getRepoName = parseRepoName <$> getRemoteUrl


getRemoteUrl :: IO String
getRemoteUrl = readProcess "git" ["config", "--get", "remote.origin.url"] ""


-- parse repo name from repo url
parseRepoName :: String -> String
parseRepoName repoUrl = case repoUrl =~ "([[:alnum:]]+/[[:alnum:]]+)\\.git" :: (String, String, String, [String]) of
   (_,_,_,subMatches) -> head subMatches
