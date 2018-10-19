{-# LANGUAGE OverloadedStrings #-}


import Data.Monoid (mconcat)
import Control.Monad.IO.Class (liftIO)

import qualified Data.Text.Lazy as L
import qualified Data.Text.Lazy.IO as L

import Web.Scotty
import Web.Scotty.TLS


writeLog :: L.Text -> L.Text -> IO ()
writeLog name log = do
    L.appendFile ("logs/" ++ L.unpack name) $ mconcat [log, "\n"]
    L.putStrLn $ mconcat ["Written to ", name, "."]
  

--main = scottyTLS 8087 "tls/privkey.pem" "tls/fullchain.pem" $
main = scotty 8087 $
    get "/log/:log:name" $ do
        log <- param "log"
        name <- param "name"
        liftIO $ writeLog name log
        html $ mconcat ["<h1>OK `", name, "`!</h1>"]

