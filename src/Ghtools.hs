{-# LANGUAGE OverloadedStrings #-}

module Ghtools
    ( getUrl,
    getToken,
    main,
    listPullsForCommitURL,
    generateAutorizedRequest,
    setUserAgent
    ) where

import Network.HTTP.Conduit (tlsManagerSettings)

import Network.HTTP.Client
import Control.Monad.IO.Class

import Data.Aeson

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C

import System.Environment
import Network.HTTP.Types.Header

import qualified Data.ByteString.Lazy.Char8 as L8
import Network.HTTP.Types.Status (statusCode)

main :: IO ()
main = do
    request <- parseRequest "https://api.github.com/users/octocat"
    manager <- newManager tlsManagerSettings

    authorizedRequest <- generateAutorizedRequest $ setUserAgent request

    response <- httpLbs authorizedRequest manager

    print response


getUrl :: String -> IO (Response L8.ByteString)
getUrl url = do
  request <- parseRequest url
  manager <- newManager tlsManagerSettings
  authorizedRequest <- generateAutorizedRequest $ setUserAgent request

  httpLbs authorizedRequest manager


getToken :: IO String
getToken = getEnv "GITHUB_TOKEN"


listPullsForCommitURL :: String -> String -> String
listPullsForCommitURL repo commit_hash = "https://api.github.com/repos/" ++ repo ++ "/commits/" ++ commit_hash ++ "/pulls"


generateAutorizedRequest :: Request -> IO Request
generateAutorizedRequest req = do
  token <- getToken
  return $ applyBasicAuth "bonyuta0204" (C.pack token) req


setUserAgent :: Request -> Request
setUserAgent x = x {requestHeaders=[(hUserAgent,"curl")]}
