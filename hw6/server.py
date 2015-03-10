import sys
from datetime import datetime
from datetime import timedelta
from time import mktime
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

        command = fields[0]
        clientID = fields[1]
        location = fields[2]
        
        try: 
            timestamp = datetime.fromtimestamp(float(fields[3]))
        except TypeError:
            self.badInput(data)
            return

        delta = datetime.now() - timestamp
        if delta >= timedelta():
            delta = '+' + str(delta.total_seconds())
        else:
            delta = '-' + str(delta.total_seconds())

        if command == "IAMAT":
            sequence = ('AT', self.factory.servername, delta, clientID, \
                    location, timestamp)

            self.transport.write(' '.join([str(s) for s in sequence]))
        elif command == "WHATSAT":
            self.transport.write("Not yet implemented")
        else:
            self.badInput(data)

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

