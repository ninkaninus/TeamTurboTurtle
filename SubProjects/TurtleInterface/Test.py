a = [55,57,58,60,61,62,'e',42,43,44]
b = []

try:
    c=a.index('e')
    b = a[0:c]
    del(a[0:c+1])
    print(a)
    print(b)
except ValueError:
    print('Not in list')





