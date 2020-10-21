import matplotlib.pyplot as plt

Ns = [10 ,100 ,1000 ,10000 ,100000 ,1000000 ,2000000 ,3000000 ,5000000 ,9000000 ,10000000 ,100000000 ,500000000 ,900000000]
TimesO0 = [[0.001917,0.001266,0.000000],
[0.001834,0.001282,0.000001],
[0.002004,0.001335,0.000004],
[0.002109,0.001317,0.000061],
[0.001928,0.001129,0.000353],
[0.005369,0.001316,0.006718],
[0.006797,0.001213,0.012481],
[0.008685,0.001300,0.013057],
[0.011005,0.001437,0.017496],
[0.017914,0.001337,0.032267],
[0.019272,0.001260,0.035214],
[0.189688,0.001331,0.340214],
[0.750545,0.001277,1.655931],
[1.265027,0.001002,2.523074]]
TimesO1 = [[0.002976,0.002062,0.000001],
[0.004493,0.002950,0.000001],
[0.002773,0.001809,0.000001],
[0.002722,0.001740,0.000008],
[0.003698,0.002138,0.000195],
[0.005477,0.002275,0.000789],
[0.005900,0.001588,0.001745],
[0.008672,0.002346,0.002823],
[0.014764,0.002645,0.007376],
[0.017528,0.002435,0.009132],
[0.024589,0.002187,0.014619],
[0.176557,0.002388,0.101754],
[0.776361,0.002961,0.397178],
[1.287684,0.002296,0.747581]]
TimesO2 = [[0.003646,0.002437,0.000001],
[0.003792,0.002444,0.000000],
[0.004575,0.003082,0.000002],
[0.003663,0.002346,0.000007],
[0.003155,0.001841,0.000070],
[0.005259,0.001780,0.001111],
[0.006325,0.001847,0.001544],
[0.010184,0.002561,0.003081],
[0.013571,0.002298,0.005574],
[0.023395,0.002713,0.012517],
[0.018259,0.002213,0.009372],
[0.171031,0.002133,0.096438],
[0.742664,0.002006,0.376032],
[1.276103,0.002156,0.686453 ]]
TimesO3 = [[0.001571,0.001048,0.000001],
[0.001670,0.001102,0.000001],
[0.001758,0.001228,0.000001],
[0.001789,0.001086,0.000005],
[0.002025,0.001027,0.000086],
[0.003669,0.000994,0.000488],
[0.005478,0.001127,0.001194],
[0.010031,0.001305,0.002931],
[0.013056,0.001567,0.004377],
[0.018823,0.001410,0.007692],
[0.023990,0.001639,0.010391],
[0.190168,0.001362,0.083660],
[0.721412,0.001488,0.334743],
[1.123435,0.001479,0.578974]]

plt.yscale("log")
plt.xscale("log")
plt.title("-O0")
plt.grid(True)
plt.xlabel("N")
plt.ylabel("Execution time(s)")
plt.plot(Ns, [ v[0] for v in TimesO0], '-')
plt.plot(Ns, [ v[1] for v in TimesO0], '-')
plt.plot(Ns, [ v[2] for v in TimesO0], '-')


plt.legend(["GPU time taking into account memcpy","GPU operation time", "CPU time"])
plt.savefig("O0.png", dpi=800)
plt.cla()



plt.yscale("log")
plt.xscale("log")
plt.title("-O1")
plt.grid(True)
plt.xlabel("N")
plt.ylabel("Execution time(s)")
plt.plot(Ns, [ v[0] for v in TimesO1], '-')
plt.plot(Ns, [ v[1] for v in TimesO1], '-')
plt.plot(Ns, [ v[2] for v in TimesO1], '-')


plt.legend(["GPU time taking into account memcpy","GPU operation time", "CPU time"])
plt.savefig("O1.png", dpi=800)
plt.cla()


plt.yscale("log")
plt.xscale("log")
plt.title("-O2")
plt.grid(True)
plt.xlabel("N")
plt.ylabel("Execution time(s)")
plt.plot(Ns, [ v[0] for v in TimesO2], '-')
plt.plot(Ns, [ v[1] for v in TimesO2], '-')
plt.plot(Ns, [ v[2] for v in TimesO2], '-')


plt.legend(["GPU time taking into account memcpy","GPU operation time", "CPU time"])
plt.savefig("O2.png", dpi=800)
plt.cla()



plt.yscale("log")
plt.xscale("log")
plt.title("-O3")
plt.grid(True)
plt.xlabel("N")
plt.ylabel("Execution time(s)")
plt.plot(Ns, [ v[0] for v in TimesO3], '-')
plt.plot(Ns, [ v[1] for v in TimesO3], '-')
plt.plot(Ns, [ v[2] for v in TimesO3], '-')


plt.legend(["GPU time taking into account memcpy","GPU operation time", "CPU time"])
plt.savefig("O3.png", dpi=800)
plt.cla()

#plt.xticks([8,16,32,64,128])
