import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = np.pi / 2  # 初期角度 (rad), 鉛直から90度
initial_phidot = 0.0     # 初期角速度 (rad/s)

# 微分方程式の定義 (非線形)
def pendulum_nonlinear(t, y):
    phi, phidot = y
    dydt = [phidot, -(g / R) * np.sin(phi)]
    return dydt

# 微分方程式の定義 (線形近似)
def pendulum_linear(t, y):
    phi, phidot = y
    dydt = [phidot, -(g / R) * phi]
    return dydt

# 初期条件
y0 = [initial_phi, initial_phidot]

# 時間の範囲
t_span = (0, 20)
t_eval = np.linspace(t_span[0], t_span[1], 1000)

# 非線形方程式を解く
sol_nonlinear = solve_ivp(pendulum_nonlinear, t_span, y0, t_eval=t_eval)

# 線形方程式を解く
sol_linear = solve_ivp(pendulum_linear, t_span, y0, t_eval=t_eval)

# 結果をプロット
plt.plot(sol_nonlinear.t, sol_nonlinear.y[0], label='Nonlinear')
plt.plot(sol_linear.t, sol_linear.y[0], '--', label='Linear')
plt.xlabel('Time [s]')
plt.ylabel('Phi [rad]')
plt.title('Pendulum motion in a half-pipe with R=5m')
plt.legend()
plt.grid(True)
plt.show()
