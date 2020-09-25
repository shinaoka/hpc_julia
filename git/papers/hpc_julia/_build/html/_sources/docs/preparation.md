# 準備

## 必要な環境
講義に必要な環境は以下の通り。Juliaの公式バイナリ、Julia Proなど使えます。

* Julia 1.5以上
* Jupyter notebook
* PyPlot.jl, BenchmarkTools.jlなど

<!-- 
* 後で並列計算に必要なもの: MPI.jl (MPIライブラリOpenMPIとかMPICHを先にインストールする必要あり。Macならbrew install openmpi) 
-->

## インストール手順
詳しくない人はblueqat (量子計算のクラウドサービス)を使うことをお勧めします。
Juliaの公式バイナリを使う場合には、
[プラットフォーム毎のインストール手引き](https://julialang.org/downloads/platform)をよく読むこと。

すでにPython (matplotlib含む)とJupyter notebook/labがインストールされているとします。
以下のファイル (pkg_install.jl)をJuliaで実行すると、とりあえず必要なライブラリをJuliaに導入できます。
1行目のPythonインタプリタへのパスは自分の環境に合わせて変更すること (which pythonをシェルで実行すれば分かります)。

```julia
ENV["PYTHON"] = "/usr/local/var/pyenv/shims/python"
using Pkg
Pkg.add("IJulia")
Pkg.add("PyCall")
Pkg.build("PyCall")
Pkg.add("BenchmarkTools")
Pkg.add("StaticArrays")
Pkg.add("CPUTime")
Pkg.add("PyPlot")
Pkg.add("Plots")
Pkg.add("PyCall")
Pkg.add("HDF5")
Pkg.add("Profile")
```

実行はシェル上でこんな感じ。

```bath
julia pkg_install.jl
```

## 予習
「1から始めるJuliaプログラミング」の2章（2.8, 2.9, .2.10は飛ばしても良いかも)を読んで、
Jupyter notebook上で実行してみましょう。