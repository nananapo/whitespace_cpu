while True:
    try:
        a = input()
        a = a.replace("[TAB]", "09")
        a = a.replace("[SP]", "20")
        a = a.replace("[LF]", "0a")
        for i in range(0, len(a) // 2):
            print(a[i * 2] + a[i * 2 + 1])
    except:
        break