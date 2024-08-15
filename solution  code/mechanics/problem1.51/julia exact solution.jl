using DifferentialEquations
using Plots

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = π / 2     # 初期角度 (rad), 鉛直から90度
initial_phidot = 0.0    # 初期角速度 (rad/s)

# 微分方程式の定義
function pendulum!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * sin(u[1])
end

# 初期条件
u0 = [initial_phi, initial_phidot]

# 時間の範囲
tspan = (0.0, 20.0)  # 20秒間のシミュレーション

# 微分方程式を解く
prob = ODEProblem(pendulum!, u0, tspan)
sol = solve(prob, Tsit5(), saveat=0.01)

# 結果をプロット
plot(sol, vars=(0, 1), xlabel="Time [s]", ylabel="Phi [rad]", title="Pendulum motion in a half-pipe with R=5m")
