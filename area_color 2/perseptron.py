# coding:utf-8
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# 非活性化関数g(x)のメソッド
def predict(w,x):
  out = np.dot(w,x)
  if out >= 0:
    o = 1.0
  else:
    o = -1.0
  return o

# プロットするメソッド
def plot(wvec,x1,x2):
  x_fig=np.arange(-2,5,0.1)
  fig = plt.figure(figsize=(8, 8),dpi=100)
  ims = []
  plt.xlim(-1,10.0)
  plt.ylim(-1,10.0)
  # プロットする
  for w in wvec:
    y_fig = [-(w[0] / w[1]) * xi - (w[2] / w[1]) for xi in x_fig]
    plt.scatter(x1[:,0],x1[:,1],marker='o',color='g',s=100)
    plt.scatter(x2[:,0],x2[:,1],marker='s',color='b',s=100)
    ims.append(plt.plot(x_fig,y_fig,"r"))
  for i in range(10):
    ims.append(plt.plot(x_fig,y_fig,"r"))
  ani = animation.ArtistAnimation(fig, ims, interval=1000)
  plt.show()

if __name__=='__main__':
  wvec=[np.array([1.0,0.5,0.8])]# 重みベクトルの初期値、適当
  mu = 0.3 # 学習係数
  sita = 1 # バイアス成分
  sita2 =-1



  t = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] # AND関数のラベル30個
   #t = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1 ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1] # AND関数のラベル30個

  # AND関数のデータ(一番後ろの列はバイアス成分:1)
  x1 = np.loadtxt("area.txt") #クラス1(演算結果が0)の行列生成
  x2 = np.loadtxt("area2.txt") # クラス2(演算結果が1)の行列生成
  bias = np.array([sita2 for i in range(len(x1))])
  x1 = np.c_[x1,bias] #バイアスをクラス1のデータ最後尾に連結
  bias = np.array([sita for i in range(len(x2))])
  x2 = np.c_[x2,bias] #バイアスをクラス2のデータ最後尾に連結
  class_x = np.r_[x1,x2] # 行列の連結
  print(class_x)


  # o:出力を求める
  o=[]
  while t != o:
    o = [] # 初期化
    # 学習フェーズ
    for i in range(class_x.shape[0]):
      out = predict(wvec[-1], class_x[i,:])
      o.append(out)
      if t[i]*out<0: #出力と教師ラベルが異なるとき
        wvectmp = mu*class_x[i,:]*t[i] #wを変化させる量
        wvec.append(wvec[-1] + wvectmp) #重みの更新
  plot(wvec,x1,x2)
