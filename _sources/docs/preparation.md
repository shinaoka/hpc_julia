# 準備

講義に必要な環境は以下の通り。Juliaの公式バイナリ、Julia Proなど使えます。

* Julia 1.5以上
* Jupyter notebook
* 最初からあると良いライブラリ: PyPlot.jl, BenchmarkTools.jlなど
* 後で並列計算に必要なもの: MPI.jl ( MPIライブラリOpenMPIとかMPICHを先にインストールする必要あり。Macならbrew install openmpi)  

私は、以下のようなファイルをつくっておいて、Juliaのバージョンアップグレード時に毎回実行して、
必要なパッケージを再インストールしています。
PyPlotはPythonのmatplotlibを呼びます。すでにPython環境を設定している場合は、1行目で対応するPythonのインタプリタを指定すること。

```julia
ENV["PYTHON"] = "/usr/local/var/pyenv/shims/python"
using Pkg

Pkg.add("PyCall")
Pkg.add("MPI") # require MPI C libraries
Pkg.add("BenchmarkTools")
Pkg.add("StaticArrays")
Pkg.add("CPUTime")
Pkg.add("PyPlot")
Pkg.add("PyCall")
Pkg.add("HDF5")
Pkg.add("Profile")
```

「1から始めるJuliaプログラミング」の2章（2.8, 2.9, .2.10は飛ばしても良いかも)を読みましょう。