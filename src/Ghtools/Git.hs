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


getMergeBaseCommit :: String -> IO String
-- head . lines で改行を取り除いている
getMergeBaseCommit commit_hash = head . lines <$> readProcess "git" ["merge-base", commit_hash ++ "^1", commit_hash ++ "^2"] ""

-- parse repo name from repo url
parseRepoName :: String -> String
parseRepoName repoUrl = case repoUrl =~ "([[:alnum:]]+/[[:alnum:]]+)\\.git" :: (String, String, String, [String]) of
   (_,_,_,subMatches) -> head subMatches


