using DifferentialEquations
using Plots

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = π / 2     # 初期角度 (rad), 鉛直から90度
initial_phidot = 0.0    # 初期角速度 (rad/s)

# 非線形微分方程式の定義
function pendulum_nonlinear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * sin(u[1])
end

# 線形微分方程式の定義
function pendulum_linear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * u[1]
end

# 初期条件
u0 = [initial_phi, initial_phidot]

# 時間の範囲
tspan = (0.0, 15.0)  # 15秒間のシミュレーション

# 非線形微分方程式を解く
prob_nonlinear = ODEProblem(pendulum_nonlinear!, u0, tspan)
sol_nonlinear = solve(prob_nonlinear, Tsit5(), saveat=0.01)

# 線形微分方程式を解く
prob_linear = ODEProblem(pendulum_linear!, u0, tspan)
sol_linear = solve(prob_linear, Tsit5(), saveat=0.01)

# 結果をプロット
plot(sol_nonlinear.t, sol_nonlinear[1, :], label="Nonlinear Phi", xlabel="Time [s]", ylabel="Phi [rad]", title="Comparison of Nonlinear and Linear Pendulum Motion")
plot!(sol_linear.t, sol_linear[1, :], label="Linear Phi", linestyle=:dash)
