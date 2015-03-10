PORT=8002

# bad
python client.py $PORT "asdf"
python client.py $PORT "WHOIS kiwi.cs.ucla.edu +34.068930-118.445127 1400794645.392014450"

#normal
python client.py $PORT "IAMAT kiwi.cs.ucla.edu +34.068930-118.445127 `date +%s`"
