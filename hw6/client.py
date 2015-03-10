import sys
from twisted.internet import reactor, protocol

class ClientProtocol(protocol.Protocol):
    # once connected, send a message, then print the result

    def connectionMade(self):
        #self.transport.write("IAMAT kiwi.cs.ucla.edu +34.068930-118.445127"+
        #                                    " 1400794645.392014450")
        self.transport.write(self.factory.message)

    def dataReceived(self, data):
        # upon receipt of data, print it and close connection
        #print "Server said: ", data
        print data
        self.transport.loseConnection()

    def connectionLost(self, reason):
        print "The connection to the server was lost"

class ClientFactory(protocol.ClientFactory):
    protocol = ClientProtocol

    def __init__(self, message):
        self.message = message

    def clientConnectionFailed(self, connector, reason):
        print "The connection to the server failed"
        reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "The connection to the server was lost"
        reactor.stop()

def usage():
    print "usage: ", sys.argv[0], " <port> <message>"

def main():
    
    if len(sys.argv) != 3:
        usage()
        return

    port = int(sys.argv[1])
    message = sys.argv[2]

    factory = ClientFactory(message)
    reactor.connectTCP("localhost", port, factory)
    reactor.run()

# only runs if module not imported
if __name__ == '__main__':
    main()

