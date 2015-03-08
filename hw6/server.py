import sys
from twisted.internet import protocol, reactor, endpoints

# simplest possible protocol
# an instance created per connection
class EchoProtocol(protocol.Protocol):
    def dataReceived(self, data):
        # upon receipt of data, echo.
        self.transport.write(data)

# this is where persistent configuration should be kept
class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return EchoProtocol()

def usage():
    print "usage: ", sys.argv[0],  " <servername> <port>"

def main():

    if len(sys.argv) != 3: 
        usage()
        return
    
    servername = sys.argv[1]
    port = int(sys.argv[2])

    factory = protocol.ServerFactory()
    factory.protocol = EchoProtocol
    reactor.listenTCP(port, factory)
    reactor.run()

# only runs if module wasn't imported
if __name__ == '__main__':
    main()

