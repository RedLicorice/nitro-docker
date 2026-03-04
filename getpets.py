release = 'flash-assets-PRODUCTION-202602271717-522497151'
urls = [
# Pets
"https://images.habbo.com/gordon/{release}/bear.swf",
"https://images.habbo.com/gordon/{release}/bearbaby.swf",
"https://images.habbo.com/gordon/{release}/bunnydepressed.swf",
"https://images.habbo.com/gordon/{release}/bunnyeaster.swf",
"https://images.habbo.com/gordon/{release}/bunnyevil.swf",
"https://images.habbo.com/gordon/{release}/bunnylove.swf",
"https://images.habbo.com/gordon/{release}/cat.swf",
"https://images.habbo.com/gordon/{release}/chicken.swf",
"https://images.habbo.com/gordon/{release}/cow.swf",
"https://images.habbo.com/gordon/{release}/croco.swf",
"https://images.habbo.com/gordon/{release}/demonmonkey.swf",
"https://images.habbo.com/gordon/{release}/dog.swf",
"https://images.habbo.com/gordon/{release}/dragon.swf",
"https://images.habbo.com/gordon/{release}/fools.swf",
"https://images.habbo.com/gordon/{release}/frog.swf",
"https://images.habbo.com/gordon/{release}/gnome.swf",
"https://images.habbo.com/gordon/{release}/haloompa.swf",
"https://images.habbo.com/gordon/{release}/horse.swf",
"https://images.habbo.com/gordon/{release}/kittenbaby.swf",
"https://images.habbo.com/gordon/{release}/lion.swf",
"https://images.habbo.com/gordon/{release}/monkey.swf",
"https://images.habbo.com/gordon/{release}/monster.swf",
"https://images.habbo.com/gordon/{release}/monsterplant.swf",
"https://images.habbo.com/gordon/{release}/pig.swf",
"https://images.habbo.com/gordon/{release}/pigeonevil.swf",
"https://images.habbo.com/gordon/{release}/pigeongood.swf",
"https://images.habbo.com/gordon/{release}/pigletbaby.swf",
"https://images.habbo.com/gordon/{release}/pterosaur.swf",
"https://images.habbo.com/gordon/{release}/puppybaby.swf",
"https://images.habbo.com/gordon/{release}/rhino.swf",
"https://images.habbo.com/gordon/{release}/spider.swf",
"https://images.habbo.com/gordon/{release}/terrier.swf",
"https://images.habbo.com/gordon/{release}/terrierbaby.swf",
"https://images.habbo.com/gordon/{release}/velociraptor.swf",
"https://images.habbo.com/gordon/{release}/turtle.swf"
]

import os
import urllib.request

dir_path = 'assets/swf/gordon/PRODUCTION'
os.makedirs(dir_path, exist_ok=True)

for url in urls:
    filename = os.path.basename(url)
    filepath = os.path.join(dir_path, filename)
    if os.path.exists(filepath):
        os.remove(filepath)
    print(f'Downloading {url} to {filepath}')
    urllib.request.urlretrieve(url, filepath)
    print(f'Downloaded {filename}')

print('All downloads completed.')