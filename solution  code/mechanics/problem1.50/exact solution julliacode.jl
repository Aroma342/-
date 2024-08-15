using DifferentialEquations
using Plots

# 定数
R_halfpipe = 5.0  # ハーフパイプの半径（メートル）
g = 9.8           # 重力加速度（m/s^2）

# 微分方程式の定義
function pendulum!(dphi, phi, p, t)
    dphi[1] = phi[2]
    dphi[2] = -(g / R_halfpipe) * sin(phi[1])
end

# 初期条件
phi0 = [0.11 * π, 0.0]  # 初期角度と初期角速度

# 時間範囲
tspan = (0.0, 10.0)  # 0秒から10秒まで解く

# ODEの定義と解の計算
prob = ODEProblem(pendulum!, phi0, tspan)
sol = solve(prob)

# 解のプロット
plot(sol, idxs=1, xlabel="Time (s)", ylabel="Angle (rad)", title="Skateboard Motion in Half-Pipe", legend=false)
