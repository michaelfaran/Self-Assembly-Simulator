import numpy as np
import codecs, json
a = np.arange(25).reshape(5,5)
a = [[2, 2, 0, 2, 0],
     [2, 2, 0, 0, 0],
     [0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0],
     [0, 0, 0, 0, 0]] # a 2 by 5 array
#b = a.tolist() # nested lists with same data, indices
file_path = r"C:\Users\admin\Documents\GitHub\GradProject\seed.json" ## your path variable
json.dump(a, codecs.open(file_path, 'w', encoding='utf-8'),
          separators=(',', ':'),
          sort_keys=True,
          indent=4) ### this saves the array in .json format