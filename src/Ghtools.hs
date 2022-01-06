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
import Network.HTTP.Conduit (tlsManagerSettings)

import Data.ByteString.Lazy.Internal as L
import Data.Maybe

-- listPr :: String -> IO (Maybe String)
listPr = mergeCommit

parseResponse :: Response L.ByteString -> Maybe PullRequest
parseResponse x  = decode (responseBody x)

parseResponses :: Response L.ByteString -> Maybe [PullRequest]
parseResponses x  = decode (responseBody x)

-- mergeCommit :: String -> IO [String]
mergeCommit pull_number = do
  repo_name <- getRepoName
  request <- showPullR repo_name pull_number
  manager <- newManager tlsManagerSettings

  response <- httpLbs request manager

  let commit_hash = merge_commit_sha <$> parseResponse response

  merge_commits <- case commit_hash of
    (Just x) -> listMergedCommit x
    Nothing -> return []

  requests <-  mapM (listPullsForCommitR repo_name) merge_commits
  responses <- sequence (map httpLbs requests <*> pure manager)

  let pull_requests =  concat $ mapMaybe parseResponses responses

  return $ map title pull_requests


