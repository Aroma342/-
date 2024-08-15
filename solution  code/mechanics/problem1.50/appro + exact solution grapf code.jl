using DifferentialEquations
using Plots

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = 0.11 * π  # 初期角度 (rad), 0.11π

# 初期角速度
initial_phidot = 0.0    # 初期角速度 (rad/s)
tspan = (0.0, 15.0)  # 15秒間のシミュレーション

function pendulum_nonlinear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * sin(u[1])
end

function pendulum_linear!(du, u, p, t)
    du[1] = u[2]
    du[2] = -(g / R) * u[1]
end

u0 = [initial_phi, initial_phidot]

prob_nonlinear = ODEProblem(pendulum_nonlinear!, u0, tspan)
sol_nonlinear = solve(prob_nonlinear, Tsit5(), saveat=1/24)  # 24 fps

prob_linear = ODEProblem(pendulum_linear!, u0, tspan)
sol_linear = solve(prob_linear, Tsit5(), saveat=1/24)  # 24 fps

animation = @animate for i in 1:length(sol_nonlinear.t)
    x_nonlinear = R * sin(sol_nonlinear[1, i])
    y_nonlinear = -R * cos(sol_nonlinear[1, i]) .- 4

    x_linear = R * sin(sol_linear[1, i])
    y_linear = -R * cos(sol_linear[1, i]) .- 4

    plot([x_nonlinear], [y_nonlinear], seriestype = :scatter, label = "Exact", xlims = (-R, R), ylims = (-10, -2), 
         xlabel = "x [m]", ylabel = "y [m]", legend = :topright, title = "Pendulum Motion: Exact vs Approximate")
    plot!([0, x_nonlinear], [-4, y_nonlinear], line = (:solid, 2, :blue), color = :blue, label="")
    
    plot!([x_linear], [y_linear], seriestype = :scatter, markercolor = :red, label="Approximate")
    plot!([0, x_linear], [-4, y_linear], line = (:dash, 2, :red), color = :red, label="")
    
    theta = range(-π/2, stop=π/2, length=100)
    plot!(R * sin.(theta), -R * cos.(theta) .- 4, seriestype = :path, color = :black, linewidth = 1.5, label="")

    plot!([-R, R], [-4, -4], line = (:dash, 1, :black), label="")
    plot!([-R, R], [-9, -9], line = (:dash, 1, :black), label="")
    plot!([0, 0], [-9, -4], line = (:dash, 1, :black), label="")
    
    annotate!(-R + 0.5, -3, text("Time: $(round(sol_nonlinear.t[i], digits=2)) s", 12, :black))
    
    plot!(size=(500, 500), aspect_ratio = 1)
end

save_path = "C:\\Users\\saito\\phyics\\classicalmechanics\\solution  code\\problem1.51\\pendulum_motion_exact_vs_approx_0.11pi.gif"
gif(animation, save_path, fps = 24)
