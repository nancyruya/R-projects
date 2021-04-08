import json
from urllib.request import Request, urlopen

req = Request("https://pokeapi.co/api/v2/pokemon/ditto", headers={'User-Agent': 'Mozilla/5.0'})
webpage = urlopen(req).read()

print(webpage)
