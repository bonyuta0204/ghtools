{-# LANGUAGE OverloadedStrings #-}

module Ghtools.Request (
  generateAutorizedRequest,
  query,
  listPullsForCommitR,
  parseListPullsForCommit,
  parseShowPull,
  showPullR
) where

import Network.HTTP.Client
import Network.HTTP.Conduit (tlsManagerSettings)

import Data.Aeson
import Control.Monad.Catch
import Control.Exception (ArithException (..))


import Network.HTTP.Types.Header
import System.Environment

import Ghtools.Data

import qualified Data.ByteString.Lazy.Internal as L
import qualified Data.ByteString.Char8 as C

-- HTTPSリクエストの実行
query :: Request -> IO (Response L.ByteString)
query r = do
  manager <- newManager tlsManagerSettings
  httpLbs r  manager

-- @see https://docs.github.com/en/rest/reference/commits#list-pull-requests-associated-with-a-commit
listPullsForCommitR :: String -> String -> IO Request
listPullsForCommitR repo commit_hash = generateAutorizedRequest =<< parseRequest ("https://api.github.com/repos/" ++ repo ++ "/commits/" ++ commit_hash ++ "/pulls")

parseListPullsForCommit :: (MonadThrow m) => Response L.ByteString -> m [PullRequest]
parseListPullsForCommit x  = safeDecode (responseBody x)

safeDecode :: (FromJSON a, MonadThrow m) => L.ByteString -> m a
safeDecode x = case eitherDecode x of
  (Left msg) -> throwM RatioZeroDenominator
  (Right y) -> return y

-- @see https://docs.github.com/en/rest/reference/pulls#get-a-pull-request
showPullR :: String -> String -> IO Request
showPullR repo pull_number = generateAutorizedRequest =<< parseRequest ("https://api.github.com/repos/" ++ repo ++ "/pulls/" ++ pull_number)

parseShowPull :: (MonadThrow m) => Response L.ByteString -> m PullRequest
parseShowPull x  = safeDecode (responseBody x)



-- 環境変数から取得した認証情報をRequestに付与する
generateAutorizedRequest :: Request -> IO Request
generateAutorizedRequest req = do
  token <- getToken
  return $ applyBasicAuth "bonyuta0204" (C.pack token) $ setUserAgent req


setUserAgent :: Request -> Request
setUserAgent x = x {requestHeaders=[(hUserAgent,"curl")]}

getToken :: IO String
getToken = getEnv "GITHUB_TOKEN"

