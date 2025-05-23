import numpy as np
import math
import itertools

vars = [4, 2, math.sqrt(2), 1, 0, -1, -math.sqrt(2), 2]

def accel_asc(n):
    a = [0 for i in range(n + 1)]
    k = 1
    y = n - 1
    while k != 0:
        x = a[k - 1] + 1
        k -= 1
        while 2 * x <= y:
            a[k] = x
            y -= x
            k += 1
        l = k + 1
        while x <= y:
            a[k] = x
            a[l] = y
            yield a[:k + 2]
            x += 1
            y -= 1
        a[k] = x + y
        y = x + y - 1
        yield a[:k + 1]

def Part(x, n, minval, maxval):
  parts = accel_asc(96)
  valid = []
  for p in parts:
  
    if (int(len(p)) < 25): #and (int(max(p)) < 17):
      valid.append(p)
  return valid

def replace_half(L, n): # Replaces half of the values of n in L with -n
  count = 0
  for i in L:
    if i == n:
      count = count + 1
  replace_count = count // 2
  for i in range(len(L)):
    if L[i] == n and replace_count > 0:
        L[i] = -n
        replace_count -= 1

def rep_four2_foreach4(L):
  count = 0
  for i in L:
    if i==4:
      count = count + 1
  repplace_count = 4*count
  for i in range(len(L)):
    if L[i] == 2 and replace_count > 0:
      L[i] = -2
      replace_count -= 1
    elif replace_count < 0 and L[i] == 2:
      L[i] = 2.1


parts = Part(96, 24, 1, 16)
for part in parts:
  print(part)
max = float('-inf')
best = None
for part in parts:
  if 3 not in part and 5 not in part and  6 not in part and 7 not in part and 8 not in part and 9 not in part and 10 not in part and 12 not in part and 13 not in part and 14 not in part and 15 not in part:
    if 16 in part:
      while len(part)!=16:
        part.append(0)
      part = [math.sqrt(x) for x in part]
      replace_half(part, math.sqrt(2))
      rep_four2_foreach4(part)
      replace_half(parts, 2)
      for num in part:
        if num == 2.01:
          num = 2
      val = sum(part[i]**5 - 6*part[i]**3 for i in range(24))
      if val > max:
        print("new max ")
        max = val
        best = part


print('\n \n \n \n \n')
print(max)
print(best)