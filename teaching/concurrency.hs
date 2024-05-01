{-

Consider having two "processes" running in parallel
and communicating with each other.

 |-----------|*              |--------|
 |           |    request    |        |
 | client(s) |     ---->     | server |
 |           |     <----     |        |
 |-----------|    response   |--------|

We will use GHC Haskell's interface for "channels" to provide
communication between processes

-}

import Control.Concurrent

{-

Relevant functions:

newChan   :: IO (Chan a)
writeChan :: Chan a -> a -> IO ()
readChan  :: Chan a -> IO a

forkIO    :: IO () -> IO ThreadId

-}

------------------------------------------
-- (>>) :: IO a -> IO b -> IO b
-- (>>=) :: IO a -> (a -> IO b) -> IO b

server0 :: Chan () -> IO ()
server0 fromClient = do
  readChan fromClient
  putStrLn "I got a request"
  server0 fromClient

client0 :: Chan () -> IO ()
client0 toServer =
  writeChan toServer ()

setup0 :: IO ()
setup0 = do
  c <- newChan
  -- c :: Chan ()
  forkIO (server0 c)
  forkIO (client0 c)
  forkIO (client0 c)
  return ()

------------------------------------------

server1 :: Int -> Chan Int -> IO ()
server1 total fromClient = do
  n <- readChan fromClient
  let total' = n + total
  putStrLn ("I got a request: " ++ show n
            ++ ". Total is now = " ++ show total')
  server1 total' fromClient

client1 :: Chan Int -> IO ()
client1 toServer = do
  writeChan toServer 1
  writeChan toServer 2

setup1 :: IO ()
setup1 = do
  c <- newChan
  forkIO (server1 0 c)
  forkIO (client1 c)
  forkIO (client1 c)
  return ()

------------------------------------------

type Response = Int
type Request = (Int, Chan Response)

server2 :: Int -> Chan Request -> IO ()
server2 total fromClient = do
  -- Get a request from the client
  (n, respChan) <- readChan fromClient
  -- Calculate our new total
  let total' = n + total
  -- Respond to the client with that total
  writeChan respChan total'
  -- Repeat
  server2 total' fromClient

-- helper function for client making a request
-- and receiving a response
requestResponse :: Int -> Chan Request -> IO Response
requestResponse n toServer = do
  -- Make a request with n
  respChan <- newChan
  writeChan toServer (n, respChan)
  -- get response
  readChan respChan

client2 :: Chan Request -> IO ()
client2 toServer = do
  -- Request 1
  t <- requestResponse 1 toServer
  putStrLn ("Got " ++ show t)
  -- Request 2
  t <- requestResponse 2 toServer
  putStrLn ("Got " ++ show t)

setup2 :: IO ()
setup2 = do
  c <- newChan
  forkIO (server2 0 c)
  forkIO (client2 c)
  forkIO (client2 c)
  return ()

--------------------------------------------------------

------------------------------------------

data Command = Add Int (Chan Response) | Stop

server3 :: Int -> Chan Command -> IO ()
server3 total fromClient = do
  -- Get a request from the client
  command <- readChan fromClient
  case command of
    Add n respChan -> do
      -- Calculate our new total
      let total' = n + total
      -- Respond to the client with that total
      writeChan respChan total'
      -- Repeat
      server3 total' fromClient

    Stop ->
      putStrLn ("Final total was " ++ show total)

-- helper function for client making a request
-- and receiving a response
requestResponseCommand :: Int -> Chan Command -> IO Response
requestResponseCommand n toServer = do
  -- Make a request with n
  respChan <- newChan
  writeChan toServer (Add n respChan)
  -- get response
  readChan respChan

client3 :: Chan () -> Chan Command -> IO ()
client3 signal toServer = do
  -- Request 1
  t <- requestResponseCommand 1 toServer
  putStrLn ("Got " ++ show t)
  -- Request 2
  t <- requestResponseCommand 2 toServer
  putStrLn ("Got " ++ show t)
  --
  writeChan signal ()

setup3 :: IO ()
setup3 = do
  c <- newChan
  signal <- newChan
  forkIO (server3 0 c)
  forkIO (client3 signal c)
  forkIO (client3 signal c)
  -- Wait for clients to finish their work
  () <- readChan signal
  () <- readChan signal
  writeChan c Stop
  return ()