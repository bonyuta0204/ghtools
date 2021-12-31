{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}


module Ghtools.Data
  (
  PullRequest(..)
  )
where

import GHC.Generics
import Data.Aeson

data PullRequest = PullRequest
  { url :: String,
    id :: Int,
    state :: String,
    title :: String,
    merge_commit_sha :: String
  } deriving (Show, Generic)


instance FromJSON PullRequest where
    parseJSON = withObject "PullRequest" $ \v -> PullRequest
        <$> v .: "url"
        <*> v .: "id"
        <*> v .: "state"
        <*> v .: "title"
        <*> v .: "merge_commit_sha"
