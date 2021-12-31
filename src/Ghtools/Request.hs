{-# LANGUAGE OverloadedStrings #-}

module Ghtools.Request (
  generateAutorizedRequest,
  listPullsForCommitR,
  showPullR
) where

import Network.HTTP.Client

import Network.HTTP.Types.Header
import System.Environment

import qualified Data.ByteString.Char8 as C

listPullsForCommitR :: String -> String -> IO Request
listPullsForCommitR repo commit_hash = generateAutorizedRequest =<< parseRequest ("https://api.github.com/repos/" ++ repo ++ "/commits/" ++ commit_hash ++ "/pulls")

showPullR :: String -> String -> IO Request
showPullR repo pull_number = generateAutorizedRequest =<< parseRequest ("https://api.github.com/repos/" ++ repo ++ "/pulls/" ++ pull_number)


-- 環境変数から取得した認証情報をRequestに付与する
generateAutorizedRequest :: Request -> IO Request
generateAutorizedRequest req = do
  token <- getToken
  return $ applyBasicAuth "bonyuta0204" (C.pack token) $ setUserAgent req


setUserAgent :: Request -> Request
setUserAgent x = x {requestHeaders=[(hUserAgent,"curl")]}

getToken :: IO String
getToken = getEnv "GITHUB_TOKEN"

