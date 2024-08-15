import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# 定数
g = 9.8  # 重力加速度（m/s^2）
R = 5    # ハーフパイプの半径（メートル）

# 運動方程式の定義
def equations(t, y, g, R):
    phi, v = y  # y[0]が角度phi、y[1]が角速度vに対応します
    dphi_dt = v
    dv_dt = -(g / R) * np.sin(phi)
    return [dphi_dt, dv_dt]

# 初期条件
phi_0 = 0.11 * np.pi  # 初期角度（ラジアン）
v_0 = 0              # 初期角速度

# 解のための時間範囲
t_span = (0, 10)
t_eval = np.linspace(t_span[0], t_span[1], 500)

# 微分方程式を解く
sol_special = solve_ivp(equations, t_span, [phi_0, v_0], args=(g, R), t_eval=t_eval)

# 結果をプロット
plt.plot(sol_special.t, sol_special.y[0], label='Particular Solution', linestyle='-')
plt.xlabel('Time [s]')
plt.ylabel('Angle [rad]')
plt.title('Motion of Skateboard in Half-Pipe (Particular Solution)')
plt.legend()
plt.grid(True)
plt.show()
