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

listPr :: String -> IO (Maybe PullRequest)
listPr pr = do
  request <- showPullR "bonyuta0204/dotfiles" pr
  manager <- newManager tlsManagerSettings
  response <- httpLbs request manager
  return (parseResponse response)

parseResponse :: Response L.ByteString -> Maybe PullRequest
parseResponse x  = decode (responseBody x)

response = do
  request <- showPullR "bonyuta0204/dotfiles" "30"
  manager <- newManager tlsManagerSettings
  httpLbs request manager

