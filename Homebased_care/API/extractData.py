import csv 

# print(f.readline())

# line = f.readline()
# x = line.split()
# print(len(x))

"""
count = 0
for line in f:
     x = line.split()
     if "99341" in line:
             count += 1
             print(count)
 #577
"""

'''
count = 0
for line in f:
    x = line.split()
    if "99341" in x:
        count += 1
        print(count)

        # 251

count = 0
for line in f:
    x = line.split()
    if "90865" in x:
        print(x)

        #2
'''

'''
rows = [
   ]

filename = "university_records.csv"

with open(filename, 'w') as csvfile: 
    # creating a csv writer object 
    csvwriter = csv.writer(csvfile) 
        
    # writing the data rows 
    csvwriter.writerows(rows)
'''
'''
f = open("Medicare_Provider_Util_Payment_PUF_CY2018.txt", "r")
g = open("newfile.txt", "a")
for line in f:
    x = line.split()
    if "90849" in x:
        g.write(line)
'''
'''
f = open("Medicare_Provider_Util_Payment_PUF_CY2018.txt", "r")
g = open("newfile.txt", "a")
for line in f:
    x = line.split()
    if "90849" in x:
        g.write(line)
    if "90865" in x:
        g.write(line)  
'''

f = open("Medicare_Provider_Util_Payment_PUF_CY2018.txt", "r")
g = open("newfileWx.txt", "a")
codes = [
    "99341","99342","99343","99344","99345","99347","99348","99349","99350","99324","99325","99326",
"99327","99328","99334","99335","99336","99337","11055","11056","11057","11719","11720","11721",
"G0127","S0390","90832","90833","90834","90836","90837","90838","90845","90846","90847","90849","90853",
"90865","G0151","G0152","G0153","G0155","G0156","G0157","G0158","G0159","G0160","G0161","G0162","G0299",
"G0300","G0493","G0494","G0495","G0496","G2168","G2169","Q5001","Q5002","Q5009"]
for line in f:
    x = line.split()
    for code in codes:
        if code in x[17:]:
            g.write(line) 
  
'''
f = open("Medicare_Provider_Util_Payment_PUF_CY2018.txt", "r")
for line in f:
    x = line.split()
    if "90849" in x:
        print(line)
    if "90865" in x:
        print(line)
'''
'''
f = open("Medicare_Provider_Util_Payment_PUF_CY2018.txt", "r")
for line in f:
    x = line.split()
    if "99341" in x:
        print(line)
    if "99342" in x:
        print(line)
    if "99343" in x:
        print(line)
    if "99344" in x:
        print(line)
    if "99345" in x:
        print(line)
    if "99347" in x:
        print(line)
    if "99348" in x:
        print(line)
    if "99349" in x:
        print(line)
    if "99350" in x:
        print(line)
    if "99324" in x:
        print(line)
    if "99325" in x:
        print(line)
    if "99326" in x:
        print(line)
    if "99327" in x:
        print(line)
    if "99328" in x:
        print(line)
    if "99334" in x:
        print(line)
    if "99335" in x:
        print(line)
    if "99336" in x:
        print(line)
    if "99337" in x:
        print(line)
    if "11055" in x:
        print(line)
    if "11056" in x:
        print(line)
    if "11057" in x:
        print(line)
    if "11719" in x:
        print(line)
    if "11720" in x:
        print(line)
    if "11721" in x:
        print(line)
    if "G0127" in x:
        print(line)
    if "S0390" in x:
        print(line)
    if "90832" in x:
        print(line)
    if "90833" in x:
        print(line)
    if "90834" in x:
        print(line)
    if "90836" in x:
        print(line)
    if "90837" in x:
        print(line)
    if "90838" in x:
        print(line)
    if "90845" in x:
        print(line)
    if "90846" in x:
        print(line)
    if "90847" in x:
        print(line)
    if "90849" in x:
        print(line)
    if "90853" in x:
        print(line)
    if "90865" in x:
        print(line)
    if "G0151" in x:
        print(line)
    if "G0152" in x:
        print(line)
    if "G0153" in x:
        print(line)
    if "G0155" in x:
        print(line)
    if "G0156" in x:
        print(line)
    if "G0157" in x:
        print(line)
    if "G0158" in x:
        print(line)
    if "G0159" in x:
        print(line)
    if "G0160" in x:
        print(line)
    if "G0161" in x:
        print(line)
    if "G0162" in x:
        print(line)
    if "G0299" in x:
        print(line)
    if "G0300" in x:
        print(line)
    if "G0493" in x:
        print(line)
    if "G0494" in x:
        print(line)
    if "G0495" in x:
        print(line)
    if "G0496" in x:
        print(line)
    if "G2168" in x:
        print(line)
    if "G2169" in x:
        print(line)
    if "Q5001" in x:
        print(line)
    if "Q5002" in x:
        print(line)
    if "Q5009" in x:
        print(line)
'''
