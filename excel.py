#-*- encoding: utf-8 -*-
'''
excel.py
Created on 2020/6/13 23:30
Copyright (c) 2020/6/13,ZZ 版权所有.
@author: ZZ
'''

import os,sys,time
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
from matplotlib.pyplot import MultipleLocator

plt.rcParams['font.sans-serif']=['SimHei']

plt.rcParams['axes.unicode_minus'] =False

def chart(rootdir):
    time1 =time.strftime("%Y-%m-%d-%H-%M-%S", time.localtime())
    num =[]
    x = []
    myMax = []
    myMin = []
    myAvg = []
    list = os.listdir(rootdir) #列出文件夹下所有的目录与文件
    with PdfPages(rootdir+"\\"+'scatterdiagram_'+time1+'.pdf') as pdf:
        for i in range(0,len(list)):
            path = os.path.join(rootdir,list[i])
            if (os.path.isfile(path) and path.__contains__("result")):
                file =path.split("-")[1]
                x.append(file)

                with open(path,"r") as f:
                    for line in f:
                        if line.__contains__("时间"):
                             for line_num in line.split("[")[1].split("]")[0].split(","):
                                 num.append(float(line_num))


                myMax.append(max(num))
                myMin.append(min(num))
                myAvg.append(sum(num) / (num.__len__()*1.0))
                #                   记号形状       颜色           点的大小    设置标签
                x1 = np.random.normal(num.__len__()/20,1.2,num.__len__())
                plt.scatter(x1, num, marker = 'o',color = 'black', alpha=0.5,s = 40 )# 随机产生300个平均值为2，方差为1.2的浮点数，即第一簇点的x轴坐标

                plt.title(file+u'线程：执行时间散点分布图')
                plt.ylabel(u'秒：s')
                plt.legend(loc = 'best')    # 设置 图例所在的位置 使用推荐位置
                # plt.show()

                # plt.savefig(rootdir+"\\"+'scatterdiagram_'+file+'.pdf')

                pdf.savefig()
                plt.clf()
                num=[]


    # plt.hist(bins=range(2,14),edgecolor='black',linewidth=1)     #normed是归一化，求频率。设置边界颜色及宽度


    plt.figure(figsize=(10,5))
    plt.plot(x,myMax,label = 'max',marker = "x",markersize=8)
    plt.plot(x,myMin,label = 'min',marker = "x",markersize=8)
    plt.plot(x,myAvg,label = 'avg',marker = "x",markersize=8)




    plt.title(u'压力测试')
    plt.xlabel(u'线程数')
    plt.ylabel(u'秒：s')

    # x_major_locator=MultipleLocator(1)
    # #把x轴的刻度间隔设置为1，并存在变量里
    # y_major_locator=MultipleLocator(10)
    # #把y轴的刻度间隔设置为10，并存在变量里
    # ax=plt.gca()
    # #ax为两条坐标轴的实例
    # ax.xaxis.set_major_locator(x_major_locator)
    # #把x轴的主刻度设置为1的倍数
    # ax.yaxis.set_major_locator(y_major_locator)
    # #把y轴的主刻度设置为10的倍数
    # plt.xlim(-0.5,11)
    # #把x轴的刻度范围设置为-0.5到11，因为0.5不满一个刻度间隔，所以数字不会显示出来，但是能看到一点空白
    # plt.ylim(-5,110)
    # #把y轴的刻度范围设置为-5到110，同理，-5不会标出来，但是能看到一点空白

    plt.tick_params(top='on', right='on', which='both') # 显示上侧和bai右侧的刻度
    plt.rcParams['xtick.direction'] = 'in' #将x轴的刻度线方向设置du向内zhi
    plt.rcParams['ytick.direction'] = 'in' #将y轴的刻度方向设置向内

    plt.grid(color="black", which="both", linestyle=':', linewidth=1)
    plt.fill(color='g', alpha=0.3)

    plt.legend(fontsize = 10)
    plt.savefig(rootdir+"\\"+"chart_"+x[0]+"_"+x[x.__len__()-1]+"_"+time1+".pdf")
    # plt.show()
    plt.close()



if __name__ == "__main__":
    reload(sys)
    sys.setdefaultencoding('utf-8')

    chart(sys.argv[1])
    # chart("E:\\python_workspaces\\forchart")



