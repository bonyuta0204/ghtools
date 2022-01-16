module Ghtools.Git (
  getRepoName,
  listMergedCommit
) where

import System.Environment
import System.Process
import Text.Regex.Posix



-- get repository name from current directory
getRepoName :: IO String
getRepoName = parseRepoName <$> getRemoteUrl


getRemoteUrl :: IO String
getRemoteUrl = readProcess "git" ["config", "--get", "remote.origin.url"] ""

-- マージコミットのコミットハッシュから、そのマージコミットに含まれるマージコミットのコミットハッシュの一覧を取得
listMergedCommit :: String -> IO [String]
listMergedCommit commit_hash = lines <$> readProcess "git" ["rev-list","--merges", commit_hash ++ "^1", commit_hash ++ "^2"] ""

-- parse repo name from repo url
parseRepoName :: String -> String
parseRepoName repoUrl = case repoUrl =~ "([[:alnum:]]+/[[:alnum:]]+)\\.git" :: (String, String, String, [String]) of
   (_,_,_,subMatches) -> head subMatches


