# The provided encoded state is decoded using the big-endian
# encoding scheme.
decode(2, b = 2, n = 2) # [1, 0]
decode(6, b = 2, n = 3) # [1, 1, 0]
decode(6, b = 3, n = 2) # [2, 0]

# If n is not provided, the length of the decoded state
# is as small as possible
decode(1, b = 2) # [1]
decode(1, b = 3) # [1]
decode(3, b = 2) # [1, 1]
decode(3, b = 3) # [1, 0]
decode(3, b = 4) # [3]

