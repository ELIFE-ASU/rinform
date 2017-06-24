# With specified base
encode(c(0, 0, 1), b = 2) # 1
encode(c(0, 1, 0), b = 3) # 3
encode(c(1, 0, 0), b = 4) # 16

# Without specified base
encode(c(0, 0, 2)) # 2
encode(c(0, 2, 0)) # 6
encode(c(1, 2, 1)) # 16
