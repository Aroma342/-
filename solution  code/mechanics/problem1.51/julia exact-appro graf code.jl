using DifferentialEquations
using Plots

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = π / 2     # 初期角度 (rad), 鉛直から90度
initial_phidot = 0.0    # 初期角速度 (rad/s)

# 非線形微分方程式の定義 (厳密解)
function pendulum_nonlinear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * sin(u[1])
end

# 線形微分方程式の定義 (近似解)
function pendulum_linear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * u[1]
end

# 初期条件
u0 = [initial_phi, initial_phidot]

# 時間の範囲
tspan = (0.0, 15.0)  # 15秒間のシミュレーション

# 厳密解 (非線形) を解く
prob_nonlinear = ODEProblem(pendulum_nonlinear!, u0, tspan)
sol_nonlinear = solve(prob_nonlinear, Tsit5(), saveat=1/24)  # 24 fps

# 近似解 (線形) を解く
prob_linear = ODEProblem(pendulum_linear!, u0, tspan)
sol_linear = solve(prob_linear, Tsit5(), saveat=1/24)  # 24 fps

# アニメーションの作成
animation = @animate for i in 1:length(sol_nonlinear.t)
    # 厳密解 (非線形) の位置
    x_nonlinear = R * sin(sol_nonlinear[1, i])
    y_nonlinear = -R * cos(sol_nonlinear[1, i]) .- 4  # ブロードキャスト演算

    # 近似解 (線形) の位置
    x_linear = R * sin(sol_linear[1, i])
    y_linear = -R * cos(sol_linear[1, i]) .- 4  # ブロードキャスト演算

    # プロット
    plot([x_nonlinear], [y_nonlinear], seriestype = :scatter, label = "Exact", xlims = (-R, R), ylims = (-R-4, -2), 
         xlabel = "x [m]", ylabel = "y [m]", legend = :topright, title = "Pendulum Motion: Exact vs Approximate")
    plot!([0, x_nonlinear], [-4, y_nonlinear], line = (:solid, 2, :blue), color = :blue, label="")
    
    plot!([x_linear], [y_linear], seriestype = :scatter, markercolor = :red, label="aprroximate")
    plot!([0, x_linear], [-4, y_linear], line = (:dash, 2, :red), color = :red, label="")
    
    # 半円の描画
    theta = range(-π/2, stop=π/2, length=100)
    plot!(R * sin.(theta), -R * cos.(theta) .- 4, seriestype = :path, color = :black, linewidth = 1.5, label="")

    # phi = 0の水平線 (y = -4)
    plot!([-R, R], [-4, -4], line = (:dash, 1, :black), label="")

    # phi = pi/2の水平線 (y = -9)
    plot!([-R, R], [-9, -9], line = (:dash, 1, :black), label="")

    # 半円を2等分する垂直線 (x = 0)
    plot!([0, 0], [-9, -4], line = (:dash, 1, :black), label="")
    
    # 時間の表示
    annotate!(-R + 0.5, -3, text("Time: $(round(sol_nonlinear.t[i], digits=2)) s", 12, :black))
    
    plot!(size=(500, 500), aspect_ratio = 1)
end

# GIFの保存
save_path = "C:\\Users\\saito\\phyics\\classicalmechanics\\solution  code\\problem1.51\\pendulum_motion_exact_vs_approx.gif"
gif(animation, save_path, fps = 24)




