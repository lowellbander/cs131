import sys
from twisted.internet import protocol, reactor, endpoints

# simplest possible protocol
class Echo(protocol.Protocol):
    def dataReceived(self, data):
        # upon receipt of data, echo.
        self.transport.write(data)

class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return Echo()

def usage():
    print "usage: ", sys.argv[0],  " <servername> <port>"

def main():

    if len(sys.argv) != 3: 
        usage()
        return
    
    servername = sys.argv[1]
    port = sys.argv[2]

    factory = protocol.ServerFactory()
    factory.protocol = Echo
    reactor.listenTCP(int(port), factory)
    reactor.run()

# only runs if module wasn't imported
if __name__ == '__main__':
    main()

