import re
import sys
import urllib
from datetime import datetime
from datetime import timedelta
from time import mktime
from twisted.web.client import Agent
from twisted.web.http_headers import Headers
from twisted.internet import reactor, endpoints
from twisted.internet.endpoints import TCP4ServerEndpoint
from twisted.internet.protocol import Protocol, Factory, ServerFactory

API_KEY = "AIzaSyCZuO6vfdPZXln8xsUr20PnjbY89FuFcWw"
agent = Agent(reactor)

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
        

        if command == "IAMAT":
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
            sequence = ('AT', self.factory.servername, delta, clientID, \
                                                        location, timestamp)

            self.transport.write(' '.join([str(s) for s in sequence]))
        elif command == "WHATSAT":
            baseURL="https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
            location = '+34.068930-118.445127'
            location = fix_location(location)
            parameters = {
                'key' : API_KEY,
                'location' : location,
                'radius' : 5,
            }
            #url = baseURL + urllib.urlencode(parameters)
            #agent = Agent(reactor)
            #d = agent.request(
            #    'GET',
            #    'http://google.com/',
            #    Headers({'User-Agent': ['Twisted Web Client Example']}),
            #    None)
            #d.addCallback(self.placesResponded)
            #d.addCallback(foo)

            doRequest()
            d = agent.request(
                'GET',
                'http://example.com/',
                Headers({'User-Agent': ['Twisted Web Client Example']}),
                None)
            d.addCallback(lambda x : self.placesResponded(x))
            self.transport.write("WHATSAT not yet implemented")
        else:
            self.badInput(data)

    def placesResponded(self, x):
        print "places responded"

def cbResponse(ignored):
    print 'basic response received'

def doRequest():
    d = agent.request(
        'GET',
        'http://example.com/',
        Headers({'User-Agent': ['Twisted Web Client Example']}),
        None)
    d.addCallback(cbResponse)
    #d.addCallback(HerdAnimalProtocol.placesResponded)

def foo():
    print "foooooo"

def fix_location(location):
    """ puts a comma between lat and lon, removes +'s """
    latlon = re.split('([+-])', location)
    latlon.remove('')
    latlon[2:2] = ','
    latlonCorrected = [part for part in latlon if part != '+']
    locationCorrected = ''.join(latlonCorrected)
    return locationCorrected

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

