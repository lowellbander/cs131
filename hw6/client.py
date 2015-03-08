from twisted.internet import reactor, protocol

class EchoClient(protocol.Protocol):
    # once connected, send a message, then print the result

    def connectionMade(self):
        self.transport.write("this is the message sent by the client")

    def dataReceived(self, data):
        # upon receipt of data, print it and close connection
        print "Server said: ", data
        self.transport.loseConnection()

    def connectionLost(self, reason):
        print "The connection to the server was lost"

class EchoFactory(protocol.ClientFactory):
    protocol = EchoClient

    def clientConnectionFailed(self, connector, reason):
        print "The connection to the server failed"
        reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "The connection to the server was lost"
        reactor.stop()

def main():
    factory = EchoFactory()
    reactor.connectTCP("localhost", 8000, factory)
    reactor.run()

# only runs if module not imported
if __name__ == '__main__':
    main()

