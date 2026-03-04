import json
import shutil
import os
from typing import Iterable 

FIGUREMAP='assets/assets/gamedata/FigureMap.json'


def fix_figuremap_parts(data: dict):
    """
    Fetches FigureMap.json and checks if any library.parts is not iterable.
    
    Args:
        url: The URL to fetch the FigureMap.json from
    
    Returns:
        Dictionary with validation results
    """
    try:

        # Check if libraries exists
        if 'libraries' not in data:
            return {
                'success': False,
                'error': 'No "libraries" key found in JSON'
            }
        
        libraries = data['libraries']
        
        # Check if libraries itself is iterable
        if not isinstance(libraries, Iterable) or isinstance(libraries, str):
            return {
                'success': False,
                'error': 'libraries is not iterable (or is a string)'
            }
        
        # Check each library's parts
        issues = []
        good_libraries = []
        for idx, library in enumerate(libraries):
            if not library:
                continue
                
            library_id = library.get('id', f'unknown_at_index_{idx}')
            
            # Check if parts exists
            if 'parts' not in library:
                print({
                    'library_id': library_id,  
                    'issue': 'Missing "parts" key'
                })
                continue
            
            parts = library['parts']
            
            # Check if parts is iterable (but not a string)
            if not isinstance(parts, Iterable) or isinstance(parts, str):
                print({
                    'library_id': library_id,
                    'issue': f'parts is not iterable (type: {type(parts).__name__})'
                })
                continue
            
            good_libraries.append(library)
        
        # Return results
        data['libraries'] = good_libraries
        return data
            
    except json.JSONDecodeError as e:
        raise
    except Exception as e:
        raise

if __name__ == "__main__":
    print('Opening')
    with open(FIGUREMAP, 'r') as f:
        data = json.load(f)

    _bak = FIGUREMAP + ".bak"
    if os.path.exists(_bak):
        os.remove(_bak)
    shutil.copy(FIGUREMAP, _bak)
    print('Fixing')
    data = fix_figuremap_parts(data)

    with open(FIGUREMAP, 'w') as f:
        json.dump(data, f)
    
    print('Written')