{-# LANGUAGE DeriveGeneric #-}


module Ghtools.Data
  (
  PullRequest(..)
  )
where

import GHC.Generics
import Data.Aeson

data PullRequest = PullRequest
  { url :: String,
    id :: String,
    state :: String,
    title :: String,
    merge_commit_sha :: String
  } deriving (Show, Generic)

instance FromJSON PullRequest
