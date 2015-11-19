import pickle #used to store python objects in text file

#factor: output each integer in the array and all the other integers in the array that are
    #factors of the first integer

    #uses dictionaries for both the caching and the output for performance
def factor(numbers,cacheFile="factorCache.txt"):
    inputTuple=tuple(numbers)#must be immutable
    cacheData = open(cacheFile,'a+')#open cache,
        #create new text file if necessary
    try:
        cache=pickle.load(cacheData)
    except EOFError:
        cache={}
    cacheData.close()

    if inputTuple in cache:
        return cache[inputTuple]
    
    ans = dict()
    for x in numbers:
        for y in numbers:
            if x>y and (x % y) == 0: #basic factor checking
                if x in ans:
                    ans[x].append(y) #add to dictionary if factor
                else:
                    ans[x]=[y] #create new dictionary entry
    

    
    

    cache[inputTuple]=ans #update cache (dictionary)

    output=open(cacheFile,'wb')#re-open for writing updated cache
    pickle.dump(cache,output)
    output.close()
  
    return ans#return only the factor dictionary

def inverseFactor(numbers,cacheFile="factorCache.txt"):
    #assuming same cache must be used
    #in a cache hit, slightly improved runtime
    #in cache miss, this might actually be slower
        #than a from-scratch approach
    start = factor(numbers,cacheFile)
    ans={}
    for init in numbers:
        ans[init]=[]#make sure empty entries still get recorded
    for x in start: #'flip' every entry the the normal factor list
        for y in start[x]:
            ans[y].append(x)
    return ans


