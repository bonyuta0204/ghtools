{-# LANGUAGE OverloadedStrings #-}

module Ghtools
  ( listPr,
  )
where

import Control.Monad.IO.Class
import Data.Aeson

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Lazy.Char8 as L8

import Ghtools.Request
import Network.HTTP.Client
import Network.HTTP.Conduit (tlsManagerSettings)
import Network.HTTP.Types.Header
import Network.HTTP.Types.Status (statusCode)
import System.Environment

listPr pr = do
  request <- showPullR "bonyuta0204/dotfiles" "30"
  manager <- newManager tlsManagerSettings
  httpLbs request manager
