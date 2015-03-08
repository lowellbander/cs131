from twisted.internet import protocol, reactor, endpoints

# simplest possible protocol
class Echo(protocol.Protocol):
    def dataReceived(self, data):
        # upon receipt of data, echo.
        self.transport.write(data)

class EchoFactory(protocol.Factory):
    def buildProtocol(self, addr):
        return Echo()

def main():
    factory = protocol.ServerFactory()
    factory.protocol = Echo
    reactor.listenTCP(8000, factory)
    reactor.run()

# only runs if module wasn't imported
if __name__ == '__main__':
    main()

