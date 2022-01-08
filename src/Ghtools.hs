{-# LANGUAGE OverloadedStrings #-}

module Ghtools
  ( listPr,
  )
where

import Control.Monad.IO.Class
import Data.Aeson

import Ghtools.Request
import Ghtools.Data
import Ghtools.Git

import Network.HTTP.Client

import Data.ByteString.Lazy.Internal as L
import Data.Maybe

-- listPr :: String -> IO (Maybe String)
listPr = mergeCommit

-- mergeCommit :: String -> IO [String]
mergeCommit pull_number = do
  repo_name <- getRepoName

  response <- query =<< showPullR repo_name pull_number

  commit_hash <- merge_commit_sha <$> parseShowPull response

  merge_commits <- listMergedCommit commit_hash

  requests <-  mapM (listPullsForCommitR repo_name) merge_commits
  responses <- mapM query requests

  pull_requests <- concat <$> mapM parseListPullsForCommit responses

  return $ map title pull_requests


