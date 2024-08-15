using DifferentialEquations
using Plots

# 定数
R_halfpipe = 5.0  # ハーフパイプの半径（メートル）
g = 9.8           # 重力加速度（m/s^2）

# 微分方程式の定義（非線形）
function pendulum!(dphi, phi, p, t)
    dphi[1] = phi[2]
    dphi[2] = -(g / R_halfpipe) * sin(phi[1])
end

# 微分方程式の定義（線形近似）
function linear_pendulum!(dphi, phi, p, t)
    dphi[1] = phi[2]
    dphi[2] = -(g / R_halfpipe) * phi[1]
end

# 初期条件
phi0 = [0.11 * π, 0.0]  # 初期角度と初期角速度

# 時間範囲
tspan = (0.0, 15.0)  # 0秒から10秒まで解く

# ODEの定義と解の計算（非線形）
prob_nonlinear = ODEProblem(pendulum!, phi0, tspan)
sol_nonlinear = solve(prob_nonlinear)

# ODEの定義と解の計算（線形近似）
prob_linear = ODEProblem(linear_pendulum!, phi0, tspan)
sol_linear = solve(prob_linear)

# 解のプロット
plot(sol_nonlinear, idxs=1, xlabel="Time (s)", ylabel="Angle (rad)", title="Skateboard Motion in Half-Pipe", label="Nonlinear Solution")
plot!(sol_linear, idxs=1, linestyle=:dash, label="Linear Approximation", color=:red)

