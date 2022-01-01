{-# LANGUAGE OverloadedStrings #-}

module Ghtools
  ( listPr,
  )
where

import Control.Monad.IO.Class
import Data.Aeson

import Ghtools.Request
import Ghtools.Data

import Network.HTTP.Client
import Network.HTTP.Conduit (tlsManagerSettings)

import Data.ByteString.Lazy.Internal as L

listPr :: String -> IO (Maybe String)
listPr = mergeCommit

parseResponse :: Response L.ByteString -> Maybe PullRequest
parseResponse x  = decode (responseBody x)

mergeCommit :: String -> IO (Maybe String)
mergeCommit pull_number = do
  request <- showPullR "bonyuta0204/dotfiles" pull_number
  manager <- newManager tlsManagerSettings
  response <- httpLbs request manager
  return (merge_commit_sha <$> parseResponse response)

