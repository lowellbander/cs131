import sys
from twisted.internet import reactor, endpoints
from twisted.internet.endpoints import TCP4ServerEndpoint
from twisted.internet.protocol import Protocol, Factory, ServerFactory

# simplest possible protocol
# an instance created per connection
class HerdAnimalProtocol(Protocol):

    def connectionMade(self):
        print "A connection was made to a client"
        # self.factory.numProtocols += 1
        # self.transport.write("A connection was made. " + 
        # "There are currently %d open connections" % self.factory.numProtocols)

    def badInput(self, message):
        self.transport.write("? " + message)

    def dataReceived(self, data):
        
        fields = data.split()

        if len(fields) != 4:
            self.badInput(data)
            return

        self.transport.write(self.factory.servername + data)

# this is where persistent configuration should be kept
class HerdAnimalFactory(Factory):

    protocol = HerdAnimalProtocol

    def __init__(self, servername):
        self.servername = servername

def usage():
    print "usage: ", sys.argv[0],  " <servername> <port>"

def main():

    if len(sys.argv) != 3: 
        usage()
        return
    
    servername = sys.argv[1]
    port = int(sys.argv[2])

    endpoint = TCP4ServerEndpoint(reactor, port)
    endpoint.listen(HerdAnimalFactory(servername))
    reactor.run()

# only runs if module wasn't imported
if __name__ == '__main__':
    main()

