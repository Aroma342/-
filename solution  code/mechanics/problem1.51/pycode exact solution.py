import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# 定数
g = 9.81  # 重力加速度 (m/s^2)
R = 5.0   # ハーフパイプの半径 (m)
initial_phi = np.pi / 2  # 初期角度 (rad), 鉛直から90度
initial_phidot = 0.0     # 初期角速度 (rad/s)

# 微分方程式の定義
def pendulum(t, y):
    phi, phidot = y
    dydt = [phidot, -(g / R) * np.sin(phi)]
    return dydt

# 初期条件
y0 = [initial_phi, initial_phidot]

# 時間の範囲
t_span = (0, 20)  # 0秒から20秒まで
t_eval = np.linspace(t_span[0], t_span[1], 1000)  # 1000ステップで時間を分割

# 微分方程式を解く
sol = solve_ivp(pendulum, t_span, y0, t_eval=t_eval)

# 結果をプロット
plt.plot(sol.t, sol.y[0])
plt.xlabel('Time [s]')
plt.ylabel('Phi [rad]')
plt.title('Pendulum motion in a half-pipe with R=5m')
plt.grid(True)
plt.show()
