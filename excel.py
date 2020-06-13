#-*- encoding: utf-8 -*-
'''
excel.py
Created on 2020/6/13 23:30
Copyright (c) 2020/6/13,ZZ 版权所有.
@author: ZZ
'''

import os,sys
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt


def chart(rootdir):
    num =[]
    x = []
    myMax = []
    myMin = []
    myAvg = []
    list = os.listdir(rootdir) #列出文件夹下所有的目录与文件
    for i in range(0,len(list)):
        path = os.path.join(rootdir,list[i])
        if (os.path.isfile(path) and path.__contains__("result")):
            x.append(path.split("-")[1])
            with open(path,"r") as f:
                for line in f:
                    if line.__contains__("时间"):
                         for line_num in line.split("[")[1].split("]")[0].split(","):
                             num.append(float(line_num))

            myMax.append(max(num))
            myMin.append(min(num))
            myAvg.append(sum(num) / (num.__len__()*1.0))
            num=[]


    # plt.hist(bins=range(2,14),edgecolor='black',linewidth=1)     #normed是归一化，求频率。设置边界颜色及宽度

    plt.rcParams['font.sans-serif']=['SimHei']

    plt.rcParams['axes.unicode_minus'] =False
    plt.figure(figsize=(10,5))
    plt.plot(x,myMax,label = 'max')
    plt.plot(x,myMin,label = 'min')
    plt.plot(x,myAvg,label = 'avg')


    plt.title('压力测试')
    plt.xlabel('线程数')
    plt.ylabel('秒：s')


    plt.legend(fontsize = 10)
    plt.savefig(rootdir+"\\"+"-".join(x)+".pdf")
    plt.show()



if __name__ == "__main__":
    reload(sys)
    sys.setdefaultencoding('utf-8')

    chart("E:\\python_workspaces\\forchart")



